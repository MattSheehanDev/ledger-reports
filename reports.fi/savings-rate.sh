#!/bin/bash


BEGIN="${current_date}"
END="${until_date}"
NOW="${now_date}"

YEAR=${year}
MONTH=${month}
MONTH_LONG="${month_long}"


# BEGIN="2017/06"
# END="2017/07/01"
# NOW="2017/06/30"

# YEAR=2017
# MONTH=06
# MONTH_LONG="June"


# take the last line and remove spaces
income_before_tax_month=$(\
ledger bal "/^Revenues/" \
-c -b $BEGIN -e $END --now $NOW \
--balance-format "%(abs(quantity(display_total)))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

taxes_and_deductions_month=$(\
ledger bal "/^Expenses:(Tax:(?!Sales)|Deductions)/" \
-c --now $NOW -b $BEGIN -e $END \
--balance-format "%(abs(quantity(display_total)))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

income_after_tax_month=$(\
ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" \
-b $BEGIN -e $END --now $NOW -c \
--balance-format "%(abs(quantity(display_total)))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

expenses_except_tax_month=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" \
-c -p $BEGIN --now $NOW -e $END \
--balance-format "%(abs(quantity(display_total)))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

income_after_expenses_month=$(\
ledger bal ^Revenues ^Expenses \
-b $BEGIN -e $END --now $NOW -c \
--balance-format "%(abs(quantity(display_total)))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)


income_before_tax=$(\
ledger bal "/^Revenues/" \
-c --now $NOW -b "$YEAR/01/01" -e $END \
--balance-format "%(abs(quantity(display_total)))\n%(abs(quantity(display_total / $MONTH)))\n" \
| tail -n 2 \
)
income_before_tax_total=$(echo "$income_before_tax" | head -n 1 | sed -e 's/^[ \t]*//')
income_before_tax_avg=$(echo "$income_before_tax" | tail -n 1 | sed -e 's/^[ \t]*//')

taxes_and_deductions=$(\
ledger bal "/^Expenses:(Tax:(?!Sales)|Deductions)/" \
-c --now $NOW -b "$YEAR/01/01" -e $END \
--balance-format "%(abs(quantity(display_total)))\n%(abs(quantity(display_total / $MONTH)))\n" \
| tail -n 2 \
)
taxes_and_deductions_avg=$(echo "$taxes_and_deductions" | tail -n 1 | sed -e 's/^[ \t]*//')
taxes_and_deductions_total=$(echo "$taxes_and_deductions" | head -n 1 | sed -e 's/^[ \t]*//')

income_after_tax=$(\
ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" \
-c --now $NOW -b "$YEAR/01/01" -e $END \
--balance-format "%(abs(quantity(display_total)))\n%(abs(quantity(display_total / $MONTH)))\n" \
| tail -n 2 \
)
income_after_tax_total=$(echo "$income_after_tax" | head -n 1 | sed -e 's/^[ \t]*//')
income_after_tax_avg=$(echo "$income_after_tax" | tail -n 1 | sed -e 's/^[ \t]*//')

expenses_except_tax=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" \
-c --now $NOW -b "$YEAR/01/01" -e $END \
--balance-format "%(abs(quantity(display_total)))\n%(abs(quantity(display_total / $MONTH)))\n" \
)
expenses_except_tax_avg=$(echo "$expenses_except_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
expenses_except_tax_total=$(echo "$expenses_except_tax" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')

income_after_expenses=$(\
ledger bal "/^Revenues/" "/^Expenses/" \
--now $NOW -b "$YEAR/01/01" -e $END -c \
--balance-format "%(abs(quantity(display_total)))\n%(abs(quantity(display_total / $MONTH)))\n" \
| tail -n 2 \
)
income_after_expenses_total=$(echo "$income_after_expenses" | head -n 1 | sed -e 's/^[ \t]*//')
income_after_expenses_avg=$(echo "$income_after_expenses" | tail -n 1 | sed -e 's/^[ \t]*//')


savings_rate_before_tax=$(echo "($income_after_expenses_month / $income_before_tax_month) * 100" | bc -l)
savings_rate_before_tax_avg=$(echo "($income_after_expenses_avg / $income_before_tax_avg) * 100" | bc -l)

savings_rate_after_tax=$(echo "($income_after_expenses_month / $income_after_tax_month) * 100" | bc -l)
savings_rate_after_tax_avg=$(echo "($income_after_expenses_avg / $income_after_tax_avg) * 100" | bc -l)


pformat="%-30s %12s %12s %12s\n"

printf "$pformat" "" "Total" "Average" "$MONTH_LONG"
printf '=%.0s' {1..80}
printf "\n"

printf "$pformat" "Revenues before taxes" $(printf "$%'.2f" $income_before_tax_total) $(printf "$%'.2f" $income_before_tax_avg) $(printf "$%'.2f" $income_before_tax_month)
printf "$pformat" "Taxes and deductions" $(printf "($%'.2f)" $taxes_and_deductions_total) $(printf "($%'.2f)" $taxes_and_deductions_avg) $(printf "($%'.2f)" $taxes_and_deductions_month)
printf "$pformat" "Revenues after taxes" $(printf "$%'.2f" $income_after_tax_total) $(printf "$%'.2f" $income_after_tax_avg) $(printf "$%'.2f" $income_after_tax_month)
printf "$pformat" "Expenses" $(printf "($%'.2f)" $expenses_except_tax_total) $(printf "($%'.2f)" $expenses_except_tax_avg) $(printf "($%'.2f)" $expenses_except_tax_month)
printf "$pformat" "Revenues after expenses" $(printf "$%'.2f" $income_after_expenses_total) $(printf "$%'.2f" $income_after_expenses_avg) $(printf "$%'.2f" $income_after_expenses_month)
printf '%.0s-' {1..80}
printf "\n"
printf "$pformat" "Savings rate, excluding tax" "" $(printf "%.*f%%\n" 2 $savings_rate_after_tax_avg) $(printf "%.*f%%\n" 2 $savings_rate_after_tax)
printf "$pformat" "Savings rate" "" $(printf "%.*f%%\n" 2 $savings_rate_before_tax_avg) $(printf "%.*f%%\n" 2 $savings_rate_before_tax)




# income_before_tax_month=$(\
# ledger bal "/^Revenues/" -X $ --invert -c \
# -f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" -p $BEGIN --now $NOW -e $END \
# | tail -n 1 | sed -e 's/^[ \t]*//' \
# )
# monthly_income_before_tax_clean=$(echo $income_before_tax_month | sed 's/[,$]//g')


# income_before_tax=$(\
# ledger bal "/^Revenues/" -X $ --invert -c \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} \
# --now $NOW -b "$YEAR/01/01" -e $END \
# --balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
# )
# income_before_tax_total=$(echo "$income_before_tax" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')
# income_before_tax_avg=$(echo "$income_before_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
# income_before_tax_avg_clean=$(echo $income_before_tax_avg | sed 's/[,$]//g')


# income_after_tax_month=$(\
# ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} -p $BEGIN --now $NOW -c -e $END \
# | tail -n 1 | sed -e 's/^[ \t]*//' \
# )
# monthly_income_after_tax_clean=$(echo $income_after_tax_month | sed 's/[,$]//g')

# income_after_tax=$(\
# ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert -c \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} \
# --now $NOW -b "$YEAR/01/01" -e $END \
# --balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
# )
# income_after_tax_avg=$(echo "$income_after_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
# income_after_tax_total=$(echo "$income_after_tax" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')
# avg_income_after_tax_clean=$(echo $income_after_tax_avg | sed 's/[,$]//g')

# income_after_expenses_month=$(\
# ledger bal ^Revenues ^Expenses -X $ --invert \
# --price-db ${LEDGER_PRICES} -p $BEGIN --now $NOW -c \
# | tail -n 1 | sed -e 's/^[ \t]*//' \
# )
# monthly_income_after_expenses_clean=$(echo $income_after_expenses_month | sed 's/[,$]//g')

# income_after_expenses=$(\
# ledger bal "/^Revenues/" "/^Expenses/" -X $ --invert -c \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} \
# --now $NOW -b "$YEAR/01/01" -e $END \
# --balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
# )
# income_after_expenses_avg=$(echo "$income_after_expenses" | tail -n 1 | sed -e 's/^[ \t]*//')
# income_after_expenses_total=$(echo "$income_after_expenses" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')
# income_after_expenses_avg_clean=$(echo $income_after_expenses_avg | sed 's/[,$]//g')

