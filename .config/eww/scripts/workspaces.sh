#!/bin/bash


check_occupied() {
    wmctrl -l | awk '{print $2}' | while read -r occupied; do
        if [ "$occupied" == "$1" ]; then
            echo "occupied"
            return
        fi
    done
}

get_workspaces_yuck() {
    buffered=""
    status_class=""

    wmctrl -d | awk '{print $1 " " $2 " " $9}' | while read -r number status name; do

        occupied=$(check_occupied $number)

        if [ "$status" == "-" ]; then  
            status_class="inactive"
            # icon="󰧞"
            icon=""
        fi

        if [ "$occupied" == "occupied" ]; then
            status_class="occupied"
            icon="○"
        fi

         
        if [ "$status" == "*" ]; then   # "*" mean active
            status_class="active"
            icon="●"
        fi

        buffered+=$'\n'
        buffered+="(button :class '$status_class'
                           :onclick 'wmctrl -s $number'
                           '$icon')"

        if [ "$number" == "$1" ]; then
            echo "$buffered"
        fi
   done
}

get_activewindow() {
    windowName=$(xdotool getwindowfocus getwindowname)
    
    if [ "$windowName" == "" ]; then
        echo "inactive"
    else
        echo "$windowName"
    fi
}


ewwStructure="box :spacing 20"
 
workspacesNumber=$(wmctrl -d | awk '{print $1}' | tail -c 2)
workspacesStatus=$(get_workspaces_yuck $workspacesNumber)
    
echo "($ewwStructure $workspacesStatus)"
   