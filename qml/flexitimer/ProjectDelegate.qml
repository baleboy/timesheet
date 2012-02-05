import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1

import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

Item {
    id: root

    height: 105
    width: parent.width

    MouseArea {
        anchors.fill: parent
        onClicked: {
            detailPage.title = name
            detailPage.project = name
            detailPage.startTime = new Date(0)
            detailPage.endTime = new Date()
            detailPage.update()
            pageStack.push(detailPage)
        }
        onPressAndHold: {
            projectMenu.projectIndex = index
            projectMenu.projectName = name
            projectMenu.open()
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
            workTimer.stopTimer()
            console.log("Project stopped. Elapsed: " + workTimer.elapsed + " todaysTotal: " + elapsedToday)
            Db.addProjectEnd()
            Db.saveElapsed(projectList.inProgress, workTimer.elapsed)
            projectsModel.setProperty(projectList.inProgressIndex,
                                      "elapsedToday",
                                      elapsedToday + workTimer.elapsed)
            projectsModel.setProperty(projectList.inProgressIndex,
                                      "elapsedTotal",
                                      elapsedTotal + workTimer.elapsed)
            projectsPage.todaysTotal += workTimer.elapsed
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
                workTimer.startTimer()
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
        text: "Today " + Utils.toTime(elapsedToday +
                                      (projectList.inProgress === name ? workTimer.elapsed : 0))
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
        text: "Total " + Utils.toTime(elapsedTotal +
                                  (projectList.inProgress === name ? workTimer.elapsed : 0))
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
