# First we check if the "Databases" Folder exists or not
source check_if_exists.sh d ../Databases
result=$?

	if [ $result -eq 0 ]
	then
		mkdir ../Databases
	fi
	
	
# Ask user the database name he/she wants to create
read -p "Enter database name : " DB_name

# Check if database exists, if it exists ask the user to enter another name

while true
do
	source check_if_exists.sh d ../Databases/$DB_name
	result=$?
	
	if [ $result -eq 1 ] 
	then
		read -p "Database already exists, enter another name : " DB_name
	else
		mkdir ../Databases/"$DB_name"
		echo Database $DB_name created successfully!
	#	sleep 0.1 
		break
	fi
done

