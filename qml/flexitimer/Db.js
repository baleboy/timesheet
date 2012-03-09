.pragma library

Qt.include("Utils.js")
var db = init()
var lastId

function init()
{
    var instance
    try {
        instance = openDatabaseSync("Flexo", "1.0", "Flexo DB", 1000000);
        instance.transaction(createTables);
    }
    catch(e) {
        // assuming it can only fail for wrong version
        console.log("Db.init: caught " + e)
/*        try {
            instance = openDatabaseSync("Flexo", "1.0", "Flexo DB", 1000000);
            console.debug("Version 1.0 open")
            // instance.changeVersion("1.0", "1.1", function(tx) {
            //                            // tx.executeSql('ALTER TABLE Projects ADD timeStamp INTEGER NOT NULL DEFAULT(0)')
            //                       })
        }
        catch(e) {
            console.debug("Upgrading: " + e)
        }
        */
    }

    return instance
}

function createTables(tx)
{
    tx.executeSql('CREATE TABLE IF NOT EXISTS Projects(name STRING UNIQUE, timeStamp INTEGER )');
    tx.executeSql('CREATE TABLE IF NOT EXISTS Details(recordId INTEGER, project STRING, startTime INTEGER, endTime INTEGER, comments TEXT)');
    tx.executeSql('CREATE TABLE IF NOT EXISTS Properties(name STRING UNIQUE, value STRING)');
    var rs = tx.executeSql('SELECT * FROM Properties WHERE name=?', ["pendingRecordId"]);
    if (rs.rows.length > 0) {
        lastId = rs.rows.item(0).value
    }
}

function addProjectStart(project)
{
    var now = new Date()
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT INTO Details (recordId, project, startTime) VALUES (?, ?, ?)', [now.getTime(), project, now.getTime()])
                       lastId = rs.insertId
                       setProperty("pendingRecordId", lastId)
                       console.log("Opened record " + lastId)
    });
    db.transaction(function(tx) {
                       var rs = tx.executeSql('UPDATE Projects SET timeStamp=? WHERE name=?', [now.getTime(), project])
    });

    return now.getTime()
}

function addProjectEnd()
{
    var now = new Date()
    db.transaction(function(tx) {
                       tx.executeSql('UPDATE Details SET endTime=? WHERE ROWID=?', [now.getTime(), lastId])
                       console.log("Closed record " + lastId)
    });

}

function clearAll()
{

    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Projects');
    });

    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Details');
    });

    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM Properties');
    });
}

function recreate()
{

    db.transaction(function(tx) {
        tx.executeSql('DROP TABLE Projects');
        tx.executeSql('DROP TABLE Details');
        tx.executeSql('DROP TABLE Properties');
    });

    db.transaction(createTables)
}

function setProperty(name, value)
{
    db.transaction(function(tx) {
        tx.executeSql("INSERT OR REPLACE INTO Properties (name, value) VALUES (?,?)", [name, value]);
    });
}

function getProperty(name)
{
    var result = ""
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM Properties WHERE name=?', [name]);
        if (rs.rows.length > 0) {
            result = rs.rows.item(0).value
        }
    });
    return result
}

function printAll()
{
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT * FROM Projects');
                       for(var i = 0; i < rs.rows.length; i++) {
                           console.log(rs.rows.item(i).name)
                       }

                       rs = tx.executeSql('SELECT * FROM Details');
                       for(i = 0; i < rs.rows.length; i++) {
                           console.log(rs.rows.item(i).recordId + " " + rs.rows.item(i).project + " " + rs.rows.item(i).startTime + " " + rs.rows.item(i).endTime)
                       }

                       rs = tx.executeSql('SELECT * FROM Properties');
                       for(i = 0; i < rs.rows.length; i++) {
                           console.log(rs.rows.item(i).name + ", " + rs.rows.item(i).value)
                       }
                   })

    console.log("LastID: " + lastId)
}
