Qt.include("Db.js")

function populateReportsModel()
{
    reportModel.clear();

    console.log("populateReportsModel: " + startTime + ", " + endTime)

    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Details WHERE startTime >= ? AND startTime <= ? ORDER BY startTime DESC',
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
                                 date: Qt.formatDate(date1, "dddd, MMMM dd yyyy"),
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
        return Qt.formatDate(now, "dddd, MMMM dd yyyy")
    }
}
