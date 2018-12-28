#!/bin/bash


# END="2017/08/01"
# NOW="2017/07/31"

END="${until_date}"
NOW="${now_date}"


ledger bal -R -e ${END} --now ${NOW} -c

