import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const
import "Details.js" as Details

CommonPage {

    property alias model: detailsList.model

    property date startTime
    property date endTime
    property string project

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
            height: 70
            width: parent.width

            MouseArea {
                anchors.fill: parent
                onPressAndHold: {
                    sessionMenu.deleteEnabled =  endTime !== ""
                    sessionMenu.sessionIndex = index
                    sessionMenu.recordId = recordId
                    sessionMenu.open()
                }
            }

            Label {
                text: startTime + " - " +  (endTime === "" ? qsTr("In progress") : endTime)
                font.pixelSize: Const.fontMedium
                width: 320
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Label {
                text: elapsed
                font.pixelSize: Const.fontMedium
                color: "gray"
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: Const.margin
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

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }

    ContextMenu {
        id: sessionMenu
        property alias deleteEnabled: deleteMenuItem.enabled
        property int sessionIndex
        property double recordId

        MenuLayout {
            MenuItem {
                id: deleteMenuItem
                text: qsTr("Delete");
                onClicked: Details.deleteRecord(project,
                                                sessionMenu.recordId,
                                                sessionMenu.sessionIndex) }
        }
    }

    Component.onCompleted: Details.populateProjectDetails()
}
