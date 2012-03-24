Qt.include("Db.js")

var startTime = new Date

function startTimer()
{
    elapsed = 0
    startTime = new Date
    setProperty("timerStart", startTime.getTime())
    myTimer.start()
}

function stopTimer()
{
    myTimer.stop()
    setProperty("timerStart", "")
}

function updateElapsed()
{
    var now = new Date
    elapsed = now.getTime() - startTime.getTime()
}

function setStartTime(utc)
{
    // if the timer is running, pause it
    // and start it again (this will trigger a tick
    // and protect from race conditions)
    var needResume = myTimer.running
    if (myTimer.running) {
        myTimer.stop()
    }
    startTime.setTime(utc)
    if (needResume)
        myTimer.start()
}
