import Quickshell.Io
import QtQuick

Item {
    id: root
    width: row.width
    height: 24

    property int percent: 0

    function icon() {
        if (root.percent >= 66) return "☀️"
        if (root.percent >= 33) return "🌤️"
        return "🌙"
    }

    Row {
        id: row
        spacing: 4
        Text {
            color: "#cdd6f4"
            font.pixelSize: 13
            text: root.icon()
        }
        Text {
            color: "#cdd6f4"
            font.pixelSize: 13
            text: root.percent + "%"
        }
    }

    MouseArea {
        anchors.fill: parent
        // scroll arriba = subir brillo, abajo = bajar
        onWheel: wheel => {
            const step = wheel.angleDelta.y > 0 ? "5%+" : "5%-"
            setBrightness.command = ["brightnessctl", "set", step]
            setBrightness.running = true
        }
    }

    Process {
        id: setBrightness
        onExited: root.refresh()
    }

    Process {
        id: queryBrightness
        command: ["brightnessctl", "-m"]
        stdout: StdioCollector {
            onStreamFinished: {
                // formato: device,class,current,percent%,max
                const parts = this.text.trim().split(",")
                if (parts.length >= 4) {
                    root.percent = parseInt(parts[3].replace("%", ""))
                }
            }
        }
    }

    function refresh() {
        queryBrightness.running = true
    }

    // Escucha cambios del kernel (backlight) para reflejar teclas de función también
    Process {
        id: watcher
        command: ["sh", "-c", "udevadm monitor -s backlight"]
        running: true
        stdout: SplitParser {
            onRead: data => root.refresh()
        }
    }

    Timer {
        interval: 500
        running: true
        onTriggered: root.refresh()
    }
}
