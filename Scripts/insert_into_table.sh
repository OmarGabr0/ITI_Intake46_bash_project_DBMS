#! /usr/bin/bash
shopt -s extglob

insert_all(){
	# Extract first line which contains column names, then ask user to insert his values
	# < <(command)  : process substitution : treats the output of the command as a file
	table_path=$1
	IFS=: read -r -a header < <(head -1 "$table_path")
	
	echo "Enter column values : "
	for((i=0; i < ${#header[@]}; i++)){
		# Here we'll get the input from user, and validate each field separately 
		# (integer or string, isPK, NULL/NOT NULL, UNIQUE or not)
		read -p "${header[i]} : " colArr[i]
		# $2 => Database name , $3 => Table name
		constraints_check ${colArr[i]} ${header[i]} "$2" "$3"
		res=$?
		if [ $res -eq 1 ]
		then i=$i-1
		fi
		
	}
}

constraints_check(){
	# Checking if unique or not 
	# Arguments definition
	user_input=$1
	col_name=$2
	DB_name=$3
	table_name=$4
	is_unique=0
	# Get meta data for the column
	meta_data_line=$(sed -n "/"$col_name"/p" "../Databases/$DB_name/."$table_name"_meta")
	IFS=: read -r -a meta_array <<< "$meta_data_line"

	# Getting the index of the column to compare user input with the remaining data of the table
	IFS=: read -r -a header < <(head -1 "../Databases/$DB_name/$table_name")

	col_index=0
	for i in ${!header[@]}
	do
	if [[ ${header[i]} == "$col_name" ]]
	then
		col_index=$((i+1))
		break
	fi
	done

	isUnique_search_result=$(awk -F: -v value="$user_input" -v col_index=$col_index '{ if(value == $col_index){print "Exists"; exit} }' "../Databases/$DB_name/$table_name")
	if [ -n "$isUnique_search_result" ] 
	then
	is_unique=0
	else
	is_unique=1
	fi

	if [[ $is_unique == 0 && ${meta_array[1]} == 1 ]]
	then 
	echo "The data you entered is not unique"
	return 1
	fi

	# Checking if NULL or not
	if [[ $user_input == NULL && ${meta_array[2]} == 0 ]]
	then 
	echo "This field doesn't accept NULL"
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
	echo "Please enter a string"
	return 1
	elif [[ $in_datatype == "s" && ${meta_array[3]} == "i" ]]
	then
	echo "Please enter an integer"
	return 1
	fi
}

main(){

	while true 
	do
		read -p "Enter Table Name : " table_name
		table_path="../Databases/$1/$table_name"
		source check_if_exists.sh f $table_path
		res=$?
		
		if [ $res -eq 0 ]
		then
			echo "Table doesn't exist, enter another name : "
		else
		# Table exists, break from the loop
		break
		fi
	done
	
	select choice in "Insert data of all columns" "Insert data of specific columns"
	do
	case $REPLY in
	# $1 => Database name
	1) insert_all $table_path $1 $table_name
	;;
	
	2) insert_spec $table_path $1
	;;
	
	*) echo Invalid option
	;;
	esac
	done 
	
}

main "$@"
