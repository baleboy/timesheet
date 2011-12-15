import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

Item {
    height: 85
    width: parent.width

    MouseArea {
        anchors.fill: parent
        onClicked: {
            detailPage.title = name
            Db.populateProjectDetails(detailsModel, name)
            pageStack.push(detailPage)
        }
    }

    Row {
        anchors.fill: parent
        anchors.margins: Const.margin
        spacing: Const.margin



        Button {
            height: 52
            width: 52
            text: checked ? "||" : ">"
            anchors.verticalCenter: parent.verticalCenter
            checked: projectList.inProgress == name
            onClicked: {
                console.log("old in progress:" + projectList.inProgress)
                if (checked) {
                    Db.addProjectEnd()
                    projectList.inProgress = ""
                }
                else {
                    if (projectList.inProgress != "")
                        Db.addProjectEnd()
                    projectList.inProgress = name
                    Db.addProjectStart(name)
                }
                console.log("new in progress:" + projectList.inProgress)
                Db.setProperty("projectInProgress", projectList.inProgress)
            }
        }

        Label {
            text: name
            font.pixelSize: Const.fontMedium
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: Utils.toTime(elapsed)
            font.pixelSize: Const.fontLarge
            color: "darkGray"
            anchors.verticalCenter: parent.verticalCenter
        }

        Label {
            text: ">"
            anchors.verticalCenter: parent.verticalCenter
        }

    }

}
