.pragma library

function zeroPad(n) {
    var s = n.toString()
    if (s.length === 1)
        s = '0' + s
    return s
}

function toTime(msec) {
    return zeroPad(Math.floor(msec / 3600000)) + ':'  +
           zeroPad(Math.floor((msec % 3600000) / 60000))
}
