.pragma library

function zeroPad(n) {
    var s = n.toString()
    if (s.length === 1)
        s = '0' + s
    return s
}

function toTime(msec) {
    return zeroPad(Math.floor(msec / 3600000)) + "h "  +
            zeroPad(Math.floor((msec % 3600000) / 60000)) + "m"
}

function dayStart(date)
{
    return new Date(date.getFullYear(),
                          date.getMonth(),
                          date.getDate())
}

function dayEnd(date)
{
    return new Date(date.getFullYear(),
                          date.getMonth(),
                          date.getDate(),
                          23, 59, 59)
}
