#!/bin/sh

# if [-z "$LEDGER_TERM" ]; then
#   LEDGER_TERM="qt size 1280,720 persist"
# fi
LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"

ledger -j reg ^Income -M --collapse \
--plot-amount-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(scrub(t)))))\n" \
--price-db ~/Dropbox/journals/finances/accounting/data/prices.ledger \
-f ~/Dropbox/journals/finances/accounting/data/general.ledger \
-X $ -R --now 2016/12/31 -c \
-p "2016" --immediate --no-revalued \
> ledgeroutput1.tmp

ledger -j reg ^Expenses -M --collapse \
--plot-amount-format="%(format_date(date, \"%Y-%m-%d\")) %(to_int(abs(quantity(scrub(t)))))\n" \
--price-db ~/Dropbox/journals/finances/accounting/data/prices.ledger \
-f ~/Dropbox/journals/finances/accounting/data/general.ledger \
-X $ -R --now 2016/12/31 -c \
-p "2016" --immediate --no-revalued \
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
