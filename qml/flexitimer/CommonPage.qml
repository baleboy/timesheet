import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const

Page {

    id: commonPage

    property alias title: titleLabel.text
    property int headerHeight: Const.headerHeight

    orientationLock: PageOrientation.LockPortrait

    Rectangle {

        id: header
        height: commonPage.headerHeight
        width: parent.width
        anchors {
            top: parent.top
        }
        color: "orange"

        Label {
            id: titleLabel
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Const.margin
                right: parent.right
            }
            font.pixelSize: Const.fontLarge
            font.family: "Nokia Pure Text Light"
            color: "white"
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }
}
