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
