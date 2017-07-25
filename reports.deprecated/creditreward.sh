#!/bin/bash


echo -n -e $startBlue"Starting current credit card reward market report..."$endColor
ledger bal "^Assets" -R -e $until_date --limit "has_tag('CREDITREWARD')" \
--price-db $LEDGER_PRICES -X $ --now $now_date -c \
> $rewards_dir"rewards-current-market.txt"

check_last_result
echo -e $startGreenBold"DONE"$endColor



echo -n -e $startBlue"Starting current retailer credit market report..."$endColor
ledger bal ^Assets -R -e $until_date --limit "has_tag('CREDITRETAIL')" \
--price-db $LEDGER_PRICES -X $ --now $now_date -c \
> $rewards_dir"retailer-credit-current-market.txt"

check_last_result
echo -e $startGreenBold"DONE"$endColor



echo -n -e $startBlue"Starting monthly credit card reward market report..."$endColor

ledger bal "/^Revenues:Rewards:(Discover it|Huntington Voice|Citi Double Cash)/" \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
-b $current_date -e $until_date --now $now_date -c \
-R \
> $rewards_dir"rewards-monthly.txt"

check_last_result
echo -e $startGreenBold"DONE"$endColor
