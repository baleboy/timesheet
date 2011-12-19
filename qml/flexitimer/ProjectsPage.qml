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
        color: "gray"
        width: parent.width
        height: 80
        anchors {
            top: parent.top
            topMargin: Const.headerHeight
        }

        Label {
            font.pixelSize: Const.fontLarge
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
            onElapsedChanged: todaysTotal += workTimer.delta
        }

        Component.onCompleted: {
            // initialize model and ongoing project if any
            inProgress = Db.getProperty("projectInProgress")
            model.clear();
            Db.db.transaction(function(tx) {
                                  var rs = tx.executeSql('SELECT * FROM Projects');
                                  for(var i = 0; i < rs.rows.length; i++) {
                                      model.append({name: rs.rows.item(i).name, elapsed: rs.rows.item(i).elapsed});
                                      if (rs.rows.item(i).name == inProgress) {
                                          inProgressIndex = i
                                          console.log("Project in progress: " + inProgress + ", index: " + inProgressIndex)
                                          workTimer.elapsed = rs.rows.item(i).elapsed
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
