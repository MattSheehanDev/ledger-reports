
LEDGER_FILE="$HOME/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="$HOME/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"
current_date="2017/06"
until_date="2017/07/01"
now_date="2017/06/30"
YEAR=2017
MONTH=06
MONTH_LONG="June"


# take the last line and remove spaces
income_before_tax_month=$(\
ledger bal "/^Revenues/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
monthly_income_before_tax_clean=$(echo $income_before_tax_month | sed 's/[,$]//g')


income_before_tax=$(\
ledger bal "/^Revenues/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
income_before_tax_avg=$(echo "$income_before_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
income_before_tax_total=$(echo "$income_before_tax" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')
income_before_tax_avg_clean=$(echo $income_before_tax_avg | sed 's/[,$]//g')


taxes_and_deductions_month=$(\
ledger bal "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b $current_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
taxes_and_deductions_year=$(\
ledger bal "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
taxes_and_deductions_avg=$(echo "$taxes_and_deductions_year" | tail -n 1 | sed -e 's/^[ \t]*//')
taxes_and_deductions_total=$(echo "$taxes_and_deductions_year" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')



income_after_tax_month=$(\
ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -c -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
income_after_tax=$(\
ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
income_after_tax_avg=$(echo "$income_after_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
income_after_tax_total=$(echo "$income_after_tax" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')

monthly_income_after_tax_clean=$(echo $income_after_tax_month | sed 's/[,$]//g')
avg_income_after_tax_clean=$(echo $income_after_tax_avg | sed 's/[,$]//g')


income_after_expenses_month=$(\
ledger bal ^Revenues ^Expenses -X $ --invert \
--price-db $LEDGER_PRICES -p $current_date --now $now_date -c \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
monthly_income_after_expenses_clean=$(echo $income_after_expenses_month | sed 's/[,$]//g')


income_after_expenses=$(\
ledger bal "/^Revenues/" "/^Expenses/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
income_after_expenses_avg=$(echo "$income_after_expenses" | tail -n 1 | sed -e 's/^[ \t]*//')
income_after_expenses_total=$(echo "$income_after_expenses" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')
income_after_expenses_avg_clean=$(echo $income_after_expenses_avg | sed 's/[,$]//g')


expenses_except_tax_month=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
expenses_except_tax_year=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
expenses_except_tax_avg=$(echo "$expenses_except_tax_year" | tail -n 1 | sed -e 's/^[ \t]*//')
expenses_except_tax_total=$(echo "$expenses_except_tax_year" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')



savings_rate_before_tax=$(echo "$monthly_income_after_expenses_clean/$monthly_income_before_tax_clean" | bc -l)
savings_rate_before_tax=$(printf "%.*f\n" 2 $(echo "$savings_rate_before_tax*100" | bc -l))
savings_rate_before_tax_avg=$(echo "$income_after_expenses_avg_clean/$income_before_tax_avg_clean" | bc -l)
savings_rate_before_tax_avg=$(printf "%.*f\n" 2 $(echo "$savings_rate_before_tax_avg*100" | bc -l))

savings_rate_after_tax=$(echo "$monthly_income_after_expenses_clean/$monthly_income_after_tax_clean" | bc -l)
savings_rate_after_tax=$(printf "%.*f\n" 2 $(echo "$savings_rate_after_tax*100" | bc -l))
savings_rate_after_tax_avg=$(echo "$income_after_expenses_avg_clean/$avg_income_after_tax_clean" | bc -l)
savings_rate_after_tax_avg=$(printf "%.*f\n" 2 $(echo "$savings_rate_after_tax_avg*100" | bc -l))


pformat="%-30s %11s %11s %11s\n"

printf "$pformat" "" "Total" "Average" "$MONTH_LONG"
printf '=%.0s' {1..80}
printf "\n"

printf "$pformat" "Revenues before taxes" "$income_before_tax_total" "$income_before_tax_avg" "$income_before_tax_month"
printf "$pformat" "(Taxes and deductions)" $taxes_and_deductions_total $taxes_and_deductions_avg $taxes_and_deductions_month
printf "$pformat" "Revenues after taxes" $income_after_tax_total $income_after_tax_avg $income_after_tax_month
printf "$pformat" "(Expenses)" $expenses_except_tax_total $expenses_except_tax_avg $expenses_except_tax_month
printf "$pformat" "Revenues after expenses" $income_after_expenses_total $income_after_expenses_avg $income_after_expenses_month
printf '%.0s-' {1..80}
printf "\n"
printf "$pformat" "Savings rate, excluding tax" "" "$savings_rate_after_tax_avg%" "$savings_rate_after_tax%"
printf "$pformat" "Savings rate" "" "$savings_rate_before_tax_avg%" "$savings_rate_before_tax%"

