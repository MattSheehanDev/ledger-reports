#!/bin/bash


# END="2017/07/01"
# NOW="2017/06/30"


END="${until_date}"
NOW="${now_date}"


total_rewards_dirty=$(\
ledger bal "/^Assets:Bank:(Discover:Cashback|Huntington:Voice Points|Citi:Cashback)/" \
-e $END --now $NOW -c -R \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
total_rewards=$(echo $total_rewards_dirty | sed 's/[,$-]//g')


printf "%11s %11s %11s\n" "Percent" "Amount" "Account"
printf '=%.0s' {1..80}
printf "\n"

ledger bal "/^Assets:Bank:(Discover:Cashback|Huntington:Voice Points|Citi:Cashback)/" \
-e $END --now $NOW -c -R --no-total \
--balance-format "\
%(justify(percent(strip(display_total), $total_rewards), 11, -1, true, false)) \
%(justify((display_total), 11, -1, true, false)) \
%(depth_spacer) \
%-(partial_account(false))\n"
# --limit "has_tag('CREDITREWARD')"
