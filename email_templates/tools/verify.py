"""Check the upload contract and regenerate deterministic approval previews."""
import json
import re
from pathlib import Path
from html.parser import HTMLParser

ROOT = Path(__file__).resolve().parents[1]
manifest = json.loads((ROOT / 'manifest.json').read_text())
(ROOT / 'preview').mkdir(exist_ok=True)
all_templates = manifest['templates']
assert len(all_templates) == 8
assert {(t['purpose'], t['locale']) for t in all_templates} == {
    (purpose, locale)
    for purpose in ['registration', 'password-reset', 'email-change', 'administrator-request']
    for locale in ['en', 'uk']
}
assert len({t['alias'] for t in all_templates}) == len(all_templates)
for t in all_templates:
    source = (ROOT / t['html']).read_text()
    text = (ROOT / t['text']).read_text()
    expected = {'CODE', 'EXPIRES_AT_UTC', 'LOGO_URL'}
    assert set(re.findall(r'\{\{\{([A-Z_]+)\}\}\}', source)) == expected
    assert set(re.findall(r'\{\{\{([A-Z_]+)\}\}\}', text)) == expected - {'LOGO_URL'}
    assert {v['key'] for v in t['variables']} == expected
    assert all(v['type'] == 'string' and 'fallback_value' not in v for v in t['variables'])
    assert '<html lang="' + t['locale'] + '"' in source
    assert '<h1 ' in source and '<ol ' in source
    assert '<script' not in source and '<a ' not in source 
    assert 'src="{{{LOGO_URL}}}"' in source
    assert 'alt="Poodle"' in source
    rendered = source
    for key, value in t['sample_variables'].items():
        rendered = rendered.replace('{{{' + key + '}}}', value)
    assert '{{{' not in rendered
    assert '01234567' in rendered
    (ROOT / 'preview' / Path(t['html']).name).write_text(rendered)
print(f'PASS: {len(all_templates)} purpose/language contracts, string variables, leading zero, HTML structure and previews')
