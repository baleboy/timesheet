import QtQuick 1.1
import Qt.labs.gestures 1.0

import com.nokia.meego 1.0
import "Constants.js" as Const
import "Reports.js" as Reports
import "Utils.js" as Utils

CommonPage {

    title: qsTr("Reports")
    property date startTime: new Date(0)
    property date endTime: new Date()

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
                text: name
                font.pixelSize: Const.fontMedium
                anchors {
                    top: parent.top
                    topMargin: Const.margin
                    left: parent.left
                    leftMargin: Const.margin
                }
            }

            Label {
                id: timeLabel
                text: Utils.toTime(elapsedTotal)
                color: "gray"
                font.pixelSize: Const.fontMedium
                anchors {
                    bottom: parent.bottom
                    bottomMargin: Const.margin
                    left: nameLabel.left
                }
            }

            MoreIndicator {
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                    rightMargin: Const.margin
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

        model: reportModel

        delegate: reportDelegate
    }

    SelectionDialog {
        id: typeDialog
        titleText: "Report Type"
        selectedIndex: 0

        property int selected: model.get(selectedIndex).type

        model: ListModel {
            // unfortunately I can't use the constants from Reports.js
            // in ListElement, see QTBUG-16289
            ListElement { name: "All Time"; type: 0 }
            ListElement { name: "Month"; type: 1 }
            ListElement { name: "Week"; type: 2 }
            ListElement { name: "Day"; type: 3 }
        }

        onSelectedIndexChanged: {
            console.log("index changed")
            if (selected == Reports.reportTypeDay) {
                var now = new Date
                startTime = Utils.dayStart(now)
                endTime = Utils.dayEnd(now)
                Reports.populateReportsModel(startTime, endTime)
            }
        }
    }

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }
}
