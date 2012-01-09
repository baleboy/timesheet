import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    width: arrow.width
    height: arrow.height

    Label {
        id: arrow
        text: ">"
        font.pixelSize: 28
        color: "gray"
        anchors.centerIn: parent
    }
}
