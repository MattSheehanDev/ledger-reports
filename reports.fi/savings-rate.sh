# dividend register report
LEDGER_FILE="$HOME/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="$HOME/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"
current_date="2017/06"
until_date="2017/07/01"
now_date="2017/06/30"
YEAR=2017
MONTH=06


# take the last line and remove spaces
monthly_income_before_tax=$(\
ledger bal "/^Revenues/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
income_before_tax=$(\
ledger bal "/^Revenues/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
income_before_tax_avg=$(echo "$income_before_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
income_before_tax_total=$(echo "$income_before_tax" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')

monthly_income_before_tax_clean=$(echo $monthly_income_before_tax | sed 's/[,$]//g')
avg_income_before_tax_clean=$(echo $income_before_tax_avg | sed 's/[,$]//g')


monthly_income_after_tax=$(\
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

monthly_income_after_tax_clean=$(echo $monthly_income_after_tax | sed 's/[,$]//g')
avg_income_after_tax_clean=$(echo $income_after_tax_avg | sed 's/[,$]//g')


monthly_income_after_expenses=$(\
ledger bal ^Revenues ^Expenses -X $ --invert \
--price-db $LEDGER_PRICES -p $current_date --now $now_date -c \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
income_after_expenses=$(\
ledger bal "/^Revenues/" "/^Expenses/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
income_after_expenses_avg=$(echo "$income_after_expenses" | tail -n 1 | sed -e 's/^[ \t]*//')
income_after_expenses_total=$(echo "$income_after_expenses" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')

monthly_income_after_expenses_clean=$(echo $monthly_income_after_expenses | sed 's/[,$]//g')
avg_income_after_expenses_clean=$(echo $income_after_expenses_avg | sed 's/[,$]//g')


monthly_expenses_except_tax=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
expenses_except_tax=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
--now $now_date -b "$YEAR/01/01" -e $until_date \
--balance-format "%(display_total)\n%(display_total / $MONTH)\n" \
)
expenses_except_tax_avg=$(echo "$expenses_except_tax" | tail -n 1 | sed -e 's/^[ \t]*//')
expenses_except_tax_total=$(echo "$expenses_except_tax" | tail -n 2 | head -n 1 | sed -e 's/^[ \t]*//')


# ledger bal ^Assets ^Liabilities --exchange $ --price-db $LEDGER_PRICES --now $now_date --current \
# -p monthly until $until_date \
net_worth=$(\
ledger bal ^Assets ^Liabilities -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
--now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)


withdrawal_rate="0.0385"

monthly_expenses_except_tax_clean=$(echo $monthly_expenses_except_tax | sed 's/[,$-]//g')
expenses_except_tax_avg_clean=$(echo $expenses_except_tax_avg | sed 's/[,$-]//g')
net_worth_clean=$(echo $net_worth | sed 's/[,$]//g')

total_coverage=$(echo "($net_worth_clean*$withdrawal_rate/12)/$monthly_expenses_except_tax_clean" | bc -l)
total_coverage=$(printf "%.*f\n" 2 $(echo "$total_coverage*100" | bc -l))
total_coverage_avg=$(echo "($net_worth_clean*$withdrawal_rate/12)/$expenses_except_tax_avg_clean" | bc -l)
total_coverage_avg=$(printf "%.*f\n" 2 $(echo "$total_coverage_avg*100" | bc -l))

required_drawdown=$(echo "($monthly_expenses_except_tax_clean*12)/$net_worth_clean" | bc -l)
required_drawdown=$(printf "%.*f\n" 2 $(echo "$required_drawdown*100" | bc -l))
required_drawdown_avg=$(echo "($expenses_except_tax_avg_clean*12)/$net_worth_clean" | bc -l)
required_drawdown_avg=$(printf "%.*f\n" 2 $(echo "$required_drawdown_avg*100" | bc -l))

savings_rate_before_tax=$(echo "$monthly_income_after_expenses_clean/$monthly_income_before_tax_clean" | bc -l)
savings_rate_before_tax=$(printf "%.*f\n" 2 $(echo "$savings_rate_before_tax*100" | bc -l))
savings_rate_before_tax_avg=$(echo "$avg_income_after_expenses_clean/$avg_income_before_tax_clean" | bc -l)
savings_rate_before_tax_avg=$(printf "%.*f\n" 2 $(echo "$savings_rate_before_tax_avg*100" | bc -l))

savings_rate_after_tax=$(echo "$monthly_income_after_expenses_clean/$monthly_income_after_tax_clean" | bc -l)
savings_rate_after_tax=$(printf "%.*f\n" 2 $(echo "$savings_rate_after_tax*100" | bc -l))
savings_rate_after_tax_avg=$(echo "$avg_income_after_expenses_clean/$avg_income_after_tax_clean" | bc -l)
savings_rate_after_tax_avg=$(printf "%.*f\n" 2 $(echo "$savings_rate_after_tax_avg*100" | bc -l))

# total, average, month
echo "
Income before taxes             $income_before_tax_total   $income_before_tax_avg   $monthly_income_before_tax
Income after taxes              $income_after_tax_total   $income_after_tax_avg   $monthly_income_after_tax
Expenses                        $expenses_except_tax_total   $expenses_except_tax_avg   $monthly_expenses_except_tax
Income after expenses           $income_after_expenses_total   $income_after_expenses_avg   $monthly_income_after_expenses
--------------------
Savings rate (after tax)                     $savings_rate_after_tax_avg%   $savings_rate_after_tax%
Savings rate (before tax)                    $savings_rate_before_tax_avg%   $savings_rate_before_tax%
"
echo "
Total monthly coverage                       $total_coverage_avg%   $total_coverage%
Required yearly drawdown                     $required_drawdown_avg%   $required_drawdown%
"
# echo $required_drawdown_rounded

# ledger reg "Assets:Portfolio" -f "${LEDGER_FILE}" -b "${current_date}" -e "${until_date}" \
# --now "${now_date}" -T "" --lot-prices \
# --format \
# "%(justify(display_total, int(total_width), 4 + int(meta_width), true, color))\n"
# "%(ansify_if( \
# ansify_if(justify(format_date(date), int(date_width)), \
# green if color and date > today), \
# bold if should_bold)) \
# %(ansify_if( \
# ansify_if(justify(truncated(payee, int(payee_width)), int(payee_width)), \
# bold if color and !cleared and actual), \
# bold if should_bold)) \
# %(ansify_if( \
# ansify_if(justify(truncated(display_account, int(account_width), \
# int(abbrev_len)), int(account_width)), \
# blue if color), \
# bold if should_bold)) \
# %(ansify_if( \
# justify(scrub(display_amount), int(amount_width), \
# 3 + int(meta_width) + int(date_width) + int(payee_width) \
# + int(account_width) + int(amount_width) + int(prepend_width), \
# true, color), \
# bold if should_bold)) \
# %(ansify_if( \
# justify(scrub(display_total), int(total_width), \
# 4 + int(meta_width) + int(date_width) + int(payee_width) \
# + int(account_width) + int(amount_width) + int(total_width) \
# + int(prepend_width), true, color), \
# bold if should_bold))\n%/ \
# %(justify(\" \", int(date_width))) \
# %(ansify_if( \
# justify(truncated(has_tag(\"Payee\") ? payee : \" \", \
# int(payee_width)), int(payee_width)), \
# bold if should_bold)) \
# %(justify((market(display_total, date, '$')), int(total_width), 4 + int(meta_width), true, color))\n"

