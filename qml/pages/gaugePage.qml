import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.14
import QtQuick.Shapes 1.14
import QtGraphicalEffects 1.0

import "../controls"

Item {

	Rectangle {
		id: rectangle
		color: "#2c313c"
		anchors.fill: parent
		
	////////////////////////////////////////////////////////////////////
	// ############## INI GAUGE 1 ######################################
	Rectangle {
		id:rect1
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 60
        anchors.left : parent.left
        anchors.leftMargin: 50
        visible: true
        color: "#00000000"
		
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader1
			anchors.fill: parent
			opacity: 0.85  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge1.value)/(gauge1.maximumValue-gauge1.minimumValue))+pi*(0.8-(1.6*gauge1.maximumValue/(gauge1.maximumValue-gauge1.minimumValue))))
			// ANGLE= [1.6*PI*(MEASURE)/(MAX-MIN)]+PI*(0.8-(1.6*MAX/(MAX-MIN)))
			readonly property real pi: 3.1415926535897932384626433832795
			vertexShader: "
			uniform highp mat4 qt_Matrix;
			attribute highp vec4 qt_Vertex;
			attribute highp vec2 qt_MultiTexCoord0;
			varying highp vec2 coord;
			
			void main() {
				coord = qt_MultiTexCoord0;
				gl_Position = qt_Matrix * qt_Vertex;
				}"

			fragmentShader: "
			uniform lowp float qt_Opacity;
			uniform highp float angleBase;
			uniform highp float angle;
			varying highp vec2 coord;
			void main() {
				gl_FragColor = vec4(0.0,0.0,0.0,0.0); 
				highp vec2 d=2.0*coord-vec2(1.0,1.0);
				highp float r=length(d);
				if (0.6<=r && r<=0.9) {
					highp float a=atan(d.x,-d.y);
					if (angleBase<=a && a<=angle) {
						highp float p=(a-angleBase)/(angle-angleBase);
						gl_FragColor = vec4(0,0.0,0.4+0.6*p,p) * qt_Opacity;
						}
					}
				}"
			}
		//##### END Shader effect  #####################################
		CircularGauge {
			
			Behavior on value {
				NumberAnimation {
					duration: 900
				}
			}
			id: gauge1
			width: 0.9*rect1.width
			height: 0.9*rect1.width
			maximumValue: backend.get_parameter('flow','maximum_display')
			minimumValue: backend.get_parameter('flow','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style1
				labelInset: outerRadius * 0.22
				labelStepSize: Math.round((gauge1.maximumValue - gauge1.minimumValue)/100)*10
				minorTickmarkInset :45
				tickmarkInset : 6
				minorTickmarkCount : 5
				tickmarkStepSize : Math.round((gauge1.maximumValue - gauge1.minimumValue)/100)*10
				function degreesToRadians(degrees) {
					return degrees * (Math.PI / 180);
				}

				background: Canvas {
				
					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();
						/*
						ctx.beginPath();
						ctx.strokeStyle = "#ff8000";
						ctx.lineWidth = outerRadius * 0.1;
						ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						ctx.beginPath();
						ctx.strokeStyle = "#ffff00";
						ctx.lineWidth = outerRadius * 0.05;
						ctx.arc(outerRadius, outerRadius, 0.75*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						*/
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge1.maximumValue) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge1.maximumValue) - 90));
						ctx.stroke();
						
					}
				}

				
				tickmark: Rectangle {
					visible: true //styleData.value > 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
					implicitWidth: outerRadius * 0.03
					antialiasing: true
					implicitHeight: outerRadius * 0.05
					color: styleData.value <= 50 ? "#ffff00" : "#ffff00"
				}
				

				minorTickmark: Rectangle {
					visible: true //styleData.value > 0 //styleData.value < 20  //|| styleData.value % 1 == 0
					implicitWidth: outerRadius * 0.05
					antialiasing: true
					implicitHeight: outerRadius * 0.07
					color: styleData.value < gauge1.value ? "#00ff00" : "#404040"
					
				}

				tickmarkLabel:  Text {
					visible: true //styleData.value > 0
					font.pixelSize: Math.max(6, outerRadius * 0.12)
					text: styleData.value
					color: styleData.value <= 40 ? "#e0e0e0" : "#e0e0e0"
					antialiasing: true
				}
				//#################
				needle: Canvas {
					property real needleBaseWidth: 10
					property real needleLength: outerRadius
					property real needleTipWidth: 1
					property real needleShort: outerRadius*0.6
					implicitWidth: needleBaseWidth
					implicitHeight: needleLength

					property real xCenter: width / 2
					property real yCenter: height / 2

					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();

						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort);
						ctx.lineTo(xCenter - needleBaseWidth / 2, (height-needleShort) - needleBaseWidth / 2);
						ctx.lineTo(xCenter - needleTipWidth / 2, 0);
						//ctx.lineTo(xCenter, yCenter - needleLength-needleShort);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.rgba(0, 0.9, 0, 0.9);
						ctx.fill();

						
						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort)
						ctx.lineTo(width, height-needleShort - needleBaseWidth / 2);
						ctx.lineTo(xCenter + needleTipWidth / 2, 0);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.lighter(Qt.rgba(0, 0.7, 0, 0.9));
						ctx.fill();
						
					}
				}
				//##################
				foreground: Item {
					Rectangle {
					}
				}

			}
			Rectangle {
				id:rectsg1
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.50*gauge1.width
				height: 0.13*gauge1.height
				color: "#00000000"
				Text {
					id:textgauge1
					anchors.horizontalCenter: parent.horizontalCenter
					width: parent.width
					y: 70
					text: gauge1.value.toFixed(2)
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.family: "Helvetica"
					font.pointSize: Math.max(10, parent.width * 0.17)
					color:"#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg1a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge1.width
				height: 0.13*gauge1.width
				color: "#00000000"
				Text {
					id:textgauge1a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "L/M"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "FLOW"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge1.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
	// ############## FIN GAUGE 1  #####################################
	
	////////////////////////////////////////////////////////////////////
	
	// ############## INI GAUGE 2  #####################################
	Rectangle {
		id:rect2
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 60
        anchors.left : parent.left
        anchors.leftMargin: 300
        visible: true
        color: "#00000000"
		
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader2
			anchors.fill: parent
			opacity: 0.85  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge2.value)/(gauge2.maximumValue-gauge2.minimumValue))+pi*(0.8-(1.6*gauge2.maximumValue/(gauge2.maximumValue-gauge2.minimumValue))))
			// ANGLE= [1.6*PI*(MEASURE)/(MAX-MIN)]+PI*(0.8-(1.6*MAX/(MAX-MIN)))
			readonly property real pi: 3.1415926535897932384626433832795
			vertexShader: "
			uniform highp mat4 qt_Matrix;
			attribute highp vec4 qt_Vertex;
			attribute highp vec2 qt_MultiTexCoord0;
			varying highp vec2 coord;
			
			void main() {
				coord = qt_MultiTexCoord0;
				gl_Position = qt_Matrix * qt_Vertex;
				}"

			fragmentShader: "
			uniform lowp float qt_Opacity;
			uniform highp float angleBase;
			uniform highp float angle;
			varying highp vec2 coord;
			void main() {
				gl_FragColor = vec4(0.0,0.0,0.0,0.0); 
				highp vec2 d=2.0*coord-vec2(1.0,1.0);
				highp float r=length(d);
				if (0.6<=r && r<=0.9) {
					highp float a=atan(d.x,-d.y);
					if (angleBase<=a && a<=angle) {
						highp float p=(a-angleBase)/(angle-angleBase);
						gl_FragColor = vec4(0,0.0,0.4+0.6*p,p) * qt_Opacity;
						}
					}
				}"
			}
		//##### END Shader effect  #####################################
		CircularGauge {
			
			Behavior on value {
				NumberAnimation {
					duration: 900
				}
			}
			id: gauge2
			width: 0.9*rect2.width
			height: 0.9*rect2.width
			maximumValue: backend.get_parameter('inlet','maximum_display')
			minimumValue: backend.get_parameter('inlet','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style2
				labelInset: outerRadius * 0.22
				labelStepSize: Math.round((gauge2.maximumValue - gauge2.minimumValue)/100)*10
				minorTickmarkInset : 45
				tickmarkInset : 6
				minorTickmarkCount : 5
				tickmarkStepSize : Math.round((gauge2.maximumValue - gauge2.minimumValue)/100)*10
				function degreesToRadians(degrees) {
					return degrees * (Math.PI / 180);
				}

				background: Canvas {
				
					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();
						/*
						ctx.beginPath();
						ctx.strokeStyle = "#ff8000";
						ctx.lineWidth = outerRadius * 0.1;
						ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						ctx.beginPath();
						ctx.strokeStyle = "#ffff00";
						ctx.lineWidth = outerRadius * 0.05;
						ctx.arc(outerRadius, outerRadius, 0.75*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						*/
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge2.maximumValue) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge2.maximumValue) - 90));
						ctx.stroke();
						
					}
				}

				
				tickmark: Rectangle {
					visible: true //styleData.value > 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
					implicitWidth: outerRadius * 0.03
					antialiasing: true
					implicitHeight: outerRadius * 0.05
					color: styleData.value <= 50 ? "#ffff00" : "#ffff00"
				}
				

				minorTickmark: Rectangle {
					visible: true //styleData.value > 0 //styleData.value < 20  //|| styleData.value % 1 == 0
					implicitWidth: outerRadius * 0.05
					antialiasing: true
					implicitHeight: outerRadius * 0.07
					color: styleData.value < gauge2.value ? "#00ff00" : "#404040"
					
				}

				tickmarkLabel:  Text {
					visible: true //styleData.value > 0
					font.pixelSize: Math.max(6, outerRadius * 0.12)
					text: styleData.value
					color: styleData.value <= 40 ? "#e0e0e0" : "#e0e0e0"
					antialiasing: true
				}
				//#################
				needle: Canvas {
					property real needleBaseWidth: 10
					property real needleLength: outerRadius
					property real needleTipWidth: 1
					property real needleShort: outerRadius*0.6
					implicitWidth: needleBaseWidth
					implicitHeight: needleLength

					property real xCenter: width / 2
					property real yCenter: height / 2

					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();

						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort);
						ctx.lineTo(xCenter - needleBaseWidth / 2, (height-needleShort) - needleBaseWidth / 2);
						ctx.lineTo(xCenter - needleTipWidth / 2, 0);
						//ctx.lineTo(xCenter, yCenter - needleLength-needleShort);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.rgba(0, 0.9, 0, 0.9);
						ctx.fill();

						
						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort)
						ctx.lineTo(width, height-needleShort - needleBaseWidth / 2);
						ctx.lineTo(xCenter + needleTipWidth / 2, 0);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.lighter(Qt.rgba(0, 0.7, 0, 0.9));
						ctx.fill();
						
					}
				}
				//##################
				foreground: Item {
					Rectangle {
					}
				}

			}
			Rectangle {
				id:rectsg2
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.50*gauge2.width
				height: 0.13*gauge2.width
				color: "#00000000"
				Text {
					id:textgauge2
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge2.value.toFixed(2)
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.family: "Helvetica"
					font.pointSize: Math.max(10, parent.width * 0.17)
					color:"#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg2a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge2.width
				height: 0.13*gauge2.width
				color: "#00000000"
				Text {
					id:textgauge2a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "BAR"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "INLET"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge2.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
	// ############## FIN GAUGE  2  ####################################
	
	////////////////////////////////////////////////////////////////////
	
		// ############## INI GAUGE 3  #####################################
	Rectangle {
		id:rect3
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 60
        anchors.left : parent.left
        anchors.leftMargin: 550
        visible: true
        color: "#00000000"
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader3
			antialiasing: true
			anchors.fill: parent
			opacity: 0.95  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge3.value)/(gauge3.maximumValue-gauge3.minimumValue))+pi*(0.8-(1.6*gauge3.maximumValue/(gauge3.maximumValue-gauge3.minimumValue))))
			// ANGLE= [1.6*PI*(MEASURE)/(MAX-MIN)]+PI*(0.8-(1.6*MAX/(MAX-MIN)))
			readonly property real pi: 3.1415926535897932384626433832795
			vertexShader: "
			uniform highp mat4 qt_Matrix;
			attribute highp vec4 qt_Vertex;
			attribute highp vec2 qt_MultiTexCoord0;
			varying highp vec2 coord;
			
			void main() {
				coord = qt_MultiTexCoord0;
				gl_Position = qt_Matrix * qt_Vertex;
				}"

			fragmentShader: "
			uniform lowp float qt_Opacity;
			uniform highp float angleBase;
			uniform highp float angle;
			varying highp vec2 coord;
			void main() {
				gl_FragColor = vec4(0.0,0.0,0.0,0.0); 
				highp vec2 d=2.0*coord-vec2(1.0,1.0);
				highp float r=length(d);
				if (0.45<=r && r<=0.55) {
					highp float a=atan(d.x,-d.y);
					if (angleBase<=a && a<=angle) {
						highp float p=(a-angleBase)/(angle-angleBase);
						gl_FragColor = vec4(0.4+0.6*p,0,0,p) * qt_Opacity;
						}
					}
				}"
			}
		//##### END Shader effect  #####################################
		CircularGauge {
			
			Behavior on value {
				NumberAnimation {
					duration: 900
				}
			}
			id: gauge3
			width: 0.9*rect3.width
			height: 0.9*rect3.width
			maximumValue: backend.get_parameter('pressure_a','maximum_display')
			minimumValue: backend.get_parameter('pressure_a','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style3
				labelInset: outerRadius * 0.01
				labelStepSize: Math.round((gauge3.maximumValue - gauge3.minimumValue)/100)*10
				minorTickmarkInset :25
				tickmarkInset : 14
				minorTickmarkCount : 5
				tickmarkStepSize : Math.round((gauge3.maximumValue - gauge3.minimumValue)/100)*10
				function degreesToRadians(degrees) {
					return degrees * (Math.PI / 180);
				}

				background: Canvas {
				
					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();
						/*
						ctx.beginPath();
						ctx.strokeStyle = "#ff8000";
						ctx.lineWidth = outerRadius * 0.1;
						ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						ctx.beginPath();
						ctx.strokeStyle = "#ffff00";
						ctx.lineWidth = outerRadius * 0.05;
						ctx.arc(outerRadius, outerRadius, 0.75*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.03;
						ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge3.maximumValue) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.03;
						ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge3.maximumValue) - 90));
						ctx.stroke();
						*/
						
					}
				}

				
				tickmark: Rectangle {
					visible: styleData.value >= 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
					implicitWidth: outerRadius * 0.03
					antialiasing: true
					implicitHeight: outerRadius * 0.2
					color: styleData.value <= 50 ? "#ffff00" : "#ffff00"
				}
				

				minorTickmark: Rectangle {
					visible: true //styleData.value > 0 //styleData.value < 20  //|| styleData.value % 1 == 0
					implicitWidth: outerRadius * 0.01
					antialiasing: true
					implicitHeight: outerRadius * 0.1
					color: styleData.value <= 40 ? "#00ff00" : "#00ff00"
				}

				tickmarkLabel:  Text {
					visible: styleData.value >= 0
					font.pixelSize: Math.max(6, outerRadius * 0.15)
					text: styleData.value
					color: styleData.value <= 40 ? "#e0e0e0" : "#e0e0e0"
					antialiasing: true
				}
				//#################
				needle: Canvas {
					property real needleBaseWidth: 10
					property real needleLength: outerRadius*0.7
					property real needleTipWidth: 1
					property real needleShort: outerRadius*0.01
					implicitWidth: needleBaseWidth
					implicitHeight: needleLength

					property real xCenter: width / 2
					property real yCenter: height / 2

					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();

						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort);
						ctx.lineTo(xCenter - needleBaseWidth / 2, (height-needleShort) - needleBaseWidth / 2);
						ctx.lineTo(xCenter - needleTipWidth / 2, 0);
						//ctx.lineTo(xCenter, yCenter - needleLength-needleShort);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.rgba(0, 0.9, 0, 0.9);
						ctx.fill();

						
						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort)
						ctx.lineTo(width, height-needleShort - needleBaseWidth / 2);
						ctx.lineTo(xCenter + needleTipWidth / 2, 0);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.lighter(Qt.rgba(0, 0.7, 0, 0.9));
						ctx.fill();
						
					}
				}
				//##################
				/*
				needle: Rectangle {
					y: outerRadius * -0.3
					implicitWidth: outerRadius * 0.05
					implicitHeight: outerRadius * 0.7
					antialiasing: true
					color: "#00ff00"
				}
				*/
				foreground: Item {
					Rectangle {
					}
				}

			}
			Rectangle {
				id:rectsg3
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.50*gauge3.width
				height: 0.13*gauge3.width
				color: "#00000000"
				Text {
					id:textgauge3
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge3.value.toFixed(2)
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.family: "Helvetica"
					font.pointSize: Math.max(10, parent.width * 0.17)
					color: "#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg3a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge3.width
				height: 0.13*gauge3.width
				color: "#00000000"
				Text {
					id:textgauge3a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "BAR"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "PRESSURE A"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge3.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
	// ############## FIN GAUGE  3  ####################################


	////////////////
	Rectangle {
		id:rect4
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 60
        anchors.left : parent.left
        anchors.leftMargin: 800
        visible: true
        color: "#00000000"
		
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader4
			antialiasing: true
			anchors.fill: parent
			opacity: 0.95  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge4.value)/(gauge4.maximumValue-gauge4.minimumValue))+pi*(0.8-(1.6*gauge4.maximumValue/(gauge4.maximumValue-gauge4.minimumValue))))
			// ANGLE= [1.6*PI*(MEASURE)/(MAX-MIN)]+PI*(0.8-(1.6*MAX/(MAX-MIN)))
			readonly property real pi: 3.1415926535897932384626433832795
			vertexShader: "
			uniform highp mat4 qt_Matrix;
			attribute highp vec4 qt_Vertex;
			attribute highp vec2 qt_MultiTexCoord0;
			varying highp vec2 coord;
			
			void main() {
				coord = qt_MultiTexCoord0;
				gl_Position = qt_Matrix * qt_Vertex;
				}"

			fragmentShader: "
			uniform lowp float qt_Opacity;
			uniform highp float angleBase;
			uniform highp float angle;
			varying highp vec2 coord;
			void main() {
				gl_FragColor = vec4(0.0,0.0,0.0,0.0); 
				highp vec2 d=2.0*coord-vec2(1.0,1.0);
				highp float r=length(d);
				if (0.45<=r && r<=0.55) {
					highp float a=atan(d.x,-d.y);
					if (angleBase<=a && a<=angle) {
						highp float p=(a-angleBase)/(angle-angleBase);
						gl_FragColor = vec4(0.4+0.6*p,0,0,p) * qt_Opacity;
						}
					}
				}"
			}
		//##### END Shader effect  #####################################
		CircularGauge {
			
			Behavior on value {
				NumberAnimation {
					duration: 900
				}
			}
			id: gauge4
			width: 0.9*rect4.width
			height: 0.9*rect4.width
			maximumValue: backend.get_parameter('pressure_b','maximum_display')
			minimumValue: backend.get_parameter('pressure_b','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style4
				labelInset: outerRadius * 0.01
				labelStepSize: Math.round((gauge4.maximumValue - gauge4.minimumValue)/100)*10
				minorTickmarkInset :25
				tickmarkInset : 14
				minorTickmarkCount : 5
				tickmarkStepSize : Math.round((gauge4.maximumValue - gauge4.minimumValue)/100)*10
				function degreesToRadians(degrees) {
					return degrees * (Math.PI / 180);
				}

				background: Canvas {
				
					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();
						/*
						ctx.beginPath();
						ctx.strokeStyle = "#ff8000";
						ctx.lineWidth = outerRadius * 0.1;
						ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						ctx.beginPath();
						ctx.strokeStyle = "#ffff00";
						ctx.lineWidth = outerRadius * 0.05;
						ctx.arc(outerRadius, outerRadius, 0.75*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(20) - 90), degreesToRadians(valueToAngle(50) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.03;
						ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge3.maximumValue) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.03;
						ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge3.maximumValue) - 90));
						ctx.stroke();
						*/
						
					}
				}

				
				tickmark: Rectangle {
					visible: styleData.value >= 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
					implicitWidth: outerRadius * 0.03
					antialiasing: true
					implicitHeight: outerRadius * 0.2
					color: styleData.value <= 50 ? "#ffff00" : "#ffff00"
				}
				

				minorTickmark: Rectangle {
					visible: true //styleData.value > 0 //styleData.value < 20  //|| styleData.value % 1 == 0
					implicitWidth: outerRadius * 0.01
					antialiasing: true
					implicitHeight: outerRadius * 0.1
					color: styleData.value <= 40 ? "#00ff00" : "#00ff00"
				}

				tickmarkLabel:  Text {
					visible: styleData.value >= 0
					font.pixelSize: Math.max(6, outerRadius * 0.15)
					text: styleData.value
					color: styleData.value <= 40 ? "#e0e0e0" : "#e0e0e0"
					antialiasing: true
				}
				//#################
				needle: Canvas {
					property real needleBaseWidth: 10
					property real needleLength: outerRadius*0.7
					property real needleTipWidth: 1
					property real needleShort: outerRadius*0.01
					implicitWidth: needleBaseWidth
					implicitHeight: needleLength

					property real xCenter: width / 2
					property real yCenter: height / 2

					onPaint: {
						var ctx = getContext("2d");
						ctx.reset();

						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort);
						ctx.lineTo(xCenter - needleBaseWidth / 2, (height-needleShort) - needleBaseWidth / 2);
						ctx.lineTo(xCenter - needleTipWidth / 2, 0);
						//ctx.lineTo(xCenter, yCenter - needleLength-needleShort);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.rgba(0, 0.9, 0, 0.9);
						ctx.fill();

						
						ctx.beginPath();
						ctx.moveTo(xCenter, height-needleShort)
						ctx.lineTo(width, height-needleShort - needleBaseWidth / 2);
						ctx.lineTo(xCenter + needleTipWidth / 2, 0);
						ctx.lineTo(xCenter, 0);
						ctx.closePath();
						ctx.fillStyle = Qt.lighter(Qt.rgba(0, 0.7, 0, 0.9));
						ctx.fill();
						
					}
				}
				//##################
				/*
				needle: Rectangle {
					y: outerRadius * -0.3
					implicitWidth: outerRadius * 0.05
					implicitHeight: outerRadius * 0.7
					antialiasing: true
					color: "#00ff00"
				}
				*/
				foreground: Item {
					Rectangle {
					}
				}

			}
			Rectangle {
				id:rectsg4
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.50*gauge4.width
				height: 0.13*gauge4.width
				color: "#00000000"
				Text {
					id:textgauge4
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge4.value.toFixed(2)
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.family: "Helvetica"
					font.pointSize: Math.max(10, parent.width * 0.17)
					color: "#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg4a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge4.width
				height: 0.13*gauge4.width
				color: "#00000000"
				Text {
					id:textgauge4a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "BAR"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "PRESSURE B"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge4.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
	// ############## FIN GAUGE  7  ####################################

	Rectangle {
        id: recswitches
        anchors.top : parent.top
        anchors.topMargin: 320
        anchors.left : parent.left
        anchors.leftMargin: 50
		width: parent.width * 0.8

		//SWITCH 1
		Rectangle {
        id: rectswitch1
		anchors.left: parent.left
		anchors.leftMargin: 100
		anchors.top: parent.top

			Text {
				id: textswitch1
				color: "white"
				text: "START"
				anchors.horizontalCenter: parent.horizontalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.top: parent.top
				font.pointSize: 11
			}

			Rectangle {
				id: boxswitch1
				anchors.top: parent.top
				anchors.topMargin: 35
				anchors.horizontalCenter: parent.horizontalCenter
				color: ((backend.get_switch('start') == "on") ? "lime" : "red");
				border.color: "white"
				border.width: 1
				width: 100
				height: 60
			}

			CustomSwitch{
				id: ledswitch1
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 105
				backgroundHeight: 30
				backgroundWidth: 100
				colorbg: "lime"
				state: backend.get_switch('start')
				onSwitched:{
					if(on == true){
						backend.set_switch('start',1);
						boxswitch1.color = "lime";
					}
					else{
						backend.set_switch('start',0);
						boxswitch1.color = "red";
					}
				}
			}
		}
		//SWITCH 1 END

		//SWITCH 2
		Rectangle {
        id: rectswitch2
		anchors.left: parent.left
		anchors.leftMargin: 250
		anchors.top: parent.top

			Text {
				id: textswitch2
				color: "white"
				text: "LAMP"
				anchors.horizontalCenter: parent.horizontalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.top: parent.top
				font.pointSize: 11
			}

			Rectangle {
				id: boxswitch2
				anchors.top: parent.top
				anchors.topMargin: 35
				anchors.horizontalCenter: parent.horizontalCenter
				color: ((backend.get_switch('lamp') == "on") ? "lime" : "red");
				border.color: "white"
				border.width: 1
				width: 100
				height: 60
			}

			CustomSwitch{
				id: ledswitch2
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 105
				backgroundHeight: 30
				backgroundWidth: 100
				colorbg: "lime"
				state: backend.get_switch('lamp')
				onSwitched:{
					if(on == true){
						backend.set_switch('lamp',1);
						boxswitch2.color = "lime";
					}
					else{
						backend.set_switch('lamp',0);
						boxswitch2.color = "red";
					}
				}
			}
		}
		//SWITCH 2 END

		//SWITCH 3
		Rectangle {
        id: rectswitch3
		anchors.left: parent.left
		anchors.leftMargin: 400
		anchors.top: parent.top

			Text {
				id: textswitch3
				color: "white"
				text: "LOAD"
				anchors.horizontalCenter: parent.horizontalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.top: parent.top
				font.pointSize: 11
			}

			Rectangle {
				id: boxswitch3
				anchors.top: parent.top
				anchors.topMargin: 35
				anchors.horizontalCenter: parent.horizontalCenter
				color: ((backend.get_switch('load') == "on") ? "lime" : "red");
				border.color: "white"
				border.width: 1
				width: 100
				height: 60
			}

			CustomSwitch{
				id: ledswitch3
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 105
				backgroundHeight: 30
				backgroundWidth: 100
				colorbg: "lime"
				state: backend.get_switch('load')
				onSwitched:{
					if(on == true){
						backend.set_switch('load',1);
						boxswitch3.color = "lime";
					}
					else{
						backend.set_switch('load',0);
						boxswitch3.color = "red";
					}
				}
			}
		}
		//SWITCH 3 END

		//SWITCH 4
		Rectangle {
        id: rectswitch4
		anchors.left: parent.left
		anchors.leftMargin: 550
		anchors.top: parent.top

			Text {
				id: textswitch4
				color: "white"
				text: "LEAK TEST"
				anchors.horizontalCenter: parent.horizontalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.top: parent.top
				font.pointSize: 11
			}

			Rectangle {
				id: boxswitch4
				anchors.top: parent.top
				anchors.topMargin: 35
				anchors.horizontalCenter: parent.horizontalCenter
				color: ((backend.get_switch('leak_test') == "on") ? "lime" : "red");
				border.color: "white"
				border.width: 1
				width: 100
				height: 60
			}

			CustomSwitch{
				id: ledswitch4
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 105
				backgroundHeight: 30
				backgroundWidth: 100
				colorbg: "lime"
				state: backend.get_switch('leak_test')
				onSwitched:{
					if(on == true){
						backend.set_switch('leak_test',1);
						boxswitch4.color = "lime";
					}
					else{
						backend.set_switch('leak_test',0);
						boxswitch4.color = "red";
					}
				}
			}
		}
		//SWITCH 4 END

		//SWITCH 5
		Rectangle {
        id: rectswitch5
		anchors.left: parent.left
		anchors.leftMargin: 700
		anchors.top: parent.top

			Text {
				id: textswitch5
				color: "white"
				text: "A TO TANK"
				anchors.horizontalCenter: parent.horizontalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.top: parent.top
				font.pointSize: 11
			}

			Rectangle {
				id: boxswitch5
				anchors.top: parent.top
				anchors.topMargin: 35
				anchors.horizontalCenter: parent.horizontalCenter
				color: ((backend.get_switch('a_to_tank') == "on") ? "lime" : "red");
				border.color: "white"
				border.width: 1
				width: 100
				height: 60
			}

			CustomSwitch{
				id: ledswitch5
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 105
				backgroundHeight: 30
				backgroundWidth: 100
				colorbg: "lime"
				state: backend.get_switch('a_to_tank')
				onSwitched:{
					if(on == true){
						backend.set_switch('a_to_tank',1);
						boxswitch5.color = "lime";
					}
					else{
						backend.set_switch('a_to_tank',0);
						boxswitch5.color = "red";
					}
				}
			}
		}
		//SWITCH 5 END

		//SWITCH 6
		Rectangle {
        id: rectswitch6
		anchors.left: parent.left
		anchors.leftMargin: 850
		anchors.top: parent.top

			Text {
				id: textswitch6
				color: "white"
				text: "B TO TANK"
				anchors.horizontalCenter: parent.horizontalCenter
				horizontalAlignment: Text.AlignHCenter
				anchors.top: parent.top
				font.pointSize: 11
			}

			Rectangle {
				id: boxswitch6
				anchors.top: parent.top
				anchors.topMargin: 35
				anchors.horizontalCenter: parent.horizontalCenter
				color: ((backend.get_switch('b_to_tank') == "on") ? "lime" : "red");
				border.color: "white"
				border.width: 1
				width: 100
				height: 60
			}

			CustomSwitch{
				id: ledswitch6
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: parent.top
				anchors.topMargin: 105
				backgroundHeight: 30
				backgroundWidth: 100
				colorbg: "lime"
				state: backend.get_switch('b_to_tank')
				onSwitched:{
					if(on == true){
						backend.set_switch('b_to_tank',1);
						boxswitch6.color = "lime";
					}
					else{
						backend.set_switch('b_to_tank',0);
						boxswitch6.color = "red";
					}
				}
			}
		}
		//SWITCH 6 END

		
	}

	Rectangle {
		id: recttemp
		color: "#2c313c"
		width: 80
		height: 350
		anchors.top : parent.top
		anchors.topMargin: 70
		anchors.left : parent.left
		anchors.leftMargin: 1080

		
		Gauge {
			id: tempbox
			anchors.fill: parent
			anchors.margins: 10
			width: 80
			height: 350
			minimumValue: 0
			maximumValue: 100

			value: 0
			Behavior on value {
				NumberAnimation {
					duration: 1000
				}
			}

			style: GaugeStyle {
				valueBar: Rectangle {
					border.width: 1
					border.color: "white"
					implicitWidth: 16
					color: Qt.rgba(tempbox.value / tempbox.maximumValue, 0, 1 - tempbox.value / tempbox.maximumValue, 1)
				}
			}

			Label {
                text: "OIL TEMP"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: tempbox.top
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
		
		Text {
			id: texttemp
			color: "white"
			text: "0°C"
			width: parent.width
			anchors.top: tempbox.bottom
			anchors.topMargin: 10
			anchors.horizontalCenter: parent.horizontalCenter
			horizontalAlignment: Text.AlignHCenter
			font.pointSize: 10
		}
	}

}	
	//
	Timer{
		id:tmgauge
		interval: 250
		repeat: true
		running: true
		onTriggered: {
			gauge1.value = Math.round(backend.get_value('flow')*100)/100 //FLOW
			gauge2.value = Math.round(backend.get_value('inlet')*100)/100 //INSET
			gauge3.value = Math.round(backend.get_value('pressure_a')*100)/100 //PRESSURE A
			gauge4.value = Math.round(backend.get_value('pressure_b')*100)/100 //PRESSURE B
			tempbox.value = Math.round(backend.get_value('temp')*100)/100 //TEMP
			texttemp.text = Math.round(tempbox.value * 100)/100+"°C"
		}
	}
	
	
	Connections{
		target: backend
		//function onValueGauge(value){
        //   slider.value = value/10
        //   progressIndicator.value = value
        //   customSlider.value = value
        //}
	}
}

