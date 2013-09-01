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
import "Projects.js" as Projects
import "UiConstants.js" as Const

Dialog {
    id: root

    property alias titleText: titleLabel.text
    property alias inputText: projectNameInput.text
    property string initialText

    title: CommonLabel {
        id: titleLabel;
        color: "white";
        font.pixelSize: Const.fontDialog
    }

    content:Item {
        id: name
        height: 140
        width: parent.width
        TextField {
            id: projectNameInput
            placeholderText: qsTr("Project name")
            anchors.centerIn: parent
            width: 300
        }
    }
    buttons: Button {
        platformStyle: ButtonStyle { inverted: true }
        text: qsTr("OK")
        width: Const.mediumButtonWidth
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: root.accept()
    }

    onStatusChanged: if (status === DialogStatus.Opening) {
                         projectNameInput.text = initialText
                         projectNameInput.focus = true
                     }
}

