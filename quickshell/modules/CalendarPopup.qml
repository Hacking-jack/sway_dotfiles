import Quickshell
import Quickshell.Wayland
import QtQuick

PopupWindow {
    id: root
    implicitWidth: 240
    implicitHeight: 260
    visible: false
    color: "#1e1e2e"

    // Mes/año que se está mostrando (por defecto: el actual)
    property date viewDate: new Date()

    function daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate()
    }

    function firstWeekday(y, m) {
        // 0 = lunes ... 6 = domingo (ajustado desde el 0=domingo de JS)
        let d = new Date(y, m, 1).getDay()
        return (d + 6) % 7
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Row {
            width: parent.width
            Text {
                text: "‹"
                color: "#cdd6f4"
                font.pixelSize: 16
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() - 1, 1)
                }
            }
            Text {
                width: parent.width - 40
                horizontalAlignment: Text.AlignHCenter
                color: "#cdd6f4"
                font.bold: true
                text: Qt.formatDate(root.viewDate, "MMMM yyyy")
            }
            Text {
                text: "›"
                color: "#cdd6f4"
                font.pixelSize: 16
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.viewDate = new Date(root.viewDate.getFullYear(), root.viewDate.getMonth() + 1, 1)
                }
            }
        }

        Grid {
            columns: 7
            width: parent.width
            columnSpacing: 4
            rowSpacing: 4

            Repeater {
                model: ["L", "M", "X", "J", "V", "S", "D"]
                Text {
                    width: (root.width - 24 - 24) / 7
                    horizontalAlignment: Text.AlignHCenter
                    color: "#6c7086"
                    font.pixelSize: 11
                    text: modelData
                }
            }

            Repeater {
                model: root.firstWeekday(root.viewDate.getFullYear(), root.viewDate.getMonth())
                Item { width: (root.width - 24 - 24) / 7; height: 24 }
            }

            Repeater {
                model: root.daysInMonth(root.viewDate.getFullYear(), root.viewDate.getMonth())
                Rectangle {
                    width: (root.width - 24 - 24) / 7
                    height: 24
                    radius: 4
                    property bool isToday: {
                        const t = new Date()
                        return t.getDate() === (index + 1)
                            && t.getMonth() === root.viewDate.getMonth()
                            && t.getFullYear() === root.viewDate.getFullYear()
                    }
                    color: isToday ? "#89b4fa" : "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: index + 1
                        color: parent.isToday ? "#1e1e2e" : "#cdd6f4"
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
}
