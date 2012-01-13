import QtQuick 1.1
import com.nokia.meego 1.0
import "Db.js" as Db
import "Constants.js" as Const
import "Utils.js" as Utils
import "Projects.js" as Projects

Item {

    id: projectsPage

    anchors.fill: parent
    property int todaysTotal

    Rectangle {

        id: rect1
        color: "orange"
        width: parent.width
        height: 90
        anchors {
            top: parent.top
            topMargin: Const.headerHeight
        }

        Label {
            font.pixelSize: Const.fontHuge
            text: Utils.toTime(todaysTotal)
            anchors.centerIn: parent
            color: "white"
        }
    }

    ListView {

        id: projectList
        property string inProgress
        property int inProgressIndex

        anchors {
            top: rect1.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        clip: true

        model: projectsModel

        delegate: ProjectDelegate {}

    }

    BackgroundTimer {
        id: workTimer
        onTick: {
            todaysTotal += workTimer.delta
            var t = parseFloat(projectList.model.get(projectList.inProgressIndex).elapsedToday) + workTimer.delta
            console.log("elapsed today: " + t)
            projectList.model.setProperty(projectList.inProgressIndex, "elapsedToday", t)
            t = parseFloat(projectList.model.get(projectList.inProgressIndex).elapsedTotal) + workTimer.delta
            console.log("elapsed total: " + t)
            projectList.model.setProperty(projectList.inProgressIndex, "elapsedTotal", t)
        }
    }

    Component.onCompleted: {
        Projects.populate()
        Projects.restoreOngoingSession()
        todaysTotal = Db.todaysTotal()
        workTimer.initialize()
    }
}
