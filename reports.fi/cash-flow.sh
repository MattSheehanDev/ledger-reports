#!/bin/bash


# LEDGER_FILE="/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
# LEDGER_PRICES="/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"

# NOW="2017/07/31"

END="${until_date}"
NOW="${now_date}"


ledger bal "^Revenues" "^Expenses" \
-f $LEDGER_FILE --price-db $LEDGER_PRICES \
-p "this month" --now $NOW -c

