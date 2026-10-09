import Quickshell.Io
import QtQuick

Item {
    id: root
    width: row.width
    height: 24

    property int percent: 0
    property bool muted: false

    function icon() {
        if (root.muted) return "🔇"
        if (root.percent >= 66) return "🔊"
        if (root.percent >= 33) return "🔉"
        if (root.percent > 0) return "🔈"
        return "🔈"
    }

    Row {
        id: row
        spacing: 4
        Text {
            color: root.muted ? "#6c7086" : "#cdd6f4"
            font.pixelSize: 13
            text: root.icon()
        }
        Text {
            color: root.muted ? "#6c7086" : "#cdd6f4"
            font.pixelSize: 13
            text: root.percent + "%"
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onClicked: {
            toggleMute.running = true
        }
        onWheel: wheel => {
            const step = wheel.angleDelta.y > 0 ? "5%+" : "5%-"
            setVolume.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", step]
            setVolume.running = true
        }
    }

    Process {
        id: setVolume
        onExited: root.refresh()
    }

    Process {
        id: toggleMute
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: root.refresh()
    }

    Process {
        id: queryVolume
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                // formato: "Volume: 0.45" o "Volume: 0.45 [MUTED]"
                const text = this.text.trim()
                root.muted = text.indexOf("MUTED") !== -1
                const match = text.match(/[\d.]+/)
                if (match) {
                    root.percent = Math.round(parseFloat(match[0]) * 100)
                }
            }
        }
    }

    function refresh() {
        queryVolume.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
