/*

Copyright (C) 2012 Francesco Balestrieri

This file is part of Timesheet for N9

Timesheet for N9 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Timesheet for N9 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Timesheet for N9.  If not, see <http://www.gnu.org/licenses/>.

*/

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

    function pauseTimer()
    {
        myTimer.stop()
    }

    interval:  60000
    repeat:  true
    running: false
    triggeredOnStart: true

    onTriggered: {
        Impl.updateElapsed()
        myTimer.tick()
    }
}

