import QtQuick 1.1

Rectangle {
    width: parent.width
    height: 40
    color: "lightGrey"

    CommonLabel {
        text: section
        font.bold: true
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 8
        }
    }
}
