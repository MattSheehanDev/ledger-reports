#!/bin/bash


# END="2017/08/01"
# YEAR=2017
# MONTH=07


# remember that -b is inclusive and -e is exclusive.
# so -b 2016/01/01 -e 2017/01/01, starts on the first of 2016 and
# goes UP TO but not including the first of 2017.
END="${until_date}"

YEAR=$year
MONTH=$month




printf "%11s %11s %11s\n" "Total" "Average" "Account"
printf '=%.0s' {1..80}
printf "\n"

ledger bal "^Expenses" \
-R --pedantic --no-total -b "${YEAR}/01/01" -e ${END} \
--balance-format "\
%(justify((display_total), 11, -1, true, false)) \
%(justify((display_total / ${MONTH}), 11, -1, true, false)) \
%(depth_spacer) \
%-(partial_account(false))\n"





# %(justify((market(display_total, date, '$') / $MONTH), 20, -1, true, color)) \
# %(!options.flat ? depth_spacer : \"\") \
# %-(ansify_if(partial_account(options.flat), blue if color))\n%/" \

# "%-18((depth_spacer)+(partial_account)) \
# %12(market(display_total, date, '$fixed') / $MONTH)\n" \

# "%(justify((market(display_total, date, '$') / $MONTH), 20, -1, true, color)) \
# %(!options.flat ? depth_spacer : \"\") \
# %-(ansify_if(partial_account(options.flat), blue if color))\n%/"


# --balance-format \
# "%-42((depth_spacer)+(partial_account)) \
# %10( ((market(display_total, date, '$'))) / (quantity(market(display_total, date, 'GAL'))) )/GAL \
# %16(quantity(market(display_total, date, 'GAL'))) GAL \
# \n%/" \

# ledger bal ^Expenses:Auto:Gas -f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
# -b "$YEAR/01/01" -e $UNTIL_DATE --format \
# "%-18((depth_spacer)+(partial_account)) \
# %8( ((market(display_total, date, '$'))) / (quantity(market(display_total, date, 'GAL'))) )/GAL \
# (%(quantity(market(display_total, date, 'GAL'))) GAL) \
# " \
# > "${averages_dir}gas-per-gallon-ytd-average.txt"


# "%-18((depth_spacer)+(partial_account)) \
# %12( ((market(display_total, date, '$'))) / (quantity(market(display_total, date, 'GAL'))) ) / GAL" \