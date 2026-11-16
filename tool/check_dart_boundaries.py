"""Keep platform clients and generated APIs out of the wrong packages."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
RULES = {
    "poodle_flutter/lib": {"poodle_server", "poodle_worker"},
    "poodle_server/lib": {"poodle_client", "poodle_flutter", "poodle_worker"},
    "poodle_worker/lib": {"poodle_client", "poodle_flutter"},
}
DIRECTIVE = re.compile(r"^\s*(?:import|export)\s+['\"]package:([^/]+)", re.M)
errors = []
for directory, prohibited in RULES.items():
    for path in sorted((ROOT / directory).rglob("*.dart")):
        if "generated" in path.parts or path.name.startswith("app_localizations"):
            continue
        for package in set(DIRECTIVE.findall(path.read_text())) & prohibited:
            errors.append(f"{path.relative_to(ROOT)}: must not depend on {package}")
if errors:
    raise SystemExit("\n".join(errors))
