#!/bin/bash


# BEGIN="2017/09"
# END="2017/10/01"
# NOW="2017/09/30"

BEGIN="${current_date}"
END="${until_date}"
NOW="${now_date}"


printf "\
%-10s %-26s %-10s %-7s %-7s %-8s %-10s\n" \
"Date" "Account" "Type" "Lot" "Sym" "Price" "Value"

printf '=%.0s' {1..80}
printf "\n"

ledger reg "Assets:Portfolio" \
--exchange " " --unround \
-b $BEGIN -e $END --now $NOW --current \
--register-format "\
%-10d \
%-26(truncated(display_account, int(25), int(2))) \
%-10(tag(\"TYPE\")) \
%-7(quantity(strip(display_amount))) \
%-7(commodity) \
%-8(roundto(lot_price(amount, amount), 2)) \
%-10(roundto(round(price), 2))\n"

# ledger reg "Assets:Portfolio" \
# -f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" --exchange " " \
# -b $BEGIN -e $END --now $NOW --current -T "" \
# --register-format "\
# %-10d \
# %-26(truncated(display_account, int(25), int(2))) \
# %-10(tag(\"TYPE\")) \
# %-14(strip(display_amount)) \
# %-10(lot_price(amount, amount)) \
# %-10(roundto(price, 4))\n"

# %-10(market(to_string(1) + ' ' + commodity, d, '$')) \
# %(market((commodity), d, '$')) \n"
#%(strip(price)*strip(display_amount))\n"

# --display "tag(\"TYPE\") == 'DIV-REINV'"
