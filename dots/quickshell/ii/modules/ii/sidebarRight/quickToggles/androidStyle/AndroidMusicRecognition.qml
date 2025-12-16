import qs
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services


AndroidQuickToggleButton {
    id: root

    toggled: SongRec.running
    property bool sourceIsMonitor: SongRec.monitorSource === SongRec.MonitorSource.Monitor

    name: "Identify Music"
    statusText: toggled ? "Listening..." : sourceIsMonitor ? "System sound" : "Microphone"
    buttonIcon: toggled ? "music_cast" : (sourceIsMonitor ? "music_note" : "frame_person_mic")

    StyledToolTip {
        text: "Recognize music | Right-click to toggle source"
    }

    mainAction: () => {
        SongRec.toggleRunning()
    }

    altAction: () => {
        SongRec.toggleMonitorSource()
    }

}
