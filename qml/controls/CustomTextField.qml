import QtQuick 2.11
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0

TextField {
    id: textField

    // Custom Properties
    property color colorDefault: "#282c34"
    property color colorOnFocus: "#242831"
    property color colorMouseOver: "#2B2F38"


    QtObject{
        id: internal

        property var dynamicColor: if(textField.activeFocus){
                                        textField.containsMouse ? colorOnFocus : colorDefault
                                   }else{
                                       textField.containsMouse ? colorMouseOver : colorDefault
                                   }
    }

    width: 300
    height: 30
    placeholderText: qsTr("Type something")
    color: "#ffffff"
    background: Rectangle {
        color: internal.dynamicColor
        radius: 10
    }

    selectByMouse: true
    selectedTextColor: "#FFFFFF"
    selectionColor: "#ff007f"
    placeholderTextColor: "#81848c"
}
