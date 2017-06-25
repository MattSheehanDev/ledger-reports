#!/bin/bash

today=$(date +"%Y-%m-%d")

# cd "$HOME/Dropbox/journals/finances/accounting/"
cd "$LEDGER_BASE_DIR"


git add -A
git commit -m "$today"
git push origin master


exit 0
