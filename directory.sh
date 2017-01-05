#!/bin/bash

#
# CREATE DIRECTORY STRUCTURE
#
# Create the year directory first
# This way we can organize by ~/year/month/
#
export year_dir="${LEDGER_REPORT_DIR}FY${year}/"
create_dir $year_dir

export month_dir="$year_dir$month_long/"
create_dir $month_dir

export expense_dir=$month_dir"Expenses/"
create_dir $expense_dir

export asset_dir=$month_dir"Assets/"
create_dir $asset_dir
export rewards_dir=$asset_dir"Rewards/"
create_dir $rewards_dir

export investments_dir=$month_dir"Portfolio/"
create_dir $investments_dir
export fees_dir="${investments_dir}Fees/"
create_dir $fees_dir
export dividend_dir="${investments_dir}Dividends/"
create_dir $dividend_dir

export liabilities_dir=$month_dir"Liabilities/"
create_dir $liabilities_dir
