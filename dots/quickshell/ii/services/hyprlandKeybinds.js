.pragma library

var MOD_MASK_ORDER = [
    [64, "Super"],
    [32, "MOD3"],
    [16, "MOD2"],
    [8, "ALT"],
    [4, "CTRL"],
    [2, "CAPS"],
    [1, "SHIFT"],
];

var GLOBAL_SHORTCUT_LABELS = {
    "quickshell:launcherToggle": "Toggle launcher",
    "quickshell:sidebarRightToggle": "Toggle sidebar",
    "quickshell:cheatsheetOpen": "Open cheatsheet",
    "quickshell:cheatsheetToggle": "Toggle cheatsheet",
    "quickshell:cheatsheetClose": "Close cheatsheet",
};

function jsonBool(value) {
    return value === true || value === "true";
}

function modmaskToMods(modmask) {
    var mods = [];
    for (var i = 0; i < MOD_MASK_ORDER.length; i++) {
        if (modmask & MOD_MASK_ORDER[i][0])
            mods.push(MOD_MASK_ORDER[i][1]);
    }
    return mods;
}

function normalizeModName(mod) {
    var upper = mod.toUpperCase();
    if (upper === "SUPER" || upper === "META" || upper === "WIN")
        return "Super";
    if (upper === "SHIFT")
        return "SHIFT";
    if (upper === "CTRL" || upper === "CONTROL")
        return "CTRL";
    if (upper === "ALT")
        return "ALT";
    return mod;
}

function parseComboString(combo) {
    var parts = combo.split("+").map(function(s) { return s.trim(); }).filter(function(s) { return s.length > 0; });
    if (parts.length === 0)
        return { mods: [], key: "" };
    return {
        mods: parts.slice(0, -1).map(normalizeModName),
        key: parts[parts.length - 1],
    };
}

function evalConcat(expr, env) {
    var parts = expr.split(/\s*\.\.\s*/);
    var out = "";
    for (var i = 0; i < parts.length; i++) {
        var p = parts[i].trim();
        if (p.length >= 2 && p.charAt(0) === '"')
            out += p.slice(1, -1);
        else if (env[p] !== undefined)
            out += env[p];
        else
            out += p;
    }
    return out.replace(/\s+/g, " ").trim();
}

function resolveKeyExpr(expr, env) {
    if (!expr)
        return { mods: [], key: "" };
    expr = expr.trim();
    if (expr.charAt(0) === '"')
        return parseComboString(expr.slice(1, -1));
    return parseComboString(evalConcat(expr, env));
}

function autogenerateComment(dispatcher, params, env) {
    var d = (dispatcher || "").toLowerCase();
    var p = (params || "").trim();
    if (env) {
        for (var k in env) {
            if (!env.hasOwnProperty(k))
                continue;
            p = p.replace(new RegExp("=\\s*" + k + "\\b"), "= " + env[k]);
            p = p.replace(new RegExp("\\b" + k + "\\b"), env[k]);
        }
    }

    if (d === "global")
        return GLOBAL_SHORTCUT_LABELS[p] || ("Global: " + p);

    if (d === "exec" || d === "execr" || d.indexOf("exec") !== -1) {
        if (p.indexOf("hyprshutdown") !== -1 || p.indexOf("hl.dsp.exit") !== -1)
            return "Exit Hyprland";
        if (p.indexOf("hyprshot") !== -1)
            return "Screenshot (output to clipboard)";
        return p ? ("Execute: " + p) : "Execute command";
    }

    if (d === "killactive" || d === "close" || d.indexOf("close") !== -1)
        return "Close window";

    if (d === "exit")
        return "Exit Hyprland";

    if (d.indexOf("float") !== -1)
        return "Float/unfloat window";

    if (d.indexOf("pseudo") !== -1)
        return "Toggle pseudotile";

    if (d.indexOf("fullscreen") !== -1)
        return "Toggle fullscreen";

    if (d.indexOf("drag") !== -1)
        return "Move window";

    if (d.indexOf("resize") !== -1)
        return "Resize window";

    if (d.indexOf("focus") !== -1) {
        var dirMatch = p.match(/direction\s*=\s*["']?(\w+)/);
        var direction = dirMatch ? dirMatch[1] : p;
        if (direction === "l" || direction === "left")
            return "Move focus left";
        if (direction === "r" || direction === "right")
            return "Move focus right";
        if (direction === "u" || direction === "up")
            return "Move focus up";
        if (direction === "d" || direction === "down")
            return "Move focus down";
        if (p === "e+1" || p === "+1")
            return "Workspace: focus next";
        if (p === "e-1" || p === "-1")
            return "Workspace: focus previous";
        var wsMatch = p.match(/workspace\s*=\s*(\d+)/);
        if (wsMatch)
            return "Focus workspace " + wsMatch[1];
        if (/^\d+$/.test(p))
            return "Focus workspace " + p;
        return "Move focus";
    }

    if (d.indexOf("move") !== -1) {
        var moveWs = p.match(/workspace\s*=\s*(\d+)/);
        if (moveWs)
            return "Move window to workspace " + moveWs[1];
        return "Move window";
    }

    return p ? (dispatcher + ": " + p) : dispatcher;
}

function parseDspArg(dspText, variables) {
    dspText = (dspText || "").trim();

    var globalMatch = dspText.match(/hl\.dsp\.global\(\s*"([^"]+)"/);
    if (globalMatch)
        return { dispatcher: "global", params: globalMatch[1] };

    var execMatch = dspText.match(/hl\.dsp\.exec_cmd\(\s*([^,)]+)/);
    if (execMatch) {
        var arg = execMatch[1].trim();
        if (arg.charAt(0) === '"')
            arg = arg.slice(1, -1);
        else if (variables[arg])
            arg = variables[arg];
        return { dispatcher: "exec", params: arg };
    }

    if (dspText.indexOf("window.close") !== -1)
        return { dispatcher: "close", params: "" };
    if (dspText.indexOf("window.float") !== -1)
        return { dispatcher: "float", params: "" };
    if (dspText.indexOf("window.pseudo") !== -1)
        return { dispatcher: "pseudo", params: "" };
    if (dspText.indexOf("window.fullscreen") !== -1)
        return { dispatcher: "fullscreen", params: "" };
    if (dspText.indexOf("window.drag") !== -1)
        return { dispatcher: "drag", params: "" };
    if (dspText.indexOf("window.resize") !== -1)
        return { dispatcher: "resize", params: "" };

    var focusMatch = dspText.match(/hl\.dsp\.focus\(\{([^}]*)\}/);
    if (focusMatch) {
        var fp = focusMatch[1].replace(/\s+/g, " ").trim();
        return { dispatcher: "focus", params: fp };
    }

    var moveMatch = dspText.match(/hl\.dsp\.window\.move\(\{([^}]*)\}/);
    if (moveMatch) {
        var mp = moveMatch[1].replace(/\s+/g, " ").trim();
        return { dispatcher: "move", params: mp };
    }

    return { dispatcher: "__lua", params: dspText };
}

function makeKeybind(mods, key, dispatcher, params, comment, env) {
    return {
        mods: mods,
        key: key,
        dispatcher: dispatcher,
        params: params,
        comment: comment || autogenerateComment(dispatcher, params, env),
    };
}

function wrapSections(sections) {
    var columns = [];
    var names = Object.keys(sections);
    for (var i = 0; i < names.length; i++) {
        var name = names[i];
        var items = sections[name];
        if (!items || items.length === 0)
            continue;
        columns.push({
            name: name,
            children: [{ name: name, keybinds: items, children: [] }],
            keybinds: [],
        });
    }
    return { children: columns, keybinds: [], name: "" };
}

function mergeEnv(variables, env) {
    var merged = {};
    for (var vk in variables) {
        if (variables.hasOwnProperty(vk))
            merged[vk] = variables[vk];
    }
    for (var ek in env) {
        if (env.hasOwnProperty(ek))
            merged[ek] = env[ek];
    }
    return merged;
}

function parseBindCall(keyExpr, dspText, variables, env, pendingComment, sectionName) {
    var mergedEnv = mergeEnv(variables, env);
    var combo = resolveKeyExpr(keyExpr, mergedEnv);
    if (!combo.key)
        return null;

    var dsp = parseDspArg(dspText, variables);
    var comment = pendingComment || autogenerateComment(dsp.dispatcher, dsp.params, mergedEnv);
    var kb = makeKeybind(combo.mods, combo.key, dsp.dispatcher, dsp.params, comment, mergedEnv);
    kb.section = sectionName;
    return kb;
}

function extractBindFromLine(line, variables, env, pendingComment, sectionName) {
    var open = line.indexOf("hl.bind(");
    if (open === -1)
        return null;

    var depth = 0;
    var comma = -1;
    for (var i = open + 8; i < line.length; i++) {
        var ch = line.charAt(i);
        if (ch === "(")
            depth++;
        else if (ch === ")") {
            if (depth === 0) {
                var dspText = line.substring(comma + 1, i).trim();
                dspText = dspText.replace(/,\s*\{[^}]*\}\s*$/, "").trim();
                var keyExpr = line.substring(open + 8, comma).trim();
                return parseBindCall(keyExpr, dspText, variables, env, pendingComment, sectionName);
            }
            depth--;
        } else if (ch === "," && depth === 0) {
            comma = i;
        }
    }
    return null;
}

function expandForLoop(lines, startIndex, variables, currentSection) {
    var header = lines[startIndex].trim();
    var headerMatch = header.match(/^for\s+(\w+)\s*=\s*(\d+)\s*,\s*(\d+)\s+do$/);
    if (!headerMatch)
        return { nextIndex: startIndex + 1, keybinds: [] };

    var loopVar = headerMatch[1];
    var from = parseInt(headerMatch[2], 10);
    var to = parseInt(headerMatch[3], 10);

    var body = [];
    var i = startIndex + 1;
    while (i < lines.length && lines[i].trim() !== "end") {
        body.push(lines[i]);
        i++;
    }

    var keybinds = [];
    var sectionName = currentSection || "Workspaces";
    var pendingComment = "";

    for (var v = from; v <= to; v++) {
        var env = {};
        env[loopVar] = String(v);

        for (var b = 0; b < body.length; b++) {
            var line = body[b].trim();
            if (!line || line.indexOf("--") === 0)
                continue;

            var keyLocal = line.match(/^local\s+key\s*=\s*(.+)$/);
            if (keyLocal) {
                env.key = String(evalLuaNumberExpr(keyLocal[1], env));
                continue;
            }

            var kb = extractBindFromLine(line, variables, env, pendingComment, sectionName);
            if (kb)
                keybinds.push(kb);
        }
    }

    return { nextIndex: i + 1, keybinds: keybinds };
}

function evalLuaNumberExpr(expr, env) {
    expr = expr.trim();
    var modMatch = expr.match(/^(\w+)\s*%\s*(\d+)$/);
    if (modMatch) {
        var base = parseInt(env[modMatch[1]] !== undefined ? env[modMatch[1]] : modMatch[1], 10);
        return base % parseInt(modMatch[2], 10);
    }
    return parseInt(expr, 10);
}

function parseVariables(text) {
    var variables = {};
    var lines = text.split("\n");
    for (var i = 0; i < lines.length; i++) {
        var m = lines[i].match(/^\s*local\s+(\w+)\s*=\s*"([^"]*)"/);
        if (m)
            variables[m[1]] = m[2];
    }
    return variables;
}

/**
 * Primary source for Hyprland 0.55 Lua configs.
 * hyprctl binds only reports dispatcher "__lua" + opaque id — not usable for labels.
 */
function parseKeybindingsLua(text) {
    if (!text || !text.trim())
        return { children: [], keybinds: [], name: "" };

    var variables = parseVariables(text);
    var lines = text.split("\n");
    var sections = { General: [] };
    var currentSection = "General";
    var pendingComment = "";
    var allKeybinds = [];

    for (var i = 0; i < lines.length; i++) {
        var stripped = lines[i].trim();

        if (!stripped || stripped.indexOf("--") === 0) {
            var sectionMatch = stripped.match(/^--\s*#+!\s*(.+)$/);
            if (sectionMatch) {
                currentSection = sectionMatch[1].trim();
                if (!sections[currentSection])
                    sections[currentSection] = [];
                pendingComment = "";
                continue;
            }
            if (stripped.indexOf("#/#") !== -1) {
                pendingComment = stripped.split("#/#")[1].trim();
                continue;
            }
            if (stripped.indexOf("--") === 0) {
                var textComment = stripped.substring(2).trim();
                if (textComment && textComment.indexOf("##") !== 0)
                    pendingComment = textComment;
            }
            continue;
        }

        if (stripped.match(/^for\s+\w+\s*=/)) {
            var expanded = expandForLoop(lines, i, variables, currentSection);
            i = expanded.nextIndex - 1;
            for (var e = 0; e < expanded.keybinds.length; e++) {
                expanded.keybinds[e].section = currentSection;
                sections[currentSection].push(expanded.keybinds[e]);
                allKeybinds.push(expanded.keybinds[e]);
            }
            pendingComment = "";
            continue;
        }

        var kb = extractBindFromLine(stripped, variables, {}, pendingComment, currentSection);
        if (kb) {
            sections[currentSection].push(kb);
            allKeybinds.push(kb);
            pendingComment = "";
        }
    }

    if (allKeybinds.length === 0)
        return { children: [], keybinds: [], name: "" };

    return wrapSections(sections);
}

function hyprctlBindToKeybinding(bind) {
    if (jsonBool(bind.catch_all))
        return null;

    var key = bind.key || "";
    if (!key)
        return null;

    var submap = bind.submap || "";
    if (submap && submap !== "reset")
        return null;

    if (bind.dispatcher === "submap")
        return null;

    var mods = [];
    if (bind.modkeys) {
        bind.modkeys.trim().split(/[\s+]+/).forEach(function(part) {
            if (part)
                mods.push(normalizeModName(part));
        });
    } else {
        mods = modmaskToMods(parseInt(bind.modmask, 10) || 0);
    }

    var dispatcher = bind.dispatcher || "";
    var params = bind.arg || "";
    var comment = (bind.description || "").trim();
    if (!comment || !jsonBool(bind.has_description))
        comment = autogenerateComment(dispatcher, params);

    return {
        mods: mods,
        key: key,
        dispatcher: dispatcher,
        params: params,
        comment: comment,
        mouse: jsonBool(bind.mouse),
    };
}

function mergeHyprctlKeys(luaTree, hyprctlRaw) {
    if (!hyprctlRaw || !hyprctlRaw.length)
        return luaTree;

    var live = {};
    for (var i = 0; i < hyprctlRaw.length; i++) {
        var kb = hyprctlBindToKeybinding(hyprctlRaw[i]);
        if (!kb)
            continue;
        live[kb.mods.join("+") + "|" + kb.key] = true;
    }

    return luaTree;
}

function buildFromHyprctlOnly(rawBinds) {
    var keybinds = [];
    for (var i = 0; i < rawBinds.length; i++) {
        var kb = hyprctlBindToKeybinding(rawBinds[i]);
        if (kb)
            keybinds.push(kb);
    }
    var sections = { Binds: keybinds };
    return wrapSections(sections);
}

function buildKeybindTree(luaText, hyprctlRaw) {
    var luaTree = parseKeybindingsLua(luaText);
    if (luaTree.children && luaTree.children.length > 0)
        return mergeHyprctlKeys(luaTree, hyprctlRaw);

    if (hyprctlRaw && hyprctlRaw.length)
        return buildFromHyprctlOnly(hyprctlRaw);

    return { children: [], keybinds: [], name: "" };
}
