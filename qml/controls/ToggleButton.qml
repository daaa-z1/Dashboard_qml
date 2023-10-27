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

    background: Rectangle {
        color: btnToggle.pressed ? btnColorClicked : (btnToggle.hovered ? btnColorMouseOver : btnColorDefault)
        radius: 10
    }

    implicitWidth: 60
    implicitHeight: 60

    Image {
        id: iconBtn
        source: btnIconSource
        anchors.centerIn: parent
        height: 25
        width: 25
        fillMode: Image.PreserveAspectFit
    }

    onClicked: {
        iconBtn.visible = !internal.clicked;
        bgBtn.color = internal.clicked ? btnColorClicked : btnColorDefault;
    }
}
