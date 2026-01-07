# Sources section
source repeating_functions.sh

while true 
do
	read -p "Enter the name of the database you want to drop : " DB_name
	is_empty $DB_name
	res=$?
	if [ $res -eq 1 ]
	then
		echo -e "${RED}Input should not be empty ${RESET}"
	elif [[ ! $DB_name =~ ^[A-Za-z][A-Za-z0-9_-]*$ ]]
	then
		echo -e "${RED}Invalid input ${RESET}"
	else 
		DB_dir="../Databases/$DB_name"
	break
	fi
done

if [ -d $DB_dir  -a  -d "../Databases" ]
then 
	read -p "Are you sure? (y/n) : " response
       
	if [ "$response" = "y" -o "$response" = "Y" ] 
	then
		rm -r $DB_dir
		echo -e "${GREEN}Database $DB_name dropped successfully ${RESET}" 
	elif [ "$response" = "n" -o "$response" = "N" ]
	then
		echo "Drop request cancelled"
	else
		echo -e "${RED}Wrong input ${RESET}"
		echo "Drop request cancelled"
	fi


else
	echo -e "${RED}Database does not exist ${RESET}"
fi
