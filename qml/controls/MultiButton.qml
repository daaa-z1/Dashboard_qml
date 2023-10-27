import QtQuick 2.11
import QtQuick.Controls 1.4

Item {
    id: button

    property string text: "Option: "
    property variant items: ["first"]
    property int currentSelection: 0

    signal selectionChanged(variant selection)
    signal clicked

    implicitWidth: 120
    implicitHeight: buttonText.implicitHeight + 10

    Button {
        id: buttonText
        width: parent.width
        height: parent.height

        background: Rectangle {
            radius: 10
            color: "#202020"
            border.color: "#a0a0a0"
            border.width: 2
        }

        contentItem: Text {
            text: button.text + button.items[currentSelection]
            clip: true
            font.bold: true
            font.pixelSize: 10
            color: "#e0e0e0"
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
        }

        onClicked: {
            currentSelection = (currentSelection + 1) % items.length;
            selectionChanged(button.items[currentSelection]);
        }
    }
}
