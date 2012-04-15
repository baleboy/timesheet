import QtQuick 1.1
import "Projects.js" as Projects

ProjectDialog {

    titleText: qsTr("Add Project")
    initialText: ""

    onAccepted: if (inputText != "") {
                    try {
                        Projects.addProject(inputText)
                        projectsModel.insert(inProgress == "" ? 0 : 1,
                                                {"name": inputText,
                                                 "elapsedTotal": 0,
                                                 "elapsedToday": 0})
                        reportsPage.updateProjectsDialog()
                    }
                    catch(e) {
                        debug.log("caught error: " + e)
                        errorBanner.text = qsTr("Project name must be unique")
                        errorBanner.show()
                    }
                }

}
