import Quickshell.Services.UPower
import QtQuick

Item {
    id: root
    width: row.width
    height: 24

    property var device: UPower.displayDevice

    function icon() {
        if (!device || !device.isLaptopBattery) return "🔌"
        const p = device.percentage * 100
        const charging = device.state === UPowerDeviceState.Charging
        if (charging) return "⚡"
        if (p >= 90) return "🔋"
        if (p >= 60) return "🔋"
        if (p >= 30) return "🪫"
        return "🪫"
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
            color: (root.device && root.device.percentage * 100 <= 15 && root.device.state !== UPowerDeviceState.Charging)
                ? "#f38ba8" : "#cdd6f4"
            font.pixelSize: 13
            text: root.device ? Math.round(root.device.percentage * 100) + "%" : "--%"
        }
    }
}
