import qs
import qs.services
import qs.modules.common
import qs.modules.common.models
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland

RippleButton {
    id: root
    property LauncherSearchResult entry
    property int horizontalMargin: 22
    property int buttonHorizontalPadding: 10
    property int buttonVerticalPadding: 6

    property bool keyboardDown: false
    property var itemExecute: entry?.execute

    colBackground: root.focus ? '#211F20' : ColorUtils.transparentize(Appearance.colors.colPrimaryContainer, 1)
    colBackgroundHover: root.focus ? '#211F20' : "transparent"

    colRipple: Appearance.colors.colPrimaryContainerActive
    buttonRadius: 5

    background {
        anchors.fill: root
        anchors.leftMargin: root.horizontalMargin
        anchors.rightMargin: root.horizontalMargin
        implicitHeight: 55
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.keyboardDown = true;
            root.clicked();
            event.accepted = true;
        }
    }

    Keys.onReleased: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.keyboardDown = false;
            event.accepted = true;
        }
    }

    onClicked: {
        LauncherSearch.query = "";

        root.itemExecute();
        GlobalStates.launcherOpen = false;
    }

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        anchors.leftMargin: root.horizontalMargin + root.buttonHorizontalPadding
        anchors.rightMargin: root.horizontalMargin + root.buttonHorizontalPadding

        spacing: 20

        Loader {
            id: iconLoader
            active: true
            sourceComponent: iconImageComponent
        }

        Component {
            id: iconImageComponent
            IconImage {
                source: Quickshell.iconPath(entry.iconName, "image-missing")
                width: 35
                height: 35
            }
        }

        ColumnLayout {
            id: contentColumn
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 2
            StyledText {
                id: nameText
                // Item name/content
                Layout.fillWidth: true
                textFormat: Text.StyledText // RichText also works, but StyledText ensures elide work
                font.pixelSize: 14
                color: Appearance.m3colors.m3onSurface
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
                text: `${entry.name}`
            }

            RowLayout {
                visible: entry.genericName

                StyledText {
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.colors.colSubtext
                    text: entry.genericName
                }
            }
        }
    }
}
