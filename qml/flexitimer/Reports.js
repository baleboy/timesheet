Qt.include("Db.js")

function populateReportsModel() {

    reportModel.clear();

    db.transaction(function(tx) {
                           var rs = tx.executeSql('SELECT \
                                                  project \
                                                  ,SUM(endTime - startTime) AS elapsedTotal \
                                                  FROM \
                                                  Details \
                                              GROUP BY \
                                                  project')
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
