import QtQuick 1.1
import com.nokia.meego 1.0
import "Db.js" as Db
import "Constants.js" as Const
import "Utils.js" as Utils

Item {

    id: projectsPage

    anchors.fill: parent
    property int todaysTotal

    Rectangle {

        id: rect1
        color: "orange"
        width: parent.width
        height: 90
        anchors {
            top: parent.top
            topMargin: Const.headerHeight
        }

        Label {
            font.pixelSize: Const.fontHuge
            text: Utils.toTime(todaysTotal)
            anchors.centerIn: parent
            color: "white"
        }
    }

    ListView {

        id: projectList
        property string inProgress
        property int inProgressIndex

        anchors {
            top: rect1.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        clip: true

        model: projectsModel

        delegate: ProjectDelegate {}

        BackgroundTimer {
            id: workTimer
            onTick: {
                console.log("*** tick()")
                console.log("Project in progress: " + projectList.inProgress + "[" + projectList.inProgressIndex + "]")
                console.log("Timer delta: " + workTimer.delta)
                todaysTotal += workTimer.delta
                var t = parseFloat(projectList.model.get(projectList.inProgressIndex).elapsedToday) + workTimer.delta
                console.log("elapsed today: " + t)
                projectList.model.setProperty(projectList.inProgressIndex, "elapsedToday", t)
                t = parseFloat(projectList.model.get(projectList.inProgressIndex).elapsedTotal) + workTimer.delta
                console.log("elapsed total: " + t)
                projectList.model.setProperty(projectList.inProgressIndex, "elapsedTotal", t)
            }
        }

        Component.onCompleted: {
            // initialize model and ongoing project if any
            inProgress = Db.getProperty("projectInProgress")
            model.clear();
            Db.db.transaction(function(tx) {
                                  var rs = tx.executeSql('SELECT \
                                                         project \
                                                         ,SUM(endTime - startTime) AS elapsedTotal \
                                                         ,SUM(CASE WHEN startTime >= ? AND startTime <= ? THEN endTime - startTime ELSE 0 END) AS elapsedToday \
                                                     FROM \
                                                         (SELECT Projects.name as project, Details.startTime, Details.endTime \
                                                         FROM Projects \
                                                         LEFT JOIN Details \
                                                         ON Projects.name=Details.project) \
                                                     GROUP BY \
                                                         project', [Db.dayStart(), Db.dayEnd()]);
                                  for(var i = 0; i < rs.rows.length; i++) {
                                      model.append({name: rs.rows.item(i).project, elapsedTotal: rs.rows.item(i).elapsedTotal, elapsedToday: rs.rows.item(i).elapsedToday});
                                      if (rs.rows.item(i).name == inProgress) {
                                          inProgressIndex = i
                                          console.log("Project in progress: " + inProgress + ", index: " + inProgressIndex)
                                          workTimer.start()
                                      }
                                  }
                              });

        }
    }

    Component.onCompleted: {

        todaysTotal = Db.todaysTotal()
    }
}
