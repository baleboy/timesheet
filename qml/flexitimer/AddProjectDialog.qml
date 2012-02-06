import QtQuick 1.1
import com.nokia.meego 1.0
import "Db.js" as Db
import "UiConstants.js" as Const

Dialog {
    id: root
    title: Label { color: "white"; text: qsTr("Add Project")}

    content:Item {
        id: name
        height: 140
        width: parent.width
        TextField {
            id: projectNameInput
            placeholderText: qsTr("Project name")
            anchors.centerIn: parent
        }
    }
    buttons: Button {
        platformStyle: ButtonStyle { inverted: true }
        text: qsTr("OK")
        width: Const.mediumButtonWidth
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: root.accept()
    }
    onAccepted: if (projectNameInput.text != "") {
                    projectsModel.append({"name": projectNameInput.text,
                                             "elapsedTotal": 0,
                                             "elapsedToday": 0})
                    Db.addProject(projectNameInput.text)
                }
    onStatusChanged: if (status === DialogStatus.Opening)
                         projectNameInput.text = ""
}
