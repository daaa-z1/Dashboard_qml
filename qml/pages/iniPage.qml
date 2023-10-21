import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0


Item {

	Rectangle {
		id: rectangle
		color: "#2c313c"
		anchors.fill: parent
		
	////////////////////////////////////////////////////////////////////
	    

		Image {    
			id: image    
			source: "../../images/dash1.png"
			height:parent.height
			width:parent.width  
			//fillMode: Image.PreserveAspectCrop    
			//Layout.fillHeight: true    
			//Layout.fillWidth: true    
		}
	   
	////////////////////////////////////////////////////////////////////

	}
	Connections{
		target: backend
	}
}

