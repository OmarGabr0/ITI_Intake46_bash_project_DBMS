#! /usr/bin/bash
 check_file(){
    source exist.sh "$1" "$2" 
    ret=$?

    # check if the file is exist
    if (( ret == 0 )) 
    then 
        touch "./$1/$2"
    else 
        echo "Table already exist" 
        exit 1 
    fi
 }

read_input(){
# read -p "Enter Table Name: " table_name 
# commented as assumed table name alreaady passed

while true ; do 
read -p "Enter no of columns: " no_coln
if [[  $no_coln == +([0-9]) ]]; then
        break 
    elif [[ $no_coln = "exit" ]]; then
    return 1 
fi
echo " wrong input, please enter integer \n or Enter exit to aprot" 
    
done  
    
read -p "Enter PK type: ( string , integer)" PK_Type 
read -p "Enter PK: " PK 
}
 

main() { 
check_file "$@"
read_input 

}

main "$@"



