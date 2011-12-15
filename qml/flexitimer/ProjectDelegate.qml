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
            Db.populateProjectDetails(name)
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
            checked: projectList.pressed == index
            onClicked:
                if (checked) {
                    projectList.pressed = -1
                }
                else {
                    projectList.pressed = index
                }

            onCheckedChanged: {
                var now = new Date()
                if (!checked) {
                    // ending the task
                    Db.addProjectEnd(name)
                }
                else {
                    // starting the task
                    Db.addProjectStart(name)
                }
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
