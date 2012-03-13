import QtQuick 1.1
import Exporter 1.0

import com.nokia.meego 1.0

import "UiConstants.js" as Const
import "Reports.js" as Reports
import "Utils.js" as Utils
import "Projects.js" as Projects

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
            platformStyle: myStyle
            width: 300
            text: Reports.getTitle(typeDialog.selected)

            font {
                pixelSize: Const.fontMedium
            }

            anchors.centerIn: parent

            onClicked: typeDialog.open()
        }

        ButtonStyle {
            id: myStyle
            background: disabledBackground
            textColor: "white"
        }

        Button {
            id: leftButton
            platformStyle: myStyle
            visible: typeDialog.selected != "all"
            anchors {
                verticalCenter: reportTitle.verticalCenter
                right: reportTitle.left
                rightMargin: Const.margin
            }
            width: 48
            height: 48
            text: "<"
            onClicked: {
                Reports.setPreviousPeriod(typeDialog.selected)
                Reports.populateReportsModel()
            }
        }

        Button {
            id: rightButton
            platformStyle: myStyle
            visible: typeDialog.selected != "all"
            anchors {
                verticalCenter: reportTitle.verticalCenter
                left: reportTitle.right
                leftMargin: Const.margin
            }
            width: 48
            height: 48
            text: ">"
            onClicked: {
                Reports.setNextPeriod(typeDialog.selected)
                Reports.populateReportsModel()
            }
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
            bottom: totalText.top
            left: parent.left
            right: parent.right
        }

        section.property: "date"
        section.criteria: ViewSection.FullString

        model: reportModel

        delegate: reportDelegate

        // section.delegate: typeDialog.selected == "day" ? null : sectionDelegate
    }

    SectionScroller {
        id: reportScroller
        listView: reportList
        visible: typeDialog.selected != "day"
    }

    ScrollDecorator {
        flickableItem: reportList
    }

    Rectangle {
        id: totalText
        color: "darkGray"
        width: parent.width
        height: 50

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        Label {
            id: totalTextCaption
            text: qsTr("Total")
            anchors {
                left: parent.left
                leftMargin: Const.margin
                verticalCenter: parent.verticalCenter
            }
            font.pixelSize: Const.fontMedium
            color: "white"
        }

        Label {
            id: totalTextLabel
            color: "white"
            anchors {
                right: parent.right
                rightMargin: Const.margin
                verticalCenter: parent.verticalCenter
            }
            font.pixelSize: Const.fontMedium
        }
    }



    SelectionDialog {
        id: typeDialog
        titleText: "Report Type"
        selectedIndex: 0

        property string selected: model.get(selectedIndex).type

        model: ListModel {
            ListElement { name: "Day"; type: "day" }
            ListElement { name: "Week"; type: "week" }
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
            case "week":
                startTime = Utils.weekStart(now)
                endTime = Utils.weekEnd(now)
                break;
            case "all":
                startTime = new Date(0)
                endTime = now
                break;
            }

            if (model.get(selectedIndex).type === "day") {
                reportList.section.delegate = null
                // reportScroller.listView = null
            }
            else {
                reportList.section.delegate = sectionDelegate
                // reportScroller.listView = reportList
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

        ToolButton {
            id: selectProjectsButton
            text: Reports.selectedProjectsText(projectSelectionDialog.selectedIndexes,
                                               projectSelectionDialog.model.count)
            onClicked: projectSelectionDialog.open()
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

    MultiSelectionDialog {
        id: projectSelectionDialog
        titleText: qsTr("Select Projects")
        model: ListModel {}
        Component.onCompleted: Reports.getProjectList(projectSelectionDialog.model)
        acceptButtonText: qsTr("OK")
        onAccepted: Reports.populateReportsModel()
    }
}
