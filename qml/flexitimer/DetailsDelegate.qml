import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

import "UiConstants.js" as Const
import "Utils.js" as Utils

Item {
    height: 100
    width: parent.width

    MouseArea {
        anchors.fill: parent
        onClicked: { pageStack.push(editSessionPage, { recordId: recordId }) }
        onPressAndHold: {
            sessionMenu.deleteEnabled =  endTime !== ""
            sessionMenu.sessionIndex = index
            sessionMenu.recordId = recordId
            sessionMenu.open()
        }
    }

    Label {
        id: startLabel
        text: startTime + " - " +  (endTime === "" ? qsTr("In progress") : endTime)
        font.pixelSize: Const.fontMedium
        width: 320
        anchors {
            top: parent.top
            topMargin: comments !== "" ? Const.margin : 2*Const.margin
            left: parent.left
            leftMargin: Const.margin
        }
    }

    Label {
        id: elapsedLabel
        text: elapsed === "" ? Utils.toTime(workTimer.elapsed) : elapsed
        font.pixelSize: Const.fontMedium
        color: "gray"
        anchors {
            top: startLabel.top
            right: moreIndicator.left
            rightMargin: Const.margin
        }
    }

    MoreIndicator {
        id: moreIndicator
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Const.margin
        }

    }

    Label {
        text: comments
        elide: Text.ElideRight
        maximumLineCount: 1
        color: "grey"
        anchors {
            left: parent.left
            leftMargin: Const.margin
            bottom: parent.bottom
            bottomMargin: Const.margin
            right: moreIndicator.left
        }
    }

}
