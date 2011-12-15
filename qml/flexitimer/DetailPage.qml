import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const

CommonPage {

    property alias model: listView.model

    ListView {
        id: listView

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
            height: 85
            width: parent.width
            Row {
                anchors.fill: parent
                anchors.margins: Const.margin
                spacing: Const.margin

                Label {
                    text: startTime
                }
                Label {
                    text: endTime
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
}
