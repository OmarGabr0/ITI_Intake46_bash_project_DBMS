#! /usr/bin/bash

# Main menu for database creation

database_dir="../Databases"

while true
do
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
	sleep 0.5
	echo -e "\n"
	echo "==========="
done
