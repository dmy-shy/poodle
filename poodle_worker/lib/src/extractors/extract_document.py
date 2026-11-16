"""Private extraction subprocess. No network clients, shell, or credential input."""
import json
import os
from pathlib import Path, PurePosixPath
import re
import resource
import signal
import subprocess
import sys
import time
import zipfile
import xml.etree.ElementTree as ET

MAX_OUTPUT = 4 * 1024 * 1024
MAX_XML = 8 * 1024 * 1024
MAX_EXPANDED = 32 * 1024 * 1024
MAX_CHARACTERS = 500000
W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"
child = None


class Rejected(Exception):
    pass


def reject(code):
    raise Rejected(code)


def stop(*_):
    if child is not None and child.poll() is None:
        os.killpg(child.pid, signal.SIGKILL)
        child.wait()
    raise SystemExit(1)


def run_tool(arguments, output, seconds):
    global child
    with output.open("wb") as target:
        try:
            child = subprocess.Popen(arguments, stdout=target,
                                     stderr=subprocess.DEVNULL,
                                     start_new_session=True)
        except OSError:
            reject("extractor_not_configured")
        try:
            code = child.wait(timeout=seconds)
        except subprocess.TimeoutExpired:
            os.killpg(child.pid, signal.SIGKILL)
            child.wait()
            reject("extraction_timeout")
    if code != 0:
        reject("invalid_document")


def xml(data):
    # Restrict OOXML to UTF-8/ASCII and reject DTD/entity declarations before
    # Expat sees any input. Nothing resolves relationships or external entities.
    if len(data) > MAX_XML or b"\x00" in data:
        reject("extraction_limit")
    upper = data.upper()
    if b"<!DOCTYPE" in upper or b"<!ENTITY" in upper:
        reject("active_content")
    return ET.fromstring(data)


def docx(source):
    with zipfile.ZipFile(source) as archive:
        entries = archive.infolist()
        if len(entries) > 2000 or sum(e.file_size for e in entries) > MAX_EXPANDED:
            reject("extraction_limit")
        names = set()
        for entry in entries:
            name = entry.filename
            if (name in names or "\\" in name or PurePosixPath(name).is_absolute()
                    or ".." in PurePosixPath(name).parts or entry.flag_bits & 1):
                reject("invalid_document")
            names.add(name)
            if (entry.file_size > MAX_EXPANDED or
                    entry.file_size > max(1, entry.compress_size) * 100):
                reject("extraction_limit")
            if (name.lower().endswith(".bin") or
                    name.lower().startswith(("word/embeddings/", "word/activex/"))):
                reject("active_content")
        if not {"[Content_Types].xml", "word/document.xml"}.issubset(names):
            reject("invalid_document")
        document = None
        for entry in entries:
            if not entry.filename.endswith((".xml", ".rels")):
                continue
            if entry.file_size > MAX_XML:
                reject("extraction_limit")
            # Never extract archive members to the filesystem.
            with archive.open(entry) as member:
                data = member.read(MAX_XML + 1)
            root = xml(data)
            if entry.filename.endswith(".rels"):
                if any(n.attrib.get("TargetMode", "").lower() == "external"
                       for n in root.iter()):
                    reject("active_content")
            if entry.filename == "[Content_Types].xml":
                types = [n.attrib.get("ContentType", "") for n in root]
                if any("macroenabled" in t.lower() for t in types):
                    reject("active_content")
                if "application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml" not in types:
                    reject("invalid_document")
            if entry.filename == "word/document.xml":
                document = root
        if document is None or document.tag != W + "document":
            reject("invalid_document")
        body = document.find(W + "body")
        if body is None:
            reject("invalid_document")
        blocks = []
        characters = 0
        for i, paragraph in enumerate(body.iter(W + "p"), 1):
            text = "".join(n.text or "" if n.tag == W + "t" else
                           "\t" if n.tag == W + "tab" else "\n"
                           for n in paragraph.iter()
                           if n.tag in {W + "t", W + "tab", W + "br", W + "cr"}).strip()
            characters += len(text)
            if characters > MAX_CHARACTERS or i > 10000:
                reject("extraction_limit")
            if text:
                blocks.append({"id": f"paragraph-{i}", "text": text})
        return blocks


def pdf(source, info_tool, text_tool, raster_tool, ocr_tool):
    info = source.parent / "info.txt"
    run_tool([info_tool, str(source)], info, 8)
    metadata = info.read_text(encoding="utf-8", errors="replace")
    if re.search(r"^Encrypted:\s+yes", metadata, re.MULTILINE):
        reject("encrypted_document")
    pages = re.search(r"^Pages:\s+(\d+)\s*$", metadata, re.MULTILINE)
    if not pages:
        reject("invalid_document")
    if not 0 < int(pages[1]) <= 200:
        reject("extraction_limit")
    output = source.parent / "text.txt"
    run_tool([text_tool, "-layout", "-enc", "UTF-8", str(source), str(output)],
             source.parent / "tool.txt", 25)
    if not output.exists() or output.stat().st_size > MAX_OUTPUT:
        reject("extraction_limit")
    text = output.read_text(encoding="utf-8")
    if len(text) > MAX_CHARACTERS:
        reject("extraction_limit")
    page_text = text.split("\f")
    blocks = []
    ocr_pages = 0
    deadline = time.monotonic() + 170
    for i in range(1, int(pages[1]) + 1):
        page = page_text[i - 1].strip() if i <= len(page_text) else ""
        if not page:
            ocr_pages += 1
            if ocr_pages > 20:
                reject("extraction_limit")
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                reject("extraction_timeout")
            prefix = source.parent / f"ocr-{i}"
            image = Path(f"{prefix}.png")
            run_tool([raster_tool, "-f", str(i), "-l", str(i),
                      "-scale-to", "1600", "-gray", "-singlefile", "-png",
                      str(source), str(prefix)], source.parent / "tool.txt",
                     min(15, remaining))
            if not image.exists() or image.stat().st_size > MAX_OUTPUT:
                reject("extraction_limit")
            output = source.parent / f"ocr-{i}.txt"
            run_tool([ocr_tool, str(image), "stdout", "-l", "eng+ukr"],
                     output, min(15, max(1, deadline - time.monotonic())))
            page = output.read_text(encoding="utf-8").strip()
            image.unlink()
            output.unlink()
        if page:
            blocks.append({"id": f"page-{i}", "page": i, "text": page})
    if sum(len(block["text"]) for block in blocks) > MAX_CHARACTERS:
        reject("extraction_limit")
    return blocks


def main():
    os.umask(0o077)
    resource.setrlimit(resource.RLIMIT_CPU, (170, 170))
    resource.setrlimit(resource.RLIMIT_FSIZE, (MAX_OUTPUT, MAX_OUTPUT))
    resource.setrlimit(resource.RLIMIT_NOFILE, (64, 64))
    # Linux deployments enforce address-space limits on helper and Poppler.
    # Darwin rejects these limits; local development still bounds input, output,
    # expansion, CPU and wall time. Deploy untrusted ingestion on Linux.
    if sys.platform.startswith("linux"):
        resource.setrlimit(resource.RLIMIT_AS, (512 * 1024 * 1024, 512 * 1024 * 1024))
    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)
    source, destination, kind, info_tool, text_tool, raster_tool, ocr_tool = sys.argv[1:]
    try:
        blocks = pdf(Path(source), info_tool, text_tool, raster_tool, ocr_tool) if kind == "pdf" else docx(Path(source))
        if not blocks:
            reject("empty_source")
        result = {"blocks": blocks}
    except Rejected as error:
        result = {"error": str(error)}
    except Exception:
        # Parser diagnostics may contain document text or local paths.
        result = {"error": "invalid_document"}
    Path(destination).write_text(json.dumps(result, ensure_ascii=False), encoding="utf-8")


if __name__ == "__main__":
    main()
