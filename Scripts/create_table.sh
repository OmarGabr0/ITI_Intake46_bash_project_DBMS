 #! /usr/bin/bash
declare -a buffer

shopt -s extglob
source repeating_functions.sh
tmp_file="../Databases/$1/$2"

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
    read -p "Enter PK type: ( string , integer): " PK_Type 
        if [[ "$PK_Type" == "string" || "$PK_Type" == "S" || "$PK_Type" == "s" || \
            "$PK_Type" == "integer" || "$PK_Type" == "int" || "$PK_Type" == "i" || "$PK_Type" == "I" ]]; then
        break
        else  
            echo "please inter a valid option (sting , s, S ) or (integer , int ,i ,I): "
        fi
done
###mapping the pk type again###############################################
    if [[ "$PK_Type" == "integer" || "$PK_Type" == "int" || "$PK_Type" == "i" || "$PK_Type" == "I" ]]; then
        pk_type_mapped="integer"
    else
        pk_type_mapped="string"
    fi
#########################################################################################

## Wrong implementation i did : #### check the type of enterd value of PK 
#while true; do
while true 
do 
    
    read -p "Enter PK name: " PK 
    is_empty $PK
    if [ $? -eq 1 ]; then 
    echo "system not accept empty input" 
    else break
    
done 

# saving the columns names 
echo -e "Enter Colns names with constrains \n"
echo "Example: Name unique notnull string"
echo -e "or: dependant notunique null integer \n"

pk_entered=0

for ((i=0 ; i< no_coln ; i++ ))
do
    echo -e "Enter Entry number: " $i 
    read arr[i]

    ###### To check PK unique and not null ######################
    is__the_pk_line=$( echo "${arr[i]}" | awk -v PK_name="$PK" '{ if ($1==PK_name) {print $0}  }' )
    if [ -n "$is__the_pk_line" ]; then
        pk_entered=1
        echo "+++++++ hint: pk entry just added!"
     IFS=' ' read -r -a cols <<< "${arr[i]}"
        if [[ "${cols[1]}" != "unique" || "${cols[2]}" != "notnull" ||  "${cols[3]}" != "$pk_type_mapped" ]]; then 

            echo "-------- please make the pk unique and notnull"
            echo -e "-------- re-enter the pk line"
            (( i-- ))
            continue
        fi
    fi
    ##############################################################

    ###### to check the inpu of data follow the rules or not ######
    cols=""
    IFS=' ' read -r -a cols <<< "${arr[i]}"
    if [[ ! ( \
        ( "${cols[1]}" == "unique" || "${cols[1]}" == "notunique" ) && \
        ( "${cols[2]}" == "notnull" || "${cols[2]}" == "null" ) && \
        ( "${cols[3]}" == "string"  || "${cols[3]}" == "integer" ) \
    ) ]]; then
        echo -e "-------- Invalid line sytax, Re-enter the line again \n"
        (( i-- ))  
    fi 
    ##############################################################
    
    ############### check if the pk is entered again ###############


    ################################################################

    done
    
    ############### check if the pk line entered before ########### 
            if (( pk_entered == 0 )); then
                echo "Error: No primary key entered"
                echo "-------- Aborting."
                # removing created trash table 
                rm "$tmp_file"
                return
            fi
        ##############################################################

}

# Create Metadata
parse_colns () {
    
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
            echo "-------- You entered wrong uniqueness constraint for ${val[0]}"
            exit 1
        fi

        if [[ "${val[2]}" == "null" ]] ; then 
                val[2]=1 
        elif [[ "${val[2]}" == "notnull" ]]; then 
                val[2]=0
        else 
            echo "-------- You entered wrong nullability constraint for ${val[0]}"
            exit 1
        fi

        if [[ "${val[3]}" == "string" ]] ; then 
                val[3]="s" 
        elif [[ "${val[3]}" == "integer" ]]; then 
                val[3]="i"
        else 
            echo "-------- You entered wrong type for ${val[0]}"
            exit 1
        fi
        ## parse the column and write it in metadata
        line=""
        for element in "${val[@]}"; do
            line="$line:$element"
        done
        
        # offsite 1 to remove the first ":"  
        line="${line:1}"
        
             buffer+=("$line")
       # echo "$line" >> "../Databases/$1/.${2}_meta"
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
create_table "$@"
parse_colns "$@"


# printing if code success 
    ## making the append in pk file
    PK_file_make "$@"
    echo "=======> PK File updated successfully."
    ##creating meta data and writing buffered data in meta data file
    touch "../Databases/$1/.${2}_meta"
    printf "%s\n" "${buffer[@]}" > "../Databases/$1/.${2}_meta"
    echo "=======> Meta Data File created successfully."
}

main "$@"

