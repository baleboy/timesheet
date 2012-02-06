import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

import "UiConstants.js" as Const
import "Details.js" as Details
import "Utils.js" as Utils

CommonPage {

    property alias model: detailsList.model

    property date startTime
    property date endTime
    property string project

    function update()
    {
        Details.populateProjectDetails()
    }

    Item {
        anchors.fill: parent
        Label {
            font.pixelSize: Const.fontLarge
            color: "gray"
            anchors.centerIn: parent
            text: qsTr("No sessions")

            visible: model.count === 0
        }
    }

    ListView {
        id: detailsList

        visible: model.count > 0

        model: detailsModel

        anchors {
            top: parent.top
            topMargin: headerHeight
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        section.property: "date"
        section.criteria: ViewSection.FullString

        clip: true

        delegate: Item {
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
                    topMargin: Const.margin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Label {
                id: elapsedLabel
                text: elapsed !== "" ? elapsed : Utils.toTime(workTimer.elapsed)
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

        section.delegate: Rectangle {
            width: parent.width
            height: 40
            color: "lightSteelBlue"

            Label {
                text: section
                font.bold: true
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 8
                }
            }
        }
    }

    tools: DefaultToolbar { }

    ContextMenu {
        id: sessionMenu
        property alias deleteEnabled: deleteMenuItem.enabled
        property int sessionIndex
        property double recordId

        MenuLayout {
            MenuItem {
                id: deleteMenuItem
                text: qsTr("Delete");
                onClicked: deleteSessionDialog.open() }
        }
    }

    QueryDialog {

        id: deleteSessionDialog
        titleText: qsTr("Delete Session")
        message:qsTr("Do you want to delete this session?")
        acceptButtonText: qsTr("Yes")
        rejectButtonText: qsTr("No")
        onAccepted: {
            Details.deleteRecord(project,
                                 sessionMenu.recordId,
                                 sessionMenu.sessionIndex)
            mainPage.update()
        }
    }

    // Component.onCompleted: update()
}
