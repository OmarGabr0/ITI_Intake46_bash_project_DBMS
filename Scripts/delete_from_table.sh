#! /usr/bin/bash
shopt -s extglob
# $1 = data base name 
take_inputs(){
    read -p "DELETE FROM: " table 
    # coln=pattern
    read -p "WHERE: " cond
    # this remove the shortest path and longest path to retrive 
    # the coln name from the pattern 
    


        operator=$(grep -oE '<=|>=|<|>|=' <<<"$cond")
        coln=${cond%%$operator*}
        patter=${cond#*$operator}

        echo "coln=$coln"
        echo "operator=$operator"
        echo "patter=$patter"

    # trem if user entered  spaces before the name 
    patter=$(echo "$patter" | sed 's/^[[:space:]]*//')
    echo "coln=$coln"
    echo "pattern:$patter"
    # retrive coln number
    coln_number=$(awk -F: -v coln="$coln" '{ if (NR==1) { for( i=1;i<=NF;i++ ){ if( $i == coln ){print i} } } }' "../Databases/$1/$table")


}
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
    type=$(grep -w -F $coln $meta | awk -F: '{print $4}') 
   
    case $type in 
        "i")  
            case $operator in 
                # case only = 
                "=") 
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
                            #Debug:
                            echo $str
                            echo "sed -n \"/$str/p\" \"../Databases/$1/$table\""
                            # sed -i "/$str/d" "../Databases/$1/$table"
                            ;;
                        +([0-9]))
                            strPtr=$patter
                            echo "strPtr=$patter"
                            echo $strptr
                            generate_sed_pattern 
                            #Debug: 
                                echo "generated_sed_pattern=$str"
                                echo "sed -n \"/$str/p\" \"../Databases/$1/$table\""
                            # sed -i "/$str/d" "../Databases/$1/$table"
                            ;;
                        # if no thing 
                        *) 
                            echo "invalid number"
                            exit 1 
                            ;;  
                    esac # End of case $patter
                    ;;
                ">") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        ((patter+=1))
                        strPtr="\(\|[${patter}-9]\|[1-9][0-9]\+\)"
                        #Debug: 
                            echo "strptr=$strPtr"

                        generate_sed_pattern
                
                        #Debug: 
                            echo "generated_sed_pattern=$str"
                            echo "sed -n \"/$str/p\" \"../Databases/$1/$table\""
                            # sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;;
                "<") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        ((patter-=1))
                        strPtr="\([0-${patter}]\)"
                        #Debug: 
                            echo "strPtr=$strPtr"
                        generate_sed_pattern
                
                        #Debug: 
                            echo "generated_sed_pattern=$str"
                            echo "sed -n \"/$str/p\" \"../Databases/$1/$table\""
                            # sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;; 
                ">=") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        
                        strPtr="\(\|[${patter}-9]\|[1-9][0-9]\+\)"
                        #Debug: 
                            echo "strPtr=$strPtr"
                        generate_sed_pattern
                
                        #Debug: 
                            echo "generated_sed_pattern=$str"
                            echo "sed -n \"/$str/p\" \"../Databases/$1/$table\""
                            # sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;;
                "<=") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        strPtr="\([0-${patter}]\)"
                        #Debug: 
                            echo "strPtr=$strPtr"
                        generate_sed_pattern
                
                        #Debug: 
                            echo "generated_sed_pattern=$str"
                            echo "sed -n \"/$str/p\" \"../Databases/$1/$table\""
                            # sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;; 
                *) 
                    echo "invalid operator"
                    # exit 1 
                    ;;
            esac # End of case $operator
            ;;
        "s")   
            case $operator in 
                "=")
                    strPtr=$patter
                    #Debug: 
                        echo "strPtr=$strPtr"
                    generate_sed_pattern
                    echo "generated_sed_pattern=$str"
                    echo "sed -En \"/$str/p\" \"../Databases/$1/$table\""
                    # sed -Ei "/$str/d" "../Databases/$1/$table"
                    
                    ##Explainaition 
                            ## here i used sed -E that enable ERE regex
                            ## check the rules of allowed patterns in sed -E 
                            ## this is the only patterns allowed 
                            ## Reminder: should implement a feel-safe to check if user
                            ## input un allowed pattern 
                    ;;
                *) 
                    echo "invalid operator used" 
                    ;;

            esac
            
            ;;
            *) 
                ;;

    esac # End of case $type
}

main () {
    take_inputs "$@"
   # retrive_coln "$@"
    get_coln_type "$@"

}
main "$@"

