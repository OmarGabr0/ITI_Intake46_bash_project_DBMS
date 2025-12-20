read -p "Enter the name of the database you want to drop : " DB_name
DB_dir="../Databases/$DB_name"

if [ -d $DB_dir  -a  -d "../Databases" ]
then 
	read -p "Are you sure? (y/n) : " response
       
	if [ "$response" = "y" -o "$response" = "Y" ] 
	then
		rm -r $DB_dir
		echo "Database $DB_name dropped successfully" 
		sleep 1
	elif [ "$response" = "n" -o "$response" = "N" ]
	then
		echo "Drop request cancelled"
		sleep 1
	else
		echo "Wrong input"
		echo "Drop request cancelled"
		sleep 1
	fi


else
	echo "Database does not exist"
	sleep 1
fi
