# First we check if the "Databases" Folder exists or not

	if [ ! -d "../Databases" ]
	then
		mkdir ../Databases
	fi


# Ask user the database name he/she wants to create
read -p "Enter database name : " DB_name

# Check if database exists, if it exists ask the user to enter another name

while true
do
	if [ -d "../Databases/$DB_name" ] 
	then
		read -p "Database already exists, enter another name : " DB_name
	else
		mkdir ../Databases/"$DB_name"
		echo Database $DB_name created successfully!
		sleep 1 
		break
	fi
done
