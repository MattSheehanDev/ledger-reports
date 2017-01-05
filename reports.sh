#!/bin/bash
# Last modified: 2016/12/03 01:31:16 UTC

source "$HOME/Dropbox/projects/dot-files/bash-helpers/helpers.sh"

#
# Parse date (if passed in as argument)
#
dates=($(parse_date $1))
export year=${dates[0]}
export month=${dates[1]}
month_long=${dates[2]}
month_last_day=${dates[3]}

#
# If year or month does not exist then explicitly ask for them
#
if [[ -z $year ]] || [[ -z $month ]]; then
  # Prompt for year/month input
  printf "Generate reports for [year/month]: "
  read -ra yearmonth

  dates=($(parse_date $yearmonth))
  export year=${dates[0]}
  export month=${dates[1]}
  month_long=${dates[2]}
  month_last_day=${dates[3]}
fi


until_month=`expr $month + 1`
until_year=$year

#
# Check if month loops into the next year
#
if [ $until_month -gt "12" ]; then
  until_year=`expr $year + 1`                         # increment to the next year
  until_month=01                                      # loop month back around to jan
fi


# The current date
export current_date=$year/$month

# A lot of reports calculate based on the --now DATE which should be the last day of the current month
export now_date=$year/$month/$month_last_day

# A lot of reports calculate UNTIL the first of the next month (exclusive, the 1st is not included)
export until_date=$until_year/$until_month/01


#
# Create directory structure
#
. "$HOME/Dropbox/projects/ledger-reports/directory.sh"



##
## Ledger reports
## run each executable in the reports.monthly directory,
## including subdirectories
##
for i in $(find /home/matt/Dropbox/projects/ledger-reports/reports.monthly); do
  if [[ -d "$i" ]]; then
    run-parts --exit-on-error --new-session "$i"
  fi
done
# run-parts --exit-on-error ./reports.monthly


exit 0
