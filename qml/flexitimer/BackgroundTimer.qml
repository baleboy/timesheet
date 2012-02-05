import QtQuick 1.1
import "Timer.js" as Impl

Timer {
    id: myTimer

    property double elapsed: 0

    signal tick;

    function startTimer()
    {
        Impl.startTimer()
    }

    function stopTimer()
    {
        Impl.stopTimer()
    }

    function setStartTime(utc)
    {
        Impl.setStartTime(utc)
    }

    function resumeTimer()
    {
        myTimer.start()
    }

    interval:  60000
    repeat:  true
    running: false
    triggeredOnStart: true

    onTriggered: {
        console.log("Timer ticked")
        Impl.updateElapsed()
        myTimer.tick()
    }
}

