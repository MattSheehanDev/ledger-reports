#!/bin/bash


# LEDGER_FILE="/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger"
# LEDGER_PRICES="/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger"

# END="2017/08/01"
# NOW="2017/07/31"

END="${until_date}"
NOW="${now_date}"


ledger bal "^Assets" "^Liabilities" \
-f "${LEDGER_FILE}" --price-db "${LEDGER_PRICES}" \
-e $END --now $NOW --current

