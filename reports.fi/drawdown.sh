#!/bin/bash


BEGIN="${current_date}"
END="${until_date}"
NOW="${now_date}"

YEAR=${year}
MONTH=${month}
MONTH_LONG="${month_long}"


# LEDGER_FILE="$HOME/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
# LEDGER_PRICES="$HOME/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"

# BEGIN="2017/06"
# END="2017/07/01"
# NOW="2017/06/30"

# YEAR=2017
# MONTH=06
# MONTH_LONG="June"



withdrawal_rate="0.0385"
withdrawal_rate_percent=$(printf "%.*f\n" 2 $(echo "$withdrawal_rate*100" | bc -l))

net_worth=$(\
ledger bal ^Assets ^Liabilities -X $ --price-db ${LEDGER_PRICES} -f ${LEDGER_FILE} \
--now $NOW -e $END --current \
--balance-format "%(quantity(display_total))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

monthly_expenses_except_tax=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $BEGIN --now $NOW -e $END \
--balance-format "%(quantity(display_total))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

expenses_except_tax_avg=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $NOW -b "$YEAR/01/01" -e $END \
--balance-format "%(quantity(display_total / $MONTH))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

withdrawal_amount_monthly=$(\
ledger bal "^Assets" "^Liabilities" -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
--now $NOW -e $END \
--balance-format "%/%(quantity(display_total * 0.0385 / 12)) \n" \
)


total_coverage_avg=$(echo "(($net_worth * $withdrawal_rate / 12) / $expenses_except_tax_avg) * 100" | bc -l)
total_coverage=$(echo "($withdrawal_amount_monthly / $monthly_expenses_except_tax) * 100" | bc -l)

required_drawdown_avg=$(echo "(($expenses_except_tax_avg * 12) / $net_worth) * 100" | bc -l)
required_drawdown=$(echo "(($monthly_expenses_except_tax * 12) / $net_worth) * 100" | bc -l)


pformat="%-30s %11s %11s\n"

printf "$pformat" "" "Average" "$MONTH_LONG"
printf '=%.0s' {1..80}
printf "\n"

printf "$pformat" "Target withdrawal rate" "$withdrawal_rate_percent%" "$withdrawal_rate_percent%"
printf "$pformat" "Expenses" $(printf "($%'.2f)" $expenses_except_tax_avg) $(printf "($%'.2f)" $monthly_expenses_except_tax)
printf "$pformat" "Withdrawal amount" $(printf "$%'.2f" $withdrawal_amount_monthly) $(printf "$%'.2f" $withdrawal_amount_monthly)
printf '%.0s-' {1..80}
printf "\n"
printf "$pformat" "Coverage of expenses" $(printf "%.*f%%\n" 2 $total_coverage_avg) $(printf "%.*f%%\n" 2 $total_coverage)
printf "$pformat" "Required withdrawal rate" $(printf "%.*f%%\n" 2 $required_drawdown_avg) $(printf "%.*f%%\n" 2 $required_drawdown)




# net_worth=$(\
# ledger bal ^Assets ^Liabilities -X $ -c --price-db ${LEDGER_PRICES} -f ${LEDGER_FILE} \
# --now $NOW -e $END \
# | tail -n 1 | sed -e 's/^[ \t]*//' \
# )
# net_worth_clean=$(echo $net_worth | sed 's/[,$]//g')


# monthly_expenses_except_tax=$(\
# ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES -p $BEGIN --now $NOW -e $END \
# | tail -n 1 | sed -e 's/^[ \t]*//' \
# )
# monthly_expenses_except_tax_clean=$(echo $monthly_expenses_except_tax | sed 's/[,$-]//g')


# --balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
# expenses_except_tax_avg=$(echo "$expenses_except_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
# expenses_except_tax_avg_clean=$(echo $expenses_except_tax_avg | sed 's/[,$-]//g')


# withdrawal_amount_monthly=$(\
# ledger bal "^Assets" "^Liabilities" -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
# --now $NOW -e $END \
# --balance-format "%/%-(display_total * 0.0385 / 12) \n" \
# )
# withdrawal_amount_monthly_clean=$(echo $withdrawal_amount_monthly | sed 's/[,$-]//g')