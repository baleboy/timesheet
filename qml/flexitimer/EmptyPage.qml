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

Item {

    Column {
        id: column1
        spacing: Const.spacing
        anchors.centerIn: parent

        CommonLabel {
            id: label1
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("No Projects")
            font.pixelSize: Const.fontLarge
            color: "gray"
        }

        CommonLabel {
            id: label2
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Add a project to start tracking")
            font.pixelSize: Const.fontMedium
            color: "gray"
        }

        Button {
            id: button1
            anchors.horizontalCenter: parent.horizontalCenter
            width: Const.mediumButtonWidth
            text: qsTr("Add project")
            onClicked: addProjectDialog.open()
        }

    }
}

