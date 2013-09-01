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
import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

Page {
    id: projectPage
    tools: commonTools
    property string title: today()

    orientationLock: PageOrientation.LockPortrait

    function update()
    {
        var t = today()
        if (title !== t) title = t // day change
        projectListPage.update()
    }

    function today() {
        var now = new Date()
        return formatter.formatDateLong(now)
    }

    function checkDate()
    {
        var t = today()
        if (title != t) {
            title = t
            projectListPage.update()
        }
    }

    function move(index1, index2)
    {
        projectListPage.move(index1, index2)
    }

    EmptyPage {
        visible: projectsModel.count == 0
        anchors {
            top: header.bottom
            topMargin: -5
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    ProjectsPage {
        id: projectListPage
        visible: projectsModel.count != 0
        anchors {
            top: header.bottom
            topMargin: -5
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    Image {
        id: header
        source: "images/header-bg.png"
        width: parent.width
        fillMode: Image.TileHorizontally

        CommonLabel {
            id: titleLabel
            text: title
            font.pixelSize: Const.fontLarge
            color: "white"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: Const.margin
            }
        }

        CommonLabel {
            font.pixelSize: Const.fontHuge
            font.weight: Font.Bold
            text: projectListPage.daysTotalText
            color: "white"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: titleLabel.bottom
                topMargin: Const.smallMargin
            }
        }

    }

}
