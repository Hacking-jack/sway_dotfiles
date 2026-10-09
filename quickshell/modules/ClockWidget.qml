import QtQuick

Item {
    id: root
    width: label.width + 16
    height: 24

    property alias calendar: calendarLoader.item

    Text {
        id: label
        anchors.centerIn: parent
        color: "#cdd6f4"
        font.pixelSize: 13
        text: Qt.formatDateTime(new Date(), "ddd dd MMM  hh:mm")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: label.text = Qt.formatDateTime(new Date(), "ddd dd MMM  hh:mm")
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (calendarLoader.item)
                calendarLoader.item.visible = !calendarLoader.item.visible
        }
    }

    Loader {
        id: calendarLoader
        source: "CalendarPopup.qml"
        onLoaded: {
            item.anchor.item = root
            item.anchor.rect.x = -80
            item.anchor.rect.y = 30
        }
    }
}
