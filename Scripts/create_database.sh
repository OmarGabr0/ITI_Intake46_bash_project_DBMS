# Sources section
source repeating_functions.sh

# First we check if the "Databases" Folder exists or not
check_if_exists d ../Databases
result=$?

	if [ $result -eq 0 ]
	then
		mkdir ../Databases
	fi

while true
do
	# Ask user the database name he/she wants to create
	read -p "Enter database name : " DB_name
	is_empty $DB_name
	res=$?
	if [ $res -eq 1 ]
	then echo -e "${RED}System doesn't accept empty inputs ${RESET}"
	else
		if [[ ! $DB_name =~ ^[A-Za-z][A-Za-z0-9_-]*$ ]]
		then 
		echo -e "${RED}Invalid name ${RESET}"
		else
			# Check if database exists, if it exists ask the user to enter another name
			check_if_exists d ../Databases/$DB_name
			result=$?
			
			if [ $result -eq 1 ] 
			then
				echo -e "${RED}Database already exists ${RESET}"
			else
				mkdir ../Databases/"$DB_name"
				echo -e "${GREEN}Database $DB_name created successfully! ${RESET}"
			#	sleep 0.1 
				break
			fi
		fi
	fi	
done


