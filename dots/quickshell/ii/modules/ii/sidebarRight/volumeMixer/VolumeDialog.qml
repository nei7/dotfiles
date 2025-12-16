pragma ComponentBehavior: Bound
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

WindowDialog {
    id: root
    property bool isSink: true
    backgroundHeight: 600

    WindowDialogTitle {
        text: root.isSink ? "Audio output" : "Audio input"
    }

    WindowDialogSeparator {
        Layout.topMargin: -22
        Layout.leftMargin: 0
        Layout.rightMargin: 0
    }

    VolumeDialogContent {
        isSink: root.isSink
    }

    WindowDialogButtonRow {
        DialogButton {
            buttonText: "Details"
            onClicked: {
                Quickshell.execDetached(["bash", "-c", `${Config.options.apps.volumeMixer}`]);
                GlobalStates.sidebarRightOpen = false;
            }
        }

        Item {
            Layout.fillWidth: true
        }

        DialogButton {
            buttonText: "Done"
            onClicked: root.dismiss()
        }
    }
}
