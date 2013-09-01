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
import "UiConstants.js" as Const
import "Details.js" as Details
import "Projects.js" as Projects
import "Utils.js" as Utils

Sheet {
    id: root

    property double recordId
    property double startTimeUTC
    property double endTimeUTC
    property bool inProgress
    property bool dirty: false
    property bool newRecord: true
    property string projectName

    function formatDate(utc) {
        var d = new Date
        d.setTime(utc)
        return formatter.formatDateTime(d)
    }

    SheetButtonAccentStyle {
        id: themedStyle
        property int themeColor: 15
        property string colorString: "color" + themeColor + "-"

        background: "image://theme/" + colorString + "meegotouch-sheet-button-accent-background"
        pressedBackground: "image://theme/" + colorString + "meegotouch-sheet-button-accent-background-pressed"
        disabledBackground: "image://theme/" + colorString + "meegotouch-sheet-button-accent-background-disabled"
    }

    buttons: Item {
        anchors.fill: parent

        SheetButton {
            id: rejectButton
            text: qsTr("Cancel")
            onClicked: root.reject()

            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: Const.margin
            }
        }


        SheetButton {
            id: acceptButton
            text: qsTr("Save")
            enabled: root.dirty
            onClicked: root.accept()

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: Const.margin
            }
            platformStyle: themedStyle
        }

    }

    content: Item {
        anchors.fill: parent
        Grid {
            id: grid1
            columns: 2
            rows: 3
            spacing: 15

            anchors {
                top: parent.top
                topMargin: Const.margin
                horizontalCenter: parent.horizontalCenter
            }

            CommonLabel {
                text: qsTr("Start: ")
                font.pixelSize: Const.fontMedium
            }

            TumblerButton {
                id: startSelector
                text: formatDate(startTimeUTC)
                width: 300
                onClicked: { startPicker.open() ; startPicker.setUtcTime(startTimeUTC); }
            }

            CommonLabel {
                text: qsTr("End: ")
                font.pixelSize: Const.fontMedium
            }

            TumblerButton {
                id: endSelector
                text: inProgress ? qsTr("In progress") : formatDate(endTimeUTC)
                width: startSelector.width
                enabled: !inProgress
                onClicked: { endPicker.open() ; endPicker.setUtcTime(endTimeUTC) }
            }

            CommonLabel {
                text: qsTr("Duration: ")
                font.pixelSize: Const.fontMedium
            }

            TumblerButton {
                id: durationSelector
                text: inProgress ? Utils.toTimeWithSeconds((new Date()).getTime() - startTimeUTC) :
                                   Utils.toTimeWithSeconds(endTimeUTC - startTimeUTC)
                width: startSelector.width
                enabled: !inProgress
                onClicked: { durationPicker.open() }
            }

        }

        CommonLabel {
            id: label1
            text: qsTr("Comments")
            font.pixelSize: Const.fontMedium

            anchors {
                top: grid1.bottom
                topMargin: Const.bigMargin
                left: grid1.left
            }
        }

        TextArea {
            id: text1
            placeholderText: qsTr("Enter comments")
            anchors {
                top: label1.bottom
                topMargin: Const.margin
                left: grid1.left
                right: grid1.right
                bottom: parent.bottom
                bottomMargin: Const.bigMargin
            }
            onActiveFocusChanged: {
                if (!activeFocus)
                {
                    // the following line is needed to ensure
                    // that the last word of the input text is
                    // taken in consideration (it makes the pre-edit buffer
                    // to be copied to the actual buffer)
                    // For reference see https://bugs.meego.com/show_bug.cgi?id=21748
                    // 'inputContext' is a C++ object exposed by Qt components
                    inputContext.reset()
                }
                dirty = true
            }
        }
    }

    DateTimePicker {
        id: startPicker

        onPicked: {
            if (((startPicker.toDateTimeUTC() < endTimeUTC) && !inProgress) ||
                    ((startPicker.toDateTimeUTC() < new Date) && inProgress)) {

                startTimeUTC = startPicker.toDateTimeUTC()

                if (inProgress) {
                    workTimer.setStartTime(startTimeUTC)
                }
                dirty = true;
            }
            else {
                errorBanner.text = qsTr("Start time must be earlier than end time")
                errorBanner.show()
            }
        }

    }

    DateTimePicker {
        id: endPicker

        onPicked: {
            if (endPicker.toDateTimeUTC() > startTimeUTC) {

                endTimeUTC = endPicker.toDateTimeUTC()
                dirty = true;
            }
            else {
                errorBanner.text = qsTr("End time must be later than start time")
                errorBanner.show()
            }
        }

    }

    TimePickerDialog {
        id: durationPicker

        property int delta: hour * 3600000 + minute * 60000 + second * 1000

        function setDuration()
        {
            var delta = endTimeUTC - startTimeUTC
            durationPicker.hour = Math.floor(delta / 3600000)
            durationPicker.minute = Math.floor((delta % 3600000) / 60000)
            durationPicker.second = Math.floor((delta % 60000) / 1000)
        }

        titleText: qsTr("Select Duration")
        hourMode: DateTime.TwentyFourHours
        fields: DateTime.Hours | DateTime.Minutes | DateTime.Seconds

        onStatusChanged: if (status == DialogStatus.Opening) durationPicker.setDuration()

        onAccepted: { endTimeUTC = startTimeUTC + durationPicker.delta ; dirty = true}
    }

    // dialog opens
    onStatusChanged: if (status === DialogStatus.Opening) {
                         dirty = newRecord
                         if (newRecord) {
                             // create new session of 1hr duration
                             // ending at the current time
                             var t = new Date()
                             recordId = t.getTime()
                             endTimeUTC = t.getTime()
                             t.setHours(t.getHours() - 1)
                             startTimeUTC = t.getTime()
                         }
                         else {
                             Details.populateEditSessionPage();
                         }
                     }

    onAccepted: {

        if (dirty) {
            if (newRecord) {
                Details.addRecord(recordId, root.projectName, startTimeUTC, endTimeUTC, text1.text)
            }
            else {
                if (!inProgress)
                    Details.updateRecord(recordId, startTimeUTC, text1.text, endTimeUTC)
                else
                    Details.updateRecord(recordId, startTimeUTC, text1.text)
            }
            mainPage.update()
            detailPage.update()
        }
    }
}

