import QtQuick
import Quickshell

QtObject {
    property string id: ""
    property string name: ""
    property string iconName: ""
    property string genericName: ""
    property var execute: () => {
        print("Not implemented");
    }
}
