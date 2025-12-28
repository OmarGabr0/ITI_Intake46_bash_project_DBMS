#! /usr/bin/bash
shopt -s extglob
declare -a buffer

# $1 = data base name 
take_inputs(){
    #read colns that want the data to be outputed by 
    read -p "SELECT: " outdata    # may be * or dno,name,ssn 
                                #IMP: should handle the case of dno, name  , ssn 

    read -p "FROM: " table 
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
    ## used in generating sed pattern 
    coln_number=$(awk -F: -v coln="$coln" '{ if (NR==1) { for( i=1;i<=NF;i++ ){ if( $i == coln ){print i} } } }' "../Databases/$1/$table")
    

}
####################################################################################
#################Getting the coln number using awk #########
### used if the user want any thing not * 
        ## example : SELECT dno,ssn,addr 
get_coln_locations() {
    outColn=""
    for colns in "${cols[@]}"; do
        colns=$(echo "$colns" | xargs) 
        num=$(awk -F: -v coln="$colns" 'NR==1{for(i=1;i<=NF;i++){if($i==coln) print i}}' "../Databases/$1/$table")
        if [[ -z "$num" ]]; then
            echo "Error: column '$colns' not found"; exit 1
        fi
        outColn+="$num "
    done
    outColn=${outColn% }
}

generate_sed_pattern() {

        str="^"
        for ((i=0; i < coln_number -1 ;i++))
        do 
            str+="[^:]*:"
        done
        str+=$strPtr":"

}

####################################################################################
### function to get the coln type from metadata file ######
## used for retriving
get_coln_type(){

    meta="../Databases/$1/.${table}_meta"
   
    # git the type from meta data  
    type=$(grep -w -F $coln $meta | awk -F: '{print $4}') 
}

retrive_using_awk(){
    


    mapfile -t buffer < <(awk -F: -v col="$coln_number" -v op="$operator"   -v val="$patter" -v type="$type" '
    NR>1 {
        if (type=="i") {
            if ((op=="=" && $col==val) ||
                (op==">" && $col>val) ||
                (op=="<" && $col<val) ||
                (op==">=" && $col>=val) ||
                (op=="<=" && $col<=val)) print
        } else if (type=="s") {
            if (op=="=" && $col==val) print
        }
    }' "../Databases/$1/$table")

}

####################################################################################
### function that handels the retriver of only selected items from table 
### retrivered data are based on SELECT argument 
#### EX: SELECT * 
#### EX: SELECT dno,ssn,name
## always call retrive_* as it saves the whole table in a buffer 
## then i chose here if i want to display the whole data or selected from SELECT argument 
## this function cant handle the spaces in SELECT arguments

retrive_data(){


    header=$(head -n 1 "../Databases/$1/$table")
    outdata=$(echo "$outdata" | sed 's/^[[:space:]]*//')
        ## retrive the whole data into buffer then deel with it 
        retrive_using_awk "$@"
        if [[ "$outdata" == "*" ]]; then
            echo "$header"
            printf '%s\n' "${buffer[@]}"
            return
        fi
            IFS=',' read -ra cols <<< "$outdata"

    ## to parse the colns needed only 

    get_coln_locations "$@"
    ## parse and get the headers only needed
     echo "$header" | awk -F: -v cols="$outColn" '
        BEGIN { n = split(cols, c, " ") }
        {
            for (i=1; i<=n; i++) {
                printf "%s", $c[i]
                if (i<n) printf ":"
            }
            print ""
        }'
    # Print selected columns
    printf '%s\n' "${buffer[@]}" | awk -F: -v cols="$outColn" '
    BEGIN { n = split(cols, c, " ") }
    {
        for (i=1; i<=n; i++) {
            printf "%s", $c[i]
            if (i<n) printf ":"
        }
        print ""
    }'

}
## SELECT * 
## retrived data are based only on battern --> only one battern: 
### EX: WHERE dno>5
retrive_all(){
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
                            
                            echo "strPtr=$strPtr"
                            generate_sed_pattern 


                        mapfile -t buffer < <(sed -n "/$str/p" "../Databases/$1/$table") 
                            ;;
                        +([0-9]))
                            strPtr=$patter
                            echo "strPtr=$patter"
                            echo $strptr
                            generate_sed_pattern 

                            mapfile -t buffer < <(sed -n "/$str/p" "../Databases/$1/$table")
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
                        generate_sed_pattern
                        mapfile -t buffer < <(sed -n "/$str/p" "../Databases/$1/$table")
              
                        else
                            echo "invalid input pattern"
                        fi
                    ;;
                "<") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        ((patter-=1))
                        strPtr="\([0-${patter}]\)"
                        generate_sed_pattern
                        mapfile -t buffer < <(sed -n "/$str/p" "../Databases/$1/$table")
                          
                        else
                            echo "invalid input pattern"
                        fi
                    ;; 
                ">=") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        
                        strPtr="\(\|[${patter}-9]\|[1-9][0-9]\+\)"

                        generate_sed_pattern
                
   
                        
                        mapfile -t buffer < <(sed -n "/$str/p" "../Databases/$1/$table")
                        
                        else
                            echo "invalid input pattern"
                        fi
                    ;;
                "<=") 
                    if [[ $patter =~ ^[0-9]+$ ]]; then 
                        strPtr="\([0-${patter}]\)"

                        generate_sed_pattern
                

                        
                        mapfile -t buffer < <(sed -n "/$str/p" "../Databases/$1/$table")

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

                    generate_sed_pattern
                    echo "generated_sed_pattern=$str"
                    mapfile -t buffer < <(sed -En "/$str/p" "../Databases/$1/$table")
               
                    
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
    retrive_data "$@"
}
main "$@"

