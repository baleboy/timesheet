Qt.include("Db.js")

function populateProjectDetails()
{
    detailsList.model.clear();

    console.log("populateProjectsDetails: " + project + ", " + startTime + ", " + endTime)
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Details WHERE project=? AND startTime >= ? AND startTime <= ? ORDER BY startTime DESC',
                                              [project, startTime.getTime(), endTime.getTime()]);
        for(var i = 0; i < rs.rows.length; i++) {
            var date1 = new Date
            date1.setTime(rs.rows.item(i).startTime)
            var endTimeText = "";
            var elapsed = ""
            if(rs.rows.item(i).endTime !== "") {
                var date2 = new Date
                date2.setTime(rs.rows.item(i).endTime)
                endTimeText = Qt.formatTime(date2, "hh:mm")
                elapsed = toTime(date2.getTime() - date1.getTime())
            }

            detailsList.model.append({startTime: Qt.formatTime(date1, "hh:mm"),
                             endTime: endTimeText,
                             elapsed: elapsed,
                             date: Qt.formatDate(date1, "dddd, MMMM dd yyyy"),
                             });
        }
    });


}
