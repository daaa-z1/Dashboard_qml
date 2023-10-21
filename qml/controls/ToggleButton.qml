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
            visible: false
        }

        Rectangle {
            width: parent.width
            height: parent.height
            color: "#e0e0e0"
            opacity: 0.0
            visible: parent.down

            opacityMask: Rectangle {
                width: parent.width
                height: parent.height
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 0.5; color: "transparent" }
                    GradientStop { position: 1.0; color: "white" }
                }
            }
        }
    }
}
