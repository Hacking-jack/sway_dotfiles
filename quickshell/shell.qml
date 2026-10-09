import "./modules"
import "./services"
import Quickshell
import QtQuick

ShellRoot {
    Sway {
        id: swayService
    }

    Bar {
        sway: swayService
    }
}
