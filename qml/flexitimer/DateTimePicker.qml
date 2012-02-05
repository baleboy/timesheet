import QtQuick 1.1
import com.nokia.extras 1.0

TumblerDialog {
    id: root
    acceptButtonText: qsTr("Ok")
    rejectButtonText: qsTr("Cancel")
    titleText: qsTr("Select Date and Time")

    property int month: 1
    property int day: 1
    property int hour: 0
    property int minute: 0

    signal picked

    onMonthChanged: monthColumn.selectedIndex = month - 1
    onDayChanged: dayColumn.selectedIndex = day - 1
    onHourChanged: hourColumn.selectedIndex = hour
    onMinuteChanged: minuteColumn.selectedIndex = minute

    function setUtcTime(utc)
    {
        var d = new Date
        d.setTime(utc)

        console.log("DateTimePicker - Setting time: " + Qt.formatDateTime(d))

        month = d.getMonth() + 1
        day = d.getDate()
        hour = d.getHours()
        minute = d.getMinutes()

        monthColumn.selectedIndex = month - 1
        dayColumn.selectedIndex = day - 1
        hourColumn.selectedIndex = hour
        minuteColumn.selectedIndex = minute

        console.log("New indexes: " + monthColumn.selectedIndex + " "
                    + dayColumn.selectedIndex + " " +
                    hourColumn.selectedIndex + " " +
                    minuteColumn.selectedIndex)
    }

    function toDateTime() {
        var date = new Date(dateTime.currentYear(),month - 1,day,hour,minute,0)
        return date
    }


    function toDateTimeUTC() {
        var date = new Date(dateTime.currentYear(),month - 1,day,hour,minute,0)
        return date.getTime()
    }

    columns: [ monthColumn, dayColumn, hourColumn, minuteColumn ]

    TumblerColumn {
        id: monthColumn
        items: monthList
        label: qsTr("MONTH")
        selectedIndex: root.month - 1

        ListModel {
            id: monthList
            Component.onCompleted: {
                for (var i = 1 ; i <= 12 ; i++)
                    monthList.append({"value": dateTime.shortMonthName(i)})
            }
        }
    }

    TumblerColumn {
        id: dayColumn
        items: dayList
        label: qsTr("DAY")
        selectedIndex: root.day - 1

        ListModel {
            id: dayList

            Component.onCompleted: {
                for (var i = 1 ; i <= dateTime.daysInMonth(dateTime.currentYear, root.month) ; i++)
                    dayList.append({"value": i})
            }
        }
    }

    TumblerColumn {
        id: hourColumn
        items: hourList
        label: qsTr("HOUR")
        selectedIndex: root.hour

        ListModel {
            id: hourList

            Component.onCompleted: {
                for (var i = 0 ; i <= 23 ; i++)
                    hourList.append({"value": (i <= 9 ? "0" : "") + i })
            }
        }
    }

    TumblerColumn {
        id: minuteColumn
        items: minuteList
        label: qsTr("MIN")
        selectedIndex: root.minute

        ListModel {
            id: minuteList

            Component.onCompleted: {
                for (var i = 0 ; i <= 59 ; i++)
                    minuteList.append({"value": (i <= 9 ? "0" : "") + i })
            }
        }
    }
    onAccepted: {
        root.month = monthColumn.selectedIndex + 1
        root.day = dayColumn.selectedIndex + 1
        root.hour = hourColumn.selectedIndex
        root.minute = minuteColumn.selectedIndex
        root.picked()
    }
}
