pragma Singleton

import Quickshell
import Quickshell.Hyprland

/**
 * Hyprland 0.55+ Lua dispatch helpers.
 * Legacy strings like "workspace 3" fail under Lua config — use hl.dsp.* instead.
 */
Singleton {
    function dispatch(command) {
        // hyprctl matches manual dispatch; Hyprland.dispatch passes the string through IPC as-is.
        Quickshell.execDetached(["hyprctl", "dispatch", command]);
    }

    function focusWorkspace(workspace) {
        if (typeof workspace === "number")
            dispatch(`hl.dsp.focus({ workspace = ${workspace} })`);
        else
            dispatch(`hl.dsp.focus({ workspace = "${workspace}" })`);
    }

    function focusWorkspaceRelative(relative) {
        dispatch(`hl.dsp.focus({ workspace = "${relative}" })`);
    }

    function toggleSpecialWorkspace(name) {
        if (name !== undefined && name !== null && name !== "")
            dispatch(`hl.dsp.workspace.toggle_special("${name}")`);
        else
            dispatch(`hl.dsp.workspace.toggle_special()`);
    }

    function reload() {
        dispatch("reload");
    }
}
