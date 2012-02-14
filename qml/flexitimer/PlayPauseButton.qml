import QtQuick 1.1
import com.nokia.meego 1.0
Item {
    id: root
    property bool checked
    signal clicked

    width: image1.width
    height: image1.height

    Image {
        id: image1
        visible: !checked
        anchors.centerIn: parent

        source: "images/orange-button.png"
        ToolIcon {
            iconId: "toolbar-mediacontrol-play-white"
            anchors.centerIn: parent
        }

    }
    Image {
        id: image2
        visible: checked
        anchors.centerIn: parent

        source: "images/cyan-button.png"

        ToolIcon {
            iconId: "toolbar-mediacontrol-pause-white"
            anchors.centerIn: parent
            visible: checked
        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: { console.log("Clicked"); root.clicked() }
    }
}
