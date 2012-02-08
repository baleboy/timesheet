import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

CommonPage {
    id: projectPage
    tools: commonTools
    title: today()

    function update()
    {
        var t = today()
        if (title !== t) title = t // day change
        projectListPage.update()
    }

    function today() {
        var now = new Date()
        return Qt.formatDate(now, "MMMM dd, yyyy")
    }

    function checkDate()
    {
        console.log("Check date")
        var t = today()
        if (title !== t) {
            title = t
            projectListPage.update()
        }
    }

    Connections {
        target: platformWindow
        onActiveChanged: {
            console.log("active changed: " + platformWindow.active)
            if (platformWindow.active)
                              checkDate()
        }
    }

    EmptyPage {
        visible: projectsModel.count == 0
    }

    ProjectsPage {
        id: projectListPage
        visible: projectsModel.count != 0
    }
}
