import QtQuick 2.11
import QtQuick.Controls 2.4

Button {
    id: btnToggle
    hoverEnabled: true

    // CUSTOM PROPERTIES
    property url btnIconSource: "../../images/svg_images/menu_icon.svg"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23272E"
    property color btnColorClicked: "#0080b0"

    QtObject {
        id: internal
        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: btnToggle.down ? btnColorClicked : (btnToggle.hovered ? btnColorMouseOver : btnColorDefault)
    }

    implicitWidth: 60
    implicitHeight: 60

    background: Rectangle {
        id: bgBtn
        color: internal.dynamicColor
        radius: 10

        Image {
            id: iconBtn
            source: btnIconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 25
            width: 25
            fillMode: Image.PreserveAspectFit

            // Simulate ColorOverlay effect
            color: "#e0e0e0"
        }
    }
}
