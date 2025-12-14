import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    id: root

    property alias searchInput: searchInput
    property string searchingText

    function forceFocus() {
        searchInput.forceActiveFocus();
    }

    ToolbarTextField {
        id: searchInput
        placeholderText: "Search..."
        implicitWidth: 570
        Component.onCompleted: forceActiveFocus()

        background: Rectangle {
            id: background
            color: "#1A1818"
            radius: Appearance.rounding.verysmall
        }

        onTextChanged: LauncherSearch.query = text

        onAccepted: {
            if (appResults.count > 0) {
                // Get the first visible delegate and trigger its click
                let firstItem = appResults.itemAtIndex(0);
                if (firstItem && firstItem.clicked) {
                    firstItem.clicked();
                }
            }
        }
    }
}
