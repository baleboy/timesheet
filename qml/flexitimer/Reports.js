Qt.include("Db.js")

const reportTypeAll = 0
const reportTypeMonth = 1
const reportTypeWeek = 2
const reportTypeDay = 3

function populateReportsModel(startTime, endTime) {

    reportModel.clear();

    db.transaction(function(tx) {
                           var rs = tx.executeSql('SELECT \
                                                  project \
                                                  ,SUM(CASE WHEN startTime >= ? AND startTime <= ? THEN endTime - startTime ELSE 0 END) AS elapsedTotal \
                                                  FROM \
                                                  Details \
                                              GROUP BY \
                                                  project', [startTime, endTime])
                           console.log("rows: " + rs.rows.length)
                           for(var i = 0; i < rs.rows.length; i++) {
                               console.log("elapsed total: " + rs.rows.item(i).elapsedTotal)
                               reportModel.append({
                                                name: rs.rows.item(i).project,
                                                elapsedTotal: rs.rows.item(i).elapsedTotal

                                            });
                           }
                       })


}

Date.prototype.getWeek = function() {
    var onejan = new Date(this.getFullYear(),0,1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay()+1)/7);
}

function getTitle(type)
{
    var now = new Date

    switch (type) {
    case reportTypeAll:
        return qsTr("All Time")

    case reportTypeMonth:
        return Qt.formatDate(now, "MMMM yyyy")

    case reportTypeWeek:
        return "Week " + now.getWeek() + ", " + now.getFullYear()

    case reportTypeDay:
        return Qt.formatDate(now, "dddd, MMMM dd yyyy")
    }
}
