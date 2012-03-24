Qt.include("Db.js")
Qt.include("Utils.js")

function populateReportsModel()
{
    reportModel.clear();

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

    db.readTransaction(function(tx) {
                           var rs = tx.executeSql(query,
                                              [startTime.getTime(), endTime.getTime()]);
         var totalElapsed = 0;

         for(var i = 0; i < rs.rows.length; i++) {
            var date1 = new Date
            date1.setTime(rs.rows.item(i).startTime)
            var endTimeText = "";
            var elapsed = ""


            if(rs.rows.item(i).endTime !== "") {
                var date2 = new Date
                date2.setTime(rs.rows.item(i).endTime)
                endTimeText = formatter.formatTime(date2, "hh:mm")
                var delta = date2.getTime() - date1.getTime()
                elapsed = toTime(delta)
                totalElapsed += delta
                reportModel.append({
                                 project: rs.rows.item(i).project,
                                 startTime: formatter.formatTime(date1, "hh:mm"),
                                 endTime: endTimeText,
                                 elapsed: elapsed,
                                 elapsedUTC: delta,
                                 date: formatter.formatDateShort(date1),
                                 comments: rs.rows.item(i).comments
                                 });
            }

        }
         totalTextLabel.text = toTime(totalElapsed)
    });


}

Date.prototype.getWeek = function() {
    var onejan = new Date(this.getFullYear(),0,1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay()+1)/7);
}

function getTitle(type)
{
    switch (type) {
    case "all":
        return qsTr("All Time")

    case "month":
        return formatter.formatDateYearAndMonth(startTime)

    case "week":
        return "Week " + startTime.getWeek() + ", " + startTime.getFullYear()

    case "day":
        return formatter.formatDateLong(startTime)
    }
}

function buildReport()
{
    var reportData = "Project, Date, Start, End, Duration, Comment\n"

    for (var i = 0 ; i < reportModel.count ; i++) {
        reportData +=
                reportModel.get(i).project + ", "  +
                reportModel.get(i).date + ", " +
                reportModel.get(i).startTime + ", " +
                reportModel.get(i).endTime + ", " +
                toTimeForReport(reportModel.get(i).elapsedUTC) + ", " +
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

function setPreviousPeriod(periodType)
{
    var refTime = startTime
    switch (periodType) {
    case "day":
        refTime.setDate(refTime.getDate() - 1)
        startTime = dayStart(refTime)
        endTime = dayEnd(refTime)
        break;
    case "week":
        refTime.setDate(refTime.getDate() - 7)
        startTime = weekStart(refTime)
        endTime = weekEnd(refTime)
        break;
    case "month":
        refTime.setMonth(refTime.getMonth() - 1)
        startTime = monthStart(refTime)
        endTime = monthEnd(refTime)
        break;
    }
}

function setNextPeriod(periodType)
{
    var refTime = startTime
    switch (periodType) {
    case "day":
        refTime.setDate(refTime.getDate() + 1)
        startTime = dayStart(refTime)
        endTime = dayEnd(refTime)
        break;
    case "week":
        refTime.setDate(refTime.getDate() + 7)
        startTime = weekStart(refTime)
        endTime = weekEnd(refTime)
        break;
    case "month":
        refTime.setMonth(refTime.getMonth() + 1)
        startTime = monthStart(refTime)
        endTime = monthEnd(refTime)
        break;
    }

}
