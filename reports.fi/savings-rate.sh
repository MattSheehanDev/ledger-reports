# dividend register report
LEDGER_FILE="$HOME/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="$HOME/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"
current_date="2017/06"
until_date="2017/07/01"
now_date="2017/06/30"


# take the last line and remove spaces
income_before_tax=$(\
ledger bal "/^Revenues/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
expenses_except_tax=$(\
ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
# ledger bal ^Assets ^Liabilities --exchange $ --price-db $LEDGER_PRICES --now $now_date --current \
# -p monthly until $until_date \
net_worth=$(\
ledger bal ^Assets ^Liabilities -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
--now $now_date -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
income_after_tax=$(\
ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -c -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
income_after_expenses=$(\
ledger bal ^Revenues ^Expenses -X $ --invert \
--price-db $LEDGER_PRICES -p $current_date --now $now_date -c \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

withdrawal_rate="0.0385"

expenses_except_tax_clean=$(echo $expenses_except_tax | sed 's/[,$-]//g')
net_worth_clean=$(echo $net_worth | sed 's/[,$]//g')
income_after_tax_clean=$(echo $income_after_tax | sed 's/[,$]//g')
income_after_expenses_clean=$(echo $income_after_expenses | sed 's/[,$]//g')
# income_after_tax_clean=$(echo $income_after_tax | cut -d $ -f 2 | sed 's/,//g')
# income_after_expenses_clean=$(echo $income_after_expenses | cut -d $ -f 2 | sed 's/,//g')
required_drawdown=$(echo "($expenses_except_tax_clean*12)/$net_worth_clean" | bc -l)
required_drawdown_rounded=$(printf "%.*f\n" 2 $(echo "$required_drawdown*100" | bc -l))
total_coverage=$(echo "($net_worth_clean*$withdrawal_rate/12)/$expenses_except_tax_clean" | bc -l)
total_coverage_rounded=$(printf "%.*f\n" 2 $(echo "$total_coverage*100" | bc -l))
savings_rate=$(echo "$income_after_expenses_clean/$income_after_tax_clean" | bc -l)
savings_rate_rounded=$(printf "%.*f\n" 2 $(echo "$savings_rate*100" | bc -l))

echo "
Income before taxes             $income_before_tax
Income after taxes              $income_after_tax
Expenses                        $expenses_except_tax
Income after expenses           $income_after_expenses
--------------------
Savings rate (after tax)        $savings_rate_rounded %
"
echo "
Total monthly coverage          $total_coverage_rounded %
Required yearly drawdown        $required_drawdown_rounded %
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

