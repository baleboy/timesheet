import QtQuick 1.1
import com.nokia.meego 1.0
import "Db.js" as Db
import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Projects.js" as Projects

Item {

    id: projectsPage

    anchors.fill: parent
    property int todaysTotal

    function update()
    {
        Projects.populate()
        todaysTotal = Db.todaysTotal()
    }

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
            text: Utils.toTime(todaysTotal + (projectList.inProgress !== "" ? workTimer.elapsed : 0))
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

    ContextMenu {
        id: projectMenu
        property int projectIndex
        property string projectName

        MenuLayout {
            MenuItem {text: qsTr("Delete"); onClicked: deleteProjectDialog.open() }
        }
    }

    QueryDialog {

        id: deleteProjectDialog
        titleText: qsTr("Delete Project")
        message:qsTr("Do you want to delete project " +
                      projectMenu.projectName + " and all its related data?")
        acceptButtonText: qsTr("Yes")
        rejectButtonText: qsTr("No")
        onAccepted: Projects.deleteProject(projectMenu.projectName, projectMenu.projectIndex)
    }

    Component.onCompleted: {
        update()
        Projects.restoreOngoingSession()
        // workTimer.initialize()
    }
}
