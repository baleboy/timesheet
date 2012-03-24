import QtQuick 1.1
import com.nokia.meego 1.0
import "Db.js" as Db
import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Projects.js" as Projects

Item {

    id: projectsPage

    property string daysTotalText: Utils.toTime(todaysTotal + (inProgress !== "" ? workTimer.elapsed : 0))

    function update()
    {
        Projects.populate()
        var now = new Date();
        todaysTotal = Projects.totalWork(Utils.dayStart(now), Utils.dayEnd(now))
    }

    function move(index1, index2)
    {
        var project = projectsModel.get(index1).name
        var etoday = projectsModel.get(index1).elapsedToday
        var etotal = projectsModel.get(index1).elapsedTotal

        projectsModel.remove(index1)
        projectList.positionViewAtBeginning()
        projectsModel.insert(index2, { "name": project, "elapsedToday": etoday, "elapsedTotal": etotal})

    }

    ListView {

        id: projectList
        currentIndex: -1

        anchors {
            top: parent.top
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
            MenuItem {text: qsTr("Rename"); onClicked: renameProjectDialog.open() }
            MenuItem {text: qsTr("Delete"); onClicked: deleteProjectDialog.open() }
        }
    }

    QueryDialog {

        id: deleteProjectDialog
        titleText: qsTr("Delete Project")
        message:qsTr("Do you want to delete project <b>" +
                      projectMenu.projectName + "</b> and all its related data?")
        acceptButtonText: qsTr("Yes")
        rejectButtonText: qsTr("No")
        onAccepted: Projects.deleteProject(projectMenu.projectName, projectMenu.projectIndex)
    }

    RenameProjectDialog {
        id: renameProjectDialog
        index: projectMenu.projectIndex
        oldName: projectMenu.projectName
    }

    Component.onCompleted: {
        update()
        Projects.restoreOngoingSession()
    }
}
