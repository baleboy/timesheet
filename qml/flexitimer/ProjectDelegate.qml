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

    Button {
        id: startButton

        height: 52
        width: 52
        text: checked ? "||" : ">"
        checked: projectList.inProgress == name

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Const.margin
        }

        function stopCurrentProject()
        {
            workTimer.stop()
            Db.addProjectEnd()
            projectsModel.setProperty(projectList.inProgressIndex, "elapsed", workTimer.elapsed)
            Db.saveElapsed(projectList.inProgress, workTimer.elapsed)
        }

        onClicked: {
            console.log("old in progress:" + projectList.inProgress)
            if (checked) {
                // this task was stopped by pressing the pause button
                stopCurrentProject()
                projectList.inProgress = ""
            }
            else {
                if (projectList.inProgress != "") {
                    // previous task stopped implicitly
                    stopCurrentProject()
                }
                projectList.inProgress = name
                projectList.inProgressIndex = index
                Db.addProjectStart(name)
                workTimer.elapsed = parseInt(elapsed)
                workTimer.start()
                console.log("elapsed: " + elapsed)
            }
            console.log("new in progress:" + projectList.inProgress)
            Db.setProperty("projectInProgress", projectList.inProgress)
        }
    }

    Label {
        text: name
        font.pixelSize: Const.fontMedium
        anchors {
            verticalCenter: parent.verticalCenter
            left: startButton.right
            leftMargin: Const.margin
        }
    }

    Label {
        text: Utils.toTime(projectList.inProgress == name ? workTimer.elapsed : elapsed)
        font.pixelSize: Const.fontMedium
        color: "darkGray"
        anchors {
            verticalCenter: parent.verticalCenter
            right: moreIndicator.left
            rightMargin: Const.margin
        }
    }

    Label {
        id: moreIndicator
        text: ">"
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Const.margin
        }
    }



}
