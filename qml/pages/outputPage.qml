import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import "../controls"


Item {
    Rectangle {
        id: rectangle
        color: "#2c313c"
        anchors.fill: parent
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top

	//##################################################################
	Text
		{
		   text: qsTr("SWITCHES")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 16
		   font.bold : true
		}
	
	//## BUTTON 1
	Rectangle {
        id: rectbtn1
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 150
		anchors.top: parent.top
		anchors.topMargin: 100

		Text {
			id: textbtn1
			color: "white"
			text: "BUTTON 1"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn1
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn1') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn1
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn1')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn1',1);
					boxbtn1.color = "lime";
				}
				else{
					backend.set_switch('btn1',0);
					boxbtn1.color = "red";
				}
			}
		}
	}
	//## BUTTON 1

	//## BUTTON 2
	Rectangle {
        id: rectbtn2
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 300
		anchors.top: parent.top
		anchors.topMargin: 100

		Text {
			id: textbtn2
			color: "white"
			text: "BUTTON 2"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn2
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn2') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn2
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn2')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn2',1);
					boxbtn2.color = "lime";
				}
				else{
					backend.set_switch('btn2',0);
					boxbtn2.color = "red";
				}
			}
		}
	}
	//## BUTTON 2

	//## BUTTON 3
	Rectangle {
        id: rectbtn3
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 450
		anchors.top: parent.top
		anchors.topMargin: 100

		Text {
			id: textbtn3
			color: "white"
			text: "BUTTON 3"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn3
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn3') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn3
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn3')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn3',1);
					boxbtn3.color = "lime";
				}
				else{
					backend.set_switch('btn3',0);
					boxbtn3.color = "red";
				}
			}
		}
	}
	//## BUTTON 3

	//## BUTTON 4
	Rectangle {
        id: rectbtn4
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 600
		anchors.top: parent.top
		anchors.topMargin: 100

		Text {
			id: textbtn4
			color: "white"
			text: "BUTTON 4"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn4
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn4') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn4
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn4')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn4',1);
					boxbtn4.color = "lime";
				}
				else{
					backend.set_switch('btn4',0);
					boxbtn4.color = "red";
				}
			}
		}
	}
	//## BUTTON 4

	//## BUTTON 5
	Rectangle {
        id: rectbtn5
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 750
		anchors.top: parent.top
		anchors.topMargin: 100

		Text {
			id: textbtn5
			color: "white"
			text: "BUTTON 5"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn5
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn5') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn5
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn5')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn5',1);
					boxbtn5.color = "lime";
				}
				else{
					backend.set_switch('btn5',0);
					boxbtn5.color = "red";
				}
			}
		}
	}
	//## BUTTON 5

	//## BUTTON 6
	Rectangle {
        id: rectbtn6
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 900
		anchors.top: parent.top
		anchors.topMargin: 100

		Text {
			id: textbtn6
			color: "white"
			text: "BUTTON 6"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn6
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn6') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn6
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn6')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn6',1);
					boxbtn6.color = "lime";
				}
				else{
					backend.set_switch('btn6',0);
					boxbtn6.color = "red";
				}
			}
		}
	}
	//## BUTTON 6

	//## BUTTON 7
	Rectangle {
        id: rectbtn7
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 150
		anchors.top: parent.top
		anchors.topMargin: 300

		Text {
			id: textbtn7
			color: "white"
			text: "BUTTON 7"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn7
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn7') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn7
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn7')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn7',1);
					boxbtn7.color = "lime";
				}
				else{
					backend.set_switch('btn7',0);
					boxbtn7.color = "red";
				}
			}
		}
	}
	//## BUTTON 7

	//## BUTTON 8
	Rectangle {
        id: rectbtn8
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 300
		anchors.top: parent.top
		anchors.topMargin: 300

		Text {
			id: textbtn8
			color: "white"
			text: "BUTTON 8"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn8
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn8') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn8
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn8')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn8',1);
					boxbtn8.color = "lime";
				}
				else{
					backend.set_switch('btn8',0);
					boxbtn8.color = "red";
				}
			}
		}
	}
	//## BUTTON 8

	//## BUTTON 9
	Rectangle {
        id: rectbtn9
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 450
		anchors.top: parent.top
		anchors.topMargin: 300

		Text {
			id: textbtn9
			color: "white"
			text: "BUTTON 9"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn9
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn9') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn9
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn9')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn9',1);
					boxbtn9.color = "lime";
				}
				else{
					backend.set_switch('btn9',0);
					boxbtn9.color = "red";
				}
			}
		}
	}
	//## BUTTON 9

	//## BUTTON 10
	Rectangle {
        id: rectbtn10
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 600
		anchors.top: parent.top
		anchors.topMargin: 300

		Text {
			id: textbtn10
			color: "white"
			text: "BUTTON 10"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn10
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn10') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn10
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn10')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn10',1);
					boxbtn10.color = "lime";
				}
				else{
					backend.set_switch('btn10',0);
					boxbtn10.color = "red";
				}
			}
		}
	}
	//## BUTTON 10

	//## BUTTON 11
	Rectangle {
        id: rectbtn11
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 750
		anchors.top: parent.top
		anchors.topMargin: 300

		Text {
			id: textbtn11
			color: "white"
			text: "BUTTON 11"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn11
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn11') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn11
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn11')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn11',1);
					boxbtn11.color = "lime";
				}
				else{
					backend.set_switch('btn11',0);
					boxbtn11.color = "red";
				}
			}
		}
	}
	//## BUTTON 11

	//## BUTTON 12
	Rectangle {
        id: rectbtn12
		color: "red"
		border.color: "white"
		border.width: 1
		anchors.left: parent.left
		anchors.leftMargin: 900
		anchors.top: parent.top
		anchors.topMargin: 300

		Text {
			id: textbtn12
			color: "white"
			text: "BUTTON 12"
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			font.pointSize: 11
			horizontalAlignment: Text.AlignHCenter
		}

		Rectangle {
			id: boxbtn12
			anchors.top: parent.top
			anchors.topMargin: 35
			anchors.horizontalCenter: parent.horizontalCenter
			color: ((backend.get_switch('btn12') == "on") ? "lime" : "red");
			border.color: "white"
			border.width: 1
			width: 100
			height: 60
		}

		CustomSwitch{
			id: btn12
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 105
			backgroundHeight: 30
			backgroundWidth: 100
			colorbg: "lime"
			state: backend.get_switch('btn12')
			onSwitched:{
				if(on == true){
					backend.set_switch('btn12',1);
					boxbtn12.color = "lime";
				}
				else{
					backend.set_switch('btn12',0);
					boxbtn12.color = "red";
				}
			}
		}
	}
	//## BUTTON 12
	


	//##################################################################

   


	


    }
	
	Timer{
		id:tmoutput
		interval: 250
		repeat: true
		running: true
		onTriggered: {
		}
	}


	Connections{
        target: backend 
	}
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
