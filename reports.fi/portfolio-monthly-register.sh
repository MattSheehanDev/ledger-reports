#!/bin/bash


# LEDGER_FILE="/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
# LEDGER_PRICES="/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"

# BEGIN="2017/06"
# END="2017/07/01"
# NOW="2017/06/30"

BEGIN="${current_date}"
END="${until_date}"
NOW="${now_date}"


printf "\
%-10s %-26s %-10s %-14s %-10s %-10s\n" \
"Date" "Account" "Type" "Lot" "Price" "Value"

printf '=%.0s' {1..80}
printf "\n"

ledger reg "Assets:Portfolio" \
-f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" \
-b $BEGIN -e $END --now $NOW --current -T "" \
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
