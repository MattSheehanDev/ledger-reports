#!/bin/bash


# END="2017/08/01"
# NOW="2017/07/31"

END="${until_date}"
NOW="${now_date}"


ledger bal "^Assets" "^Liabilities" \
--exchange " " -e $END --now $NOW --current

