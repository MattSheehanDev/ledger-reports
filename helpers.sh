#!/bin/bash


# Colors for reporting to the terminal
export startBlue=$'\e[34m'
# export startBlue=$'\e[1;31m'
export startBlueBold="\e[32;01m;"
export startGreen="\e[32m"
export startGreenBold=$'\e[32;01m'
export startGreenBlack=$'\e[32;40;01m'   # green foreground w/ black background
export startRed="\e[31m"
export startRedBold="\e[31;01m"
export endColor=$'\e[m'

# Array of month names
declare months_long
months_long[1]="January"
months_long[2]="February"
months_long[3]="March"
months_long[4]="April"
months_long[5]="May"
months_long[6]="June"
months_long[7]="July"
months_long[8]="August"
months_long[9]="September"
months_long[10]="October"
months_long[11]="November"
months_long[12]="December"

# Array of month days
declare month_days
month_days[1]=31
month_days[2]=28
month_days[3]=31
month_days[4]=30
month_days[5]=31
month_days[6]=30
month_days[7]=31
month_days[8]=31
month_days[9]=30
month_days[10]=31
month_days[11]=30
month_days[12]=31


#
# Helper Functions
#
create_dir(){
  if [ ! -d $1 ]
  then
    # echo "Creating directory $1"
    mkdir -p $1
  fi
}
remove_existing_file(){
  if [ -f $1 ]; then
    rm $1
  fi
}
check_last_result(){
  # some third party scripts don't return exit codes properly,
  # so if the last exit code exists and does not equal zero then
  # we alert a failure.
  # otherwise, if there is no last error code returned, then we'll
  # assume it finished successfully.
  if [[ -n $? ]] && [[ $? -ne 0 ]]; then
    echo -e $startRedBold$?$endColor
    exit 1
  fi
  # if [[ -n $? ]]; then
  #   if [[ $? != "0" ]]; then
  #     echo -e $start_red$?$end_color
  #     exit 1
  #   fi
  # elif [[ $? -ne 0 ]]; then
  #   echo -e $start_red$?$end_color
  #   exit 1
  # fi
}

#
# Parse script param into year and month via Parameter Expansion.
# Replaces all instances of '/' with ' ' in variable $1, then interprets the space
# delimitted string as an array (...)
#
parse_date(){
  local arr=(${1//\// })                   # local variable

  local year=${arr[0]}                     # local variable
  local month=${arr[1]}                    # local variable
  local month_long=${months_long[$month]}  # local variable
  local month_day=${month_days[$month]}

  echo "$year $month $month_long $month_day"
}


#
# Export functions
#
export -f create_dir
export -f remove_existing_file
export -f check_last_result
export -f parse_date
