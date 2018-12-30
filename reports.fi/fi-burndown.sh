#!/bin/bash

YEAR=2017
MONTH=06

BEGIN="2017/06"
END="2017/07/01"
NOW="2017/06/30"


net_worth=$(\
ledger bal "^Assets" "^Liabilities" \
--now ${NOW} -e ${END} --current \
--balance-format "%(quantity(display_total))\n" \
| tail -n 1 | sed -e 's/^[ \t]*//' \
)
withdrawal_rate="3.85"
growth_rate="5.00"


pformat="%-30s %12s\n"
printf "$pformat" "Net worth" $(printf "$%'.2f" $net_worth)
printf "$pformat" "Withdrawal rate" $(printf "%'.2f%%" $withdrawal_rate)
printf "$pformat" "Inflation-adjusted growth rate" $(printf "%'.2f%%" $growth_rate)
printf "\n" {1}


pformat="%-11s %-11s %-11s %-14s %-30s\n"
printf "$pformat" "Daily" "Monthly" "Annually" "Savings required" ""
printf '=%.0s' {1..80}
printf "\n"

annual_expenses=$(ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" \
--no-total --now $NOW -b "$YEAR/01/01" -e $END --current \
--balance-format "\
%-12((abs(display_total / $MONTH) * 12) / 365)\
%-12((abs(display_total / $MONTH) * 12) / 12)\
%-12(abs(display_total / $MONTH) * 12)\
%-14((abs(display_total / $MONTH) * 12) / ($withdrawal_rate / 100))\
%(depth_spacer)\
%-30(truncated(partial_account(options.flat), int(20), int(2)))\n\
"\
)
echo "$annual_expenses"


# pformat="%-12 %-12s %-12s %-12s %-12s %-20s\n"
# printf "$pformat" "Average" "Daily" "Monthly" "Annually" "Required Savings"
# printf '=%.0s' {1..80}
# printf "\n"


# ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} --no-total \
# --now $NOW -b "$YEAR/01/01" -e $END --current \
# --balance-format "\
# %-12(abs(display_total / $MONTH))\
# %-12((abs(display_total / $MONTH) * 12) / 365)\
# %-12((abs(display_total / $MONTH) * 12) / 12)\
# %-12(abs(display_total / $MONTH) * 12)\
# %-12((abs(display_total / $MONTH) * 12) / ($withdrawal_rate / 100))\
# %(depth_spacer)\
# %-20(truncated(partial_account(options.flat), int(20), int(2)))\n\
# "


# annual_expenses=$(\
# ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} \
# --now $NOW -b "$YEAR/01/01" -e $END --current \
# --balance-format "%(abs(quantity(display_total / $MONTH)) * 12)\n" \
# | tail -n -1 | sed -e 's/^[ \t]*//' \
# )
# monthly_expenses=$(echo "($annual_expenses / 12)" | bc -l)
# daily_expenses=$(echo "($annual_expenses / 365)" | bc -l)
# required_savings=$(echo "($annual_expenses / ($withdrawal_rate / 100))" | bc -l)


# pformat="%-20s %-20s %-20s %-20s\n"
# printf "$pformat" "Daily" "Monthly" "Annually" "Required Savings"
# printf "$pformat" $(printf "$%'.2f" $daily_expenses) $(printf "$%'.2f" $monthly_expenses) $(printf "$%'.2f" $annual_expenses) $(printf "$%'.2f" $required_savings)
# printf "\n" {1}


# annual_expenses=$(\
# ledger bal "/^Expenses:(?!Tax|Deductions)/" "/^Expenses:Tax:Sales/" -X $ \
# -f ${LEDGER_FILE} --price-db ${LEDGER_PRICES} \
# --now $NOW -b "$YEAR/01/01" -e $END --current \
# --balance-format "%(abs(quantity(display_total / $MONTH)) * 12)\n" \
# | tail -n -1 | sed -e 's/^[ \t]*//' \
# )
