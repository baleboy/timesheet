import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

CommonPage {
    tools: commonTools
    title: qsTr("Projects")

    EmptyPage {
        visible: projectsModel.count == 0
    }

    ProjectsPage {
        visible: projectsModel.count != 0
    }

    ListModel {
        id: testModel
        ListElement { startTime: "00:00"; endTime: "10:00"; date: "26/10/2011"}
        ListElement { startTime: "10:00"; endTime: "12:00"; date: "26/10/2011"}
        ListElement { startTime: "00:00"; endTime: "10:00"; date: "25/10/2011"}
        ListElement { startTime: "10:00"; endTime: "12:00"; date: "25/10/2011"}
    }
}
