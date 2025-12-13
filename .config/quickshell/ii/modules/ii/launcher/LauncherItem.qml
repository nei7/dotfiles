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
    implicitWidth: rowLayout.implicitWidth
    property LauncherSearchResult entry

    RowLayout {
        id: rowLayout

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
            spacing: 0
            StyledText {
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colSubtext
                text: entry.type
            }
        }
    }
}
