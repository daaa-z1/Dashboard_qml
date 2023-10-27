import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    visible: true
    width: 600
    height: 400
    title: "QT 5.11.3 Conversion"

    Rectangle {
        id: rectangle
        color: "#2c313c"
        anchors.fill: parent

        Rectangle {
            id: rectangleTop
            height: 69
            color: "#495163"
            radius: 10
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottomMargin: 50
            anchors.topMargin: 40

            GridLayout {
                anchors.fill: parent
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                rows: 1
                columns: 3

                TextField {
                    id: textField
                    placeholderText: "Type your name"
                    Layout.fillWidth: true
                    Keys.onPressed: {
                        if (event.key === Qt.Key_Return) {
                            backend.welcomeText(textField.text);
                        }
                    }
                }

                Button {
                    id: btnChangeName
                    text: "Change Name"
                    Layout.maximumWidth: 200
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 250
                    onClicked: {
                        backend.welcomeText(textField.text);
                    }
                }

                Switch {
                    id: switchHome
                    text: qsTr("Sw")
                    checked: true
                    Layout.preferredHeight: 40
                    Layout.preferredWidth: 68
                    onCheckedChanged: {
                        backend.showHideRectangle(switchHome.checked, 611);
                    }
                }
            }
        }
    }

    Rectangle {
        id: rectangleVisible
        color: "#1d2128"
        radius: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rectangleTop.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.rightMargin: 50
        anchors.leftMargin: 50
        anchors.topMargin: 10

        Text {
            id: labelTextName
            y: 8
            height: 25
            color: "#5c667d"
            text: qsTr("Welcome")
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            font.pointSize: 14
        }

        Text {
            id: labelDate
            y: 31
            height: 25
            color: "#55aaff"
            text: qsTr("Date")
            anchors.left: parent.left
            anchors.right: parent.right
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            font.pointSize: 12
        }

        ScrollView {
            id: scrollView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: labelDate.bottom
            anchors.bottom: parent.bottom
            clip: true
            anchors.rightMargin: 10
            anchors.leftMargin: 10
            anchors.bottomMargin: 10
            anchors.topMargin: 10

            Rectangle {
                color: "#00000000"
                anchors.fill: parent
                Text {
                    anchors.fill: parent
                    color: "#e0e0e0"
                    font.pointSize: 12
                    text: "Total Servo Expert APP made by Total Servo Hydraulic"
                    width: 150
                    height: 100
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    Connections {
        target: backend

        function onSetName(name) {
            labelTextName.text = name
        }

        function onPrintTime(time) {
            labelDate.text = time
        }

        function onIsVisible(isVisible) {
            rectangleVisible.visible = isVisible
        }
    }
}
