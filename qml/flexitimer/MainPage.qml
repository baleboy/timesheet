import QtQuick 1.1
import com.nokia.meego 1.0
import "UiConstants.js" as Const
import "Utils.js" as Utils
import "Db.js" as Db

Page {
    id: projectPage
    tools: commonTools
    property string title: today()

    function update()
    {
        var t = today()
        if (title !== t) title = t // day change
        projectListPage.update()
    }

    function today() {
        var now = new Date()
        return formatter.formatDateLong(now)
    }

    function checkDate()
    {
        console.log("Check date")
        var t = today()
        console.log("comparing " + title + " with " + t)
        if (title != t) {
            console.debug("Date has changed, updating")
            title = t
            projectListPage.update()
        }
    }

    function move(index1, index2)
    {
        projectListPage.move(index1, index2)
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
        anchors {
            top: header.bottom
            topMargin: -5
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    ProjectsPage {
        id: projectListPage
        visible: projectsModel.count != 0
        anchors {
            top: header.bottom
            topMargin: -5
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
    }

    Image {
        id: header
        source: "images/header-bg.png"
        width: parent.width
        fillMode: Image.TileHorizontally

        Label {
            id: titleLabel
            text: title
            font.pixelSize: Const.fontLarge
            color: "white"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: Const.margin
            }
        }

        Label {
            font.pixelSize: Const.fontHuge
            font.weight: Font.Bold
            text: projectListPage.daysTotalText
            color: "white"
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: titleLabel.bottom
                topMargin: Const.smallMargin
            }
        }
    }

}
