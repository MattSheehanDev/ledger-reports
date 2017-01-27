#!/bin/bash

. "/home/matt/Dropbox/projects/ledger-reports/helpers.sh"

YEAR=$1
YEAR_NEXT=`expr $YEAR + 1`

YEAR_BOUNDS="$YEAR_NEXT/01/01"

if [[ -z $YEAR ]]; then
    echo "Must provide a year"
    exit 1
fi

# make dir
DATA_DIR="/home/matt/Dropbox/journals/finances/accounting/data"
FY_DIR="/home/matt/Dropbox/journals/finances/accounting/data/FY${YEAR}"
ARCHIVE_DIR="/home/matt/Dropbox/journals/finances/accounting/data/FY${YEAR}/archive"

create_dir $FY_DIR
create_dir $ARCHIVE_DIR


# seperate old transactions from new transactions
ledger print --columns=999 -e "$YEAR_BOUNDS" > "${FY_DIR}/general-fy${YEAR}.ledger"
ledger print --columns=999 -b "$YEAR_BOUNDS" > "${FY_DIR}/general-fy${YEAR_NEXT}.ledger"

# equity for the previous year
# TODO: include --lot-prices
ledger equity not "^Allocation" --lot-prices -e "$YEAR_BOUNDS" > "${FY_DIR}/equity-fy${YEAR}.ledger"
# ledger equity -f "${FY_DIR}/general-fy${YEAR}.ledger" -e "$YEAR_BOUNDS" > "${FY_DIR}/equity-fy${YEAR}.ledger"

touch "${FY_DIR}/x"
echo "include accounts.ledger" >> "${FY_DIR}/x"
echo "include commodities.ledger" >> "${FY_DIR}/x"
echo "include expressions.ledger" >> "${FY_DIR}/x"
echo "include payees.ledger" >> "${FY_DIR}/x"
echo "include tags.ledger" >> "${FY_DIR}/x"
echo "" >> "${FY_DIR}/x"
# combine equity for the previous year and the general ledger for the current year
cat "${FY_DIR}/equity-fy${YEAR}.ledger" >> "${FY_DIR}/x"
echo "" >> "${FY_DIR}/x"
cat "${FY_DIR}/general-fy${YEAR_NEXT}.ledger" >> "${FY_DIR}/x"

mv "${FY_DIR}/x" "${FY_DIR}/general.ledger"


# archive old files
cp "${DATA_DIR}/general.ledger" "${ARCHIVE_DIR}/general.ledger"
cp "${DATA_DIR}/accounts.ledger" "${ARCHIVE_DIR}/accounts.ledger"
cp "${DATA_DIR}/commodities.ledger" "${ARCHIVE_DIR}/commodities.ledger"
cp "${DATA_DIR}/expressions.ledger" "${ARCHIVE_DIR}/expressions.ledger"
cp "${DATA_DIR}/payees.ledger" "${ARCHIVE_DIR}/payees.ledger"
cp "${DATA_DIR}/prices.ledger" "${ARCHIVE_DIR}/prices.ledger"
cp "${DATA_DIR}/tags.ledger" "${ARCHIVE_DIR}/tags.ledger"