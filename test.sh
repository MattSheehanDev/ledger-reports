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

ledger bal "^Revenues" "^Expenses" \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
-X $ \
-p $current_date --now $now_date -c
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
