import QtQuick 1.1
import com.nokia.meego 1.0
import "Projects.js" as Projects
import "UiConstants.js" as Const

Dialog {
    id: root

    property alias titleText: titleLabel.text
    property alias inputText: projectNameInput.text

    title: Label { id: titleLabel; color: "white" }

    content:Item {
        id: name
        height: 140
        width: parent.width
        TextField {
            id: projectNameInput
            placeholderText: qsTr("Project name")
            anchors.centerIn: parent
            width: 300
        }
    }
    buttons: Button {
        platformStyle: ButtonStyle { inverted: true }
        text: qsTr("OK")
        width: Const.mediumButtonWidth
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: root.accept()
    }

    onStatusChanged: if (status === DialogStatus.Opening) {
                         projectNameInput.text = ""
                         projectNameInput.focus = true
                     }
}

