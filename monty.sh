#!/bin/bash

## bash 'monty-hall game' simulator
## a.k.a. 'deal or no deal' tv show
## http://en.wikipedia.org/wiki/Monty_Hall_problem
##   " .. Pigeons repeatedly exposed to the problem show that they rapidly learn always to switch, unlike humans"

ITERS=100 ; GOAT=0 ; AUTO=1 ; RND012=0

function rnd012() {
    RND012=$RANDOM
    RND012 = $(( RND012 %= 3 )) 2>/dev/null
    }

echo "playing $ITERS random monty-hall games"

for unused in `seq 1 $ITERS` ; do
    # random input
    L="ERR"
    rnd012 ; i=$RND012
    case $i in
        0) L="${GOAT}${GOAT}${AUTO}" ;;
        1) L="${GOAT}${AUTO}${GOAT}" ;;
        2) L="${AUTO}${GOAT}${GOAT}" ;;
    esac
    # guess a random door 'g'
    rnd012 ; g=$RND012 ; gdoor=${L:g:1}
    # we are told about one of the other two which is a goat
    odoor="ERR" ; o=9
    while true ; do
        rnd012 ; o=$RND012
        [ $o = $g ] && continue
        # random door 'o', != guess
        odoor=${L:o:1}
        [ $odoor = $AUTO ] && continue
        # door 'o' has a GOAT
        break                 
    done
    # stick with 1st guess; get outcome
    strat_stick_won=$gdoor
    # change to other door; get outcome
    cdoor=`echo -e "0\n1\n2" | egrep -v "[${g}${o}]"`
    strat_change_won=${L:cdoor:1}

    echo "stick won=$strat_stick_won ; change won=$strat_change_won"

done | sort | uniq -c | sed -e "1 s|^|counts of results:\n|" -e "s|=0|:Goat|g" -e "s|=1|:Auto|g"

