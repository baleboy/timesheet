import QtQuick 1.1
import "Timer.js" as Data

Timer {

    id: myTimer

    property int elapsed: 0
    property int delta: 0

    interval:  60000
    repeat:  true
    running: false
    triggeredOnStart: false

    signal tick;

    function updateElapsed()
    {
        var currentTime = new Date
        delta = (currentTime.getTime() - Data.previousTime.getTime())
        Data.previousTime = currentTime
        elapsed += delta
    }

    onTriggered: {
        updateElapsed()
        console.log("Timer ticked. Elapsed: " + elapsed + ", delta: " + delta)
        myTimer.tick()

    }

    onRunningChanged: if (running) {
                          Data.previousTime = new Date
                      }
                      else {
                          updateElapsed()
                      }
}
