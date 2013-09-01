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

Item {
    id: root

    property int maxHeight: 100
    height: maxHeight
    width: parent.width

    Rectangle {
        anchors.fill: parent
        color: "#0083C8"
        opacity: endTime == "" ? .5 : 0
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
            sessionSheet.recordId = recordId;
            sessionSheet.newRecord = false;
            sessionSheet.open()
        }
        onPressAndHold: {
            sessionMenu.deleteEnabled =  endTime !== ""
            sessionMenu.sessionIndex = index
            sessionMenu.recordId = recordId
            sessionMenu.open()
        }        
        onReleased: highlight.opacity = 0
        onCanceled: highlight.opacity = 0
        onPressed: highlight.opacity = 0.7

    }

    CommonLabel {
        id: startLabel
        text: startTime + " - " +  (endTime === "" ? qsTr("In progress") : endTime)
        font.pixelSize: Const.listItemTitleFont
        width: 320
        color: endTime == "" ? "white" : "black"
        anchors {
            top: parent.top
            topMargin: comments !== "" ? Const.margin : 2*Const.margin
            left: parent.left
            leftMargin: Const.margin
        }
    }

    CommonLabel {
        id: elapsedLabel
        text: elapsed === "" ? Utils.toTime(workTimer.elapsed) : elapsed
        font.pixelSize: Const.listItemTitleFont
        color: endTime == "" ? "white" : "gray"
        anchors {
            top: startLabel.top
            right: parent.right
            rightMargin: Const.margin
        }
    }


    CommonLabel {
        text: comments
        elide: Text.ElideRight
        maximumLineCount: 1
        color: "grey"
        font.pixelSize: Const.listItemSubtitleFont
        anchors {
            left: parent.left
            leftMargin: Const.margin
            top: startLabel.bottom
            topMargin: Const.smallMargin
            right: parent.right
            rightMargin: Const.margin
        }
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
