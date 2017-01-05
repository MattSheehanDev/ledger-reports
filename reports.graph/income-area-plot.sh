#!/bin/sh

# if [-z "$LEDGER_TERM" ]; then
#   LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"
# fi
LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"

# Plot assets and liabilities
# ledger --price-db ~/Dropbox/journals/finances/accounting/data/prices.ledger -f ~/Dropbox/journals/finances/accounting/data/general.ledger --plot-total-format="%(format_date(d, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n" reg -J ^Assets -X $ -M  --now 2016/12/31 -c -n  --no-revalued --immediate

ledger -J reg ^Income -M --collapse \
--plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(T))))\n" \
--price-db "~/Dropbox/journals/finances/accounting/data/prices.ledger" \
-f "~/Dropbox/journals/finances/accounting/data/general.ledger" \
-X $ -R --now 2016/12/31 -c \
-p "2016" --immediate --no-revalued \
> ledgeroutput1.tmp

ledger -J reg ^Expenses -M --collapse \
--plot-total-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(scrub(T)))))\n" \
--price-db "~/Dropbox/journals/finances/accounting/data/prices.ledger" \
-f "~/Dropbox/journals/finances/accounting/data/general.ledger" \
-X $ -R --now 2016/12/31 -c \
-p "2016" --immediate --no-revalued \
> ledgeroutput2.tmp

YEAR=$(date --date='last year' +%Y)
LAST_YEAR=`expr $YEAR - 1`
BEGIN_YEAR="$LAST_YEAR-12-20"
END_YEAR="$YEAR-12-10"

(cat <<EOF) | gnuplot
  set terminal $LEDGER_TERM
  set xdata time
  set timefmt "%Y-%m-%d"
  set xrange ["$BEGIN_YEAR":"$END_YEAR"]
  set xtics nomirror $BEGIN_YEAR,2592000 format "%b"
  unset mxtics
  set mytics 2
  set grid xtics ytics mytics
  set title "Cashflow"
  set ylabel "Accumulative Income and Expenses"
  set style fill transparent solid 0.6 noborder
  plot "ledgeroutput1.tmp" using 1:2 with filledcurves x1 title "Income" linecolor rgb "light-salmon", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle, "ledgeroutput2.tmp" using 1:2 with filledcurves y1=0 title "Expenses" linecolor rgb "seagreen", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle
EOF
# (cat <<EOF) | gnuplot
#   set terminal $LEDGER_TERM
#   set xdata time
#   set timefmt "%Y-%m-%d"
#   set xrange ["$(date --date='last year' +%Y)-12-20":"$(date +%Y)-12-10"]
#   set xtics nomirror "$(date +%Y)-01-01",2592000 format "%b"
#   unset mxtics
#   set mytics 2
#   set grid xtics ytics mytics
#   set title "Cashflow"
#   set ylabel "Accumulative Income and Expenses"
#   set style fill transparent solid 0.6 noborder
#   plot "ledgeroutput1.tmp" using 1:2 with filledcurves x1 title "Income" linecolor rgb "light-salmon", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle, "ledgeroutput2.tmp" using 1:2 with filledcurves y1=0 title "Expenses" linecolor rgb "seagreen", '' using 1:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle
# EOF

rm ledgeroutput*.tmp