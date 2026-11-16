"""Check relative file links and assets in maintained documentation."""
from pathlib import Path
import re
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
LINK = re.compile(r'\]\(([^)\s]+)\)|(?:href|src)="([^"\s]+)"')
documents = [ROOT / "README.md", ROOT / "AGENTS.md"]
documents.extend((ROOT / "docs").rglob("*.md"))
documents.extend((ROOT / "docs" / "archive" / "learning").rglob("*.html"))
documents.extend(ROOT / name / "README.md" for name in (
    "poodle_flutter", "poodle_server", "poodle_worker", "email_templates",
))
errors = []
for file in documents:
    content = re.sub(r"```.*?```", "", file.read_text(), flags=re.S)
    for markdown, html in LINK.findall(content):
        target = urlsplit(markdown or html)
        if target.scheme or target.netloc or not target.path or target.path.startswith("/"):
            continue
        if not (file.parent / unquote(target.path)).exists():
            errors.append(f"{file.relative_to(ROOT)}: {target.path}")
if errors:
    raise SystemExit("\n".join(sorted(errors)))
