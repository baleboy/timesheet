import QtQuick 1.1
import "Projects.js" as Projects

ProjectDialog {
    property string oldName
    property int index

    titleText: qsTr("Rename project %1").arg(oldName)
    onAccepted: if ((inputText != "") && (inputText != oldName)) {
                    try {
                        Projects.renameProject(oldName, inputText, index)
                    }
                    catch(e) {
                        console.debug("renameProject: caught " + e)
                        errorBanner.text = qsTr("Project name must be unique")
                        errorBanner.show()
                    }
                }
}
