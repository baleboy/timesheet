import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const
import "Db.js" as Db

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    property string inProgress
    property int inProgressIndex
    property double todaysTotal

    function stopCurrentProject()
    {
        workTimer.stopTimer()

        var elapsedToday = projectsModel.get(inProgressIndex).elapsedToday
        var elapsedTotal = projectsModel.get(inProgressIndex).elapsedTotal

        console.log("Project stopped. Elapsed: " + workTimer.elapsed + " todaysTotal: " + elapsedToday)
        Db.addProjectEnd()
        Db.saveElapsed(inProgress, workTimer.elapsed)
        projectsModel.setProperty(inProgressIndex,
                                  "elapsedToday",
                                  elapsedToday + workTimer.elapsed)
        projectsModel.setProperty(inProgressIndex,
                                  "elapsedTotal",
                                  elapsedTotal + workTimer.elapsed)
        todaysTotal += workTimer.elapsed
        inProgress = ""
        Db.setProperty("projectInProgress", "")
    }

    function startProject(name, index)
    {
        if (inProgress !== "") {
            // previous task stopped implicitly
            appWindow.stopCurrentProject()
        }
        inProgress = name
        inProgressIndex = index
        var recordId = Db.addProjectStart(name)
        workTimer.startTimer()
        Db.setProperty("projectInProgress", inProgress)
        return recordId
    }

    MainPage {
        id: mainPage
    }

    DetailPage {
        id: detailPage
    }

    Component {
        id: reportsPage
        ReportsPage {}
    }

    Component {
        id: editSessionPage
        EditSessionPage {}
    }

    ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            platformIconId: "toolbar-add"
            onClicked: addProjectDialog.open()
        }

        ToolIcon {
            iconSource: "images/document-icon.png"
            onClicked: pageStack.push(reportsPage)
            scale: 0.6
            smooth: true
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Clear data")
                onClicked: { Db.clearAll(); projectsModel.clear() }
            }
            MenuItem {
                text: qsTr("Print all")
                onClicked: { Db.printAll() }
            }
        }
    }

    AddProjectDialog {
        id: addProjectDialog
    }

    /* Dialog {
      id: addProjectDialog
      title: Label { color: "white"; text: qsTr("Add Project")}

      content:Item {
        id: name
        height: 140
        width: parent.width
        TextField {
            id: projectNameInput
            placeholderText: qsTr("Project name")
            anchors.centerIn: parent
        }
      }
      buttons: Button {
          platformStyle: ButtonStyle { inverted: true }
          text: qsTr("OK")
          width: Const.mediumButtonWidth
          anchors.horizontalCenter: parent.horizontalCenter
          onClicked: addProjectDialog.accept()
      }
      onAccepted: if (projectNameInput.text != "") {
                      projectsModel.append({"name": projectNameInput.text,
                                          "elapsedTotal": 0,
                                          "elapsedToday": 0})
                      Db.addProject(projectNameInput.text)
                  }
      onStatusChanged: if (status === DialogStatus.Opening)
                           projectNameInput.text = ""
    } */
    ListModel {
        id: projectsModel
    }

    ListModel {
        id: detailsModel
    }

    BackgroundTimer {
        id: workTimer
    }
}
