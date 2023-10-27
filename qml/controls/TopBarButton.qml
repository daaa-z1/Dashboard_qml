import QtQuick 2.11
import QtQuick.Controls 2.4

Button {
    id: btnTopBar

    // CUSTOM PROPERTIES
    property url btnIconSource: "../../images/svg_images/minimize_icon.svg"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23f72E"
    property color btnColorClicked: "#00a1f1"

    background: Rectangle {
        color: btnTopBar.pressed ? btnColorClicked : (btnTopBar.hovered ? btnColorMouseOver : btnColorDefault)
        radius: 5
        border.color: "transparent"
        border.width: 0
        anchors.fill: parent
        anchors.margins: 4
    }

    width: 35
    height: 35

    Image {
        id: iconBtn
        source: btnIconSource
        anchors.centerIn: parent
        height: 24
        width: 24
        fillMode: Image.PreserveAspectFit
        antialiasing: false
        color: "white" // Ganti warna ikon sesuai kebutuhan
    }
}
