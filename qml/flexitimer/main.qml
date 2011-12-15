import QtQuick 1.1
import com.nokia.meego 1.0
import "Constants.js" as Const
import "Db.js" as Db

PageStackWindow {
    id: appWindow

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    DetailPage {
        id: detailPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            platformIconId: "toolbar-add"
            onClicked: addProjectDialog.open()
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Clear data")
                onClicked: { Db.clearAll(); projectsModel.clear() }
            }
            MenuItem {
                text: qsTr("Print all")
                onClicked: { Db.printAll() }
            }
        }
    }

    Dialog {
      id: addProjectDialog
      title: Label { color: "white"; text: qsTr("Add Project")}

      content:Item {
        id: name
        height: 140
        width: parent.width
        TextField {
            id: projectNameInput
            placeholderText: qsTr("Project name")
            anchors.centerIn: parent
        }
      }
      buttons: Button {
          platformStyle: ButtonStyle { inverted: true }
          text: qsTr("OK")
          width: Const.mediumButtonWidth
          anchors.horizontalCenter: parent.horizontalCenter
          onClicked: addProjectDialog.accept()
      }
      onAccepted: if (projectNameInput.text != "") {
                      projectsModel.append({"name": projectNameInput.text,
                                          "elapsed": 0})
                      Db.addProject(projectNameInput.text)
                  }

    }
    ListModel {
        id: projectsModel
    }

    ListModel {
        id: detailsModel
    }

    Component.onCompleted: {
        Db.populateProjectsModel(projectsModel);
    }
}
