.pragma library

function zeroPad(n) {
    var s = n.toString()
    if (s.length === 1)
        s = '0' + s
    return s
}

function toTime(msec) {
    var hours = Math.floor(msec / 3600000)
    return  zeroPad(hours) + "h " +
            zeroPad(Math.floor((msec % 3600000) / 60000)) + "m"
}

function toTimeForReport(msec) {
    var hours = Math.floor(msec / 3600000)
    return  zeroPad(hours) + ":" +
            zeroPad(Math.floor((msec % 3600000) / 60000)) + ":" +
            zeroPad(Math.floor((msec % 60000) / 1000))
}

function toTimeWithSeconds(msec) {
    var hours = Math.floor(msec / 3600000)
    return  zeroPad(hours) + "h " +
            zeroPad(Math.floor((msec % 3600000) / 60000)) + "m " +
            zeroPad(Math.floor((msec % 60000) / 1000)) + "s"
}


function dayStart(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth(),
                          date.getDate())
}

function dayEnd(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth(),
                          date.getDate(),
                          23, 59, 59)
}

function monthStart(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth())
}

function monthEnd(date)
{
    if (date === undefined)
        date = new Date()

    return new Date(date.getFullYear(),
                          date.getMonth() + 1,
                          0,
                          23, 59, 59)
}

function weekStart(date)
{
    if (date === undefined)
        date = new Date()
    return new Date(date.getFullYear(),
                    date.getMonth(),
                    date.getDate() - date.getDay())
}

function weekEnd(date)
{
    if (date === undefined)
        date = new Date()
    return new Date(date.getFullYear(),
                    date.getMonth(),
                    date.getDate() + (7 - date.getDay()))
}

function localizedShortDate(date, monthFirst)
{
    return monthFirst ? Qt.formatDate(date, "MM/dd/yyyy") : Qt.formatDate(date, "dd/MM/yyyy")
}
