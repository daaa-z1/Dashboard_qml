import QtQuick 2.11
import QtQuick.Controls 2.4

Button {
    id: btnTopBar
    // CUSTOM PROPERTIES
    property url btnIconSource: "../../images/svg_images/minimize_icon.svg"
    property color btnColorDefault: "#1c1d20"
    property color btnColorMouseOver: "#23f72E"
    property color btnColorClicked: "#00a1f1"

    QtObject {
        id: internal
        // MOUSE OVER AND CLICK CHANGE COLOR
        property var dynamicColor: btnTopBar.down ? btnColorClicked : (btnTopBar.hovered ? btnColorMouseOver : btnColorDefault)
    }

    width: 35
    height: 35

    background: Rectangle {
        id: bgBtn
        color: internal.dynamicColor
        radius: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.topMargin: 4
        anchors.bottomMargin: 4

        Image {
            id: iconBtn
            source: btnIconSource
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 24
            width: 24
            fillMode: Image.PreserveAspectFit
            antialiasing: false
        }

        Rectangle {
            anchors.fill: iconBtn
            color: btnTopBar.down ? "#000000" : ""
            opacity: btnTopBar.down ? 0.5 : 1
        }
    }
}
