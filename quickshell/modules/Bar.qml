import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: bar
    property var sway

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 32
    color: "#1e1e2e"

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "#313244"
        border.width: 0
    }

    // Izquierda: workspaces
    Workspaces {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        sway: bar.sway
    }

    // Centro: reloj + calendario
    ClockWidget {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    // Derecha: volumen, brillo, batería
    Row {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        spacing: 14

        Volume {}
        Brightness {}
        Battery {}
    }
}
