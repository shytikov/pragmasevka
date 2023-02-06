import sys
import fontforge

if len(sys.argv) < 2:
    print("Please provide path prefix of the font to update!")
    exit()

prefix = sys.argv[1]

glyphs = [
    "colon",
    "comma",
    "period",
    "semicolon",
]

pairs = [
    ['regular', 'semibold'],
    ['italic', 'semibolditalic'],
    ['bold', 'black'],
    ['bolditalic', 'blackitalic'],
]

for [recipient, donor] in pairs:
    font = f"{prefix}-{recipient}.ttf"

    target = fontforge.open(font)
    # Finding all punctuation
    target.selection.select(*glyphs)
    # and deleting it to make space
    for i in target.selection.byGlyphs:
        target.removeGlyph(i)

    source = fontforge.open(f"{prefix}-{donor}.ttf")
    source.selection.select(*glyphs)
    source.copy()
    target.paste()

    target.generate(font)
