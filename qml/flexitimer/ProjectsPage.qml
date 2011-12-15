import QtQuick 1.1
import com.nokia.meego 1.0
import "Db.js" as Db

ListView {

    id: projectList
    property string inProgress: Db.getProperty("projectInProgress")
    property int lastId: -1
    property int nextId: 1

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
