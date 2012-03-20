import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import Formatter 1.0

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
        var recordId = Db.addProjectStart(name)
        workTimer.startTimer()
        Db.setProperty("projectInProgress", inProgress)
        if (index !== 0) mainPage.move(index, 0)
        inProgressIndex = 0
        // projectsList.positionAtBeginning()
        return recordId
    }

    MainPage {
        id: mainPage
    }

    DetailPage {
        id: detailPage
    }

    ReportsPage {
        id: reportsPage
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
                text: qsTr("Delete All")
                onClicked: { eraseDialog.open() }
            }
            MenuItem {
                text: qsTr("Recreate DB")
                onClicked: { Db.recreate(); projectsModel.clear() }
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

    ListModel {
        id: projectsModel
    }

    ListModel {
        id: detailsModel
    }

    BackgroundTimer {
        id: workTimer
    }

    QueryDialog {
        id: eraseDialog
        acceptButtonText :qsTr("OK")
        rejectButtonText: qsTr("Cancel")
        titleText: qsTr("Erase all data")
        message: qsTr("Do you really want to erase all the data?")
        onAccepted: { Db.clearAll() ; mainPage.update() }
    }

    InfoBanner {
        id: errorBanner
        topMargin: 40.0
        iconSource: "images/banner-error.png"
    }

    Formatter {
        id: formatter
        onLocaleChanged: {
            mainPage.update()
            detailPage.update()
            reportsPage.update()
        }
    }

    Connections {
        target: platformWindow
        onActiveChanged: {
            if (inProgress != "") {
                if (platformWindow.active) {
                    console.log("resuming timer")
                    workTimer.resumeTimer()
                }
                else {
                    console.log("pausing timer")
                    workTimer.pauseTimer()
                }
            }
        }
    }

}
