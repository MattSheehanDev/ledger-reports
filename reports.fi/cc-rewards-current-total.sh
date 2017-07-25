#!/bin/bash


until_date="2017/08/01"
now_date="2017/07/31"
LEDGER_FILE="/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
LEDGER_PRICES="/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"

printf "%11s %11s %11s\n" "Percent" "Amount" "Account"
printf '=%.0s' {1..80}
printf "\n"

total_rewards_unclean=$(\
ledger bal "/^Assets:Bank:(Discover:Cashback|Huntington:Voice Points|Citi:Cashback)/" \
-e $until_date --now $now_date -c \
-f $LEDGER_FILE \
--price-db $LEDGER_PRICES \
-X $ -R \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
total_rewards=$(echo $total_rewards_unclean | sed 's/[,$-]//g')

ledger bal "/^Assets:Bank:(Discover:Cashback|Huntington:Voice Points|Citi:Cashback)/" \
-e $until_date --now $now_date -c \
-f $LEDGER_FILE \
--price-db $LEDGER_PRICES \
-X $ -R --no-total \
--balance-format "\
%(justify(percent(strip(display_total), $total_rewards), 11, -1, true, false)) \
%(justify((display_total), 11, -1, true, false)) \
%(depth_spacer) \
%-(partial_account(false))\n"
# --limit "has_tag('CREDITREWARD')"
