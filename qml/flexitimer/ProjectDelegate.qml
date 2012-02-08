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
            detailPage.projectIndex = index
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
        checked: inProgress === name

        anchors {
            top: parent.top
            topMargin: Const.margin
            left: parent.left
            leftMargin: Const.margin
        }

        onClicked: {
            console.log("old in progress:" + inProgress)
            if (checked) {
                // this task was stopped by pressing the pause button
                appWindow.stopCurrentProject()
            }
            else {
                appWindow.startProject(name, index)
            }/*
                if (inProgress !== "") {
                    // previous task stopped implicitly
                    appWindow.stopCurrentProject()
                }
                inProgress = name
                inProgressIndex = index
                Db.addProjectStart(name)
                workTimer.startTimer()
                console.log("elapsed today: " + elapsedToday)
                Db.setProperty("projectInProgress", inProgress)
            }
            */
            console.log("new in progress:" + inProgress)
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
                                      (inProgress === name ? workTimer.elapsed : 0))
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
                                  (inProgress === name ? workTimer.elapsed : 0))
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
