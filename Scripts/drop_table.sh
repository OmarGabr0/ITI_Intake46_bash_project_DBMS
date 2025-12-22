#! /usr/bin/bash
# $1 tha data base name
# $2 the table name 


# remove the table and metadata 
remove_source () {

    rm -f "../Databases/$1/$2" 
    rm -f "../Databases/$1/.${2}_meta"
}

pk_edit () {

    sed -i "/${2}/d" "../Databases/$1/pk_file"
}


main () {
    remove_source "$@"
    pk_edit "$@"
}
main "$@"


