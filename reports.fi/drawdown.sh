LEDGER_FILE="$HOME/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="$HOME/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"
current_date="2017/06"
until_date="2017/07/01"
now_date="2017/06/30"
YEAR=2017
MONTH=06
MONTH_LONG="June"


net_worth=$(\
ledger bal ^Assets ^Liabilities -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
--now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
net_worth_clean=$(echo $net_worth | sed 's/[,$]//g')


monthly_expenses_except_tax=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
monthly_expenses_except_tax_clean=$(echo $monthly_expenses_except_tax | sed 's/[,$-]//g')


expenses_except_tax=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
expenses_except_tax_avg=$(echo "$expenses_except_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
expenses_except_tax_avg_clean=$(echo $expenses_except_tax_avg | sed 's/[,$-]//g')


withdrawal_rate="0.0385"
withdrawal_rate_percent=$(printf "%.*f\n" 2 $(echo "$withdrawal_rate*100" | bc -l))

#withdrawal_amount_monthly=$(echo "$net_worth_clean*$withdrawal_rate/12" | bc -l)
withdrawal_amount_monthly=$(\
ledger bal "^Assets" "^Liabilities" -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
--now $now_date -e $until_date \
--balance-format "%/%-(display_total * 0.0385 / 12) \n" \
)
withdrawal_amount_monthly_clean=$(echo $withdrawal_amount_monthly | sed 's/[,$-]//g')

# total_coverage=$(echo "($net_worth_clean*$withdrawal_rate/12)/$monthly_expenses_except_tax_clean" | bc -l)
total_coverage=$(echo "$withdrawal_amount_monthly_clean / $monthly_expenses_except_tax_clean" | bc -l)
total_coverage=$(printf "%.*f\n" 2 $(echo "$total_coverage*100" | bc -l))

total_coverage_avg=$(echo "($net_worth_clean*$withdrawal_rate/12)/$expenses_except_tax_avg_clean" | bc -l)
total_coverage_avg=$(printf "%.*f\n" 2 $(echo "$total_coverage_avg*100" | bc -l))

required_drawdown=$(echo "($monthly_expenses_except_tax_clean*12)/$net_worth_clean" | bc -l)
required_drawdown=$(printf "%.*f\n" 2 $(echo "$required_drawdown*100" | bc -l))

required_drawdown_avg=$(echo "($expenses_except_tax_avg_clean*12)/$net_worth_clean" | bc -l)
required_drawdown_avg=$(printf "%.*f\n" 2 $(echo "$required_drawdown_avg*100" | bc -l))


pformat="%-30s %11s %11s\n"

printf "$pformat" "" "Average" "$MONTH_LONG"
printf '=%.0s' {1..80}
printf "\n"

printf "$pformat" "Target withdrawal rate" "$withdrawal_rate_percent%" "$withdrawal_rate_percent%"
printf "$pformat" "Expenses" $expenses_except_tax_avg $monthly_expenses_except_tax
printf "$pformat" "Withdrawal amount" $withdrawal_amount_monthly $withdrawal_amount_monthly
printf '%.0s-' {1..80}
printf "\n"
printf "$pformat" "Coverage of expenses" "$total_coverage_avg%" "$total_coverage%"
printf "$pformat" "Required withdrawal rate" "$required_drawdown_avg%" "$required_drawdown%"

# echo "
# Target withdrawal rate                   $withdrawal_rate_percent%         $withdrawal_rate_percent%
# Expenses monthly                  $expenses_except_tax_avg       $monthly_expenses_except_tax
# Withdrawal monthly                $withdrawal_amount_monthly        $withdrawal_amount_monthly
# -----------------------
# Coverage of expenses      $total_coverage_avg%           $total_coverage%

# Required withdrawal rate           $required_drawdown_avg%     $required_drawdown%
# "

