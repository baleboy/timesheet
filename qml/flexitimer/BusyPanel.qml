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

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const

Rectangle {
    id: root
    color: "lightgrey"

    property alias text: text.text
    property alias running: spinner.running

    Item {
        anchors.centerIn: parent
        width: spinner.width + text.width + Const.smallMargin
        height: Math.max(spinner.height, text.height)

        BusyIndicator {
            id: spinner
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }
        CommonLabel {
            id: text
            anchors {
                left: spinner.right
                leftMargin: Const.margin
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
