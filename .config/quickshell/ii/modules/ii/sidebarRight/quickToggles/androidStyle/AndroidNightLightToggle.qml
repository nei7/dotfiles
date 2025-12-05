import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell

AndroidQuickToggleButton {
    id: root
    
    property bool auto: Config.options.light.night.automatic

    name: "Night Light"
    statusText: (auto ? "Auto, " : "") + (toggled ? "Active" : "Inactive")

    toggled: Hyprsunset.active
    buttonIcon: auto ? "night_sight_auto" : "bedtime"
    
    mainAction: () => {
        Hyprsunset.toggle()
    }

    altAction: () => {
        root.openMenu()
    }

    Component.onCompleted: {
        Hyprsunset.fetchState()
    }
    
    StyledToolTip {
        text: "Night Light | Right-click to configure"
    }
}

