.pragma library

function zeroPad(n) {
    var s = n.toString()
    if (s.length === 1)
        s = '0' + s
    return s
}

function toTime(msec) {
    return (msec >= 36000 ? Math.floor(msec / 36000) + ':' : '') +
                  zeroPad(Math.floor((msec % 36000) / 600)) + ':' +
                  zeroPad(Math.floor((msec % 600) / 10)) + '.' +
                  msec % 10
}
