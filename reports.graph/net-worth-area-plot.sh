#!/bin/bash


# --immediate prevents ledger from caclulating the prices of commodities lazily
# --no-revalued prevents ledger from making adjustments if the price of a commodity changes

# Creates an area plot with revenues and expenses.
# Graphs up to, but not more than, the last twelve months.
# Takes three arguments/environment variables,
# YEAR, MONTH, and DATE_NOW (year/month/last day of the month).

YEAR=$year
MONTH=$month
DATE_NOW=$now_date
# YEAR=2016
# MONTH=12
# DATE_NOW=$YEAR/$MONTH/31
DATE_DISPLAY=$YEAR/01/01            # only display transactions from the beginning of the year

# if [-z "$LEDGER_TERM" ]; then
#   LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"
# fi
LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"
LEDGER_PLOT_FORMAT="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n"

# Plot assets and liabilities
# ledger reg -J ^Assets -X $ -M  --now 2016/12/31 -c -n  --no-revalued --immediate

ledger reg ^Assets -M --collapse -J --plot-total-format="$LEDGER_PLOT_FORMAT" \
-f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
--display "d>=[$DATE_DISPLAY]" -X $ -R --now "$DATE_NOW" -c --no-revalued \
> ledgeroutput1.tmp

ledger reg ^Liabilities -M --collapse -J --plot-total-format="$LEDGER_PLOT_FORMAT" \
-f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
--display "d>=[$DATE_DISPLAY]" -X $ -R --now "$DATE_NOW" -c --no-revalued \
> ledgeroutput2.tmp


LAST_YEAR=`expr $YEAR - 1`
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
  set title "Net Worth"
  set ylabel "Amount of Assets and Liabilities"
  set style fill transparent solid 0.6 noborder
  plot "ledgeroutput1.tmp" using 1:2 with filledcurves x1 title "Assets" linecolor rgb "light-salmon", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle, "ledgeroutput2.tmp" using 1:2 with filledcurves y1=0 title "Liabilities" linecolor rgb "seagreen", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle
EOF

rm ledgeroutput*.tmp
