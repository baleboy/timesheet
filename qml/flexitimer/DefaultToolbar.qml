import QtQuick 1.1
import com.nokia.meego 1.0

ToolBarLayout {
    ToolIcon {
        platformIconId: "toolbar-back"
        onClicked: pageStack.pop()
    }
}
