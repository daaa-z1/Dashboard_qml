import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0

import QtQuick 2.14
import QtQuick.Controls 2.14
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
		
		
		////////////////
		Rectangle {
			id:rect4
			width: 220
			height: 220
			anchors.top : parent.top
			anchors.topMargin: 60
			anchors.left : parent.left
			anchors.leftMargin: 30
			visible: true
			color: "#00000000"
			
			//###### Shader effect to provide gradient-based gauge #########
			ShaderEffect {
				id: shader4
				anchors.fill: parent
				opacity: 0.85  
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
				id: gauge4
				width: 0.9*rect4.width
				height: 0.9*rect4.width
				maximumValue: backend.get_parameter('common_ma','maximum_display')
				minimumValue: backend.get_parameter('common_ma','minimum_display')
				value: 0
				anchors.centerIn: parent
				style: CircularGaugeStyle {
					id: style4
					labelInset: outerRadius * 0.22
					labelStepSize: Math.round((gauge4.maximumValue - gauge4.minimumValue)/100)*10
					minorTickmarkInset :45
					tickmarkInset : 6
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
							*/
							ctx.beginPath();
							ctx.strokeStyle = "#f0f0f0";
							ctx.lineWidth = outerRadius * 0.02;
							ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge4.maximumValue) - 90));
							ctx.stroke();
							
							ctx.beginPath();
							ctx.strokeStyle = "#f0f0f0";
							ctx.lineWidth = outerRadius * 0.02;
							ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge4.maximumValue) - 90));
							ctx.stroke();
							
						}
					}

					
					tickmark: Rectangle {
						visible: true // styleData.value > 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
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
						color: styleData.value < gauge4.value ? "#00ff00" : "#404040"
						
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
					id:rectsg4
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter 
					//y: 220
					width: 0.35*gauge4.width
					height: 0.13*gauge4.width
					color: "#00000000"
					Text {
						id:textgauge4
						anchors.horizontalCenter: parent.horizontalCenter
						y: 70
						width: parent.width
						text: gauge4.value
						font.family: "Helvetica"
						maximumLineCount: 1
						wrapMode: Text.WrapAnywhere
						horizontalAlignment: Text.AlignHCenter
						font.pointSize: Math.max(6, parent.width * 0.25)
						color:"#e5e5e5"
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
						text: "mA"
						font.family: "Helvetica"
						font.pointSize: Math.max(6, parent.width * 0.4)
						color: "#e5e5e5"
					}
				}
				Label {
					text: "COMMON mA"
					color: "#00A5FF"
					font.pointSize: 16
					anchors.bottom: gauge4.top
					anchors.bottomMargin: 10
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		
		}
		////////////////
		Rectangle {
			id:rect5
			width: 220
			height: 220
			anchors.top : parent.top
			anchors.topMargin: 60
			anchors.left : parent.left
			anchors.leftMargin: 280
			visible: true
			color: "#00000000"
			//###### Shader effect to provide gradient-based gauge #########
			ShaderEffect {
				id: shader5
				antialiasing: true
				anchors.fill: parent
				opacity: 0.95  
				property real angleBase: -pi*0.80
				property real angle: ((1.6*pi*(gauge5.value)/(gauge5.maximumValue-gauge5.minimumValue))+pi*(0.8-(1.6*gauge5.maximumValue/(gauge5.maximumValue-gauge5.minimumValue))))
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
				id: gauge5
				width: 0.9*rect5.width
				height: 0.9*rect5.width
				maximumValue: backend.get_parameter('common','maximum_display')
				minimumValue: backend.get_parameter('common','minimum_display')
				value: 0
				anchors.centerIn: parent
				style: CircularGaugeStyle {
					id: style5
					labelInset: outerRadius * 0.01
					labelStepSize: Math.ceil((gauge5.maximumValue - gauge5.minimumValue)/10)
					minorTickmarkInset :25
					tickmarkInset : 14
					minorTickmarkCount : 5
					tickmarkStepSize : Math.ceil((gauge5.maximumValue - gauge5.minimumValue)/10)
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
						visible: true //styleData.value >= 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
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
						visible: true //styleData.value >= 0
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
					id:rectsg5
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter 
					//y: 220
					width: 0.35*gauge5.width
					height: 0.13*gauge5.width
					color: "#00000000"
					Text {
						id:textgauge5
						anchors.horizontalCenter: parent.horizontalCenter
						y: 70
						width: parent.width
						text: gauge5.value.toFixed(2)
						font.family: "Helvetica"
						maximumLineCount: 1
						wrapMode: Text.WrapAnywhere
						horizontalAlignment: Text.AlignHCenter
						font.pointSize: Math.max(6, parent.width * 0.25)
						color: "#e5e5e5"
					}
				}
				//
				Rectangle {
					id:rectsg5a
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter 
					//y: 220
					width: 0.26*gauge5.width
					height: 0.13*gauge5.width
					color: "#00000000"
					Text {
						id:textgauge5a
						anchors.horizontalCenter: parent.horizontalCenter
						y: -10
						text: "VOLT"
						font.family: "Helvetica"
						font.pointSize: Math.max(6, parent.width * 0.4)
						color: "#e5e5e5"
					}
				}
				Label {
					text: "COMMON"
					color: "#00A5FF"
					font.pointSize: 16
					anchors.bottom: gauge5.top
					anchors.bottomMargin: 10
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		
		}
		/////////////////
		Rectangle {
			id:rect6
			width: 220
			height: 220
			anchors.top : parent.top
			anchors.topMargin: 60
			anchors.left : parent.left
			anchors.leftMargin: 530
			visible: true
			color: "#00000000"
			
			//###### Shader effect to provide gradient-based gauge #########
			ShaderEffect {
				id: shader6
				anchors.fill: parent
				opacity: 0.85  
				property real angleBase: -pi*0.80
				property real angle: ((1.6*pi*(gauge6.value)/(gauge6.maximumValue-gauge6.minimumValue))+pi*(0.8-(1.6*gauge6.maximumValue/(gauge6.maximumValue-gauge6.minimumValue))))
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
				id: gauge6
				width: 0.9*rect6.width
				height: 0.9*rect6.width
				maximumValue: backend.get_parameter('aktual_ma','maximum_display')
				minimumValue: backend.get_parameter('aktual_ma','minimum_display')
				value: 0
				anchors.centerIn: parent
				style: CircularGaugeStyle {
					id: style6
					labelInset: outerRadius * 0.22
					labelStepSize: Math.round((gauge6.maximumValue - gauge6.minimumValue)/100)*10
					minorTickmarkInset :45
					tickmarkInset : 6
					minorTickmarkCount : 5
					tickmarkStepSize : Math.round((gauge6.maximumValue - gauge6.minimumValue)/100)*10
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
							ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge6.maximumValue) - 90));
							ctx.stroke();
							
							ctx.beginPath();
							ctx.strokeStyle = "#f0f0f0";
							ctx.lineWidth = outerRadius * 0.02;
							ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge6.maximumValue) - 90));
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
						color: styleData.value < gauge6.value ? "#00ff00" : "#404040"
						
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
					id:rectsg6
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter 
					//y: 220
					width: 0.35*gauge6.width
					height: 0.13*gauge6.width
					color: "#00000000"
					Text {
						id:textgauge6
						anchors.horizontalCenter: parent.horizontalCenter
						y: 70
						width: parent.width
						text: gauge6.value.toFixed(2)
						font.family: "Helvetica"
						maximumLineCount: 1
						wrapMode: Text.WrapAnywhere
						horizontalAlignment: Text.AlignHCenter
						font.pointSize: Math.max(6, parent.width * 0.25)
						color:"#e5e5e5"
					}
				}
				//
				Rectangle {
					id:rectsg6a
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter 
					//y: 220
					width: 0.26*gauge6.width
					height: 0.13*gauge6.width
					color: "#00000000"
					Text {
						id:textgauge6a
						anchors.horizontalCenter: parent.horizontalCenter
						y: -10
						text: "mA"
						font.family: "Helvetica"
						font.pointSize: Math.max(6, parent.width * 0.4)
						color: "#e5e5e5"
					}
				}
				Label {
					text: "AKTUAL VALVE"
					color: "#00A5FF"
					font.pointSize: 16
					anchors.bottom: gauge6.top
					anchors.bottomMargin: 10
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		
		}
		
		
		////////////////
		Rectangle {
			id:rect8
			width: 220
			height: 220
			anchors.top : parent.top
			anchors.topMargin: 60
			anchors.left : parent.left
			anchors.leftMargin: 780
			visible: true
			color: "#00000000"
			//###### Shader effect to provide gradient-based gauge #########
			ShaderEffect {
				id: shader8
				antialiasing: true
				anchors.fill: parent
				opacity: 0.95  
				property real angleBase: -pi*0.80
				property real angle: ((1.6*pi*(gauge8.value)/(gauge8.maximumValue-gauge8.minimumValue))+pi*(0.8-(1.6*gauge8.maximumValue/(gauge8.maximumValue-gauge8.minimumValue))))
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
				id: gauge8
				width: 0.9*rect8.width
				height: 0.9*rect8.width
				maximumValue: backend.get_parameter('aktual_valve','maximum_display')
				minimumValue: backend.get_parameter('aktual_valve','minimum_display')
				value: 0
				anchors.centerIn: parent
				style: CircularGaugeStyle {
					id: style8
					labelInset: outerRadius * 0.01
					labelStepSize: Math.ceil((gauge8.maximumValue - gauge8.minimumValue)/10)
					minorTickmarkInset :25
					tickmarkInset : 14
					minorTickmarkCount : 5
					tickmarkStepSize : Math.ceil((gauge8.maximumValue - gauge8.minimumValue)/10)
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
						visible: true // styleData.value >= 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
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
						visible: true //styleData.value >= 0
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
					id:rectsg8
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter 
					//y: 220
					width: 0.35*gauge8.width
					height: 0.13*gauge8.width
					color: "#00000000"
					Text {
						id:textgauge8
						anchors.horizontalCenter: parent.horizontalCenter
						y: 70
						width: parent.width
						text: gauge8.value.toFixed(2)
						font.family: "Helvetica"
						maximumLineCount: 1
						wrapMode: Text.WrapAnywhere
						horizontalAlignment: Text.AlignHCenter
						font.pointSize: Math.max(6, parent.width * 0.25)
						color: "#e5e5e5"
					}
				}
				//
				Rectangle {
					id:rectsg8a
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter 
					//y: 220
					width: 0.26*gauge8.width
					height: 0.13*gauge8.width
					color: "#00000000"
					Text {
						id:textgauge8a
						anchors.horizontalCenter: parent.horizontalCenter
						y: -10
						text: "VOLT"
						font.family: "Helvetica"
						font.pointSize: Math.max(6, parent.width * 0.4)
						color: "#e5e5e5"
					}
				}
				Label {
					text: "AKTUAL VALVE"
					color: "#00A5FF"
					font.pointSize: 16
					anchors.bottom: gauge8.top
					anchors.bottomMargin: 10
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		
		}

	////////////////
	Rectangle {
		id:rect13
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 60
        anchors.left : parent.left
        anchors.leftMargin: 1030
        visible: true
        color: "#00000000"
		
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader13
			anchors.fill: parent
			opacity: 0.85  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge13.value)/(gauge13.maximumValue-gauge13.minimumValue))+pi*(0.8-(1.6*gauge13.maximumValue/(gauge13.maximumValue-gauge13.minimumValue))))
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
			id: gauge13
			width: 0.9*rect13.width
			height: 0.9*rect13.width
			maximumValue: backend.get_parameter('ampere','maximum_display')
			minimumValue: backend.get_parameter('ampere','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style13
				labelInset: outerRadius * 0.22
				labelStepSize: Math.round((gauge13.maximumValue - gauge13.minimumValue)/100)*10
				minorTickmarkInset :45
				tickmarkInset : 6
				minorTickmarkCount : 5
				tickmarkStepSize : Math.round((gauge13.maximumValue - gauge13.minimumValue)/100)*10
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
						ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge13.maximumValue) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge13.maximumValue) - 90));
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
					visible: true // styleData.value > 0 //styleData.value < 20  //|| styleData.value % 1 == 0
					implicitWidth: outerRadius * 0.05
					antialiasing: true
					implicitHeight: outerRadius * 0.07
					color: styleData.value < gauge13.value ? "#00ff00" : "#404040"
					
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
				id:rectsg13
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.35*gauge13.width
				height: 0.13*gauge13.width
				color: "#00000000"
				Text {
					id:textgauge13
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge13.value.toFixed(2)
					font.family: "Helvetica"
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.pointSize: Math.max(6, parent.width * 0.25)
					color:"#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg13a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge13.width
				height: 0.13*gauge13.width
				color: "#00000000"
				Text {
					id:textgauge13a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "mA"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "AMPERE"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge13.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}

	////////////////
	Rectangle {
		id:rect9
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 350
        anchors.left : parent.left
        anchors.leftMargin: 30
        visible: true
        color: "#00000000"
		
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader9
			anchors.fill: parent
			opacity: 0.85  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge9.value)/(gauge9.maximumValue-gauge9.minimumValue))+pi*(0.8-(1.6*gauge9.maximumValue/(gauge9.maximumValue-gauge9.minimumValue))))
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
			id: gauge9
			width: 0.9*rect9.width
			height: 0.9*rect9.width
			maximumValue: backend.get_parameter('common_ma_2','maximum_display')
			minimumValue: backend.get_parameter('common_ma_2','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style9
				labelInset: outerRadius * 0.22
				labelStepSize: Math.round((gauge9.maximumValue - gauge9.minimumValue)/100)*10
				minorTickmarkInset :45
				tickmarkInset : 6
				minorTickmarkCount : 5
				tickmarkStepSize : Math.round((gauge9.maximumValue - gauge9.minimumValue)/100)*10
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
						ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge9.maximumValue) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge9.maximumValue) - 90));
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
					color: styleData.value < gauge9.value ? "#00ff00" : "#404040"
					
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
				id:rectsg9
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.35*gauge9.width
				height: 0.13*gauge9.width
				color: "#00000000"
				Text {
					id:textgauge9
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge9.value.toFixed(2)
					font.family: "Helvetica"
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.pointSize: Math.max(6, parent.width * 0.25)
					color:"#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg9a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge9.width
				height: 0.13*gauge9.width
				color: "#00000000"
				Text {
					id:textgauge9a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "mA"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "COMMON mA 2"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge9.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
	////////////////
	Rectangle {
		id:rect10
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 350
        anchors.left : parent.left
        anchors.leftMargin: 280
        visible: true
        color: "#00000000"
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader10
			antialiasing: true
			anchors.fill: parent
			opacity: 0.95  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge10.value)/(gauge10.maximumValue-gauge10.minimumValue))+pi*(0.8-(1.6*gauge10.maximumValue/(gauge10.maximumValue-gauge10.minimumValue))))
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
			id: gauge10
			width: 0.9*rect10.width
			height: 0.9*rect10.width
			maximumValue: backend.get_parameter('common_2','maximum_display')
			minimumValue: backend.get_parameter('common_2','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style10
				labelInset: outerRadius * 0.01
				labelStepSize: Math.ceil((gauge10.maximumValue - gauge10.minimumValue)/10)
				minorTickmarkInset :25
				tickmarkInset : 14
				minorTickmarkCount : 5
				tickmarkStepSize : Math.ceil((gauge10.maximumValue - gauge10.minimumValue)/10)
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
					visible: true //styleData.value >= 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
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
					visible: true //styleData.value >= 0
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
				id:rectsg10
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.35*gauge10.width
				height: 0.13*gauge10.width
				color: "#00000000"
				Text {
					id:textgauge10
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge10.value.toFixed(2)
					font.family: "Helvetica"
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.pointSize: Math.max(6, parent.width * 0.25)
					color: "#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg10a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge10.width
				height: 0.13*gauge10.width
				color: "#00000000"
				Text {
					id:textgauge10a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "VOLT"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "COMMON 2"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge10.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
	/////////////////
	Rectangle {
		id:rect11
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 350
        anchors.left : parent.left
        anchors.leftMargin: 530
        visible: true
        color: "#00000000"
		
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader11
			anchors.fill: parent
			opacity: 0.85  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge11.value)/(gauge11.maximumValue-gauge11.minimumValue))+pi*(0.8-(1.6*gauge11.maximumValue/(gauge11.maximumValue-gauge11.minimumValue))))
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
			id: gauge11
			width: 0.9*rect11.width
			height: 0.9*rect11.width
			maximumValue: backend.get_parameter('aktual_ma_2','maximum_display')
			minimumValue: backend.get_parameter('aktual_ma_2','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style11
				labelInset: outerRadius * 0.22
				labelStepSize: Math.round((gauge11.maximumValue - gauge11.minimumValue)/100)*10
				minorTickmarkInset :45
				tickmarkInset : 6
				minorTickmarkCount : 5
				tickmarkStepSize : Math.round((gauge11.maximumValue - gauge11.minimumValue)/100)*10
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
						ctx.arc(outerRadius, outerRadius, 1*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge11.maximumValue) - 90));
						ctx.stroke();
						
						ctx.beginPath();
						ctx.strokeStyle = "#f0f0f0";
						ctx.lineWidth = outerRadius * 0.02;
						ctx.arc(outerRadius, outerRadius, 0.67*outerRadius - ctx.lineWidth / 2,degreesToRadians(valueToAngle(0) - 90), degreesToRadians(valueToAngle(gauge11.maximumValue) - 90));
						ctx.stroke();
						
					}
				}

				
				tickmark: Rectangle {
					visible: true // styleData.value > 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
					implicitWidth: outerRadius * 0.03
					antialiasing: true
					implicitHeight: outerRadius * 0.05
					color: styleData.value <= 50 ? "#ffff00" : "#ffff00"
				}
				

				minorTickmark: Rectangle {
					visible: true // styleData.value > 0 //styleData.value < 20  //|| styleData.value % 1 == 0
					implicitWidth: outerRadius * 0.05
					antialiasing: true
					implicitHeight: outerRadius * 0.07
					color: styleData.value < gauge11.value ? "#00ff00" : "#404040"
					
				}

				tickmarkLabel:  Text {
					visible: true // styleData.value > 0
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
				id:rectsg11
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.35*gauge11.width
				height: 0.13*gauge11.width
				color: "#00000000"
				Text {
					id:textgauge11
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge11.value.toFixed(2)
					font.family: "Helvetica"
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.pointSize: Math.max(6, parent.width * 0.25)
					color:"#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg11a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge11.width
				height: 0.13*gauge11.width
				color: "#00000000"
				Text {
					id:textgauge11a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "mA"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "AKTUAL VALVE"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge11.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
	
	
	////////////////
	Rectangle {
		id:rect12
		width: 220
        height: 220
        anchors.top : parent.top
        anchors.topMargin: 350
        anchors.left : parent.left
        anchors.leftMargin: 780
        visible: true
        color: "#00000000"
		//###### Shader effect to provide gradient-based gauge #########
		ShaderEffect {
			id: shader12
			antialiasing: true
			anchors.fill: parent
			opacity: 0.95  
			property real angleBase: -pi*0.80
			property real angle: ((1.6*pi*(gauge12.value)/(gauge12.maximumValue-gauge12.minimumValue))+pi*(0.8-(1.6*gauge12.maximumValue/(gauge12.maximumValue-gauge12.minimumValue))))
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
			id: gauge12
			width: 0.9*rect12.width
			height: 0.9*rect12.width
			maximumValue: backend.get_parameter('aktual_valve_2','maximum_display')
			minimumValue: backend.get_parameter('aktual_valve_2','minimum_display')
			value: 0
			anchors.centerIn: parent
			style: CircularGaugeStyle {
				id: style12
				labelInset: outerRadius * 0.01
				labelStepSize: Math.ceil((gauge12.maximumValue - gauge12.minimumValue)/10)
				minorTickmarkInset :25
				tickmarkInset : 14
				minorTickmarkCount : 5
				tickmarkStepSize : Math.ceil((gauge12.maximumValue - gauge12.minimumValue)/10)
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
					visible: true // styleData.value >= 0  //|| styleData.value % 20 == 0  // styleData.value < 3 || 
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
					visible: true //styleData.value >= 0
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
				id:rectsg12
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.35*gauge12.width
				height: 0.13*gauge12.width
				color: "#00000000"
				Text {
					id:textgauge12
					anchors.horizontalCenter: parent.horizontalCenter
					y: 70
					width: parent.width
					text: gauge12.value.toFixed(2)
					font.family: "Helvetica"
					maximumLineCount: 1
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					font.pointSize: Math.max(6, parent.width * 0.25)
					color: "#e5e5e5"
				}
			}
			//
			Rectangle {
				id:rectsg12a
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter 
				//y: 220
				width: 0.26*gauge12.width
				height: 0.13*gauge12.width
				color: "#00000000"
				Text {
					id:textgauge12a
					anchors.horizontalCenter: parent.horizontalCenter
					y: -10
					text: "VOLT"
					font.family: "Helvetica"
					font.pointSize: Math.max(6, parent.width * 0.4)
					color: "#e5e5e5"
				}
			}
			Label {
                text: "AKTUAL VALVE 2"
                color: "#00A5FF"
                font.pointSize: 16
                anchors.bottom: gauge12.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
            }
		}
	
	}
		
	// ############## FIN GAUGE  8  ####################################
		
			
		// ############## FIN GAUGE  8  ####################################

	}




	//
	Timer{
		id:tmgauge
		interval: 250
		repeat: true
		running: true
		onTriggered: {
			gauge4.value = backend.get_value('common_ma') //COMMON mA
			gauge5.value = backend.get_value('common') //COMMON
			gauge6.value = backend.get_value('aktual_ma') //AKTUAL mA
			gauge8.value = backend.get_value('aktual_valve') //AKTUAL VALVE
			gauge9.value = backend.get_value('common_ma_2') //COMMON mA
			gauge10.value = backend.get_value('common_2') //COMMON
			gauge11.value = backend.get_value('aktual_ma_2') //AKTUAL mA
			gauge12.value = backend.get_value('aktual_valve_2') //AKTUAL VALVE
			gauge13.value = backend.get_value('ampere') //AMPERE

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

