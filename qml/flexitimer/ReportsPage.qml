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

import Exporter 1.0

import com.nokia.meego 1.0
import com.nokia.extras 1.0

import "UiConstants.js" as Const
import "Reports.js" as Reports
import "Utils.js" as Utils
import "Projects.js" as Projects

Page {

    property string title: qsTr("Reports")

    property date startTime: Utils.dayStart()
    property date endTime: Utils.dayEnd()
    property bool loading: false
    property bool exporting: false

    orientationLock: PageOrientation.LockPortrait

    function updateProjectsDialog()
    {
        projectSelectionDialog.updateProjects();
    }

    function update()
    {
        loading = true
        var projectString = ""
        if (typeDialog.selected == "all")
            endTime = new Date // update report limit to current time
        for (var i = 0 ; i < projectSelectionDialog.selectedIndexes.length; i++) {
            projectString += "'" + projectSelectionDialog.model.get(projectSelectionDialog.selectedIndexes[i]).name + "'"
            if (i !== projectSelectionDialog.selectedIndexes.length - 1)
                projectString += ","
        }

        reportWorker.sendMessage({
                                     'model': reportModel,
                                     'projectString': projectString,
                                     'startTime': startTime,
                                     'endTime': endTime,
                                     'monthFirst': formatter.monthFirst
                                 })
    }

    ListModel {
        id: reportModel
    }

    WorkerScript {
        id: reportWorker
        source: "ReportScript.js"
        onMessage: { totalTextLabel.text = messageObject.elapsed; loading = false }
    }

    WorkerScript {
        id: exportWorker
        source: "ExportScript.js"
        onMessage: {
            var dateString = reportTitle.text
            dateString = dateString.replace(" ", "-")
            dateString = dateString.replace(", ", "-")
            dateString = dateString.replace(" ", "-")
            dateString = dateString.toLowerCase()
            exporter.fileName = "timesheet-report-" + dateString + ".csv"
            exporter.body = messageObject.data
            exporter.share()
            exporting = false
        }
    }


    Component {
        id: reportDelegate

        Item {
            height: 125
            width: reportList.width

            CommonLabel {
                id: nameLabel
                text: project
                font.pixelSize: Const.listItemTitleFont
                anchors {
                    top: parent.top
                    topMargin: comments != "" ? Const.smallMargin : Const.margin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            CommonLabel {
                text: formatter.formatTime(new Date(startTimeUTC)) + " - " +  formatter.formatTime(new Date(endTimeUTC))
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

            CommonLabel {
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

            CommonLabel {
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
        SectionDelegate {}
    }

    Item {
        anchors.fill: parent
        CommonLabel {
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
            topMargin: -5
            bottom: totalText.top
            left: parent.left
            right: parent.right
        }

        section.property: "date"
        section.criteria: ViewSection.FullString

        model: reportModel

        delegate: reportDelegate
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

        CommonLabel {
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

        CommonLabel {
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

    BusyPanel {
        id: busy
        text: "Loading..."

        running: loading
        visible: loading
        anchors {
            top: reportList.top
            bottom: totalText.bottom
            left: parent.left
            right: parent.right
        }
    }

    Image {
        id: background
        width: parent.width
        source: "images/header-bg-165.png"
        fillMode: Image.TileHorizontally

        enabled: !loading

        anchors {
            top: parent.top
            left: parent.left
        }

        CommonLabel {
            id: titleLabel
            text: title
            anchors {
                top: parent.top
                topMargin: Const.margin
                left: parent.left
                leftMargin: Const.margin
                right: parent.right
            }
            font.pixelSize: Const.fontLarge
            color: "white"
            elide: Text.ElideRight
            maximumLineCount: 1
        }


        Button {
            id: reportTitle
            platformStyle: myStyle
            width: 315
            text: Reports.getTitle(typeDialog.selected)

            font {
                pixelSize: Const.fontMedium
            }

            anchors {
                top: titleLabel.bottom
                topMargin: Const.margin
                horizontalCenter: parent.horizontalCenter
            }

            Image {
                source: "images/triangle.png"
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: 10
                }
            }

            onClicked: typeDialog.open()
        }

        ButtonStyle {
            id: myStyle
            background: "image://theme/meegotouch-button-background-disabled"
            textColor: "white"
            disabledTextColor: "orange"
        }

        ButtonStyle {
            id: iconStyle
            background: ""
            disabledBackground: ""
        }

        Button {
            id: leftButton
            platformStyle: iconStyle
            iconSource: "images/previousButton.png"
            visible: typeDialog.selected != "all"
            anchors {
                verticalCenter: reportTitle.verticalCenter
                right: reportTitle.left
                rightMargin: Const.margin
            }
            opacity: enabled ? 1 : 0.7
            width: 48
            height: 48
            onClicked: {
                Reports.setPreviousPeriod(typeDialog.selected)
                update()
            }
        }

        Button {
            id: rightButton
            platformStyle: iconStyle
            visible: typeDialog.selected != "all"
            iconSource: "images/nextButton.png"
            anchors {
                verticalCenter: reportTitle.verticalCenter
                left: reportTitle.right
                leftMargin: Const.margin
            }
            opacity: enabled ? 1 : 0.7
            width: 48
            height: 48
            onClicked: {
                Reports.setNextPeriod(typeDialog.selected)
                update()
            }
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
            }
            else {
                reportList.section.delegate = sectionDelegate
            }
            update()
        }
    }

    Exporter {
        id: exporter
        folderName: "Timesheet"
        mimeType: "text/plain"

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
            id: sharingButton
            platformIconId: enabled ? "toolbar-share" : "toolbar-share-dimmed"
            iconSource: exporting ? "images/empty.png" : ""

            enabled: (reportModel.count != 0) && !exporting

            onClicked: {
                exporting = true
                exportWorker.sendMessage({ 'model': reportModel })
            }

            BusyIndicator {
                anchors.centerIn: sharingButton
                running: exporting
                visible: exporting
            }

        }
    }

    MultiSelectionDialog {
        id: projectSelectionDialog
        titleText: qsTr("Select Projects")
        model: ListModel {}

        function updateProjects()
        {
            Reports.getProjectList(projectSelectionDialog.model)
        }

        onSelectedIndexesChanged: {
            if (selectedIndexes.indexOf(0) !== -1) { // handles the "all projects" item
                selectedIndexes = []
                accept()
            }
        }

        Component.onCompleted: updateProjects()

        acceptButtonText: qsTr("OK")

        onAccepted: reportsPage.update()
    }

}
