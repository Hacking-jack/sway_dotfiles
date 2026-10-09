import Quickshell
import Quickshell.Io
import QtQuick

// Servicio singleton-like: instánciarlo una vez en shell.qml y pasarlo
// a los módulos que lo necesiten (Workspaces.qml, etc).
Item {
    id: root

    property var workspaces: []
    property var focusedWorkspace: null

    // Escucha eventos de workspace en tiempo real
    Process {
        id: subscriber
        command: ["swaymsg", "-t", "subscribe", "-m", "[\"workspace\"]"]
        running: true

        stdout: SplitParser {
            onRead: data => root.refresh()
        }
    }

    // Pide el estado completo cada vez que hay un cambio
    Process {
        id: queryWorkspaces
        command: ["swaymsg", "-t", "get_workspaces"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(this.text)
                    root.workspaces = parsed
                    root.focusedWorkspace = parsed.find(ws => ws.focused) || null
                } catch (e) {
                    console.log("Sway.qml: error parseando get_workspaces:", e)
                }
            }
        }
    }

    function refresh() {
        queryWorkspaces.running = true
    }

    function switchTo(num) {
        Quickshell.execDetached(["swaymsg", "workspace", "" + num])
    }

    Component.onCompleted: refresh()
}
