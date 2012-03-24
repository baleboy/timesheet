import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const

Page {

    id: commonPage

    property alias title: titleLabel.text
    property int headerHeight: Const.headerHeight

    orientationLock: PageOrientation.LockPortrait

    Image {

        id: header
        width: parent.width
        z: 10
        anchors {
            top: parent.top
        }
        source: "images/header-bg-77.png"
        fillMode: Image.TileHorizontally

        CommonLabel {
            id: titleLabel
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
    }
}
