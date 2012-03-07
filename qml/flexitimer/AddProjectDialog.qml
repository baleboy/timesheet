import QtQuick 1.1
import "Projects.js" as Projects

ProjectDialog {

    titleText: qsTr("Add Project")

    onAccepted: if (inputText != "") {
                    try {
                        Projects.addProject(inputText)
                        projectsModel.append({"name": inputText,
                                                 "elapsedTotal": 0,
                                                 "elapsedToday": 0})
                    }
                    catch(e) {
                        console.debug("addProject: caught " + e)
                        errorBanner.text = qsTr("Project name must be unique")
                        errorBanner.show()
                    }
                }

}
