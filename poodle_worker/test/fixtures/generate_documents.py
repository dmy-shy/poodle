"""Regenerate original, non-user document fixtures (requires ReportLab)."""
from pathlib import Path
import zipfile
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.pdfencrypt import StandardEncryption

HERE = Path(__file__).parent
FONT = Path('/System/Library/Fonts/Supplemental/Arial.ttf')
if not FONT.exists():
    FONT = Path('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf')
pdfmetrics.registerFont(TTFont('Fixture', str(FONT)))
pdf = canvas.Canvas(str(HERE / 'study.pdf'))
pdf.setFont('Fixture', 14)
pdf.drawString(40, 760, 'A citation identifies a source version and supporting passage.')
pdf.showPage()
pdf.setFont('Fixture', 14)
pdf.drawString(40, 760, 'Посилання визначає версію джерела та уривок.')
pdf.save()
pdf = canvas.Canvas(str(HERE / 'encrypted.pdf'),
                    encrypt=StandardEncryption('', ownerPassword='fixture-owner', canCopy=0))
pdf.drawString(40, 760, 'Private encrypted fixture')
pdf.save()
pdf = canvas.Canvas(str(HERE / 'empty.pdf'))
pdf.showPage()
pdf.save()

TYPES = '''<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>'''
DOCUMENT = '''<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>
<w:p><w:r><w:t>A citation identifies a source version.</w:t></w:r></w:p>
<w:p><w:r><w:t>Посилання визначає версію джерела.</w:t></w:r></w:p>
<w:tbl><w:tr><w:tc><w:p><w:r><w:t>Table evidence</w:t></w:r></w:p></w:tc></w:tr></w:tbl>
</w:body></w:document>'''


def docx(name, extras=None, document=DOCUMENT):
    with zipfile.ZipFile(HERE / name, 'w', compression=zipfile.ZIP_DEFLATED) as archive:
        for key, value in {'[Content_Types].xml': TYPES,
                           'word/document.xml': document, **(extras or {})}.items():
            archive.writestr(key, value)


docx('study.docx')
docx('macro.docx', {'word/vbaProject.bin': b'not executed'})
docx('external.docx', {'word/_rels/document.xml.rels': '<Relationships><Relationship TargetMode="External" Target="https://example.invalid/private"/></Relationships>'})
docx('traversal.docx', {'../escape': 'never written'})
docx('entity.docx', document='<!DOCTYPE x [<!ENTITY a "expanded">]>' + DOCUMENT)
docx('bomb.docx', document='x' * 1000000)
