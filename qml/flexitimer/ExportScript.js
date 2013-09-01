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

Qt.include("Utils.js")

WorkerScript.onMessage = function(message) {

            var reportModel = message.model

            var reportData = "Project, Date, Start, End, Duration, Comment\n"

            for (var i = 0 ; i < reportModel.count ; i++) {
                reportData +=
                        reportModel.get(i).project + ", "  +
                        reportModel.get(i).date + ", " +
                        Qt.formatTime(new Date(reportModel.get(i).startTimeUTC), Qt.DefaultLocaleLongDate) + ", " +
                        Qt.formatTime(new Date(reportModel.get(i).endTimeUTC), Qt.DefaultLocaleLongDate) + ", " +
                        toTimeForReport(reportModel.get(i).elapsedUTC) + ", " +
                        reportModel.get(i).comments + "\n"
            }

            WorkerScript.sendMessage({ 'data': reportData })
        }
