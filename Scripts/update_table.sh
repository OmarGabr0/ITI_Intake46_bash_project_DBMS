#! /usr/bin/bash
# Script Parameter : $DB_Name

# Sources section
source repeating_functions.sh

DB_Path="../Databases/$1"

take_inputs(){
    
    # First phase : Getting table name and its validation
    while true
    do
        echo "====================================="
        read -p "Enter table name : " table_name
        is_empty $table_name
        res=$?
        if [ $res -eq 1 ]
        then 
        echo "Enter a value, the system doesn't accept empty inputs"
        else
        check_if_exists f "$DB_Path/$table_name"
            if [ $? -eq 0 ]
            then
            echo "This table doesn't exist"
            else break 
            fi
        fi
    done

    # Second phase : Asking for number of columns & its validation

    # Get the column names (meta data) of the table
    col_names=$(head -1 "$DB_Path/$table_name")
    echo $col_names
    
    # Parsing the line into an array :
    IFS=: read -r -a col_names_arr <<< $col_names

    while true
    do
        echo "====================================="
        read -p "Enter number of columns you want to update : " no_cols
        is_empty $no_cols
        if [ $? -eq 1 ]
        then echo "System does not accept empty inputs"
        else
            if [[ ( $no_cols > ${#col_names_arr[@]} ) || ( $no_cols -lt 1 ) ]]
            then echo "Invalid number of columns"
            else break 
            fi
	    fi
    done

        echo "====================================="
        echo "Enter column name, followed by the value you want to insert"

        # A string that stores the 
        # input columns that exist in the table meta data (column names => first line )
        # This is used to make sure that the user doesn't enter the same column name again 
        found_cols=""

        for(( i=1; i <= no_cols; i++ ))
        do

     
            while true
            do
                read -p "Column $i : " input_col
                is_empty $input_col
                if [ $? -eq 1 ]
                then echo "Error: empty input"
                else 
                    col_names_validation $input_col $col_names
                    res=$?
                    if [ $res -eq 0 ]
                    then 
                    echo "Column name you entered does not exist in the table, enter another name :  "
                    elif [ $res -eq 2 ]
                    then 
                    echo "You entered this name before, enter another column name "
                   # continue 2
                    else break
                        # No errors in col name, start taking value and validating it
                    fi
                fi
            done

            # while true
            # do
            #     col_names_validation $input_col $col_names
            #     if [ $? -eq 0 ]
            #     then 
            #     echo " Column name you entered does not exist in the table, enter another name :  "
            #     (( i-- ))
            #     continue 2
            #     fi
            # done
            
        done

}

# Takes 2 arguments :
# $1 : col name to be validated ($1)
# $2 : col names line coming from table 
col_names_validation(){
    col_name=$1
    col_names_line=":$2"
    IFS=: read -r -a col_names_array <<< $col_names_line

    is_found=0
    for((ctr = 1; ctr <= ${#col_names_array[@]}; ctr++))
    do 
    # if the column name entered by user exists in the table => no error => return 1
    # else : the user entered a col name that does not exist in the table => error => return 0 
        if [[ $col_name == ${col_names_array[ctr]} ]]
        then 
            is_found=1
            is_repeated=0
            for data in $found_cols
            do 
                if [ $col_name == $data ]
                then 
                is_repeated=1
                break
                else is_repeated=0
                fi
            done
                if [ $is_repeated -eq 0 ]
                then
                found_cols+="$col_name "
                # echo $found_cols
                break    
                else return 2   # 2 return value => for error handling
                fi
        fi
    done
    return $is_found
}

main(){
    take_inputs
}

main $@
