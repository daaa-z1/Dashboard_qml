import QtQuick 2.11
import QtQuick.Controls 2.2

Slider {
    id: control
    stepSize: 1
    property string bgcolor : "#21be2b"

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: "#c0c0c0"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color : control.bgcolor
            radius: 2
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"
        Label {
            anchors.centerIn: parent
            text: Number(control.value).toFixed()
        }
    }
}
