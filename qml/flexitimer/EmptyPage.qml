import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const

Item {

    Column {
        id: column1
        spacing: Const.spacing
        anchors.centerIn: parent

        CommonLabel {
            id: label1
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("No Projects")
            font.pixelSize: Const.fontLarge
            color: "gray"
        }

        CommonLabel {
            id: label2
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Add a project to start tracking")
            font.pixelSize: Const.fontMedium
            color: "gray"
        }

        Button {
            id: button1
            anchors.horizontalCenter: parent.horizontalCenter
            width: Const.mediumButtonWidth
            text: qsTr("Add project")
            onClicked: addProjectDialog.open()
        }

    }
}

