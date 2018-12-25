#!/bin/bash

# $@ -- inserts bash parameter

LEDGER_ACCT="Expenses"
LEDGER_TERM="svg enhanced background rgb 'white' size 1280,720"

begin="${current_date}"
end="${until_date}"
now="${now_date}"

# ledger -J bal "${LEDGER_ACCT}" -f "${LEDGER_FILE}" --sort="-abs(amount)" --flat --no-total \
# -X $ --price-db "${LEDGER_PRICES}" -b ${begin} -e ${end} --now ${now} --current \
# --plot-total-format="%(partial_account(options.flat)) %(abs(quantity(scrub(total))))\n" \
ledger bal "${LEDGER_ACCT}" \
--sort="-abs(amount)" --no-total --flat -J \
-b ${begin} -e ${end} --now ${now} --current \
--plot-total-format="%(partial_account(options.flat)) %(abs(quantity(scrub(display_total))))\n" \
> ledgeroutput1.tmp

(cat <<EOF) | gnuplot
  set terminal $LEDGER_TERM
  set style data histogram
  set style histogram clustered gap 1
  set style fill transparent solid 0.4 noborder
  set xtics nomirror scale 0 rotate by -45
  set ytics add ('' 0) scale 0
  set border 1
  set grid ytics
  set title "Histogram of ${LEDGER_ACCT}"
  set ylabel "Amount"
  plot "ledgeroutput1.tmp" using 2:xticlabels(1) notitle linecolor rgb "light-turquoise", '' using 0:2:2 with labels font "Courier,8" offset 0,0.5 textcolor linestyle 0 notitle
EOF

rm ledgeroutput*.tmp
