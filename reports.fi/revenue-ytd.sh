#!/bin/bash

##
## Total and average YTD revenues
##


# END="2017/08/01"
# YEAR=2017
# MONTH=07

END="${until_date}"
YEAR=$year
MONTH=$month



printf "%11s %11s %11s\n" "Total" "Average" "Account"
printf '=%.0s' {1..80}
printf "\n"

ledger bal "^Revenues" \
--invert -R --pedantic --no-total -b "${YEAR}/01/01" -e $END \
--balance-format "\
%(justify((display_total), 11, -1, true, false)) \
%(justify((display_total / ${MONTH}), 11, -1, true, false)) \
%(depth_spacer) \
%-(partial_account(false))\n"


