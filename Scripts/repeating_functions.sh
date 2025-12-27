# This script contains the functions that are frequently used in the other scripts

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

