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



    # trem if user entered  spaces before the name 
    patter=$(echo "$patter" | sed 's/^[[:space:]]*//')

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
                            
                            strPtr="\(" 
                            for ele in "${arr[@]}"
                            do 
                                strPtr+=$ele"\|"
                            done 

                            strPtr="${strPtr%\|}"
                            strPtr=$strPtr")"
                            
                            
                            generate_sed_pattern 

                            sed -i "/$str/d" "../Databases/$1/$table"
                            ;;
                        +([0-9]))
                            strPtr=$patter
                            
                            generate_sed_pattern 

                            sed -i "/$str/d" "../Databases/$1/$table"
                            ;;
                        # if no thing 
                        *) 
                            echo "invalid number"
                            return 
                            ;;  
                    esac # End of case $patter
                    ;;
                ">") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                            # Don't do ((patter+=1)) here if you use the logic below, 
                            # because the logic already uses $((units+1)).
                            
                            if [ ${#patter} -eq 1 ]; then

                                strPtr="\([$((patter+1))-9]\|[0-9]\{2,\}\)"
                                
                            elif [ ${#patter} -eq 2 ]; then
                                tens=${patter:0:1}
                                units=${patter:1:1}
                                
                                strPtr="\($tens[$((units+1))-9]\|[$((tens+1))-9][0-9]\|[0-9]\{3,\}\)"
                            else 
                                echo "please enter numbers between 1-99"
                                # Use return or continue instead of exit 1 to keep the script running
                                return 
                            fi
                            
                            # Ensure generate_sed_pattern uses $strPtr to build $str
                            generate_sed_pattern 
                            
                            sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;;
                "<") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        ((patter-=1))
                        
                        if [ $patter -lt 10 ]; then
                          strPtr="\([0-$patter]\)"
                        else
                            # For multi-digits, you need complex ranges
                            # Example for <= 12: \([0-9]\|1[0-2]\)
                            strPtr="\([0-9]\|1[0-$((patter % 10))]\)"
                        fi
                        generate_sed_pattern
                

                         sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;; 
                ">=") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        
                            
                            if [ ${#patter} -eq 1 ]; then

                                strPtr="\([$((patter))-9]\|[0-9]\{2,\}\)"
                                
                            elif [ ${#patter} -eq 2 ]; then
                                tens=${patter:0:1}
                                units=${patter:1:1}
                                
                                strPtr="\($tens[$((units))-9]\|[$((tens+1))-9][0-9]\|[0-9]\{3,\}\)"
                            else 
                                echo "please enter numbers between 1-99"
                                # Use return or continue instead of exit 1 to keep the script running
                                return 
                            fi
                        
                        generate_sed_pattern
                

                        sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;;
                "<=") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        if [ $patter -lt 10 ]; then
                        strPtr="\([0-$patter]\)"
                        else
                            # For multi-digits, you need complex ranges
                            # Example for <= 12: \([0-9]\|1[0-2]\)
                            strPtr="\([0-9]\|1[0-$((patter % 10))]\)"
                        fi

                        generate_sed_pattern
                

                        sed -i "/$str/d" "../Databases/$1/$table"
                        else
                            echo "invalid input pattern"
                        fi
                    ;; 
                *) 
                    echo "invalid operator"
                    return
                    ;;
            esac # End of case $operator
            ;;
        "s")   
            case $operator in 
                "=")
                    strPtr=$patter

                    generate_sed_pattern
                    
                    sed -Ei "/$str/d" "../Databases/$1/$table"
                    
                    ##Explainaition 
                            ## here i used sed -E that enable ERE regex
                            ## check the rules of allowed patterns in sed -E 
                            ## this is the only patterns allowed 
                            ## Reminder: should implement a feel-safe to check if user
                            ## input un allowed pattern 
                    ;;
                *) 
                    echo "invalid operator used"
                    return 
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

