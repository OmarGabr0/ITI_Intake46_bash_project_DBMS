#! /usr/bin/bash
declare -a buffer

# Sources section
source repeating_functions.sh

if [ $# -eq 0 ]
then
	while true
	do
		echo "====================================="
		read -p "Enter the database name : " DB_Name
		is_empty $DB_Name
		if [ $? -eq 0 ]
			then 
			DB_Path="../Databases/$DB_Name"
			break
		else 
			echo "${RED}System doesn't accept empty inputs ${RESET}"
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
			sleep 0.7
			clear
			echo -e "${CYAN}=====================================${RESET}"
			echo -e "${GREEN}            Tables Menu                ${RESET}"
			echo -e "${CYAN}=====================================${RESET}"
			 PS3="Enter a number : "
			select choice in "Create Table" "List Tables" "Drop Table" "Insert into Table" "Select from Table" "Delete From Table" "Update Table" "Exit" 
			do
				case $REPLY in
				1)
				while true
				do
				 read -p "Enter table name : " table_name
				 is_empty $table_name
				 if [ $? -eq 1 ]
				 then echo -e "${RED}System doesn't accept empty inputs${RESET}"
				 else break
				 fi
				 done
				 source create_table.sh $DB_Name $table_name
					break;;
				2) ls $DB_Path 
					break;;
				3)  
					while true
					do
					read -p "Enter table name : " table_name
					is_empty $table_name
					if [ $? -eq 1 ]
					then echo -e "${RED}Empty inputs are not allowed${RESET}"
					else break
					fi 
					done
					source drop_table.sh $DB_Name $table_name
					break;;
				4) source insert_into_table.sh $DB_Name
					break;;
				5) source select_from_table.sh $DB_Name

					break;;
				6) source delete_from_table.sh $DB_Name
					break;;
				7) source update_table.sh $DB_Name
					break;;
				8) source main.sh
				;;
				*) echo -e "${RED}Invalid option${RESET}"
					break;;
				esac
			done
		done
		else
			echo -e "${RED}Database name you entered is not found ${RESET}"
			echo "====================================="
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



