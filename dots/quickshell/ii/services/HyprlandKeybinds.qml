pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "hyprlandKeybinds.js" as KeybindParser

/**
 * Cheatsheet keybinds from ~/.config/hypr/conf/keybindings.lua.
 * Hyprland 0.55 Lua reports hyprctl binds as dispatcher "__lua" — we parse the config file instead.
 */
Singleton {
    id: root
    property string keybindingsLuaPath: FileUtils.trimFileProtocol(`${Directories.config}/hypr/conf/keybindings.lua`)
    property var keybinds: ({ "children": [] })
    property var _hyprctlRaw: []

    function applyTree(tree) {
        root.keybinds = ({
            children: tree.children || [],
            keybinds: tree.keybinds || [],
            name: tree.name || "",
        });
    }

    function rebuild() {
        const tree = KeybindParser.buildKeybindTree(keybindingsFile.text(), root._hyprctlRaw);
        applyTree(tree);
        const count = (tree.children || []).reduce((n, col) => {
            const sec = col.children && col.children[0];
            return n + (sec && sec.keybinds ? sec.keybinds.length : 0);
        }, 0);
        console.log("[HyprlandKeybinds] Loaded", count, "binds in", (tree.children || []).length, "sections");
    }

    function refresh() {
        root._hyprctlRaw = [];
        keybindingsFile.reload();
        getBinds.running = true;
    }

    Component.onCompleted: {
        keybindingsFile.reload();
        refresh();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "configreloaded")
                root.refresh();
        }
    }

    FileView {
        id: keybindingsFile
        path: root.keybindingsLuaPath

        onLoaded: root.rebuild()

        onLoadFailed: err => {
            if (err === FileViewError.FileNotFound)
                console.warn("[HyprlandKeybinds] Missing", root.keybindingsLuaPath);
            root.rebuild();
        }
    }

    Process {
        id: getBinds
        command: ["hyprctl", "binds", "-j"]

        stdout: StdioCollector {
            id: bindsCollector

            onStreamFinished: {
                const raw = bindsCollector.text.trim();
                if (raw) {
                    try {
                        root._hyprctlRaw = JSON.parse(raw);
                    } catch (e) {
                        console.warn("[HyprlandKeybinds] hyprctl parse failed:", e);
                    }
                }
                root.rebuild();
            }
        }
    }
}
