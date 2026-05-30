pragma Singleton

import qs.modules.common
import qs.modules.common.models
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string query: ""
    property list<var> results: {
        return (root.query == "" ? AppSearch.initialList() : AppSearch.fuzzyQuery(root.query)).map(entry => {
            return resultComp.createObject(null, {
                id: entry.id,
                name: entry.name,
                iconName: entry.icon,
                genericName: entry.genericName,
                execute: () => {
                    if (!entry.runInTerminal)
                        entry.execute();
                    else {
                        Quickshell.execDetached(["bash", '-c', `${Config.options.apps.terminal} -e '${StringUtils.shellSingleQuoteEscape(entry.command.join(' '))}'`]);
                    }
                }
            });
        });
    }

    Component {
        id: resultComp
        LauncherSearchResult {}
    }
}
