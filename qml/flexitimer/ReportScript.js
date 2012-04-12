.pragma library

Qt.include("Db.js")
Qt.include("Utils.js")

function handleReport(message)
{
    var reportModel = message.model
    var projectString = message.projectString
    var startTime = message.startTime
    var endTime = message.endTime
    var monthFirst = message.monthFirst

    reportModel.clear();

    // build query to include list of project names filter if needed

    var query = "SELECT * FROM Details WHERE startTime >= ? AND startTime <= ?"
    if (projectString !== "") {
        query += " AND project IN (" + projectString + ")"
    }
    query += " ORDER BY startTime DESC"

    console.debug("Reports query: " + query)

    db.readTransaction(function(tx) {
                           var rs = tx.executeSql(query,
                                                  [startTime.getTime(), endTime.getTime()]);
                           var totalElapsed = 0;

                           for(var i = 0; i < rs.rows.length; i++) {
                               var date1 = new Date
                               date1.setTime(rs.rows.item(i).startTime)
                               var elapsed = ""


                               if(rs.rows.item(i).endTime !== "") {
                                   var date2 = new Date
                                   date2.setTime(rs.rows.item(i).endTime)
                                   var delta = date2.getTime() - date1.getTime()
                                   elapsed = toTime(delta)
                                   totalElapsed += delta
                                   reportModel.append({
                                                          project: rs.rows.item(i).project,
                                                          startTimeUTC: date1.getTime(),
                                                          endTimeUTC: date2.getTime(),
                                                          elapsed: elapsed,
                                                          elapsedUTC: delta,
                                                          date: localizedShortDate(date1, monthFirst),
                                                          comments: rs.rows.item(i).comments
                                                      });
                               }

                           }
                           reportModel.sync()
                           WorkerScript.sendMessage({ 'elapsed': toTime(totalElapsed) })
                       })
}

WorkerScript.onMessage = function(message) {
            handleReport(message)
        }

