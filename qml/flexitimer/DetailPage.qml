import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0

import "UiConstants.js" as Const
import "Details.js" as Details
import "Utils.js" as Utils

CommonPage {

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
        Label {
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

        section.delegate: Rectangle {
            width: parent.width
            height: 48
            color: "lightGray"

            Label {
                text: section
                font.bold: true
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 8
                }
            }
        }
    }

    tools: DefaultToolbar {

        ToolIcon {
            iconId: project == inProgress ? "toolbar-mediacontrol-pause" :
                                            "toolbar-mediacontrol-play"

            onClicked: project == inProgress ? stopAction() : startAction()

            function startAction() {
                var recordId = appWindow.startProject(project, projectIndex)
                var now = new Date
                detailsModel.insert(0, {
                                        startTime: Qt.formatTime(now, "hh:mm"),
                                        endTime: "",
                                        elapsed: "",
                                        date: Qt.formatDate(now, "dddd, MMMM dd yyyy"),
                                        recordId: recordId,
                                        comments: ""
                                    })

            }

            function stopAction() {
                appWindow.stopCurrentProject()
                detailsModel.setProperty(0, "endTime", Qt.formatDateTime(new Date, "hh:mm"))
                detailsModel.setProperty(0, "elapsed", Utils.toTime(workTimer.elapsed))
                mainPage.update()
            }
        }

        /*
        Button {
            id: startButton
            style: PositiveButtonStyle {}
            text: qsTr("Start")
            width: Const.mediumButtonWidth
            visible: project !== inProgress

            anchors.centerIn: parent

            onClicked: {
                var recordId = appWindow.startProject(project, projectIndex)
                var now = new Date
                detailsModel.insert(0, {
                                        startTime: Qt.formatTime(now, "hh:mm"),
                                        endTime: "",
                                        elapsed: "",
                                        date: Qt.formatDate(now, "dddd, MMMM dd yyyy"),
                                        recordId: recordId,
                                        comments: ""
                                    })
            }
        }

        Button {
            id: stopButton
            style: NegativeButtonStyle {}
            text: qsTr("Stop")
            width: startButton.width
            visible: project === inProgress
            anchors.centerIn: startButton
            onClicked: {
                appWindow.stopCurrentProject()
                detailsModel.setProperty(0, "endTime", Qt.formatDateTime(new Date, "hh:mm"))
                detailsModel.setProperty(0, "elapsed", Utils.toTime(workTimer.elapsed))
                mainPage.update()
            }
        }
*/

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
                onClicked: deleteSessionDialog.open() }
        }
    }

    QueryDialog {

        id: deleteSessionDialog
        titleText: qsTr("Delete Session")
        message:qsTr("Do you want to delete this session?")
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
