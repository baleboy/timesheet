import QtQuick 1.1
import Qt.labs.gestures 1.0

import com.nokia.meego 1.0
import "UiConstants.js" as Const
import "Reports.js" as Reports
import "Utils.js" as Utils

CommonPage {

    title: qsTr("Reports")

    property date startTime: Utils.dayStart()
    property date endTime: Utils.dayEnd()

    Button {
        id: reportTitle
        width: 400
        text: Reports.getTitle(typeDialog.selected)

        font {
            pixelSize: Const.fontMedium
        }

        anchors {
            top: parent.top
            topMargin: Const.headerHeight + Const.margin
            horizontalCenter: parent.horizontalCenter
        }

        onClicked: typeDialog.open()
    }

    ListModel {
        id: reportModel
    }

    Component.onCompleted: Reports.populateReportsModel(startTime, endTime)


    Component {
        id: reportDelegate

        Item {
            height: 105
            width: reportList.width

            Label {
                id: nameLabel
                text: project
                font.pixelSize: Const.fontMedium
                anchors {
                    top: parent.top
                    topMargin: Const.margin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Label {
                text: startTime + " - " +  (endTime === "" ? qsTr("In progress") : endTime)
                font.pixelSize: Const.fontMedium
                color: "gray"
                width: 320
                anchors {
                    top: nameLabel.bottom
                    topMargin: Const.margin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Label {
                text: elapsed
                font.pixelSize: Const.fontMedium
                color: "gray"
                anchors {
                    top: nameLabel.bottom
                    topMargin: Const.margin
                    right: parent.right
                    rightMargin: Const.margin
                }
            }

        }

    }
    Component {
        id: sectionDelegate

        Rectangle {
            width: parent.width
            height: 40
            color: "lightGrey"

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
    Item {
        anchors.fill: parent
        Label {
            font.pixelSize: Const.fontLarge
            color: "gray"
            anchors.centerIn: parent
            text: qsTr("No data")
        }
        visible: reportModel.count === 0
    }

    ListView {
        id: reportList
        visible: reportModel.count > 0
        clip: true

        anchors {
            top: reportTitle.bottom
            topMargin: Const.margin
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        section.property: "date"
        section.criteria: ViewSection.FullString

        model: reportModel

        delegate: reportDelegate

        section.delegate: sectionDelegate
    }

    SelectionDialog {
        id: typeDialog
        titleText: "Report Type"
        selectedIndex: 0

        property string selected: model.get(selectedIndex).type

        model: ListModel {
            ListElement { name: "Day"; type: "day" }
            ListElement { name: "Month"; type: "month" }
            ListElement { name: "All Time"; type: "all" }
        }

        onSelectedIndexChanged: {
            console.log("new report type: " + model.get(selectedIndex).type)
            var now = new Date()
            switch (model.get(selectedIndex).type) {
            case "day":
                startTime = Utils.dayStart(now)
                endTime = Utils.dayEnd(now)
                break;
            case "month":
                startTime = Utils.monthStart(now)
                endTime = Utils.monthEnd(now)
                break;
            case "all":
                startTime = new Date(0)
                endTime = now
                break;
            }

            Reports.populateReportsModel()

        }
    }

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }
}
