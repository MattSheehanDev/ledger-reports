# dividend register report
LEDGER_FILE="$HOME/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="$HOME/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"
current_date="2017/06"
until_date="2017/07/01"
now_date="2017/06/30"

# take the last line and remove spaces
income_after_tax=$(\
ledger bal "/^Revenues/" "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert \
-f $LEDGER_FILE --price-db $LEDGER_PRICES -p $current_date --now $now_date -c -e $until_date \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
income_after_expenses=$(ledger bal ^Revenues ^Expenses -X $ --invert \
--price-db $LEDGER_PRICES -p $current_date --now $now_date -c \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)

income_after_tax_clean=$(echo $income_after_tax | sed 's/[,$]//g')
income_after_expenses_clean=$(echo $income_after_expenses | sed 's/[,$]//g')
# income_after_tax_clean=$(echo $income_after_tax | cut -d $ -f 2 | sed 's/,//g')
# income_after_expenses_clean=$(echo $income_after_expenses | cut -d $ -f 2 | sed 's/,//g')
savings_rate=$(echo "$income_after_expenses_clean/$income_after_tax_clean" | bc -l)
savings_rate_rounded=$(printf "%.*f\n" 2 $(echo "$savings_rate*100" | bc -l))

echo "
Income after taxes      $income_after_tax
Income after expenses   $income_after_expenses
--------------------
Savings rate            $savings_rate_rounded %
"
# echo $income_after_tax

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

