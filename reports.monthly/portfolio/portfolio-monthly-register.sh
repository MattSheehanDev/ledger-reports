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
MONTH=07

current_date="2017/07/01"
until_date="2017/08/01"
now_date="2017/07/31"
LEDGER_FILE="/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"


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


# TODO: move to a seperate file in reports.fi
printf "\
%-10s %-26s %-10s %-14s %-10s %-10s\n" \
"Date" "Account" "Type" "Lot" "Price" "Value"

printf '=%.0s' {1..80}
printf "\n"

ledger reg "Assets:Portfolio" \
-f "/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger" \
--price-db "/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger" \
-b "2017/06" -e "2017/07/01" --now "2017/06/30" --current -T "" \
--register-format "\
%-10d \
%-26(truncated(display_account, int(25), int(2))) \
%-10(tag(\"TYPE\")) \
%-14(strip(display_amount)) \
%-10(lot_price(amount, amount)) \
%-10(roundto(price, 4))\n"

# %-10(market(to_string(1) + ' ' + commodity, d, '$')) \
# %(market((commodity), d, '$')) \n"
#%(strip(price)*strip(display_amount))\n"

# --display "tag(\"TYPE\") == 'DIV-REINV'"
