pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

/**
 * Provides access to some Hyprland data not available in Quickshell.Hyprland.
 */
Singleton {
    id: root
    property var windowList: []
    property var addresses: []
    property var windowByAddress: ({})
    property var workspaces: []
    property var workspaceIds: []
    property var workspaceById: ({})
    property var activeWorkspace: null
    property var monitors: []
    property var layers: ({})

    function updateWindowList() {
        getClients.running = true;
    }

    function updateLayers() {
        getLayers.running = true;
    }

    function updateMonitors() {
        getMonitors.running = true;
    }

    function updateActiveWorkspace() {
        getActiveWorkspace.running = true;
    }

    function updateWorkspaces() {
        getWorkspaces.running = true;
        getActiveWorkspace.running = true;
    }

    // Only the data the shell actually consumes (windowList, monitors,
    // activeWorkspace). layers/workspaces are available on demand via the
    // functions above.
    function updateAll() {
        updateWindowList();
        updateMonitors();
        updateActiveWorkspace();
    }

    function updateEverything() {
        updateAll();
        updateLayers();
        getWorkspaces.running = true;
    }

    function biggestWindowForWorkspace(workspaceId) {
        const windowsInThisWorkspace = HyprlandData.windowList.filter(w => w.workspace.id == workspaceId);
        return windowsInThisWorkspace.reduce((maxWin, win) => {
            const maxArea = (maxWin?.size?.[0] ?? 0) * (maxWin?.size?.[1] ?? 0);
            const winArea = (win?.size?.[0] ?? 0) * (win?.size?.[1] ?? 0);
            return winArea > maxArea ? win : maxWin;
        }, null);
    }

    Component.onCompleted: {
        updateEverything();
    }

    // A single user action makes Hyprland emit a burst of raw events (opening a
    // window: openwindow + activewindow + activewindowv2 + focusedmon + ...).
    // Refreshing on each one used to spawn 5 hyprctl processes per event.
    // Coalesce the burst into one refresh and skip events that cannot change
    // the data we expose.
    readonly property var ignoredEvents: new Set([
        "activelayout", "submap", "screencast", "bell", "urgent", "minimized",
        "openlayer", "closelayer", "configreloaded", "activespecialv2"
    ])
    // Title updates are frequent (browser tabs, terminals, media players) and
    // only affect the fallback title in the bar; refresh them lazily.
    readonly property var titleEvents: new Set(["windowtitle", "windowtitlev2"])

    Timer {
        id: refreshTimer
        interval: 50
        repeat: false
        onTriggered: root.updateAll()
    }

    function scheduleUpdate(delay) {
        // A pending sooner refresh already covers this event.
        if (refreshTimer.running && refreshTimer.interval <= delay)
            return;
        refreshTimer.interval = delay;
        refreshTimer.restart();
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (root.ignoredEvents.has(event.name))
                return;
            root.scheduleUpdate(root.titleEvents.has(event.name) ? 400 : 50);
        }
    }

    Process {
        id: getClients
        command: ["hyprctl", "clients", "-j"]
        stdout: StdioCollector {
            id: clientsCollector
            onStreamFinished: {
                root.windowList = JSON.parse(clientsCollector.text)
                let tempWinByAddress = {};
                for (var i = 0; i < root.windowList.length; ++i) {
                    var win = root.windowList[i];
                    tempWinByAddress[win.address] = win;
                }
                root.windowByAddress = tempWinByAddress;
                root.addresses = root.windowList.map(win => win.address);
            }
        }
    }

    Process {
        id: getMonitors
        command: ["hyprctl", "monitors", "-j"]
        stdout: StdioCollector {
            id: monitorsCollector
            onStreamFinished: {
                root.monitors = JSON.parse(monitorsCollector.text);
            }
        }
    }

    Process {
        id: getLayers
        command: ["hyprctl", "layers", "-j"]
        stdout: StdioCollector {
            id: layersCollector
            onStreamFinished: {
                root.layers = JSON.parse(layersCollector.text);
            }
        }
    }

    Process {
        id: getWorkspaces
        command: ["hyprctl", "workspaces", "-j"]
        stdout: StdioCollector {
            id: workspacesCollector
            onStreamFinished: {
                root.workspaces = JSON.parse(workspacesCollector.text);
                let tempWorkspaceById = {};
                for (var i = 0; i < root.workspaces.length; ++i) {
                    var ws = root.workspaces[i];
                    tempWorkspaceById[ws.id] = ws;
                }
                root.workspaceById = tempWorkspaceById;
                root.workspaceIds = root.workspaces.map(ws => ws.id);
            }
        }
    }

    Process {
        id: getActiveWorkspace
        command: ["hyprctl", "activeworkspace", "-j"]
        stdout: StdioCollector {
            id: activeWorkspaceCollector
            onStreamFinished: {
                root.activeWorkspace = JSON.parse(activeWorkspaceCollector.text);
            }
        }
    }
}
