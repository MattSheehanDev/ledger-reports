#!/bin/bash

# Bring in helpers script
. "$HOME/bin/bash-helpers/helpers.sh"

# Parse date
parse_date $1

#Create directory structure
. "$HOME/Dropbox/projects/bash/ledger/directory.sh"



LEDGER_TERM=png

plot_temp="/tmp/reg-plot"
discover_temp="/tmp/reg-discover"
huntington_temp="/tmp/reg-huntington"
acctspayable_temp="/tmp/reg-ap"

# echo -e -n "\r\n\r\n" >> $discover

ledger reg ^Liabilities:Discover --display "date>=[$year/$month/01] and has_tag('CREDIT')" --market --invert -J > $discover_temp
ledger reg ^Liabilities:Huntington --display "date>=[$year/$month/01] and has_tag('CREDIT')" --market --invert -J > $huntington_temp
ledger reg ^Liabilities:Accounts Payable --display "date>=[$year/$month/01]" --market --invert -J > $acctspayable_temp


header="
set terminal $LEDGER_TERM size 640,480
set grid
set size 1,1
set title 'Credit Card Balance(s) for $month_long $year'
set key bmargin center horizontal
set xdata time
set timefmt '%Y-%m-%d'
set format x '%m/%d'
set xlabel 'Date'
set xtics rotate by -45
set ylabel 'Dollars'
set xrange ['2016-02-01':'2016-02-29']
set lmargin 9
set rmargin 3
set bmargin 7
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.0
set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 5 ps 1.0
set style line 3 lc rgb '#00cc00' lt 1 lw 2 pt 9 ps 1.0
plot '$discover_temp' using 1:2 with lp ls 1 title 'Discover',\
     '$huntington_temp' using 1:2 with lp ls 2 title 'Huntington',\
     '$acctspayable_temp' using 1:2 with lp ls 3 title 'Accts Payable'
"

echo "$header" > $plot_temp


# Graph
liabilities_graph="${liabilities_dir}credit-cards.$LEDGER_TERM"
gnuplot < $plot_temp > $liabilities_graph


# Cleanup
remove_existing_file $plot_temp
remove_existing_file $discover_temp
remove_existing_file $huntington_temp
remove_existing_file $acctspayable_temp





net_worth_temp="/tmp/reg-networth"
ledger reg ^Assets --display "date>=[$year/$month/01]" --price-db $LEDGER_PRICE_DB --market -J > $net_worth_temp

header="
set terminal $LEDGER_TERM size 640,480
set grid
set size 1,1
set title 'Net Worth for $month_long $year'
set key bmargin center horizontal
set xdata time
set timefmt '%Y-%m-%d'
set format x '%m/%d'
set xlabel 'Date'
set xtics rotate by -45
set ylabel 'Dollars'
set xrange ['2016-02-01':'2016-02-29']
set lmargin 9
set rmargin 3
set bmargin 7
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 7 ps 1.0
plot '$net_worth_temp' using 1:2 with lp ls 1 title 'Net Worth'
"
echo "$header" > $plot_temp

net_worth_graph="${liabilities_dir}net-worth.$LEDGER_TERM"
gnuplot < $plot_temp > $net_worth_graph



ledger bal ^Allocation --display "date>=[$year/$month/01]" --price-db $LEDGER_PRICE_DB --force-color --market --format "\
%-17((depth_spacer)+(partial_account))\
%10(percent(market(display_total), market(account(\"Allocation\").total)))\
%16(market(display_total))\n\
%/" > "/tmp/reg-allocation"
# ledger bal ^Allocation --price-db $LEDGER_PRICE_DB --market --format "\
# %-17((partial_account))\
# %10(percent(market(display_total), market(parent.total)))\
# %16(market(display_total))\n\
# %/" > "/tmp/reg-allocation"
