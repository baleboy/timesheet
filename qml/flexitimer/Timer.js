Qt.include("Db.js")

// Date object used by BackgroundTimer
var previousTime

function saveState()
{
    console.log("Timer.saveState")
    if (running) {
        console.log("saving time: " + previousTime)
        setProperty("previousTime", previousTime.getTime())
    }
    else {
        console.log("clearing time")
        setProperty("previousTime", "")
    }
}

function restoreState()
{
    console.log("Timer.restoreState")
    var storedTime = getProperty("previousTime")
    if (storedTime !== "") {
        previousTime = new Date(parseFloat(storedTime))
        console.log("restored previous time: " + previousTime)
        workTimer.start()
    }
}


function updateElapsed()
{
    var currentTime = new Date
    delta = (currentTime.getTime() - previousTime.getTime())
    previousTime = currentTime
    elapsed += delta
}
