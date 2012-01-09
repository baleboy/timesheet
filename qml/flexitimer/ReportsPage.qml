import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const
import "Reports.js" as Reports
import "Utils.js" as Utils

CommonPage {

    title: qsTr("Reports")

    Label {
        id: reportTitle
        text: qsTr("All Time")

        font {
            pixelSize: Const.fontLarge
        }

        anchors {
            top: parent.top
            topMargin: Const.headerHeight + Const.margin
            horizontalCenter: parent.horizontalCenter
        }
    }

    ListModel {
        id: reportModel
    }

    Component.onCompleted: Reports.populateReportsModel()


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

    tools: ToolBarLayout {

        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
    }
}
