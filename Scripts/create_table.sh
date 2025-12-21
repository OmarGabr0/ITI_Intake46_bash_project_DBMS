#! /usr/bin/bash
shopt -s extglob
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
# if user didnt enter an integer it keeps looping or exit
while true ; do 
read -p "Enter no of columns: " no_coln
if [[  $no_coln == +([0-9]) ]]; then
        break 
    elif [[ $no_coln = "exit" ]]; then
    return 1 
fi
echo -e " wrong input, please enter integer \n or Enter exit to aprot"   
done  
# keep tring to enter till the value of pk type is valid
while true; do    
read -p "Enter PK type: ( string , integer)" PK_Type 
if [[ "$PK_Type" == "string" || "$PK_Type" == "S" || "$PK_Type" == "s" || \
      "$PK_Type" == "integer" || "$PK_Type" == "int" || "$PK_Type" == "i" || "$PK_Type" == "I" ]]; then
 break
 else  
 echo "please inter a valid option (sting , s, S ) or (integer , int ,i ,I) "
fi
done

#### check the type of enterd value of PK 
while true; do
read -p "Enter PK name: " PK 
    case $PK_Type in 
        "string"|"s"|"s")
            if [[ ! $pk == +([a-zA-Z]) ]]; then
            echo "please enter valid input according to selected type:  string"
            else 
            break 2 
            fi
            ;;
        "integer"|"int"|"i"|"I")        
            if [[ ! $pk == +([0-9]) ]]; then
            echo "please enter valid input according to selected type:  integer"
            else 
            break 2 
            fi
            ;

    esac
done
# saving the columns names 
echo "Enter Colns names"
for ((i=0 ; i< no_coln ; i++ )){
    read arr[i]
}

# remove it or leave it : main is for debugging 
    echo " Columns = ${arr[@]}"

}


PK_file_make(){

    if [[ ! -f "$1/pk_file" ]]; then 
    touch "$1/pk_file"
    fi
    echo "$2:$PK:$PK_Type" >> "$1"/pk_file

}





 

main() { 
check_file "$@"
read_input 
PK_file_make "$@"

}

main "$@"



