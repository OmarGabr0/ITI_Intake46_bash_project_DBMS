#! /usr/bin/bash
# $1 = Data base name 
# $2 = Table name
if [[ -f ../Databases/$1/$2 ]]; then
    return 1 
    else
    return 0 
fi

