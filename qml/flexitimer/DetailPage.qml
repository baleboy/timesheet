import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

import "UiConstants.js" as Const
import "Details.js" as Details
import "Utils.js" as Utils

CommonPage {

    id: root

    property alias model: detailsList.model

    property date startTime
    property date endTime
    property string project
    property int projectIndex

    function update()
    {
        Details.populateProjectDetails()
    }

    Item {
        anchors.fill: parent
        CommonLabel {
            font.pixelSize: Const.fontLarge
            color: "gray"
            anchors.centerIn: parent
            text: qsTr("No sessions")

            visible: model.count === 0
        }
    }

    ListView {
        id: detailsList
        visible: model.count > 0
        model: detailsModel
        currentIndex: -1

        anchors {
            top: parent.top
            topMargin: headerHeight
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        section.property: "date"
        section.criteria: ViewSection.FullString

        clip: true

        delegate: DetailsDelegate {}

        section.delegate: SectionDelegate {}
    }

    SectionScroller {
        listView: detailsList
    }

    ScrollDecorator {
        flickableItem: detailsList
    }

    tools: DefaultToolbar {

        ToolButton {
            text: project == inProgress ? qsTr("Stop") : qsTr("Start")

            onClicked: project == inProgress ? stopAction() : startAction()

            function startAction() {
                var recordId = appWindow.startProject(project, projectIndex)
                var now = new Date
                detailsModel.insert(0, {
                                        startTime: formatter.formatTime(now), //Qt.formatTime(now),
                                        endTime: "",
                                        elapsed: "",
                                        date: formatter.formatDateFull(now),
                                        recordId: recordId,
                                        comments: ""
                                    })

            }

            function stopAction() {
                appWindow.stopCurrentProject()
                var now = new Date()
                detailsModel.setProperty(0, "endTime", formatter.formatTime(now)) // Qt.formatTime(now))
                detailsModel.setProperty(0, "elapsed", Utils.toTime(workTimer.elapsed))
                mainPage.update()
            }
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: (detailsMenu.status == DialogStatus.Closed) ? detailsMenu.open() : detailsMenu.close()
        }
    }

    Menu {
        id: detailsMenu
        visualParent: pageStack
        MenuLayout {

            MenuItem {
                text: qsTr("Create Session")
                onClicked: {
                    sessionSheet.inProgress = false
                    sessionSheet.newRecord = true
                    sessionSheet.projectName = root.project
                    sessionSheet.open()
                }
            }

            MenuItem {
                text: qsTr("Delete All")
                onClicked: { deleteAllSessionsDialog.open() }
            }
        }
    }

    QueryDialog {
        id: deleteAllSessionsDialog
        titleText: qsTr("Delete sessions")
        message: qsTr("Delete all sessions for project <b>%1</b>?").arg(project)
        acceptButtonText: qsTr("Ok")
        rejectButtonText: qsTr("Cancel")
        onAccepted: Details.deleteAll(project)
    }


    SessionSheet {
        id: sessionSheet
    }

    ContextMenu {
        id: sessionMenu
        property alias deleteEnabled: deleteMenuItem.enabled
        property int sessionIndex
        property double recordId

        MenuLayout {
            MenuItem {
                id: deleteMenuItem
                text: qsTr("Delete");
                onClicked: {
                    deleteSessionDialog.date = detailsModel.get(sessionMenu.sessionIndex).date
                    deleteSessionDialog.start = detailsModel.get(sessionMenu.sessionIndex).startTime
                    deleteSessionDialog.end = detailsModel.get(sessionMenu.sessionIndex).endTime
                    deleteSessionDialog.open()
                }
            }
        }
    }

    QueryDialog {

        id: deleteSessionDialog
        property string date
        property string start
        property string end

        titleText: qsTr("Delete Session")
        message:qsTr("<b>%1</b><br/>From %2 to %3<br/><br/>Do you want to delete this session?")
        .arg(date).arg(start).arg(end)
        acceptButtonText: qsTr("Yes")
        rejectButtonText: qsTr("No")
        onAccepted: {
            Details.deleteRecord(project,
                                 sessionMenu.recordId,
                                 sessionMenu.sessionIndex)
            mainPage.update()
        }
    }

}
