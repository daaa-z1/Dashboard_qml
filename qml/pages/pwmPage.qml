import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import "../controls"

Item {
	//############ INI : Main Rectangle page ###########################
	Rectangle {
		id: rectangle
		color: "#2c313c"
		anchors.fill: parent


	//############ INI : Rectangle Container for Flow Parameter ###################
	Rectangle
	{
		id: rectFlowParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 30
		anchors.top: parent.top
		anchors.topMargin: 30
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Flow Parameter  ####################################
		Text
		{
		   text: qsTr("FLOW Parameter")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Flow Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: flowMinParam.left
		   anchors.verticalCenter: flowMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: flowMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('flow','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('flow', 'minimum_display', flowMinParam.text);
			}
		}

		//######## Space Flow Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: flowMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: flowMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: flowMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('flow','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('flow', 'maximum_display', flowMaxParam.text);
			}
		}

		//######## Space Flow Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: flowMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: flowMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: flowMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('flow','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('flow', 'minimum_input', flowMinValue.text);
			}
		}

		//######## Space Flow Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: flowMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: flowMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: flowMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('flow','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('flow', 'maximum_input', flowMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Flow Parameter ########################


	//############ INI : Rectangle Container for Inlet Parameter ###################
	Rectangle
	{
		id: rectInletParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 330
		anchors.top: parent.top
		anchors.topMargin: 30
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Inlet Parameter  ####################################
		Text
		{
		   text: qsTr("INLET Parameter")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Inlet Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: inletMinParam.left
		   anchors.verticalCenter: inletMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: inletMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('inlet','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('inlet', 'minimum_display', inletMinParam.text);
			}
		}

		//######## Space Inlet Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: inletMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: inletMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: inletMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('inlet','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('inlet', 'maximum_display', inletMaxParam.text);
			}
		}

		//######## Space Inlet Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: inletMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: inletMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: inletMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('inlet','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('inlet', 'minimum_input', inletMinValue.text);
			}
		}

		//######## Space Inlet Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: inletMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: inletMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: inletMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('inlet','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('inlet', 'maximum_input', inletMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Inlet Parameter ########################


	//############ INI : Rectangle Container for Pressure A Parameter ###################
	Rectangle
	{
		id: rectPressAParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 630
		anchors.top: parent.top
		anchors.topMargin: 30
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Pressure A Parameter  ####################################
		Text
		{
		   text: qsTr("PRESSURE A")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Pressure A Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: pressAMinParam.left
		   anchors.verticalCenter: pressAMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressAMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_a','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('pressure_a', 'minimum_display', pressAMinParam.text);
			}
		}

		//######## Space Pressure A Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: pressAMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: pressAMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressAMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_a','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('pressure_a', 'maximum_display', pressAMaxParam.text);
			}
		}

		//######## Space Pressure A Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: pressAMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: pressAMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressAMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_a','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('pressure_a', 'minimum_input', pressAMinValue.text);
			}
		}

		//######## Space Pressure A Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: pressAMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: pressAMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressAMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_a','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('pressure_a', 'maximum_input', pressAMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Pressure A Parameter ########################


	//############ INI : Rectangle Container for Pressure B Parameter ###################
	Rectangle
	{
		id: rectPressBParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 930
		anchors.top: parent.top
		anchors.topMargin: 30
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Pressure B Parameter  ####################################
		Text
		{
		   text: qsTr("PRESSURE B")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Pressure B Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: pressBMinParam.left
		   anchors.verticalCenter: pressBMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressBMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_b','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('pressure_b', 'minimum_display', pressBMinParam.text);
			}
		}

		//######## Space Pressure B Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: pressBMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: pressBMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressBMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_b','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('pressure_b', 'maximum_display', pressBMaxParam.text);
			}
		}

		//######## Space Pressure B Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: pressBMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: pressBMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressBMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_b','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('pressure_b', 'minimum_input', pressBMinValue.text);
			}
		}

		//######## Space Pressure B Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: pressBMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: pressBMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: pressBMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('pressure_b','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('pressure_b', 'maximum_input', pressBMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Pressure B Parameter ########################


//############ INI : Rectangle Container for Common mA Parameter ###################
	Rectangle
	{
		id: rectComAParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 30
		anchors.top: parent.top
		anchors.topMargin: 280
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Common mA Parameter  ####################################
		Text
		{
		   text: qsTr("COMMON mA")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Common mA Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: comAMinParam.left
		   anchors.verticalCenter: comAMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comAMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common_ma','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('common_ma', 'minimum_display', comAMinParam.text);
			}
		}

		//######## Space Common mA Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: comAMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: comAMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comAMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common_ma','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('common_ma', 'maximum_display', comAMaxParam.text);
			}
		}

		//######## Space Common mA Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: comAMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: comAMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comAMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common_ma','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('common_ma', 'minimum_input', comAMinValue.text);
			}
		}

		//######## Space Common mA Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: comAMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: comAMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comAMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common_ma','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('common_ma', 'maximum_input', comAMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Common mA Parameter ########################



	//############ INI : Rectangle Container for Common Parameter ###################
	Rectangle
	{
		id: rectComParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 330
		anchors.top: parent.top
		anchors.topMargin: 280
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Common Parameter  ####################################
		Text
		{
		   text: qsTr("COMMON")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Common Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: comMinParam.left
		   anchors.verticalCenter: comMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('common', 'minimum_display', comMinParam.text);
			}
		}

		//######## Space Common Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: comMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: comMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('common', 'maximum_display', comMaxParam.text);
			}
		}

		//######## Space Common Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: comMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: comMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('common', 'minimum_input', comMinValue.text);
			}
		}

		//######## Space Common Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: comMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: comMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: comMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('common','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('common', 'maximum_input', comMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Common Parameter ########################


	//############ INI : Rectangle Container for Aktual Valve mA Parameter ###################
	Rectangle
	{
		id: rectAktAParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 630
		anchors.top: parent.top
		anchors.topMargin: 280
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Aktual Ma Parameter  ####################################
		Text
		{
		   text: qsTr("AKTUAL mA")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Aktual Ma Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: aktualAMinParam.left
		   anchors.verticalCenter: aktualAMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualAMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_ma','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('aktual_ma', 'minimum_display', aktualAMinParam.text);
			}
		}

		//######## Space Aktual Ma Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: aktualAMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: aktualAMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualAMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_ma','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('aktual_ma', 'maximum_display', aktualAMaxParam.text);
			}
		}

		//######## Space Aktual Ma Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: aktualAMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: aktualAMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualAMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_ma','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('aktual_ma', 'minimum_input', aktualAMinValue.text);
			}
		}

		//######## Space Aktual Ma Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: aktualAMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: aktualAMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualAMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_ma','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('aktual_ma', 'maximum_input', aktualAMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Aktual Ma Parameter ########################


	//############ INI : Rectangle Container for Aktual Valve Parameter ###################
	Rectangle
	{
		id: rectAktParameter
		width: 290
		height: 240
		anchors.left: parent.left
		anchors.leftMargin: 930
		anchors.top: parent.top
		anchors.topMargin: 280
		color: "transparent"
		border.color: "gray"
		border.width: 2
		radius: 10

		//######## Space Aktual Parameter ####################################
		Text
		{
		   text: qsTr("AKTUAL")
		   anchors.horizontalCenter: parent.horizontalCenter
		   anchors.top: parent.top
		   anchors.topMargin: 10
		   color: "#00a5ff"
		   font.pointSize: 12
		   font.bold : true
		}


		//######## Space Aktual Min. Display #######################################
		Text
		{
		   text: qsTr("Min. Display")
		   anchors.right: aktualMinParam.left
		   anchors.verticalCenter: aktualMinParam.verticalCenter
		   anchors.rightMargin: 15
		   color: "#00a5ff"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualMinParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 60
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_valve','minimum_display')
			onTextChanged:
			{
				backend.set_parameter('aktual_valve', 'minimum_display', aktualMinParam.text);
			}
		}

		//######## Space Aktual Max. Display #######################################
		Text
		{
		   text: qsTr("Max. Display")
		   anchors.right: aktualMaxParam.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: aktualMaxParam.verticalCenter
		   color: "red"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualMaxParam
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 100
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_valve','maximum_display')
			onTextChanged:
			{
				backend.set_parameter('aktual_valve', 'maximum_display', aktualMaxParam.text);
			}
		}

		//######## Space Aktual Min. Value #######################################
		Text
		{
		   text: qsTr("Min. Value")
		   anchors.right: aktualMinValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: aktualMinValue.verticalCenter
		   color: "#80ff80"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualMinValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 140
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_valve','minimum_input')
			onTextChanged:
			{
				backend.set_parameter('aktual_valve', 'minimum_input', aktualMinValue.text);
			}
		}

		//######## Space Aktual Max. Value #######################################
		Text
		{
		   text: qsTr("Max. Value")
		   anchors.right: aktualMaxValue.left
		   anchors.rightMargin: 15
		   anchors.verticalCenter: aktualMaxValue.verticalCenter
		   color: "#ffa500"
		   font.pointSize: 8
		   font.bold : true
		}

		CustomTextField
		{
			id: aktualMaxValue
			anchors.left: parent.horizontalCenter
			anchors.top: parent.top
			anchors.topMargin: 180
			font.pointSize: 8
			horizontalAlignment: TextInput.AlignRight
			width: 120
			text: backend.get_parameter('aktual_valve','maximum_input')
			onTextChanged:
			{
				backend.set_parameter('aktual_valve', 'maximum_input', aktualMaxValue.text);
			}
		}

	}
	//######## END : Rectangle Container for Aktual Parameter ########################




	
	} //############ END : Main Rectangle page ###########################
	
	
	//######## INI Space for connections ###############################
	Connections{
        target: backend
	}
	//######## END : Space for connections##############################
}

