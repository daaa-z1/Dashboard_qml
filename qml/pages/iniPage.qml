import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4

Item {
    Rectangle {
        id: rectangle
        color: "#2c313c"
        anchors.fill: parent

        Image {
            id: image
            source: "../../images/dash1.png"
            height: parent.height
            width: parent.width
        }
    }

    Connections {
        target: backend
    }
}
