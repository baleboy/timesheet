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
                             recordId: rs.rows.item(i).recordId,
                             comments: rs.rows.item(i).comments
                             });
        }
    });

}

function deleteRecord(project, recordId, index)
{
    console.log("Details.deleteRecord: " + project + ", " + recordId + ", " + index)
    db.transaction(function(tx) {
                       var rs = tx.executeSql('DELETE FROM Details WHERE project=? AND recordId = ?',
                                              [project, recordId])});
    detailsModel.remove(index)
}

function populateEditSessionPage()
{
    console.log("Edit session page - record Id: ", editSessionPage.recordId)
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Details WHERE recordId = ? ',
                                              [editSessionPage.recordId]);
                       console.log("Start time: ", rs.rows.item(0).startTime)
                       startTimeUTC = rs.rows.item(0).startTime
                       endTimeUTC = rs.rows.item(0).endTime

                       if (rs.rows.item(0).comments !== undefined)
                           text1.text = rs.rows.item(0).comments
                   })
}

function saveComments(recordId, text)
{
    console.log("Details.saveComments. Record ID: " +  recordId + " text: " + text)
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET comments=? WHERE recordId=?', [text, recordId])
    });
}

function saveStartTime(recordId, t)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET startTime=? WHERE recordId=?', [t, recordId])
    });
}

function saveEndTime(recordId, t)
{
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET endTime=? WHERE recordId=?', [t, recordId])
    });
}
