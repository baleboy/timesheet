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
Item {
    id: root
    property bool checked
    signal clicked

    width: image1.width
    height: image1.height

    Image {
        id: image1
        visible: !checked
        anchors.centerIn: parent

        source: "images/orange-button.png"
    }
    Image {
        id: image2
        visible: checked
        anchors.centerIn: parent

        source: "images/cyan-button.png"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
