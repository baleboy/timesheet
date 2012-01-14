import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

import "Constants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

Item {
    height: 105
    width: parent.width

    MouseArea {
        anchors.fill: parent
        onClicked: {
            pageStack.push(detailPage, { title: name, project: name, startTime: new Date(0), endTime: new Date() })
        }
    }

    Button {
        id: startButton

        height: 58
        width: 58
        text: checked ? "||" : ">"
        checked: projectList.inProgress === name

        anchors {
            top: parent.top
            topMargin: Const.margin
            left: parent.left
            leftMargin: Const.margin
        }

        function stopCurrentProject()
        {
            workTimer.stop()
            Db.addProjectEnd()
            // projectsModel.setProperty(projectList.inProgressIndex, "elapsed", workTimer.elapsed)
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
                workTimer.start()
                console.log("elapsed today: " + elapsedToday)
            }
            console.log("new in progress:" + projectList.inProgress)
            Db.setProperty("projectInProgress", projectList.inProgress)
        }
    }

    Label {
        id: nameLabel
        text: name
        font.pixelSize: Const.fontMedium
        anchors {
            top: parent.top
            topMargin: Const.margin
            left: startButton.right
            leftMargin: Const.margin
        }
    }

    Label {
        id: timeLabel
        text: "Today " + Utils.toTime(elapsedToday)
        color: "gray"
        font.pixelSize: Const.fontSmall
        anchors {
            top: nameLabel.bottom
            topMargin: Const.smallMargin
            left: nameLabel.left
        }
    }

    Label {
        id: timeLabel2
        text: "Total " + Utils.toTime(elapsedTotal)
        color: "gray"
        font.pixelSize: Const.fontSmall
        anchors {
            top: timeLabel.top
            left: timeLabel.right
            leftMargin: Const.bigMargin
        }
    }

    MoreIndicator {
        id: moreIndicator
        anchors {
            verticalCenter: startButton.verticalCenter
            right: parent.right
            rightMargin: Const.margin
        }
    }

}
