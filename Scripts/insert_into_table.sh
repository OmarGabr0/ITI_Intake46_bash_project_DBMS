#! /usr/bin/bash
shopt -s extglob
# Sources section
source repeating_functions.sh



insert_all(){
	# Extract first line which contains column names, then ask user to insert his values
	# < <(command)  : process substitution : treats the output of the command as a file
	table_path=$1
	IFS=: read -r -a header < <(head -1 "$table_path")
	
	echo "Enter column values : "
	record=""
	for((i=0; i < ${#header[@]}; i++)){
		# Here we'll get the input from user, and validate each field separately 
		# (integer or string, isPK, NULL/NOT NULL, UNIQUE or not)
		read -p "${header[i]} : " colArr[i]
		# Checking if the input from user is empty, if empty => error pops out
			is_empty "${colArr[i]}"
			res=$?
			if [ $res -eq 1 ]
			then 
			echo "Please enter a value, empty values are not allowed"
			(( i-- ))
			else
				DB_Name=$2
				table_name=$3
				constraints_check ${colArr[i]} ${header[i]} "$DB_Name" "$table_name"
				res=$?
				if [ $res -eq 1 ]
				then i=$i-1
				
				else
				#Insert data (no errors)
				record+="${colArr[i]}:"
				fi
			fi
	
	}
	echo $record >> "$table_path"
	echo "Data inserted successfully"
}

main(){

	while true 
	do
		while true
		do
			read -p "Enter Table Name : " table_name
			is_empty $table_name
			if [ $? -eq 0 ]
			then
				table_path="../Databases/$1/$table_name"
				break
			else
				echo "System does not accept empty input"
			fi
		done

		check_if_exists f $table_path
		if [ $? -eq 0 ]
		then
			echo "Table doesn't exist, enter another name : "
		else
		# Table exists, break from the loop
		break
		fi
	done
	DB_name="$1"
	# select choice in "Insert data of all columns" "Insert data of specific columns"
	# do
	# case $REPLY in
	# 1) 
	insert_all $table_path $DB_name $table_name
	source connect_to_database.sh $DB_name
	# ;;
	
	# 2)
	# DB_Name=$1 
	# insert_spec $table_path $DB_Name
	# ;;
	
	# *) echo Invalid option
	# ;;
	# esac
	# done 
	
}

main "$@"
