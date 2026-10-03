import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Qt.labs.synchronizer

Item {
    id: root
    width: searchWidgetContent.implicitWidth + Appearance.sizes.elevationMargin * 2
    height: searchBar.implicitHeight + searchBar.verticalPadding * 2 + Appearance.sizes.elevationMargin * 2
    // Background
    property string searchingText: LauncherSearch.query

    StyledRectangularShadow {
        target: searchWidgetContent
    }

    function focusFirstItem() {
        appResults.currentIndex = 0;
    }

    function focusSearchInput() {
        searchBar.forceFocus();
    }

    // Moves the selection without taking focus from the search input; the list scrolls to follow it
    function moveSelection(delta) {
        if (appResults.count === 0)
            return;
        appResults.currentIndex = Math.max(0, Math.min(appResults.count - 1, appResults.currentIndex + delta));
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape) {
            GlobalStates.launcherOpen = false;
            return;
        }

        // Arrows and page keys bubble up from the search input
        const steps = {
            [Qt.Key_Down]: 1,
            [Qt.Key_Up]: -1,
            [Qt.Key_PageDown]: appResults.pageSize,
            [Qt.Key_PageUp]: -appResults.pageSize
        };
        if (event.key in steps) {
            root.moveSelection(steps[event.key]);
            event.accepted = true;
            return;
        }

        // Only handle visible printable characters (ignore control chars, arrows, etc.)
        if (event.text && event.text.length === 1 && event.key !== Qt.Key_Enter && event.key !== Qt.Key_Return && event.key !== Qt.Key_Delete && event.text.charCodeAt(0) >= 0x20) // ignore control chars like Backspace, Tab, etc.
        {
            if (!searchBar.searchInput.activeFocus) {
                root.focusSearchInput();
                // Insert the character at the cursor position
                searchBar.searchInput.text = searchBar.searchInput.text.slice(0, searchBar.searchInput.cursorPosition) + event.text + searchBar.searchInput.text.slice(searchBar.searchInput.cursorPosition);
                searchBar.searchInput.cursorPosition += 1;
                event.accepted = true;
                root.focusFirstItem();
            }
        }
    }

    Rectangle {
        id: searchWidgetContent
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        implicitWidth: columnLayout.implicitWidth
        implicitHeight: columnLayout.implicitHeight
        radius: Appearance.rounding.normal

        color: Appearance.colors.colLayer0

        border.width: 1
        border.color: Appearance.colors.colLayer0Border

        property real padding: 20

        ColumnLayout {
            id: columnLayout
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            LauncherInput {
                id: searchBar
                property real verticalPadding: 22

                Layout.fillWidth: true
                Layout.leftMargin: verticalPadding
                Layout.rightMargin: verticalPadding
                Layout.topMargin: verticalPadding

                Synchronizer on searchingText {
                    property alias source: root.searchingText
                }
            }
            Item {
                Layout.bottomMargin: 22
                Layout.fillWidth: true
                Layout.preferredWidth: 600
                Layout.preferredHeight: 500

                ListView {
                    id: appResults
                    // Rows the selection jumps on PageUp/PageDown
                    readonly property int pageSize: Math.max(1, Math.floor(height / ((currentItem?.height ?? 55) + spacing)))

                    Layout.fillWidth: true
                    anchors.fill: parent
                    clip: true
                    topMargin: 5
                    bottomMargin: searchBar.verticalPadding
                    spacing: 2
                    highlightMoveDuration: 100

                    ScrollBar.vertical: StyledScrollBar {
                        // Stay visible while there is more to scroll, also when moving with the keyboard
                        policy: size < 1.0 ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
                    }

                    model: ScriptModel {
                        id: model
                        values: LauncherSearch.results
                        // New results start from the top with the best match selected
                        onValuesChanged: {
                            root.focusFirstItem();
                            appResults.positionViewAtBeginning();
                        }
                    }

                    delegate: LauncherItem {
                        entry: modelData
                        anchors.left: parent?.left
                        anchors.right: parent?.right
                    }
                }
            }
        }
    }
}
