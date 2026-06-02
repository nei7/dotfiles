pragma ComponentBehavior: Bound

import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var sections: HyprlandKeybinds.keybinds.children ?? []
    property real spacing: 20
    property real titleSpacing: 7
    property real padding: 4

    implicitWidth: row.implicitWidth + padding * 2
    implicitHeight: row.implicitHeight + padding * 2

    Connections {
        target: HyprlandKeybinds
        function onKeybindsChanged() {
            root.sections = HyprlandKeybinds.keybinds.children ?? [];
        }
    }

    function formatKeyLabel(key) {
        if (keyBlacklist.includes(key))
            return "";
        return keySubstitutions[key] || key;
    }

    function formatKeybindLine(kb) {
        var parts = [];
        for (var i = 0; i < kb.mods.length; i++) {
            var mod = formatKeyLabel(kb.mods[i]) || kb.mods[i];
            if (mod)
                parts.push(mod);
        }
        var keyLabel = formatKeyLabel(kb.key);
        if (keyLabel)
            parts.push(keyLabel);
        return parts.join(" ");
    }

    property var macSymbolMap: ({
        "Ctrl": "󰘴",
        "Alt": "󰘵",
        "Shift": "󰘶",
        "Space": "󱁐",
        "Tab": "↹",
        "Equal": "󰇼",
        "Minus": "",
        "Print": "",
        "BackSpace": "󰭜",
        "Delete": "⌦",
        "Return": "󰌑",
        "Period": ".",
        "Escape": "⎋",
    })

    property var functionSymbolMap: ({
        "F1": "󱊫",
        "F2": "󱊬",
        "F3": "󱊭",
        "F4": "󱊮",
        "F5": "󱊯",
        "F6": "󱊰",
        "F7": "󱊱",
        "F8": "󱊲",
        "F9": "󱊳",
        "F10": "󱊴",
        "F11": "󱊵",
        "F12": "󱊶",
    })

    property var mouseSymbolMap: ({
        "mouse_up": "󱕐",
        "mouse_down": "󱕑",
        "mouse:272": "L󰍽",
        "mouse:273": "R󰍽",
        "Scroll ↑/↓": "󱕒",
        "Page_↑/↓": "⇞/⇟",
    })

    property var keyBlacklist: ["Super_L"]

    property var keySubstitutions: Object.assign({
        "Super": "",
        "mouse_up": "Scroll ↓",
        "mouse_down": "Scroll ↑",
        "mouse:272": "LMB",
        "mouse:273": "RMB",
        "mouse:275": "MouseBack",
        "Slash": "/",
        "Hash": "#",
        "Return": "Enter",
    },
    !!Config.options.cheatsheet.superKey ? {
        "Super": Config.options.cheatsheet.superKey,
    } : {},
    Config.options.cheatsheet.useMacSymbol ? macSymbolMap : {},
    Config.options.cheatsheet.useFnSymbol ? functionSymbolMap : {},
    Config.options.cheatsheet.useMouseSymbol ? mouseSymbolMap : {})

    Row {
        id: row
        anchors.centerIn: parent
        spacing: root.spacing

        Repeater {
            model: root.sections

            delegate: Column {
                id: column
                spacing: root.spacing
                required property var modelData
                anchors.top: row.top

                Repeater {
                    model: {
                        if (column.modelData.children && column.modelData.children.length > 0)
                            return column.modelData.children;
                        if (column.modelData.keybinds && column.modelData.keybinds.length > 0)
                            return [column.modelData];
                        return [];
                    }

                    delegate: Column {
                        id: section
                        spacing: root.titleSpacing
                        required property var modelData
                        width: Math.max(title.implicitWidth, bindsColumn.implicitWidth)

                        StyledText {
                            id: title
                            width: parent.width
                            font {
                                family: Appearance.font.family.title
                                pixelSize: Appearance.font.pixelSize.title
                                variableAxes: Appearance.font.variableAxes.title
                            }
                            color: Appearance.colors.colOnLayer0
                            text: section.modelData.name ?? ""
                        }

                        Column {
                            id: bindsColumn
                            width: parent.width
                            spacing: 4

                            Repeater {
                                model: section.modelData.keybinds ?? []

                                delegate: Row {
                                    id: bindRow
                                    spacing: 12
                                    required property var modelData

                                    Item {
                                        id: keysPart
                                        implicitWidth: keysRow.implicitWidth
                                        implicitHeight: keysRow.implicitHeight

                                        Row {
                                            id: keysRow
                                            spacing: 4
                                            visible: Config.options.cheatsheet.splitButtons

                                            Repeater {
                                                model: bindRow.modelData.mods ?? []

                                                delegate: Row {
                                                    spacing: 4
                                                    required property int index
                                                    required property var modelData

                                                    KeyboardKey {
                                                        key: root.formatKeyLabel(modelData) || modelData
                                                        pixelSize: Config.options.cheatsheet.fontSize.key
                                                    }

                                                    StyledText {
                                                        property int modCount: bindRow.modelData.mods ? bindRow.modelData.mods.length : 0
                                                        visible: index < modCount - 1
                                                        text: "+"
                                                        color: Appearance.colors.colOnLayer0
                                                    }
                                                }
                                            }

                                            StyledText {
                                                property int modCount: bindRow.modelData.mods ? bindRow.modelData.mods.length : 0
                                                visible: modCount > 0 && !root.keyBlacklist.includes(bindRow.modelData.key)
                                                text: "+"
                                                color: Appearance.colors.colOnLayer0
                                            }

                                            KeyboardKey {
                                                visible: !root.keyBlacklist.includes(bindRow.modelData.key)
                                                key: root.formatKeyLabel(bindRow.modelData.key)
                                                pixelSize: Config.options.cheatsheet.fontSize.key
                                            }
                                        }

                                        KeyboardKey {
                                            visible: !Config.options.cheatsheet.splitButtons
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            key: root.formatKeybindLine(bindRow.modelData)
                                            pixelSize: Config.options.cheatsheet.fontSize.key
                                        }
                                    }

                                    StyledText {
                                        id: commentText
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: 220
                                        wrapMode: Text.WordWrap
                                        font.pixelSize: Config.options.cheatsheet.fontSize.comment
                                            || Appearance.font.pixelSize.smaller
                                        color: Appearance.colors.colOnLayer0
                                        text: bindRow.modelData.comment ?? ""
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
