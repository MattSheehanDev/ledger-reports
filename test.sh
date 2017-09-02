#!/bin/bash



# ledger bal "^Expenses:Fees:Portfolio" \
# -f "/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger" \
# --price-db "/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger" \
# --pivot SYM --no-total -R --pedantic --gain -X $
# # --balance-format "\
# # %-10d \
# # %-26(partial_account(false)) \
# # %-14(strip(display_total)) \
# # %-10(lot_price)\n"

YEAR=2017
# MONTH=07
MONTH=06

current_date="2017/07"
until_date="2017/08/01"
now_date="2017/07/31"
# current_date="2017/07/01"
# until_date="2017/08/01"
# now_date="2017/07/31"
LEDGER_FILE="/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"


LEDGER_ACCT="Expenses"
DATE_DISPLAY="${YEAR}/01/01"
begin="${current_date}"
end="${until_date}"
now="${now_date}"

END=$end
NOW=$now


withdrawal_amount_monthly=$(\
ledger bal "^Assets" "^Liabilities" -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
--now $NOW -e $END \
--balance-format "%/%(quantity(display_total * 0.0385 / 12)) \n" \
)
# echo $withdrawal_amount_monthly
printf "$%'.2f%%\n" $withdrawal_amount_monthly
# ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# --now $NOW -b "$YEAR/01/01" -e $END \
# --balance-format "%(display_total / $MONTH)\n" \
# | tail -n 1 | sed -e 's/^[ \t]*//'

# ledger reg "^Expenses" \
# -f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" \
# -M --collapse -J -X $ -R --no-revalued \
# -b "${begin}" -e "${end}" --now "${now}" --current \
# --plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %((((T))))\n"

# ledger reg "^Assets" \
# -f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" \
# -M --collapse -J -X $ -R --no-revalued \
# -e "${end}" --now "${now}" --display "d>=[$DATE_DISPLAY]" --current \
# --plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n"
# echo ""
# ledger reg "^Liabilities" \
# -f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" \
# -M --collapse -J -X $ -R --no-revalued \
# -e "${end}" --now "${now}" --display "d>=[$DATE_DISPLAY]" --current \
# --plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n"
# --display "d>=[$DATE_DISPLAY]" \

# ledger bal "${LEDGER_ACCT}" \
# -f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" \
# --sort="-abs(amount)" --no-total --flat -J -X $ \
# -b ${begin} -e ${end} --now ${now} --current \
# --plot-total-format="%(partial_account(options.flat)) %(abs(quantity(scrub(display_total))))\n"

# --plot-total-format="%(partial_account(options.flat)) %(total)\n"
# --plot-total-format="%(partial_account(options.flat)) %(abs(quantity(scrub(total))))\n"
# > ledgeroutput1.tmp


# ledger reg "^Assets:Portfolio:Vanguard:SEP IRA" \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} \
# --limit "commodity=~/BLV/" -T "" \
# --register-format "\
# %-10d \
# %-26(truncated(display_account, int(25), int(2))) \
# %-10(tag(\"TYPE\")) \
# %-14(roundto(strip(display_amount), 4)) \
# %-10(roundto(lot_price(amount, amount), 4)) \
# %-10(roundto(price, 4))\n"



# ledger bal "^Revenues" "^Expenses" \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# -X $ \
# -p "this month" --now $now_date -c
# ledger bal \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# -R -X $ \
# -e $until_date --now $now_date -c

# ledger bal "^Assets" "^Liabilities" -X $ \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# --now $now_date --current -e $until_date


# ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# --now $now_date -b "$YEAR/01/01" -e $until_date \
# --balance-format "%(display_total)\n%(display_total / $MONTH)\n" \

# ledger bal "^Assets" "^Liabilities" -X $ -c --price-db $LEDGER_PRICES -f $LEDGER_FILE \
# --now $now_date -e $until_date \
# --balance-format "%/%-(display_total * 0.0385 / 12)\n %-("

# ledger bal "/^Expenses:(Tax:(?!Sales)|Deductions)/" -X $ --invert -c \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# --now $now_date -b "$YEAR/01/01" -e $until_date
# --balance-format "%(display_total)\n%(display_total / $MONTH)\n"

# ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ --invert -c \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# --now $now_date -b "$YEAR/01/01" -e $until_date \
# --balance-format "\
# %(justify((display_total), 11, -1, true, false)) \
# %(justify((display_total / $MONTH), 11, -1, true, false)) \
# %(depth_spacer) \
# %-(partial_account(false))\n"
# # --balance-format "%(display_total)\n%(display_total / $MONTH)\n"

# ledger bal "/^Revenues/" -X $ --invert -c \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES \
# --now $now_date -b "$YEAR/01/01" -e $until_date \
# --balance-format "%(display_total)\n%(display_total / $MONTH)\n"

# ledger reg "/^Liabilities:Credit Card:Discover it/" -X $ --invert \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES --now $now_date -e $until_date -c \
# --limit "strip(display_amount) > 0"



# ledger bal "/^Revenues:Rewards:Discover it/" -X $ --invert \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES --now $now_date -e $until_date -c \
# --balance_format="\
# %(display_total)"

# discover_total_dirty=$(\
# ledger bal "/^Liabilities:Credit Card:Discover it/" -X $ --invert -c \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES --now $now_date -e $until_date \
# | tail -n 1 | sed -e 's/^[ \t]*//' \
# )
# discover_rewards_dirty=$(\
# ledger bal "/^Revenues:Rewards:Discover it/" -R -X $ \
# -f $LEDGER_FILE --price-db $LEDGER_PRICES --now $now_date -e $until_date -c \
# | tail -n 1 | sed -e 's/^[ \t]*//' \
# )

# discover_total=$(echo $discover_total_dirty | sed 's/[,$-]//g')
# discover_rewards=$(echo $discover_rewards_dirty | sed 's/[,$-]//g')

# # cashback_rate=$(echo "$discover_rewards/$discover_total" | bc -l)
# # cashback_rate_percent=$(printf "%.*f\n" 2 $(echo "$cashback_rate*100" | bc -l))

# echo "
# $discover_total
# $discover_rewards
# "
