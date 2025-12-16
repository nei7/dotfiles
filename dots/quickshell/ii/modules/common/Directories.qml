pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions
import QtCore
import QtQuick
import Quickshell

Singleton {
    // XDG Dirs, with "file://"
    readonly property string home: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
    readonly property string config: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0]
    readonly property string state: StandardPaths.standardLocations(StandardPaths.StateLocation)[0]
    readonly property string cache: StandardPaths.standardLocations(StandardPaths.CacheLocation)[0]
    readonly property string genericCache: StandardPaths.standardLocations(
                                               StandardPaths.GenericCacheLocation)[0]
    readonly property string documents: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]
    readonly property string downloads: StandardPaths.standardLocations(StandardPaths.DownloadLocation)[0]
    readonly property string pictures: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
    readonly property string music: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
    readonly property string videos: StandardPaths.standardLocations(StandardPaths.MoviesLocation)[0]

    // Other dirs used by the shell, without "file://"
    property string assetsPath: Quickshell.shellPath("assets")
    property string scriptPath: Quickshell.shellPath("scripts")
    property string favicons: FileUtils.trimFileProtocol(`${Directories.cache}/media/favicons`)
    property string coverArt: FileUtils.trimFileProtocol(`${Directories.cache}/media/coverart`)
    property string tempImages: "/tmp/quickshell/media/images"

    property string shellConfig: FileUtils.trimFileProtocol(`${Directories.home}/dotfiles/.config/quickshell`)
    property string shellConfigName: "config.json"
    property string shellConfigPath: `${Directories.shellConfig}/${Directories.shellConfigName}`
    property string todoPath: FileUtils.trimFileProtocol(`${Directories.state}/user/todo.json`)
    property string notesPath: FileUtils.trimFileProtocol(`${Directories.state}/user/notes.txt`)
    property string conflictCachePath: FileUtils.trimFileProtocol(`${Directories.cache}/conflict-killer`)
    property string notificationsPath: FileUtils.trimFileProtocol(`${Directories.cache
                                                                  }/notifications/notifications.json`)

    property string generatedMaterialThemePath: FileUtils.trimFileProtocol(`${Directories.state
                                                                           }/user/generated/colors.json`)
    property string generatedWallpaperCategoryPath: FileUtils.trimFileProtocol(`${Directories.state
                                                                               }/user/generated/wallpaper/category.txt`)
    property string cliphistDecode: FileUtils.trimFileProtocol(`/tmp/quickshell/media/cliphist`)
    property string screenshotTemp: "/tmp/quickshell/media/screenshot"
    property string wallpaperSwitchScriptPath: FileUtils.trimFileProtocol(`${Directories.scriptPath
                                                                          }/colors/switchwall.sh`)

    property string recordScriptPath: FileUtils.trimFileProtocol(`${Directories.scriptPath}/videos/record.sh`)
    // Cleanup on init
    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", `${shellConfig}`]);
        Quickshell.execDetached(["mkdir", "-p", `${favicons}`]);
        Quickshell.execDetached(["bash", "-c", `rm -rf '${coverArt}'; mkdir -p '${coverArt}'`]);
        Quickshell.execDetached(["bash", "-c", `rm -rf '${cliphistDecode}'; mkdir -p '${cliphistDecode}'`]);
        Quickshell.execDetached(["rm", "-rf", `${tempImages}`]);
    }
}
