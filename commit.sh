#!/bin/bash

today=$(date +"%Y-%m-%d")

cd "$HOME/Dropbox/journals/finances/accounting/"


git add -A
git commit -m "$today"
git push origin master


exit 0
