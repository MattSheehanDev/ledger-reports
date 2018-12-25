#!/bin/bash


# Creates an area plot with revenues and expenses.
# Graphs up to, but not more than, the last twelve months.
# Takes three arguments/environment variables,
# YEAR, MONTH, and DATE_NOW (year/month/last day of the month).

YEAR=${year}
MONTH=${month}

begin="${YEAR}/01/01"
end="${until_date}"
now="${now_date}"
# YEAR=2016
# MONTH=12
# DATE_NOW=$YEAR/$MONTH/31

# if [-z "$LEDGER_TERM" ]; then
#   LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"
# fi
LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"
# LEDGER_PLOT_FORMAT="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n"


ledger reg "^Revenues" \
-M --collapse -J -R --no-revalued \
-b "${begin}" -e "${end}" --now "${now}" --current \
--plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n" \
> ledgeroutput1.tmp


ledger reg "^Expenses" \
-M --collapse -J -R --no-revalued \
-b "${begin}" -e "${end}" --now "${now}" --current \
--plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n" \
> ledgeroutput2.tmp


# YEAR=$(date --date='last year' +%Y)
LAST_YEAR=`expr $YEAR - 1`
# BEGIN_YEAR="$LAST_YEAR-12-20"
BEGIN="$LAST_YEAR-12-20"
END="$YEAR-$MONTH-10"

(cat <<EOF) | gnuplot
  set terminal $LEDGER_TERM
  set xdata time
  set timefmt "%Y-%m-%d"
  set xrange ["$BEGIN":"$END"]
  set xtics nomirror $BEGIN,2592000 format "%b"
  unset mxtics
  set mytics 2
  set grid xtics ytics mytics
  set title "Cashflow"
  set ylabel "Accumulative Income and Expenses"
  set style fill transparent solid 0.6 noborder
  plot "ledgeroutput1.tmp" using 1:2 with filledcurves x1 title "Income" linecolor rgb "light-salmon", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle, "ledgeroutput2.tmp" using 1:2 with filledcurves y1=0 title "Expenses" linecolor rgb "seagreen", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle
EOF

rm ledgeroutput*.tmp
