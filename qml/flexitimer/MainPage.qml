import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

CommonPage {
    id: projectPage
    tools: commonTools
    title: today()

    function today() {
        var now = new Date()
        return Qt.formatDate(now, "MMMM dd, yyyy")
    }

    EmptyPage {
        visible: projectsModel.count == 0
    }

    ProjectsPage {
        visible: projectsModel.count != 0
    }
}
