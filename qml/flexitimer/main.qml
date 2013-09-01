/*

Copyright (C) 2012 Francesco Balestrieri

This file is part of Timesheet for N9

Timesheet for N9 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Timesheet for N9 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Timesheet for N9.  If not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import Formatter 1.0

import "UiConstants.js" as Const
import "Db.js" as Db
import "StressTest.js" as Test

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
            onClicked: { reportsPage.update(); pageStack.push(reportsPage) }
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
                text: qsTr("About")
                onClicked: { aboutDialog.open() }
            }
            /* Uncomment for performance tests
            MenuItem {
                text: qsTr("Create Test Data")
                onClicked: { Test.createData() }
            }
            */

        }
    }

    AboutDialog {
        id: aboutDialog
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
        onAccepted: { Db.clearAll() ; mainPage.update(); reportsPage.updateProjectsDialog() }
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
        onVisibleChanged: {
            mainPage.checkDate()
            if (inProgress != "") {
                if (platformWindow.visible) {
                    workTimer.resumeTimer()
                }
                else {
                    workTimer.pauseTimer()
                }
            }
        }
    }

}
