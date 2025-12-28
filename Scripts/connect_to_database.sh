#! /usr/bin/bash
declare -a buffer

# Sources section
source repeating_functions.sh

if [ $# -eq 0 ]
then
	while true
	do
		read -p "Enter the database name : " DB_Name
		is_empty $DB_Name
		if [ $? -eq 0 ]
			then 
			DB_Path="../Databases/$DB_Name"
			break
		else 
			echo "System doesn't accept empty inputs"
		fi 
	done

elif [ $# -eq 1 ]
then
	DB_Name="$1"
	DB_Path="../Databases/$DB_Name"
fi

while true
do
		
		check_if_exists d $DB_Path
		if [ $? -eq 1 ]
		then 
		# While loop for the select to display the menu after choosing any option
		while true
		do
			select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table" "Delete From Table" "Update Table" "Exit" 
			do
				case $REPLY in
				1)
				 read -p "Enter table name : " table_name
				 source create_table.sh $DB_Name $table_name
					break;;
				2) ls $DB_Path 
					break;;
				3)  
					read -p "Enter table name : " table_name
					source drop_table.sh $DB_Name $table_name
					break;;
				4) source insert_into_table.sh $DB_Name
					break;;
				5) source enhanced_select_from_table.sh $DB_Name
					break;;
				6) source delete_from_table.sh $DB_Name
					break;;
				7) source update_table.sh $DB_Name
					break;;
				8) source main.sh
				;;
				*) echo "Invalid option"
					break;;
				esac
			done
			# Wait a second until display is read
		      sleep 0.5	
		done
		else
			echo "Database name you entered is not found"
			select choice in "Enter another name" "Exit from this menu"
			do 
				case $REPLY in
				1) 
					while true
					do
						read -p "Enter a valid name: " DB_Name
						is_empty $DB_Name
						if [ $? -eq 0 ]
						then
							DB_Path="../Databases/$DB_Name"
							break
						else
							echo "Empty inputs are not allowed" 
						fi
					done
				break
				;;
				
				2) 
				break 2
				;;
				
				*) 
				echo "Invalid option"
				;;
				esac
			done	
		fi
done



