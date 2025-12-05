import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell

AndroidQuickToggleButton {
    id: root

    name: "Audio output"
    statusText: toggled ? "Unmuted" : "Muted"
    toggled: !Audio.sink?.audio?.muted
    buttonIcon: Audio.sink?.audio?.muted ? "volume_off" : "volume_up"
    mainAction: () => {
        Audio.sink.audio.muted = !Audio.sink.audio.muted
    }

    altAction: () => {
        root.openMenu()
    }

    StyledToolTip {
        text: "Audio output | Right-click for volume mixer & device selector"
    }
}
