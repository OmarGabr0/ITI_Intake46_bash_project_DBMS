#! /usr/bin/bash
# Script Parameter : $DB_Name

# Sources section
source repeating_functions.sh

DB_Path="../Databases/$1"

take_inputs(){
    
    # First phase : Getting table name and its validation
    table_name=""
    table_name_validation $table_name  
   

    # Second phase : Asking for number of columns & its validation

    # Get the column names (meta data) of the table
    col_names=$(head -1 "$DB_Path/$table_name")

    # For debugging :
    # echo $col_names

    no_cols_validation $col_names

        echo "====================================="
        echo "Enter column name, followed by the value you want to insert"

        # A string that stores the 
        # input columns that exist in the table meta data (column names => first line )
        # This is used to make sure that the user doesn't enter the same column name again 
        found_cols=""
        typeset input_cols_arr[$no_cols]
        typeset input_vals_arr[$no_cols]
        for(( i=1; i <= no_cols; i++ ))
        do     
            input_cols_validation

             # No errors in col name, insert column in an array and start taking value and validating it
            input_vals_validation
        done

    # For debugging
        # for ((i=0; i < no_cols; i++))
        #     do 
        #     echo ${input_cols_arr[$i]}
        # done

        #     echo "--------------------" 

        #  for ((i=0; i < no_cols; i++))
        #     do 
        #     echo ${input_vals_arr[$i]}
        # done

    update_by_id

}

table_name_validation(){
    table_name=$1
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
}

no_cols_validation(){
    col_names=$1
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
}

input_cols_validation(){
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
                    else 
                        input_cols_arr[$((i-1))]=$input_col
                        break
                    fi
                fi
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

input_vals_validation(){
    while true
    do 
        read -p "Value $i : " input_val
        is_empty $input_val
        if [ $? -eq 1 ]
        then
            echo "System does not accept empty inputs"
        else
            constraints_check $input_val "${input_cols_arr[$((i-1))]}" $DB_Name $table_name
            if [ $? -eq 0 ]  # There are no errors
            then
            input_vals_arr[$((i-1))]=$input_val
            break
            fi
        fi
    done
}

update_by_id(){
    # Get primary key and its index then ask user for the pk value for the row he searches for
    PK=$(sed -n "/$table_name/p" "$DB_Path/pk_file" | awk -F: '{print $2}')
    PK_Datatype=$(sed -n "/nti/p" "$DB_Path/pk_file" | awk -F: '{print $3}')
     echo "====================================="
     while true
     do
        read -p "Enter value of the row you are updating ($PK) : " PK_Val
        # This value needs to be validated => integer or string
        is_empty $PK_Val
        if [ $? -eq 1 ]
        then echo "System does not accept empty input"
        else break
        fi
     done

     # Get PK index & indices of columns to be updated
   
     PK_Index=$(get_index "$PK")

     input_cols_indices=()
     for coln in "${input_cols_arr[@]}"
     do
        input_cols_indices+=( "$( get_index $coln )" )
     done
     
    # --- Perform the update using awk ---
    awk -F: -v OFS=: \
    -v pk_i="$PK_Index" \
    -v pk_v="$PK_Val" \
    -v idxs="$(IFS=,; echo "${input_cols_indices[@]}")" \
    -v vals="$(IFS=,; echo "${input_vals_arr[@]}")" '
    BEGIN{
        split(idxs, I, ",")   # I = indexes of columns to update
        split(vals, V, ",")   # V = new values
    }
    NR==1 { print; next }      # print header line
    $(pk_i) == pk_v {        # if PK matches
    for(i=1;i<=length(I);i++)
        $I[i] = V[i]   # update fields
}
{ print }                  # print every line
' "$DB_Path/$table_name" > /tmp/tmp_tbl && mv /tmp/tmp_tbl "$DB_Path/$table_name"
}

main(){
    take_inputs
}

main $@
