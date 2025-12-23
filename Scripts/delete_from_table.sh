#! /usr/bin/bash

# $1 = data base name 
take_inputs(){
    read -p "DELETE FROM: " table 
    # coln=pattern
    read -p "WHERE: " cond
    # this remove the shortest path and longest path to retrive 
    # the coln name from the pattern 
    coln=${cond%=*}
    patter=${cond#*=}
    # trem if user entered  spaces before the name 
    patter=$(echo "$patter" | sed 's/^[[:space:]]*//')
    echo "$coln"
    echo "$patter"
}
#################Getting the coln number using awk #########
retrive_coln() {
    coln_number=$(awk -F: -v coln="$coln" '{ if (NR==1) { for( i=1;i<=NF;i++ ){ if( $i == coln ){print i} } } }' "../Databases/$1/$table")


        str=""
        for ((i=0; i < "$coln_number" ;i++))
        do 
            str+="*:"
        done
        str+=$patter":*"
    echo "$str"
}
delete_record(){

    sed -i "/$str/d" "../Databases/$1/$table"
}

####################

#case $cond in 
#    ## normal number 9 , 99, 23 
#    +([0-9]) )
#
#        ;;
#
#
#esac

main () {
    take_inputs "$@"
    retrive_coln "$@"
    delete_record "$@"

}
main "$@"

