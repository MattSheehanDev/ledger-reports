#!/bin/bash


# remember that -b is inclusive and -e is exclusive.
# so -b 2016/01/01 -e 2017/01/01, starts on the first of 2016 and
# goes UP TO but not including the first of 2017.
YEAR=$year

# we want to divide the display total by the number of current months in the year.
# so for 2016/06 we want to divide by 6 to get the average for the current year.
MONTH=$month
UNTIL_DATE=$until_date





echo -n -e "${startBlue}Starting expense-ytd report...${endColor}"
# Total and average YTD expenses

printf "%11s %11s %11s\n" "Total" "Average" "Account" > "${expense_dir}expenses-ytd.txt"
printf '=%.0s' {1..80} >> "${expense_dir}expenses-ytd.txt"
printf "\n" >> "${expense_dir}expenses-ytd.txt"

ledger bal "^Expenses" \
-f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
-R --pedantic --no-total -b "$YEAR/01/01" -e $UNTIL_DATE -X $ \
--balance-format "\
%(justify((display_total), 11, -1, true, false)) \
%(justify((display_total / $MONTH), 11, -1, true, false)) \
%(depth_spacer) \
%-(partial_account(false))\n" \
>> "${expense_dir}expenses-ytd.txt"


check_last_result
echo -e "${startGreenBold}DONE${endColor}"



echo -n -e "${startBlue}Starting average gas price per gallon...${endColor}"
# Average price/gallon of gas YTD

printf "%-9s %-7s %-s\n" "Gallons" "$/Gal" "Automobile" > "${expense_dir}price-per-gallon-ytd.txt"
printf '=%.0s' {1..80} >> "${expense_dir}price-per-gallon-ytd.txt"
printf "\n" >> "${expense_dir}price-per-gallon-ytd.txt"

ledger bal "^Expenses:Auto:Gas" \
-f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
--pivot VEHICLE -b "$YEAR/01/01" -e $UNTIL_DATE \
--balance-format "\
%-9(quantity(market(display_total, date, 'GAL'))) \
%-7( market(display_total, date, '$') / quantity(market(display_total, date, 'GAL')) ) \
%-(partial_account(false)) \
\n%/" \
>> "${expense_dir}price-per-gallon-ytd.txt"


check_last_result
echo -e "${startGreenBold}DONE${endColor}"



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