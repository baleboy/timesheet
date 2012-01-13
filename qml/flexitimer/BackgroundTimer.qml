import QtQuick 1.1
import "Timer.js" as TimerImp

Timer {

    id: myTimer

    property int elapsed: 0
    property int delta: 0
    property bool initCompleted

    function initialize()
    {
        initCompleted = false
        TimerImp.restoreState()
        if (!running) initCompleted = true
    }

    interval:  60000
    repeat:  true
    running: false
    triggeredOnStart: true

    signal tick;

    onTriggered: {
        TimerImp.updateElapsed()
        console.log("Timer ticked. Elapsed: " + elapsed + ", delta: " + delta)
        myTimer.tick()

    }

    onRunningChanged: {
        if (initCompleted) { // skip the first start if it was due to restoring a running timer
            if (running) {
                TimerImp.previousTime = new Date
            }
            else {
                TimerImp.updateElapsed()
            }
            TimerImp.saveState()
        }
        else
            initCompleted = true
    }
}
