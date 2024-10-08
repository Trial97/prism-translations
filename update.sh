#!/bin/bash

set -e

ROOT="$(pwd)"
SRC=${ROOT}/src

LCONVERT_BIN=${LCONVERT_BIN:-lconvert}
LUPDATE_BIN=${LUPDATE_BIN:-lupdate}

###############################################################################

curl https://l10n-files.qt.io/l10n-files/qt-old65/qtbase_untranslated.ts --output ./.qtbase_untranslated.ts
readarray -d '' SOURCE_FILES < <(find "$SRC" -regex '.*\.\(h\|cpp\|ui\)' -type f -print0)

update_file() {
    ts_file="$1"

    # Update .ts
    $LUPDATE_BIN "${SOURCE_FILES[@]}" -locations "absolute" -ts "$ts_file"
    $LCONVERT_BIN -i "$ts_file" ./.qtbase_untranslated.ts -o "$ts_file"
}

cd "$ROOT"

if [ -n "$1" ]; then
    update_file "$1"
else
    for f in *.ts; do
        update_file "$f"
    done

    update_file .template.ts
fi

# rm ./.qtbase_untranslated.ts
