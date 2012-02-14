import QtQuick 1.1
import com.nokia.extras 1.1

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
        label: qsTr("MONTH")
        selectedIndex: root.month - 1

        items: ListModel {
            id: monthList
        }
    }


    TumblerColumn {
        id: dayColumn
        label: qsTr("DAY")
        selectedIndex: root.day - 1

        items: ListModel {
            id: dayList
        }
    }

    TumblerColumn {
        id: hourColumn
        label: qsTr("HOUR")
        selectedIndex: root.hour

        items: ListModel {
            id: hourList
        }
    }

    TumblerColumn {
        id: minuteColumn
        label: qsTr("MIN")
        selectedIndex: root.minute

        items: ListModel {
            id: minuteList
        }
    }

    onAccepted: {
        root.month = monthColumn.selectedIndex + 1
        root.day = dayColumn.selectedIndex + 1
        root.hour = hourColumn.selectedIndex
        root.minute = minuteColumn.selectedIndex
        root.picked()
    }

    function initializeDataModels()
    {
        var i
        for (i = 1 ; i <= 12 ; i++)
            monthList.append({"value": dateTime.shortMonthName(i)})
        for (i = 1 ; i <= dateTime.daysInMonth(dateTime.currentYear, root.month) ; i++)
            dayList.append({"value": i})
        for (i = 0 ; i <= 23 ; i++)
            hourList.append({"value": (i <= 9 ? "0" : "") + i })
        for (i = 0 ; i <= 59 ; i++)
            minuteList.append({"value": (i <= 9 ? "0" : "") + i })
    }

    Component.onCompleted: initializeDataModels()
}
