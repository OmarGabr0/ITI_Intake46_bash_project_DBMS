#! /usr/bin/bash

if [[ -f $1/$2 ]]; then
    return 1 
    else
    return 0 
fi

