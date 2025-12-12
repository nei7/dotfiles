import qs
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: root

    // Background
    StyledRectangularShadow {
        target: launcherBackground
    }

    Rectangle {
        id: launcherBackground
        anchors.centerIn: parent
        color: Appearance.colors.colLayer0
        border.width: 1
        border.color: Appearance.colors.colLayer0Border
        radius: Appearance.rounding.windowRounding

        implicitHeight: launcherColumnLayout.implicitHeight + padding * 2
        implicitWidth: parent.width / 7

        property real padding: 20

        ColumnLayout { // Real content
            id: launcherColumnLayout
            anchors.centerIn: parent
            spacing: 10

            ToolbarTextField {
                id: searchField
                placeholderText: "Search..."
                implicitWidth: launcherBackground.width - 40

                Component.onCompleted: forceActiveFocus()

                background: Rectangle {
                    id: background
                    color: Appearance.colors.colLayer1
                    radius: Appearance.rounding.verysmall
                }

                Keys.onEscapePressed: GlobalStates.launcherOpen = false
            }

            RippleButton {
                buttonText: "jd"
                implicitWidth: launcherColumnLayout.implicitWidth
            }
        }
    }
}
