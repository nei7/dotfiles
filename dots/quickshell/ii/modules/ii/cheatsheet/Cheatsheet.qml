import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope { // Scope
    id: root

    Loader {
        id: cheatsheetLoader
        active: false

        sourceComponent: PanelWindow { // Window
            id: cheatsheetRoot
            visible: cheatsheetLoader.active

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            function hide() {
                cheatsheetLoader.active = false;
            }
            exclusiveZone: 0
            implicitWidth: cheatsheetBackground.width + Appearance.sizes.elevationMargin * 2
            implicitHeight: cheatsheetBackground.height + Appearance.sizes.elevationMargin * 2
            WlrLayershell.namespace: "quickshell:cheatsheet"
            // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: "transparent"

            mask: Region {
                item: cheatsheetBackground
            }

            HyprlandFocusGrab { // Click outside to close
                id: grab
                windows: [cheatsheetRoot]
                active: cheatsheetRoot.visible
                onCleared: () => {
                               if (!active)
                               cheatsheetRoot.hide();
                           }
            }

            // Background
            StyledRectangularShadow {
                target: cheatsheetBackground
            }
            Rectangle {
                id: cheatsheetBackground
                anchors.centerIn: parent
                color: Appearance.colors.colLayer0
                border.width: 1
                border.color: Appearance.colors.colLayer0Border
                radius: Appearance.rounding.windowRounding
                property real padding: 20
                implicitWidth: cheatsheetColumnLayout.implicitWidth + padding * 2
                implicitHeight: cheatsheetColumnLayout.implicitHeight + padding * 2

                Keys.onPressed: event => { // Esc to close
                                    if (event.key === Qt.Key_Escape) {
                                        cheatsheetRoot.hide();
                                    }
                                }

                RippleButton { // Close button
                    id: closeButton
                    focus: cheatsheetRoot.visible
                    implicitWidth: 40
                    implicitHeight: 40
                    buttonRadius: Appearance.rounding.full
                    anchors {
                        top: parent.top
                        right: parent.right
                        topMargin: 20
                        rightMargin: 20
                    }

                    onClicked: {
                        cheatsheetRoot.hide();
                    }

                    contentItem: MaterialSymbol {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Appearance.font.pixelSize.title
                        text: "close"
                    }
                }

                ColumnLayout { // Real content
                    id: cheatsheetColumnLayout
                    anchors.centerIn: parent
                    spacing: 10

                    StyledText { // Title, level with the close button
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: closeButton.implicitHeight
                        verticalAlignment: Text.AlignVCenter
                        font {
                            family: Appearance.font.family.title
                            pixelSize: Appearance.font.pixelSize.title
                            variableAxes: Appearance.font.variableAxes.title
                        }
                        color: Appearance.colors.colOnLayer0
                        text: "Keybinds"
                    }

                    CheatsheetKeybinds {
                        Layout.topMargin: 5
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "cheatsheet"

        function toggle(): void {
        if (!cheatsheetLoader.active)
            HyprlandKeybinds.refresh();
        cheatsheetLoader.active = !cheatsheetLoader.active;
    }

        function close(): void {
                              cheatsheetLoader.active = false;
                          }

        function open(): void {
        HyprlandKeybinds.refresh();
        cheatsheetLoader.active = true;
        Qt.callLater(() => HyprlandKeybinds.rebuild());
    }
    }

        GlobalShortcut {
            name: "cheatsheetToggle"
            description: "Toggles cheatsheet on press"

            onPressed: {
                if (!cheatsheetLoader.active)
                    HyprlandKeybinds.refresh();
                cheatsheetLoader.active = !cheatsheetLoader.active;
            }
        }

        GlobalShortcut {
            name: "cheatsheetOpen"
            description: "Opens cheatsheet on press"

            onPressed: {
                HyprlandKeybinds.refresh();
                cheatsheetLoader.active = true;
            }
        }

        GlobalShortcut {
            name: "cheatsheetClose"
            description: "Closes cheatsheet on press"

            onPressed: {
                cheatsheetLoader.active = false;
            }
        }
    }
