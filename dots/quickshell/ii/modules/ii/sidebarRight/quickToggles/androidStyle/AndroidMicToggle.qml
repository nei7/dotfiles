import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell

AndroidQuickToggleButton {
    id: root

    name: "Audio input"
    statusText: toggled ? "Enabled" : "Muted"
    toggled: !Audio.source?.audio?.muted
    buttonIcon: Audio.source?.audio?.muted ? "mic_off" : "mic"
    mainAction: () => {
        Audio.source.audio.muted = !Audio.source.audio.muted
    }

    altAction: () => {
        root.openMenu()
    }

    StyledToolTip {
        text: "Audio input | Right-click for volume mixer & device selector"
    }
}
