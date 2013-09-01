/*

Copyright (C) 2012 Francesco Balestrieri

This file is part of Timesheet for N9

Timesheet for N9 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Timesheet for N9 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Timesheet for N9.  If not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

Item {
    id: root

    property int maxHeight: 105
    height: maxHeight
    width: parent.width

    Rectangle {
        anchors.fill: parent
        color: "#0083C8"
        opacity: inProgress === name ? .5 : 0
    }

    Rectangle {
        id: highlight
        anchors.fill: parent
        color: "lightGray"
        opacity: 0
    }

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
        onCanceled: highlight.opacity = 0
        onReleased: highlight.opacity = 0

        onPressed: highlight.opacity = 0.7
    }

    PlayPauseButton {
        id: startButton

        checked: inProgress === name

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Const.mediumMargin
        }

        onClicked: {
            if (checked) {
                // this task was stopped by pressing the pause button
                appWindow.stopCurrentProject()
            }
            else {
                appWindow.startProject(name, index)
            }

        }

    }

    CommonLabel {
        id: nameLabel
        text: name
        font.pixelSize: Const.listItemTitleFont
        elide: Text.ElideRight
        maximumLineCount: 1
        color: inProgress === name ? "white" : "black"
        anchors {
            top: parent.top
            topMargin: 15
            left: startButton.right
            leftMargin: Const.margin
            right: moreIndicator.left
        }
    }

    CommonLabel {
        id: timeLabel
        text: Utils.toTime(elapsedTotal +
                           (inProgress === name ? workTimer.elapsed : 0))
        color: inProgress === name ? "white" : "gray"
        font.pixelSize: Const.listItemSubtitleFont
        anchors {
            left: nameLabel.left
            top: nameLabel.bottom
            topMargin: 2
        }
    }

    CommonLabel {
        id: todaysTimeLabel
        text: qsTr("Today: ") + Utils.toTime(elapsedToday +
                           (inProgress === name ? workTimer.elapsed : 0))
        color: inProgress === name ? "white" : "gray"
        font.pixelSize: Const.listItemSubtitleFont
        anchors {
            left: timeLabel.right
            leftMargin: Const.bigMargin
            top: nameLabel.bottom
            topMargin: 2
        }
    }

    Image {
        id: moreIndicator
        anchors {
            verticalCenter: startButton.verticalCenter
            right: parent.right
            rightMargin: Const.smallMargin
        }
        source: inProgress !== name ?
                    "image://theme/icon-m-common-drilldown-arrow" :
                    "image://theme/icon-m-common-drilldown-arrow-inverse"
    }

    Image {
        source: "images/separator.png"
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
    }

    // appear and disappear animations for list items
    ListView.onAdd: SequentialAnimation {
        PropertyAction { target: root; property: "opacity"; value: 0 }
        NumberAnimation { target: root; property: "height"; from: 0; to: maxHeight ; duration: 150 ; easing.type: Easing.InOutQuad }
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: 100 }
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: root; property: "ListView.delayRemove"; value: true }
        ParallelAnimation {
            NumberAnimation { target: root; property: "height"; from: maxHeight; to: 0 ; duration: 150 ; easing.type: Easing.InOutQuad }
            NumberAnimation { target: root; property: "opacity"; from: 1; to: 0; duration: 200 }
        }
        PropertyAction { target: root; property: "ListView.delayRemove"; value: false }
    }

}
