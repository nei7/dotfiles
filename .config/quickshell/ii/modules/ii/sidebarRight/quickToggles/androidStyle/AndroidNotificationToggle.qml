import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell

AndroidQuickToggleButton {
    id: root

    name: "Notifications"
    statusText: toggled ? "Show" : "Silent"
    toggled: !Notifications.silent
    buttonIcon: toggled ? "notifications_active" : "notifications_paused"

    mainAction: () => {
        Notifications.silent = !Notifications.silent;
    }

    StyledToolTip {
        text: "Show notifications"
    }
}
