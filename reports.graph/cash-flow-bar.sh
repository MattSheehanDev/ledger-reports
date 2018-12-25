#!/bin/bash


# Creates a double bar graph of revenues and expenses.
# Graphs up to, but not more than, the last twelve months.
# Takes three arguments/environment variables,
# YEAR, MONTH, and DATE_NOW (year/month/last day of the month).

YEAR=$year
MONTH=$month

begin="${YEAR}/01/01"
end="${until_date}"
now="${now_date}"
# YEAR=2016
# MONTH=12
# DATE_NOW=$year/$month/31

# if [-z "$LEDGER_TERM" ]; then
#   LEDGER_TERM="qt size 1280,720 persist"
# fi
LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"
# LEDGER_PLOT_FORMAT="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(scrub(t)))))\n"


# ledger reg ^Revenues -M --collapse -j --plot-amount-format="$LEDGER_PLOT_FORMAT" \
# -f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
# -X $ -R --now $DATE_NOW -c -p $YEAR --no-revalued \
ledger reg "^Revenues" \
-M --collapse -j -R --no-revalued \
-b ${begin} -e ${end} --now ${now} --current \
--plot-amount-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(scrub(t)))))\n" \
> ledgeroutput1.tmp

# ledger reg ^Expenses -M --collapse -j --plot-amount-format="$LEDGER_PLOT_FORMAT" \
# -f "$LEDGER_FILE" --price-db "$LEDGER_PRICES" \
# -X $ -R --now $DATE_NOW -c -p $YEAR --no-revalued \
ledger reg "^Expenses" \
-M --collapse -j -R --no-revalued \
-b ${begin} -e ${end} --now ${now} --current \
--plot-amount-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(scrub(t)))))\n" \
> ledgeroutput2.tmp

(cat <<EOF) | gnuplot
  set terminal $LEDGER_TERM
  set style data histogram
  set style histogram clustered gap 1
  set style fill transparent solid 0.4 noborder
  set xtics nomirror scale 0 center
  set ytics add ('' 0) scale 0
  set border 1
  set grid ytics
  set title "Monthly Income and Expenses"
  set ylabel "Amount"
  plot "ledgeroutput1.tmp" using 2:xticlabels(strftime('%b', strptime('%Y-%m-%d', strcol(1)))) title "Income" linecolor rgb "light-salmon", '' using 0:2:2 with labels left font "Courier,8" rotate by 15 offset -4,0.5 textcolor linestyle 0 notitle, "ledgeroutput2.tmp" using 2 title "Expenses" linecolor rgb "light-green", '' using 0:2:2 with labels left font "Courier,8" rotate by 15 offset 0,0.5 textcolor linestyle 0 notitle
EOF

rm ledgeroutput*.tmp
