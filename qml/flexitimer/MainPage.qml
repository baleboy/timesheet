import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

CommonPage {
    id: projectPage
    tools: commonTools
    title: qsTr("Projects")

    EmptyPage {
        visible: projectsModel.count == 0
    }

    ProjectsPage {
        visible: projectsModel.count != 0
    }
}
