# This shell script takes 2 arguments: $1 => directory or file ('d' or 'f') , $2 => path of the dir/file

if [ $# -gt 2 ]
then
	echo "Error: check_if_exists.sh script takes only 2 arguments"
elif [ $# -lt 2 ]
then
	echo "Error: check_if_exists.sh script takes at least 2 arguments" 
else
	if [ "$1" == "d" ]
	then
		if [ -d "$2"  ]
		then
			return 1
		else 
			return 0
		fi

	elif [ "$1" == "f" ]
	then
		if [ -f "$2" ]
		then
			return 1
		else 
			return 0
		fi
	fi

fi



