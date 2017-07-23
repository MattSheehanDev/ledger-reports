#!/bin/bash


# printf "\
# %-9s %-7s %-s\n" \
# "Gallons" "$/Gal" "Automobile"

# printf '=%.0s' {1..80}
# printf "\n"

# ledger bal "^Expenses:Auto:Gas" \
# -f "/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger" \
# --price-db "/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger" \
# --pivot "VEHICLE" -b "2017/01/01" -e "2017/08/01" \
# --balance-format "\
# %-9(quantity(market(display_total, date, 'GAL'))) \
# %-7( market(display_total, date, '$') / quantity(market(display_total, date, 'GAL')) ) \
# %-(partial_account(false)) \
# \n%/"

# %-48(partial_account(false)) \
# %10( market(display_total, date, '$') / quantity(market(display_total, date, 'GAL')) )/GAL \
# %13(quantity(market(display_total, date, 'GAL'))) GAL \
# \n%/"




# printf "%11s %11s %11s\n" "Total" "Average" "Account"
# printf '=%.0s' {1..80}
# printf "\n"

# ledger bal "^Expenses" \
# -f "/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger" \
# --price-db "/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger" \
# -R --pedantic --no-total -b "2017/01/01" -e "2017/08/01" -X $ \
# --balance-format "\
# %(justify((display_total), 11, -1, true, false)) \
# %(justify((display_total / 7), 11, -1, true, false)) \
# %(depth_spacer) \
# %-(partial_account(false))\n"

# %-10(display_amount > 0 ? (display_amount / 7) : '') \
# %-(display_amount > 0 ? (partial_account(true)) : '') \
# %(display_amount > 0 ? '\n' : '\b\b\b\b\b\b\b\b\b\b\b\b')"



# ledger bal "^Expenses:Fees:Portfolio" \
# -f "/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger" \
# --price-db "/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger" \
# --pivot SYM --no-total -R --pedantic --gain -X $
# # --balance-format "\
# # %-10d \
# # %-26(partial_account(false)) \
# # %-14(strip(display_total)) \
# # %-10(lot_price)\n"

# # --balance-format "\
# # %-20( market(display_total, post.date, '$') ) \
# # %(depth_spacer) \
# # %-(partial_account(false)) \
# # \n%/"



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
