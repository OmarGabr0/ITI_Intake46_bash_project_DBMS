#! /usr/bin/bash
source repeating_functions.sh
# Main menu for database creation


while true
do
	sleep 0.7
	clear
 	echo -e "${CYAN}=====================================${RESET}"
	echo -e "${GREEN}            Main Menu                ${RESET}"
	echo -e "${CYAN}=====================================${RESET}"
	 PS3="Enter a number : "
	select choice in "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit"
	do

	case $REPLY in
		1) source ./create_database.sh
			break
			;;
		2) ls ../Databases 
			break
			;;
		3) source ./connect_to_database.sh 
			break
			;;
		4) source drop_database.sh
			break
			;;
		5) echo "Thanks for your time :)"
			exit
			;;
		*) echo "Invalid Input :("
	esac

	done
	
done
