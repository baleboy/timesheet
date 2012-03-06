import QtQuick 1.1
import Exporter 1.0

import com.nokia.meego 1.0

import "UiConstants.js" as Const
import "Reports.js" as Reports
import "Utils.js" as Utils

CommonPage {

    title: qsTr("Reports")

    property date startTime: Utils.dayStart()
    property date endTime: Utils.dayEnd()

    Rectangle {
        id: background
        width: parent.width
        height: 90
        color: "orange"

        anchors {
            top: parent.top
            topMargin: Const.headerHeight
            horizontalCenter: parent.horizontalCenter
        }

        Button {
            id: reportTitle
            width: 400
            text: Reports.getTitle(typeDialog.selected)

            font {
                pixelSize: Const.fontMedium
            }

            anchors.centerIn: parent

            onClicked: typeDialog.open()
        }
    }


    ListModel {
        id: reportModel
    }

    Component.onCompleted: Reports.populateReportsModel(startTime, endTime)


    Component {
        id: reportDelegate

        Item {
            height: 125
            width: reportList.width

            Label {
                id: nameLabel
                text: project
                font.pixelSize: Const.listItemTitleFont
                font.weight: Font.Bold
                anchors {
                    top: parent.top
                    topMargin: Const.smallMargin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Label {
                text: startTime + " - " +  (endTime === "" ? qsTr("In progress") : endTime)
                font.pixelSize: Const.listItemSubtitleFont
                color: "gray"
                width: 320
                anchors {
                    top: nameLabel.bottom
                    topMargin: Const.smallMargin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Label {
                id: elapsedLabel
                text: elapsed
                font.pixelSize: Const.listItemSubtitleFont
                color: "gray"
                anchors {
                    top: nameLabel.bottom
                    topMargin: Const.smallMargin
                    right: parent.right
                    rightMargin: Const.margin
                }
            }

            Label {
                text: comments
                font.pixelSize: Const.listItemSubtitleFont
                color: "gray"
                anchors {
                    top: elapsedLabel.bottom
                    topMargin: Const.smallMargin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Image {
                source: "images/separator.png"
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
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
            top: background.bottom
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

    Exporter {
        id: exporter
        folderName: "FlexiTimer"
        mimeType: "text/plain"
        fileName: "flexiTimer-report.csv"

        onError: {
            errorBanner.text = msg;
            errorBanner.show()
        }
    }

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }

        ToolIcon {
            platformIconId: enabled ? "toolbar-share" : "toolbar-share-dimmed"
            enabled: reportModel.count != 0
            onClicked: {
                exporter.body = Reports.buildReport()
                exporter.share()
            }
        }
    }
}
