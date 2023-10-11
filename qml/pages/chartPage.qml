import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import QtQuick.Dialogs 1.3



//import QtQuick 2.0
import QtCharts 2.1
import "../controls"


Item {

	Text {
		id: title
		text: qsTr("Analog Grafik")
		anchors.top:  parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: 5
		font.pointSize :18
		color: "#00a5ff"
	}

    Rectangle {
        id: rectrec
        color: "#2c313c"
        anchors{
            top:title.bottom
            topMargin:20
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:20
            leftMargin:50
            rightMargin:10
        }
        
        CustomButton{
            id: buttonrec
            height: 30
            width: 100
            text: "Record"
            checkable: true
            checked: true
			onToggled:{
				if(buttonrec.checked){
                    buttonrec.text = "Record";
                    buttonrec.colorDefault = "#4891d9";
                    buttonrec.colorMouseOver= "#55AAFF"
                    buttonload.visible = true
                    buttonreport.visible = true
                    texttimer.visible = false
                    texttimer.text = "0"
                    backend.set_record("no")
                    backend.save_data()
                    popupsuccess.open()
				}
                else{
                    buttonrec.text = "Stop";
                    buttonrec.colorDefault = "crimson";
                    buttonrec.colorMouseOver = "firebrick";
                    texttimer.visible = true
                    buttonload.visible = false
                    buttonreport.visible = false
                    backend.set_record("yes")
                }
            }
        }
        
        Text {
            id: texttimer
            color: "white"
            text: "0"
            visible: false
            anchors.left:parent.left
            anchors.leftMargin: 140
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
        }

        CustomButton{
            id: buttonload
            anchors.left:parent.left
            anchors.leftMargin: 120
            height: 30
            width: 100
            text: "Load"
			onClicked:{
                fileDialog.open()       
            }
        }

        CustomButton{
            id: buttonreport
            anchors.left:parent.left
            anchors.leftMargin: 240
            height: 30
            width: 100
            text: "Report"
			onClicked:{
                if(buttonreport=="Report"){
                    cv.grabToImage(function(result) {
                        result.saveToFile("temp-chart.png");
                        backend.save_pdf();
                        popupsuccess.open();
                    });
                }    
    
                else{
                    backend.set_loaded("reset");
                }
                

            }
        }

    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        folder: shortcuts.home
        nameFilters: [ "JSON (*.json)"]
        onAccepted: {
            backend.load_data(fileUrl)
            popupsuccess.open()
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    Popup {
        id: popupsuccess
        padding: 10
        x:100
        y:100
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 100
            color: "#00a5ff"
        }
        modal: true
        focus: true
        dim: false
        anchors.centerIn: Overlay.overlay
        contentItem: Text {
            id:textpopup
            text: "Success!"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 28
            color: "white"
        }
    }


    // AKTUAL VALVE
    Rectangle {
        id: rect0
		color: "#2c313c"
		width: 80
        anchors{
            top:title.bottom
            topMargin:60
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:10
            leftMargin:50
            rightMargin:10
        }

        Rectangle {
            id: recttemp1
            width: 80
            height: parent.height * 0.945
            color: "#2c313c"
            Gauge {
                id: tempbox1
                anchors.fill: parent
                anchors.margins: 10
                width: 80
                height: 280
                minimumValue: backend.get_parameter('pressure_a','minimum_display')
                maximumValue: backend.get_parameter('pressure_a','maximum_display')
                tickmarkStepSize : Math.round((tempbox1.maximumValue - tempbox1.minimumValue)/100)*10

                value: backend.get_parameter('pressure_a','maximum_display')

                style: GaugeStyle {
                    valueBar: Rectangle {
                        border.width: 1
                        implicitWidth: 16
                        color: "#a5ff00"
                    }
                }
            }
            
            Text {
                color: "#00a5ff"
                text: "PRESSURE"
                width: recttemp1.width
                anchors.top: tempbox1.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 8
            }
        }
    }
    // PRESSURE

    // FLOW
    Rectangle {
        id: rect2
		color: "#2c313c"
		width: 80
        anchors{
            top:title.bottom
            topMargin:60
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:10
            leftMargin:130
            rightMargin:10
        }

        Rectangle {
            id: rectflow
            width: 80
            height: parent.height * 0.945
            color: "#2c313c"
            Gauge {
                id: flowbox
                anchors.fill: parent
                anchors.margins: 10
                width: 80
                height: 280
                minimumValue: backend.get_parameter('flow','minimum_display')
                maximumValue: backend.get_parameter('flow','maximum_display')
                tickmarkStepSize : Math.round((flowbox.maximumValue - flowbox.minimumValue)/100)*10

                value: backend.get_parameter('flow','maximum_display')

                style: GaugeStyle {
                    valueBar: Rectangle {
                        border.width: 1
                        implicitWidth: 16
                        color: "#1267D4"
                    }
                }
            }
            
            Text {
                color: "#00a5ff"
                text: "FLOW"
                width: rectflow.width
                anchors.top: flowbox.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 8
            }
        }
    }
    // FLOW

    // COMMON
    Rectangle {
        id: rect3
		color: "#2c313c"
		width: 80
        anchors{
            top:title.bottom
            topMargin:60
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:10
            leftMargin:210
            rightMargin:10
        }

        Rectangle {
            id: rectcommon
            width: 80
            height: parent.height * 0.945
            color: "#2c313c"
            Gauge {
                id: boxcommon
                anchors.fill: parent
                anchors.margins: 10
                width: 80
                height: 280
                minimumValue: backend.get_parameter('common','minimum_display')
                maximumValue: backend.get_parameter('common','maximum_display')
                tickmarkStepSize : Math.round((boxcommon.maximumValue - boxcommon.minimumValue)/10)

                value: backend.get_parameter('common','maximum_display')

                style: GaugeStyle {
                    valueBar: Rectangle {
                        border.width: 1
                        implicitWidth: 16
                        color: "#ff5ee9"
                    }
                }
            }
            
            Text {
                color: "#00a5ff"
                text: "VOLTASE"
                width: rectcommon.width
                anchors.top: boxcommon.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 8
            }

        }
    }
    // COMMON

    // INLET
    Rectangle {
        id: rect4
		color: "#2c313c"
		width: 80
        anchors{
            top:title.bottom
            topMargin:60
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:10
            leftMargin:280
            rightMargin:10
        }

        Rectangle {
            id: rectinlet
            width: 80
            height: parent.height * 0.945
            color: "#2c313c"
            Gauge {
                id: boxinlet
                anchors.fill: parent
                anchors.margins: 10
                width: 80
                height: 280
                minimumValue: backend.get_parameter('common_ma','minimum_display')
                maximumValue: backend.get_parameter('common_ma','maximum_display')
				tickmarkStepSize : Math.round((boxinlet.maximumValue - boxinlet.minimumValue)/100)*10

                value: backend.get_parameter('common_ma','maximum_display')

                style: GaugeStyle {
                    valueBar: Rectangle {
                        border.width: 1
                        implicitWidth: 16
                        color: "#07ccff"
                    }
                
                }
            }
            
            Text {
                color: "#00a5ff"
                text: "mA"
                width: rectinlet.width
                anchors.top: boxinlet.bottom
                anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: 8
            }
        }
    }
    // INLET

    Rectangle {
        id: rectbox
        width: 80
        height: parent.height * 0.945
        color: "#2c313c"
        anchors{
            top:title.bottom
            topMargin:60
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:10
            leftMargin:400
            rightMargin:10
        }
        
        CustomButton{
            id: buttonflow
            anchors.top:parent.top
            anchors.topMargin: 50
            height: 30
            width: 50
            text: "Flow"
            checkable: true
			onToggled:{
                if(buttonflow.checked){
                    lines1.visible = false
                    buttonflow.colorDefault = "crimson";
                    buttonflow.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines1.visible = true
                    buttonflow.colorDefault = "#4891d9";
                    buttonflow.colorMouseOver= "#55AAFF"
                    
                }
                
            }
        }

        CustomButton{
            id: buttoninlet
            anchors.top:parent.top
            anchors.topMargin: 100
            height: 30
            width: 50
            text: "Inlet"
            checkable: true
			onToggled:{
                if(buttoninlet.checked){
                    lines2.visible = false
                    buttoninlet.colorDefault = "crimson";
                    buttoninlet.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines2.visible = true
                    buttoninlet.colorDefault = "#4891d9";
                    buttoninlet.colorMouseOver= "#55AAFF"
                }
                
            }
        }

        CustomButton{
            id: buttonpressa
            anchors.top:parent.top
            anchors.topMargin: 150
            height: 30
            width: 50
            text: "Pres. A"
            checkable: true
			onToggled:{
                if(buttonpressa.checked){
                    lines3.visible = false
                    buttonpressa.colorDefault = "crimson";
                    buttonpressa.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines3.visible = true
                    buttonpressa.colorDefault = "#4891d9";
                    buttonpressa.colorMouseOver= "#55AAFF"
                }   
            }
        }

        CustomButton{
            id: buttonpressb
            anchors.top:parent.top
            anchors.topMargin: 200
            height: 30
            width: 50
            text: "Pres. B"
            checkable: true
			onToggled:{
                if(buttonpressb.checked){
                    lines4.visible = false
                    buttonpressb.colorDefault = "crimson";
                    buttonpressb.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines4.visible = true
                    buttonpressb.colorDefault = "#4891d9";
                    buttonpressb.colorMouseOver= "#55AAFF"
                }       
            }
        }

        CustomButton{
            id: buttoncommona
            anchors.top:parent.top
            anchors.topMargin: 250
            height: 30
            width: 50
            text: "Com. mA"
            checkable: true
			onToggled:{
                if(buttoncommona.checked){
                    lines5.visible = false
                    buttoncommona.colorDefault = "crimson";
                    buttoncommona.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines5.visible = true
                    buttoncommona.colorDefault = "#4891d9";
                    buttoncommona.colorMouseOver= "#55AAFF"
                }       
            }
        }

        CustomButton{
            id: buttoncommonv
            anchors.top:parent.top
            anchors.topMargin: 300
            height: 30
            width: 50
            text: "Com. V"
            checkable: true
			onToggled:{
                if(buttoncommonv.checked){
                    lines6.visible = false
                    buttoncommonv.colorDefault = "crimson";
                    buttoncommonv.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines6.visible = true
                    buttoncommonv.colorDefault = "#4891d9";
                    buttoncommonv.colorMouseOver= "#55AAFF"
                }       
            }
        }

        CustomButton{
            id: buttonaktuala
            anchors.top:parent.top
            anchors.topMargin: 350
            height: 30
            width: 50
            text: "Akt. A"
            checkable: true
			onToggled:{
                if(buttonaktuala.checked){
                    lines7.visible = false
                    buttonaktuala.colorDefault = "crimson";
                    buttonaktuala.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines7.visible = true
                    buttonaktuala.colorDefault = "#4891d9";
                    buttonaktuala.colorMouseOver= "#55AAFF"
                }       
            }
        }

        CustomButton{
            id: buttonaktualv
            anchors.top:parent.top
            anchors.topMargin: 400
            height: 30
            width: 50
            text: "Akt. V"
            checkable: true
			onToggled:{
                if(buttonaktualv.checked){
                    lines8.visible = false
                    buttonaktualv.colorDefault = "crimson";
                    buttonaktualv.colorMouseOver = "firebrick";
                }    
    
                else{
                    lines8.visible = true
                    buttonaktualv.colorDefault = "#4891d9";
                    buttonaktualv.colorMouseOver= "#55AAFF"
                }       
            }
        }
    



    }
    // CHECKBOX



	//########## INI CHART VIEW ##############################
	
	ChartView{
        id:cv
        anchors{
            top:title.bottom
            topMargin:0
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:10
            leftMargin:460
            rightMargin:10
        }
        antialiasing: true
        theme: ChartView.ChartThemeDark

        property int  timcnt: 0
        property double  valueCH1: 0
        property double  valueCH2: 0
        property double  valueCH3: 0
        property double  valueCH4: 0
		property double  valueCH5: 0
		property double  valueCH6: 0
		property double  valueCH7: 0
		property double  valueCH8: 0
        //property double  valueTM1: 0        
        property double  periodGRAPH: 60 // Seconds
		property double  startTIME: 0
		property double  intervalTM: 250 // miliseconds

        ValueAxis{
            id:yAxis
            min: -10
            max: 10
            tickCount: 0
            labelFormat: " "
        }

        LineSeries {
			name: "FLOW"
			id:lines1
			//axisX: xAxis
			axisY: yAxis
			width: 2
			color: "#1267D4"
			axisX: 	DateTimeAxis {
					id: eje
					//format: "yyyy MMM"
					format:"HH:mm:ss"
					//format:"mm:ss.z"
				}
		}
        
        LineSeries {
            name: "INLET"
            id:lines2
            axisX: eje
            axisY: yAxis    
            width: 2
            color: "#ffa500"
        }

        LineSeries {
            name: "PRESS. A"
            id:lines3
            axisX: eje
            axisY: yAxis
            width: 2
            color: "#a5ff00"
        }

        LineSeries {
            name: "PRESS. B"
            id:lines4
            axisX: eje
            axisY: yAxis
            width: 2
            color: "#ff0000"
        }

		LineSeries {
            name: "COM mA"
            id:lines5
            axisX: eje
            axisY: yAxis
            width: 2
            color: "#07ccff"
        }

		LineSeries {
            name: "COM V"
            id:lines6
            axisX: eje
            axisY: yAxis
            width: 2
            color: "#ff5ee9"
        }

		LineSeries {
            name: "AKT mA"
            id:lines7
            axisX: eje
            axisY: yAxis
            width: 2
            color: "#C4A484"
        }

		LineSeries {
            name: "AKT V"
            id:lines8
            axisX: eje
            axisY: yAxis
            width: 2
            color: "#ffffff"
        }

        ///
        Timer{
			id:tm
			interval: cv.intervalTM
			repeat: true
			running: true
			onTriggered: {
                
                tempbox1.value = backend.get_parameter('pressure_a', 'maximum_display') //Math.round(backend.get_value('inlet')*100)/100 //AKTUAL mA
                flowbox.value = backend.get_parameter('flow', 'maximum_display') //Math.round(backend.get_value('flow')*100)/100 //FLOW
                boxcommon.value = backend.get_parameter('common', 'maximum_display') //Math.round(backend.get_value('common')*100)/100 //COMMON
                boxinlet.value = backend.get_parameter('common_ma', 'maximum_display') //Math.round(backend.get_value('common_ma')*100)/100 //INLET

                switch(backend.is_loaded()){
                    case "loading":{
                        cv.timcnt = 0
                        backend.set_loaded("yes")
                        buttonreport.text = "Reset"
                        buttonrec.visible = false
                        break
                    }

                    case "yes":{
                        if(backend.get_count()<backend.get_datacount()){
                            lines1.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('flow',backend.get_count()))
                            lines2.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('inlet',backend.get_count()))
                            lines3.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('pressure_a',backend.get_count()))
                            lines4.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('pressure_b',backend.get_count()))
                            lines5.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('common_ma',backend.get_count()))
                            lines6.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('common',backend.get_count()))
                            lines7.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('aktual_ma',backend.get_count()))
                            lines8.append(cv.startTIME+cv.timcnt*cv.intervalTM ,backend.get_data('aktual_valve',backend.get_count()))
                            
                            backend.add_counter()
                            cv.timcnt = cv.timcnt + 1
                            //cv.valueTM1 = backend.get_tiempo()*1000
                        }
                        break
                    }

                    case "reset":{
                        cv.timcnt = 0
                        buttonrec.visible = true
                        buttonreport.text = "Report"
                        backend.reset_counter()
                        backend.max_counter()
                        backend.initData()
                        backend.set_loaded("no")
                        break
                    }

                    case "no":
                    {
                        if(backend.is_loaded()=="no"){
                            //cv.valueCH1 = backend.get_adc('flow')
                            //cv.valueCH2 = backend.get_adc('inlet')
                            //cv.valueCH3 = backend.get_adc('pressure_a')
                            //cv.valueCH4 = backend.get_adc('pressure_b')
                            //cv.valueCH5 = backend.get_adc('common_ma')
                            //cv.valueCH6 = backend.get_adc('common')
                            //cv.valueCH7 = backend.get_adc('aktual_ma')
                            //cv.valueCH8 = backend.get_adc('aktual_valve')
                            
                            lines1.append(cv.startTIME+cv.timcnt*cv.intervalTM , (backend.get_adc('flow')*4)-10)
                            lines2.append(cv.startTIME+cv.timcnt*cv.intervalTM , (backend.get_adc('inlet')*4)-10)
                            lines3.append(cv.startTIME+cv.timcnt*cv.intervalTM , (backend.get_adc('pressure_a')*4)-10)
                            lines4.append(cv.startTIME+cv.timcnt*cv.intervalTM , (backend.get_adc('pressure_b')*4)-10)
                            lines5.append(cv.startTIME+cv.timcnt*cv.intervalTM , backend.get_adc('common_ma'))
                            lines6.append(cv.startTIME+cv.timcnt*cv.intervalTM , backend.get_adc('common'))
                            lines7.append(cv.startTIME+cv.timcnt*cv.intervalTM , backend.get_adc('aktual_ma'))
                            lines8.append(cv.startTIME+cv.timcnt*cv.intervalTM , backend.get_adc('aktual_valve'))
                            cv.timcnt = cv.timcnt + 1
                        }
                        //cv.valueTM1 = backend.get_tiempo()*1000
                        break
                    }
                }


				if (lines1.count>cv.periodGRAPH*1000/cv.intervalTM){
					lines1.remove(0)
					lines2.remove(0)
					lines3.remove(0)
					lines4.remove(0)
                    lines5.remove(0)
					lines6.remove(0)
					lines7.remove(0)
					lines8.remove(0)
					}
				



                if (backend.is_recording()=="yes" && backend.is_loaded()=="no"){
                    backend.append_data('flow',cv.valueCH1.toFixed(2))
                    backend.append_data('inlet',cv.valueCH2.toFixed(2))
                    backend.append_data('pressure_a',cv.valueCH3.toFixed(2))
                    backend.append_data('pressure_b',cv.valueCH4.toFixed(2))
                    backend.append_data('common_ma',cv.valueCH5.toFixed(2))
                    backend.append_data('common',cv.valueCH6.toFixed(2))
                    backend.append_data('aktual_ma',cv.valueCH7.toFixed(2))
                    backend.append_data('aktual_valve',cv.valueCH8.toFixed(2))
                    texttimer.text = parseInt(texttimer.text) + 1
                }
                
				//lines1.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH1)
				//lines2.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH2)
				//lines3.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH3)
				//lines4.append(cv.valueTM1+cv.timcnt*500 ,cv.valueCH4)
				
				//lines1.axisX.min = cv.timcnt < cv.periodGRAPH ? new Date(cv.startTIME) : new Date(cv.startTIME  - cv.periodGRAPH*1000 + cv.timcnt*1000)
				//lines1.axisX.max = cv.timcnt < cv.periodGRAPH ? new Date(cv.startTIME  + cv.periodGRAPH*1000) : new Date(cv.startTIME   + cv.timcnt*1000)
				
				//lines1.axisX.min = new Date(cv.startTIME-cv.periodGRAPH*1000 + cv.timcnt*500)
				//lines1.axisX.max = new Date(cv.startTIME + cv.timcnt*500)
				
				lines1.axisX.min = new Date(cv.startTIME-cv.periodGRAPH*1000 + cv.timcnt*cv.intervalTM)
				lines1.axisX.max = new Date(cv.startTIME + cv.timcnt*cv.intervalTM)

			}
		}

    }
    Component.onCompleted: {
		cv.startTIME = backend.get_tiempo()*1000
	}
    

	//########## END CHART VIEW ##############################
	
	Connections{
        target: backend
        
        
	}
}

