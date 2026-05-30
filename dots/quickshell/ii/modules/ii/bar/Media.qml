import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import qs.modules.common.functions

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland

Item {
    id: root
    property bool borderless: Config.options.bar.borderless
    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(activePlayer?.trackTitle ?? "")
    readonly property bool hasActiveTrack: root.cleanedTitle.length > 0

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.preferredHeight: Appearance.sizes.barHeight

    Timer {
        running: activePlayer?.playbackState == MprisPlaybackState.Playing
        interval: Config.options.resources.updateInterval
        repeat: true
        onTriggered: activePlayer.positionChanged()
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton | Qt.BackButton | Qt.ForwardButton | Qt.RightButton | Qt.LeftButton
        onPressed: event => {
            if (event.button === Qt.MiddleButton) {
                activePlayer?.togglePlaying();
            } else if (event.button === Qt.BackButton) {
                activePlayer?.previous();
            } else if (event.button === Qt.ForwardButton || event.button === Qt.RightButton) {
                activePlayer?.next();
            } else if (event.button === Qt.LeftButton) {
                GlobalStates.mediaControlsOpen = !GlobalStates.mediaControlsOpen;
            }
        }
    }

    RowLayout {
        id: rowLayout
        spacing: 2
        anchors.fill: parent

        ClippedFilledCircularProgress {
            id: mediaCircProg
            visible: root.hasActiveTrack
            Layout.alignment: Qt.AlignVCenter
            lineWidth: Appearance.rounding.unsharpen
            value: activePlayer?.position / activePlayer?.length
            implicitSize: 20
            colPrimary: Appearance.colors.colOnSecondaryContainer
            enableAnimation: false

            Item {
                anchors.centerIn: parent
                width: mediaCircProg.implicitSize
                height: mediaCircProg.implicitSize

                MaterialSymbol {
                    anchors.centerIn: parent
                    fill: 1
                    text: activePlayer?.isPlaying ? "pause" : "music_note"
                    iconSize: Appearance.font.pixelSize.normal
                    color: Appearance.m3colors.m3onSecondaryContainer
                }
            }
        }

        StyledText {
            visible: Config.options.bar.verbose
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            Layout.maximumWidth: root.hasActiveTrack ? 200 : undefined
            horizontalAlignment: root.hasActiveTrack ? Text.AlignLeft : Text.AlignHCenter
            elide: Text.ElideRight
            color: Appearance.colors.colOnLayer1
            text: root.hasActiveTrack
                  ? `${cleanedTitle}${activePlayer?.trackArtist ? ' • ' + activePlayer.trackArtist : ''}`
                  : "No media"
        }
    }
}
