#! /usr/bin/bash
shopt -s extglob
# $1 = data base name 
take_inputs(){
    read -p "DELETE FROM: " table 
    # coln=pattern
    read -p "WHERE: " cond
    # this remove the shortest path and longest path to retrive 
    # the coln name from the pattern 
    

   operator=$(echo $cond | sed -n 's/.*\(<=\|>=\|<\|>\|=\).*/\1/p')  
# need to understand more 
        op_escaped=$(echo "$operator" | sed 's/[][\\.^$*]/\\&/g')

    #coln=${cond%=*}
        coln=$(echo "$cond" | sed "s/\(.*\)$op_escaped.*/\1/")

    #patter=${cond#*=}
        patter=$(echo "$cond" | sed "s/.*$op_escaped\(.*\)/\1/")

    # trem if user entered  spaces before the name 
    patter=$(echo "$patter" | sed 's/^[[:space:]]*//')
    echo "coln=$coln"
    echo "pattern=$patter"
    # retrive coln number
    coln_number=$(awk -F: -v coln="$coln" '{ if (NR==1) { for( i=1;i<=NF;i++ ){ if( $i == coln ){print i} } } }' "../Databases/$1/$table")



#################Getting the coln number using awk #########
generate_sed_pattern() {

        str="^"
        for ((i=0; i < coln_number -1 ;i++))
        do 
            str+="[^:]*:"
        done
        str+=$strPtr":"
    # for debugging:
            echo "sed_strting=$str"
}

####################
get_coln_type(){

    meta="../Databases/$1/.${table}_meta"
   
    # git the type from meta data  
    type=$(grep -w -F  $coln $meta | awk -F: '{print $4}') 
   
   case $type in 
    
    "i")  
    case $operator in 
      # case only = 
      =) 
        case $patter in 
            {+([0-9])..+([0-9])})
            # if input like {1..12} --then arr = 1 2 3 4 

                arr=($(eval echo "$patter"))
                # for debugging 
                echo "arr=${arr[@]}"
                
                strPtr="\(" 
                for ele in "${arr[@]}"
                do 
                    strPtr+=$ele"\|"
                done 

                strPtr="${strPtr%\|}"
                strPtr=$strPtr")"
                    
                    
                echo "strPtr=$strPtr"
                generate_sed_pattern 
                
                echo $str
                # sed -i "/$str/d" "../Databases/$1/$table"
                ;;
            +([0-9]))
                    
                
                echo "strPtr=$patter"
                echo $strptr
                generate_sed_pattern 
                # echo the generated sed  pattern 
                echo $str
                # sed -i "/$str/d" "../Databases/$1/$table"
                ;;
                # if no thing else 
            *) 
                echo "invalid number"
                exit 1 
                ;;  
            esac
        ;;
        >) 
            ;;
        <) 
            ;; 
        >=) 
            ;;
        <=) 
            ;; 
        *) 
            echo "invalid operator"
            exit 1 
            ;;
    
    "s")   
        ;;

   esac
    
    
}


main () {
    take_inputs "$@"
   # retrive_coln "$@"
    get_coln_type "$@"

}
main "$@"

