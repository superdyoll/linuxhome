DEFAULT="[0m"
PINK="[35m"
GREEN="[32m"
ORANGE="[33m"
RED="[91m"
LGREEN="[92m"
LCYAN="[96m"
LYELL="[1;93m"

hg_dirty() {
    hg status 2> /dev/null \
    | awk '$1 == "?" { unknown = 1 } 
           $1 != "?" { changed = 1 }
           END {
             if (changed) printf "! "
             else if (unknown) printf "? " 
           }'
}

hg_branch() {
    hg branch 2> /dev/null | \
        awk '{ printf "\033[35m" $1 }'
    hg bookmarks 2> /dev/null | \
        awk '/\*/ { printf "\033[30m" $2 }'
}

ret_arrow() {
    local code=$?
    if [ $code == 0 ];
    then
        echo "\e${LGREEN}➜ "
    else
        echo "\e${RED}➜ "
    fi
}

set_bash_prompt(){
    PS1="\n\e${DEFAULT}\u\e${DEFAULT}@\e${GREEN}\h\e${DEFAULT} \e${LCYAN}\W $(ret_arrow)\e${DEFAULT}$(hg_branch)\e${LYELL}$(hg_dirty)\e${DEFAULT}"
}

PROMPT_COMMAND=set_bash_prompt
