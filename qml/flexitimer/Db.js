/*

Copyright (C) 2012 Francesco Balestrieri

This file is part of Timesheet for N9

Timesheet for N9 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Timesheet for N9 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Timesheet for N9.  If not, see <http://www.gnu.org/licenses/>.

*/

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
    }

    return instance
}

function createTables(tx)
{
    tx.executeSql('CREATE TABLE IF NOT EXISTS Projects(name STRING UNIQUE, timeStamp INTEGER )');
    tx.executeSql('CREATE TABLE IF NOT EXISTS Details(recordId INTEGER UNIQUE, project STRING, startTime INTEGER, endTime INTEGER, comments TEXT)');
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

                       }

                       rs = tx.executeSql('SELECT * FROM Details');
                       for(i = 0; i < rs.rows.length; i++) {

                       }

                       rs = tx.executeSql('SELECT * FROM Properties');
                       for(i = 0; i < rs.rows.length; i++) {

                       }
                   })

}
