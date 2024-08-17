#!/bin/bash

get_workspaces_yuck() {
    active_workspace_id=$(hyprctl activeworkspace -j | jq -r '.id')
 
    hyprctl workspaces -j | jq -r '.[] | .id' | sort -n | while read i; do
        if [ "$i" == $active_workspace_id ]; then
            icon="●"
        else  
            icon="○"
        fi

 

        echo $'\n'
        echo "(button :class 'indicator $status_class' :style 'font-size: 20px; min-height: 10px '
                           :onclick 'wmctrl -s 0'
                           '$icon')"

      done
}

ewwStructure="box :spacing 20"
 
workspacesStatus=$(get_workspaces_yuck)
    
echo "($ewwStructure $workspacesStatus)"
   
