import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope { // Scope
    id: root

    PanelWindow { // Window
        id: launcherRoot
        visible: GlobalStates.launcherOpen

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"

        WlrLayershell.namespace: "quickshell:launcher"
        WlrLayershell.keyboardFocus: GlobalStates.launcherOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: GlobalStates.launcherOpen = false
        }

        Loader {
            id: launcherContentLoader
            active: GlobalStates.launcherOpen
            anchors {
                fill: parent
            }

            sourceComponent: LauncherContent {}
        }
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            GlobalStates.launcherOpen = !GlobalStates.launcherOpen;
        }

        function close(): void {
            GlobalStates.launcherOpen = false;
        }

        function open(): void {
            GlobalStates.launcherOpen = true;
        }
    }

    GlobalShortcut {
        name: "launcherToggle"
        description: "Toggles launcher on press"

        onPressed: {
            GlobalStates.launcherOpen = !GlobalStates.launcherOpen;
        }
    }

    GlobalShortcut {
        name: "launcherOpen"
        description: "Opens launcher on press"

        onPressed: {
            GlobalStates.launcherOpen = true;
        }
    }

    GlobalShortcut {
        name: "launcherClose"
        description: "Closes launcher on press"

        onPressed: {
            GlobalStates.launcherOpen = false;
        }
    }
}
