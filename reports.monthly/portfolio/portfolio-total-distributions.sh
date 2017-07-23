#!/bin/bash


# commodity amount
ledger bal "^Revenues:Portfolio:Dividend" "^Revenues:Portfolio:Capital Gains" \
-f "/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger" \
--price-db "/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger" \
--invert --current -R --flat --pivot "SYM" --no-total 


# market value w/ total
ledger bal "^Revenues:Portfolio:Dividend" "^Revenues:Portfolio:Capital Gains" \
-f "/home/matt/Dropbox/journals/finances/accounting/ledger/data/general.ledger" \
--price-db "/home/matt/Dropbox/journals/finances/accounting/ledger/data/prices.ledger" \
--invert --current -R --flat --pivot "SYM" -X $
