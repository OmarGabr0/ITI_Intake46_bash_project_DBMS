#! /usr/bin/bash
shopt -s extglob
 check_file(){
    source exist.sh "$1" "$2" 
    ret=$?

    # check if the file is exist
    if (( ret == 0 )) 
    then 
        mkdir -p "../Databases/$1"
        touch "../Databases/$1/$2"
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

## Wrong implementation i did : #### check the type of enterd value of PK 
#while true; do
read -p "Enter PK name: " PK 
 #   case $PK_Type in 
 #       "string"|"s"|"s")
 #           if [[ ! $pk == +([a-zA-Z]) ]]; then
 #           echo "please enter valid input according to selected type:  string"
 #           else 
 #           break 2 
 #           fi
 #           ;;
 #       "integer"|"int"|"i"|"I")        
 #           if [[ ! $pk == +([0-9]) ]]; then
 #           echo "please enter valid input according to selected type:  integer"
 #           else 
 #           break 2 
 #           fi
 #           ;
 #
 #   esac
#done
# saving the columns names 
echo "Enter Colns names eith constrains"
echo "Example: Name unique notnull string"
echo "or: dependant notunique null integer "

for ((i=0 ; i< no_coln ; i++ )){
    read arr[i]
}

# remove it or leave it : main is for debugging 
    echo " Columns = ${arr[@]}"

}

# Create Metadata
parse_colns () {
    touch "../Databases/$1/.${2}_meta"
    for coln in "${arr[@]}" 
    do 
        # initializing an array that will have each coln data
        val=($coln) 
        #  map null =1 , notnull = 0
        # string =s , integer = i 
        if [[ "${val[1]}" == "unique" ]] ; then 
                val[1]=1 
        elif [[ "${val[1]}" == "notunique" ]]; then 
                val[1]=0
        else 
            echo "You entered wrong uniqueness constraint for ${val[0]}"
            exit 1
        fi

        if [[ "${val[2]}" == "null" ]] ; then 
                val[2]=1 
        elif [[ "${val[2]}" == "notnull" ]]; then 
                val[2]=0
        else 
            echo "You entered wrong nullability constraint for ${val[0]}"
            exit 1
        fi

        if [[ "${val[3]}" == "string" ]] ; then 
                val[3]="s" 
        elif [[ "${val[3]}" == "integer" ]]; then 
                val[3]="i"
        else 
            echo "You entered wrong type for ${val[0]}"
            exit 1
        fi
        ## parse the column and write it in metadata
        line=""
        for element in "${val[@]}"; do
            line="$line:$element"
        done
        line="${line:1}"
        echo "$line" >> "../Databases/$1/.${2}_meta"
    done
}
# create PK file
PK_file_make(){

    # as $1 = the data base name ; employee for examples
    if [[ ! -f "../Databases/$1/pk_file" ]]; then 
    touch "../Databases/$1/pk_file"
    fi
    echo "$2:$PK:$PK_Type" >> ../Databases/$1/pk_file

}

# create table and first line in it
## this i made to echo the first line in new table which is column names
### like : ID:essn:dno:address 
create_table(){
    for element in "${arr[@]}"
    do
    coln_name=$(echo "$element" | awk '{print $1}' )
        line="$line":"$coln_name"
    done
    #to remove first : in the line 
    line="${line:1}:"
    echo "$line" > "../Databases/$1/$2"
}

 

main() { 
check_file "$@"
read_input 
PK_file_make "$@"
create_table "$@"
parse_colns "$@"

}

main "$@"



