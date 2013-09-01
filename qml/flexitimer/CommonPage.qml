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

Page {

    id: commonPage

    property alias title: titleLabel.text
    property int headerHeight: Const.headerHeight

    orientationLock: PageOrientation.LockPortrait

    Image {

        id: header
        width: parent.width
        z: 10
        anchors {
            top: parent.top
        }
        source: "images/header-bg-77.png"
        fillMode: Image.TileHorizontally

        CommonLabel {
            id: titleLabel
            anchors {
                top: parent.top
                topMargin: Const.margin
                left: parent.left
                leftMargin: Const.margin
                right: parent.right
            }
            font.pixelSize: Const.fontLarge
            color: "white"
            elide: Text.ElideRight
            maximumLineCount: 1
        }
    }
}
