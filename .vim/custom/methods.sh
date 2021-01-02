#!/bin/bash
#FILE=$(pwd)/$(echo "$1" | cut -d\( -f2 | grep -Eo "[^)\"]*")
FILES=$(pwd)/*.java
FILE=$(pwd)/$1

PUBLIC_LEADER="syn match javaPublicMethod"
PRIVATE_LEADER="syn match javaPrivateMethod"

PUBLIC=$(grep -E "(public)" $FILES | grep -o "\<[a-z0-9][0-9A-Za-z_]*(" | grep -o "[_a-zA-Z0-9]*" | paste -s -d\| -)
PRIVATE=$(grep -E "(private)" $FILE | grep -o "\<[a-z0-9][0-9A-Za-z_]*(" | grep -o "[_a-zA-Z0-9]*" | paste -s -d\| -)

if [[ -n $PUBLIC ]]; then
    PUBLIC_SYN=$(echo $PUBLIC_LEADER '"\\v('$PUBLIC')\\("me=e-1')
    $(sed -in "2 c ${PUBLIC_SYN}" ~/.vim/after/syntax/java.vim)
else
    $(sed -in "2 c \"" ~/.vim/after/syntax/java.vim)
fi

if [[ -n $(echo $PRIVATE | grep -v "|") ]]; then
    PRIVATE_SYN=$(echo $PRIVATE_LEADER '"\\v('$PRIVATE')\\("me=e-1')
    $(sed -in "3 c ${PRIVATE_SYN}" ~/.vim/after/syntax/java.vim)
else
    $(sed -in "3 c \"" ~/.vim/after/syntax/java.vim)
fi
