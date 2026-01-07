#! /usr/bin/bash
shopt -s extglob
# This script contains the functions that are frequently used in the other scripts

# Colors
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
WHITE="\e[97m"
BOLD="\e[1m"
RESET="\e[0m"

# Global variables 
header=()

# This Function takes 2 arguments: 
# $1 => directory or file ('d' or 'f') , $2 => path of the dir/file

check_if_exists() {
	if [ "$1" == "d" ]
	then
		if [ -d "$2"  ]
		then
			return 1
		else 
			return 0
		fi

	elif [ "$1" == "f" ]
	then
		if [ -f "$2" ]
		then
			return 1
		else 
			return 0
		fi
	fi
}

# Checks if user input is empty or not
is_empty(){
    input=$1
    if [ -z "$input" ]
    then return 1
    else return 0
    fi 
}

match_regex(){
	if [[ $DB_name =~ ^[A-Za-z][A-Za-z0-9_-]*$ ]]
	then return 1
	else return 0
	fi
}


constraints_check(){

	# Arguments definition
	user_input=$1
	col_name=$2
	DB_name=$3
	table_name=$4

	# Checking if unique or not 

	is_unique=0
	# Get meta data for the column
	meta_data_line=$(sed -n "/"$col_name"/p" "../Databases/$DB_name/."$table_name"_meta")
	IFS=: read -r -a meta_array <<< "$meta_data_line"

	# Getting the index of the column to compare user input with the remaining data of the table
	IFS=: read -r -a header < <(head -1 "../Databases/$DB_name/$table_name")

	col_index=$(get_index $col_name)

	isUnique_search_result=$(awk -F: -v value="$user_input" -v col_index=$col_index '{ if(value == $col_index){print "Exists"; exit} }' "../Databases/$DB_name/$table_name")
	if [ -n "$isUnique_search_result" ] 
	then
	is_unique=0
	else
	is_unique=1
	fi

	if [[ $is_unique == 0 && ${meta_array[1]} == 1 ]]
	then 
	echo -e "${RED}The data you entered is not unique ${RESET}"
	return 1
	fi    
	

	# Checking if NULL or not
	is_null=0
	if [[ $user_input == NULL && ${meta_array[2]} == 0 ]]
	then 
	echo -e "${RED}This field doesn't accept NULL ${RESET}"
	is_null=1
	return 1
	fi

	# Checking if string or integer

	case "$user_input" in
	+([0-9]) ) in_datatype="i"
	;;

	*) in_datatype="s"
	;; 
	esac

	if [[ $in_datatype == "i" && ${meta_array[3]} == "s" ]]
	then 
	echo -e "${RED}Please enter a string ${RESET}"
	return 1
	elif [[ $in_datatype == "s" && ${meta_array[3]} == "i" ]]
	then
	echo -e "${RED}Please enter an integer ${RESET}"
	return 1
	fi
}

# Function to get column index by name 
get_index() {
    local col_name="$1"
    for ((i=0; i<${#header[@]}; i++)); do
        if [ "${header[i]}" = "$col_name" ]; then
            echo "$((i+1))"
            return
        fi
    done
}
