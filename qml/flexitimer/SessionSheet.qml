import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "UiConstants.js" as Const
import "Details.js" as Details
import "Projects.js" as Projects

Sheet {
    id: root

    acceptButtonText: qsTr("Save")
    rejectButtonText: qsTr("Cancel")

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

            Label {
                text: qsTr("Start: ")
                font.pixelSize: Const.fontLarge
            }

            TumblerButton {
                id: startSelector
                text: formatDate(startTimeUTC)
                width: 300
                onClicked: { startPicker.setUtcTime(startTimeUTC); startPicker.open() }
            }

            Label {
                text: qsTr("End: ")
                font.pixelSize: Const.fontLarge
            }

            TumblerButton {
                id: endSelector
                text: inProgress ? qsTr("In progress") : formatDate(endTimeUTC)
                width: startSelector.width
                enabled: !inProgress
                onClicked: { endPicker.setUtcTime(endTimeUTC); endPicker.open() }
            }
        }

        Label {
            id: label1
            text: qsTr("Comments")
            font.pixelSize: Const.fontLarge

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
            onActiveFocusChanged: if (!activeFocus)
                                  {
                                      // the following line is needed to ensure
                                      // that the last word of the input text is
                                      // taken in consideration (it makes the pre-edit buffer
                                      // to be copied to the actual buffer)
                                      // For reference see https://bugs.meego.com/show_bug.cgi?id=21748
                                      // 'inputContext' is a C++ object exposed by Qt components
                                      inputContext.reset()
                                      dirty = true;
                                  }
        }
    }

    DateTimePicker {
        id: startPicker

        onPicked: {
            if (((startPicker.toDateTimeUTC() < endTimeUTC) && !inProgress) ||
                    ((startPicker.toDateTimeUTC() < new Date) && inProgress)) {

                startTimeUTC = startPicker.toDateTimeUTC()
                // Details.saveStartTime(recordId, startTimeUTC)

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

    // dialog opens
    onStatusChanged: if (status === DialogStatus.Opening) {
                         console.log("opening. Project: " + root.projectName)
                         dirty = newRecord
                         if (newRecord) {
                             var t = new Date()
                             recordId = t.getTime()
                             startTimeUTC = t.getTime()
                             t.setHours(t.getHours() + 1)
                             endTimeUTC = t.getTime()
                         }
                         else {
                             Details.populateEditSessionPage();
                             console.log("updated. Projcect: " + root.projectName)
                         }
                     }

    onAccepted: {

        if (dirty) {
            if (newRecord) {
                console.log("creating: project " + root.projectName )
                Details.addRecord(recordId, root.projectName, startTimeUTC, endTimeUTC, text1.text)
            }
            else {
                console.log("updating")
                if (!inProgress)
                    Details.updateRecord(recordId, startTimeUTC, endTimeUTC, text1.text)
                else
                    Details.updateRecord(recordId, startTimeUTC, text1.text)
            }
            mainPage.update()
            detailPage.update()
        }
    }
}

