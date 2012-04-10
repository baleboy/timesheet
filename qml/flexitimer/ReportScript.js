Qt.include("Db.js")
Qt.include("Utils.js")

WorkerScript.onMessage = function(message) {

            var reportModel = message.model
            var selectionModel = message.selectionModel
            var selectedIndexes = message.selectedIndexes
            var startTime = message.startTime
            var endTime = message.endTime
            var monthFirst = message.monthFirst

            reportModel.clear();

            // build query to include list of project names filter if needed

            var query = "SELECT * FROM Details WHERE startTime >= ? AND startTime <= ?"
            if (selectedIndexes.length > 0)
                query += " AND project IN ("
            for (var i = 0 ; i < selectedIndexes.length; i++) {
                query += "'" + selectionModel.get(selectedIndexes[i]).name + "'"
                if (i !== selectedIndexes.length - 1)
                    query += ","
            }
            if (selectedIndexes.length > 0)
                query += ") "
            query += "ORDER BY startTime DESC"

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

