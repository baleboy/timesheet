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
