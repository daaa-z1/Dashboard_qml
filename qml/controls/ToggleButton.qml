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
        property bool clicked: false

        // MOUSE OVER CHANGE COLOR
        property var dynamicColor: btnToggle.hovered ? btnColorMouseOver : btnColorDefault

        onClicked: {
            internal.clicked = !internal.clicked;
            btnToggle.clicked = internal.clicked;
        }
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
        }
    }

    onClicked: {
        iconBtn.color = internal.clicked ? btnColorClicked : "#ffffff"; // Ganti warna ikon saat diklik
    }
}
