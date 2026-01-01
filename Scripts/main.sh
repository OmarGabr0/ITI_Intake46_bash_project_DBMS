#! /usr/bin/bash

# Main menu for database creation
source ui.sh
while true
do	
	clear
	#echo "==========================================================" 
	#echo "                 Welcome to DBMS                          " 
	#echo " Made by Omar Gabr & Medhat Osama                         "
	#echo "=========================================================="

	print_header

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
