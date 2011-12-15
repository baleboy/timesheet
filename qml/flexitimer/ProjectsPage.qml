import QtQuick 1.1
import com.nokia.meego 1.0

ListView {

    id: projectList
    property int pressed: -1

    anchors {
        top: parent.top
        topMargin: headerHeight
        bottom: parent.bottom
        left: parent.left
        right: parent.right
    }
    clip: true

    model: projectsModel

    delegate: ProjectDelegate {}
}
