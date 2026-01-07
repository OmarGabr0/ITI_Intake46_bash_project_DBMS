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
            echo -e "${RED}Error: column '$colns' not found ${RESET}"; exit 1
        fi
        outColn+="$num "
    done
    outColn=${outColn% }
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
            #echo "$header"
            return
        fi
        IFS=',' read -ra cols <<< "$outdata"

    ## to parse the colns needed only 

    get_coln_locations "$@"
  
    # Print selected columns
    mapfile -t buffer < <(printf '%s\n' "${buffer[@]}" | awk -F: -v cols="$outColn" '
    BEGIN { n = split(cols, c, " ") }
            {
                for (i=1; i<=n; i++) {
                    printf "%s", $c[i]
                    if (i<n) printf ":"
                }
                print ""
            }')
## adding & parsing the header
       header=$(echo "$header" | awk -F: -v cols="$outColn" '
            BEGIN { n = split(cols, c, " ") }
            {
                for (i=1; i<=n; i++) {
                    printf "%s", $c[i]
                    if (i<n) printf ":"
                }
                print ""
            }')

}
main () {
    take_inputs "$@"
   # retrive_coln "$@"
    get_coln_type "$@"
    retrive_data "$@"
    clear
   
    buffer=( "$header" "${buffer[@]}" )
    printf '%s\n' "${buffer[@]}" | column -s ':' -t
    echo -e "\n"
    echo -e "${RED} Press ENTER to continue...${RESET}"
    read
}
main "$@"