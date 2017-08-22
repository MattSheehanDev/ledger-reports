#!/bin/bash

##
## Total and average YTD revenues
##

LEDGER_FILE="/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"

END="2017/08/01"
YEAR=2017
MONTH=07

# END="${until_date}"
# YEAR=$year
# MONTH=$month



printf "%11s %11s %11s\n" "Total" "Average" "Account"
printf '=%.0s' {1..80}
printf "\n"

ledger bal "^Revenues" \
-f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
--invert -R --pedantic --no-total -b "$YEAR/01/01" -e $END -X $ \
--balance-format "\
%(justify((display_total), 11, -1, true, false)) \
%(justify((display_total / $MONTH), 11, -1, true, false)) \
%(depth_spacer) \
%-(partial_account(false))\n"


