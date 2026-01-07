#! /usr/bin/bash
# $1 tha data base name
# $2 the table name 

source repeating_functions.sh

# remove the table and metadata 
remove_source () {

    check_if_exists "f" "../Databases/$1/$2"
    if [ $? -eq 1 ]
    then  
    rm -f "../Databases/$1/$2" 
    rm -f "../Databases/$1/.${2}_meta"
    echo -e "${GREEN}Table dropped successfully ${RESET}"
    else 
    echo -e "${RED}Table already doesn't exist ${RESET}"
    source connect_to_database.sh
    fi
}

pk_edit () {

    sed -i "/${2}/d" "../Databases/$1/pk_file"
}


main () {
    remove_source "$@"
    pk_edit "$@"
}
main "$@"


