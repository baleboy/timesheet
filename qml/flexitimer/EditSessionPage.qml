import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "Constants.js" as Const
import "Details.js" as Details
import "Projects.js" as Projects

CommonPage {

    title: qsTr("Edit Session")
    id: editSessionPage

    property double recordId
    property double startTimeUTC
    property double endTimeUTC

    function formatDate(utc) {
        var d = new Date
        d.setTime(utc)
        return Qt.formatDateTime(d, "ddd MMM dd, hh:mm")
    }

    Grid {
        id: grid1
        columns: 2
        rows: 2
        spacing: 15

        anchors {
            top: parent.top
            topMargin: Const.headerHeight + Const.bigMargin
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
            text: formatDate(endTimeUTC)
            width: startSelector.width
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
                                  Details.saveComments(recordId, text)
                                  detailPage.update()
                              }
    }

    tools: DefaultToolbar { }


    InfoBanner {
        id: errorBanner
        text: qsTr("Start time must be earlier than end time")
    }

    DateTimePicker {
        id: startPicker

        onPicked: {
            if (startPicker.toDateTimeUTC() < endTimeUTC) {

                startTimeUTC = startPicker.toDateTimeUTC()
                Details.saveStartTime(recordId, startTimeUTC)

                mainPage.update()
                detailPage.update()
            }
            else {
                errorBanner.show()
            }
        }

    }

    DateTimePicker {
        id: endPicker

        onPicked: {
            if (endPicker.toDateTimeUTC() > startTimeUTC) {

                endTimeUTC = endPicker.toDateTimeUTC()
                Details.saveEndTime(recordId, endTimeUTC)

                mainPage.update()
                detailPage.update()
            }
            else {
                errorBanner.show()
            }
        }

    }

    Component.onCompleted: Details.populateEditSessionPage()
}
