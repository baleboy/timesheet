import QtQuick 1.1
import com.nokia.meego 1.0
import "Db.js" as Db
import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Projects.js" as Projects

Item {

    id: projectsPage

    anchors.fill: parent
    // property int todaysTotal

    function update()
    {
        Projects.populate()
        todaysTotal = Db.todaysTotal()
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
            font.weight: Font.Bold
            text: Utils.toTime(todaysTotal + (inProgress !== "" ? workTimer.elapsed : 0))
            anchors.centerIn: parent
            color: "white"
        }
    }

    ListView {

        id: projectList
        currentIndex: -1

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
            MenuItem {text: qsTr("Rename"); onClicked: renameProjectDialog.open() }
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

    RenameProjectDialog {
        id: renameProjectDialog
        index: projectMenu.projectIndex
        oldName: projectMenu.projectName
    }

    Component.onCompleted: {
        update()
        Projects.restoreOngoingSession()
        // workTimer.initialize()
    }
}
