Qt.include("Db.js")

function populateReportsModel()
{
    reportModel.clear();

    console.log("populateReportsModel: " + startTime + ", " + endTime)

    // build query (I couldn't figure out how to parametrize the list)

    var query = "SELECT * FROM Details WHERE startTime >= ? AND startTime <= ?"
    if (projectSelectionDialog.selectedIndexes.length > 0)
        query += " AND project IN ("
    for (var i = 0 ; i < projectSelectionDialog.selectedIndexes.length; i++) {
        query += "'" + projectSelectionDialog.model.get(projectSelectionDialog.selectedIndexes[i]).name + "'"
        if (i !== projectSelectionDialog.selectedIndexes.length - 1)
            query += ","
    }
    if (projectSelectionDialog.selectedIndexes.length > 0)
        query += ") "
    query += "ORDER BY startTime DESC"

    console.log("report query: " + query)

    db.readTransaction(function(tx) {
                           var rs = tx.executeSql(query,
                                              [startTime.getTime(), endTime.getTime()]);
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

                reportModel.append({
                                 project: rs.rows.item(i).project,
                                 startTime: Qt.formatTime(date1, "hh:mm"),
                                 endTime: endTimeText,
                                 elapsed: elapsed,
                                 date: Qt.formatDate(date1, "dd/MM/yyyy"),
                                 comments: rs.rows.item(i).comments
                                 });
            }

        }
    });


}

Date.prototype.getWeek = function() {
    var onejan = new Date(this.getFullYear(),0,1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay()+1)/7);
}

function getTitle(type)
{
    var now = new Date

    switch (type) {
    case "all":
        return qsTr("All Time")

    case "month":
        return Qt.formatDate(now, "MMMM yyyy")

    case "week":
        return "Week " + now.getWeek() + ", " + now.getFullYear()

    case "day":
        return Qt.formatDate(now, "MMMM dd yyyy")
    }
}

function buildReport()
{
    var reportData = "Date, Start, End, Duration, Comment\n"

    for (var i = 0 ; i < reportModel.count ; i++) {
        reportData += reportModel.get(i).date + ", " +
                reportModel.get(i).startTime + ", " +
                reportModel.get(i).endTime + ", " +
                reportModel.get(i).elapsed + ", " +
                reportModel.get(i).comments + "\n"
    }

    return reportData
}

function getProjectList(model)
{
    db.readTransaction(function(tx) {
                           var rs = tx.executeSql('SELECT name FROM Projects ORDER BY name ASC')
                           for(var i = 0; i < rs.rows.length; i++) {
                               model.append({name: rs.rows.item(i).name})
                           }

                       });

}

function selectedProjectsText(list, total)
{
    if (list.length === 0 || list.length === total)
        return qsTr("All projects")

    if (list.length === 1)
        return qsTr("1 project")

    return list.length + " projects"
}
