// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const

Rectangle {
    id: root
    color: "lightgrey"

    property alias text: text.text
    property alias running: spinner.running

    Item {
        anchors.centerIn: parent
        width: spinner.width + text.width + Const.smallMargin
        height: Math.max(spinner.height, text.height)

        BusyIndicator {
            id: spinner
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }
        CommonLabel {
            id: text
            anchors {
                left: spinner.right
                leftMargin: Const.margin
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
