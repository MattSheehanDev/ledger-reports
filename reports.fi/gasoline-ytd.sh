#!/bin/bash


END="2017/10/01"
YEAR=2017
MONTH=9


# # remember that -b is inclusive and -e is exclusive.
# # so -b 2016/01/01 -e 2017/01/01, starts on the first of 2016 and
# # goes UP TO but not including the first of 2017.
# END="${until_date}"

# YEAR=$year
# MONTH=$month



printf "%-9s %-7s %-s\n" "Gallons" "$/Gal" "Automobile"
printf '=%.0s' {1..80}
printf "\n"

ledger bal "^Expenses:Auto:Gas" --exchange " " \
--pivot VEHICLE -b "${YEAR}/01/01" -e ${END} \
--balance-format "\
%-9(roundto(round(quantity(market(display_total, date, 'GAL'))), 2)) \
%-7( market(display_total, date, '$') / quantity(market(display_total, date, 'GAL')) ) \
%-(partial_account(false)) \
\n%/"
# >> "${expense_dir}price-per-gallon-ytd.txt"

