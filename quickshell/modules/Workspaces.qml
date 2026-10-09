import QtQuick

Row {
    id: root
    spacing: 6

    // Se le pasa la instancia del servicio Sway desde fuera
    property var sway

    Repeater {
        model: root.sway ? root.sway.workspaces : []

        Rectangle {
            width: 30
            height: 24
            radius: 6
            color: modelData.focused
                ? "#89b4fa"
                : (modelData.urgent ? "#f38ba8" : "#313244")

            Text {
                anchors.centerIn: parent
                text: modelData.num
                font.pixelSize: 13
                font.bold: modelData.focused
                color: modelData.focused ? "#1e1e2e" : "#cdd6f4"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.sway.switchTo(modelData.num)
            }

            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }
}
