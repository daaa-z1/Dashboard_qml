import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0


//import QtQuick 2.0
import QtCharts 2.1
import "../controls"


Item {

	Text {
		id: title
		text: qsTr("Analog Measure - Volatile chart")
		anchors.top:  parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: 5
		font.pointSize :18
		color: "#a0a0a0"
	}
	//########## INI CHART VIEW ##############################
	
	ChartView{
        id:cv
        anchors{
            top:title.bottom
            topMargin:10
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            bottomMargin:10
            leftMargin:10
            rightMargin:300
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

        ValueAxis{
            id:xAxis
            min: cv.timcnt < 50 ? 0 : cv.timcnt - 50
            max: cv.timcnt < 50 ? 50 : cv.timcnt + 1
            tickCount: 11
            labelFormat: "%d.1"
        }

        ValueAxis{
            id:yAxis
            min: 0
            max: 1000
            tickCount: 1
            labelFormat: "%d.1"
        }

        LineSeries {
            name: "AIN 0"
            id:lines1
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#00a5ff"
        }

        LineSeries {
            name: "AIN 1"
            id:lines2
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#ffa500"
        }

        LineSeries {
            name: "AIN 2"
            id:lines3
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#a5ff00"
        }

        LineSeries {
            name: "AIN 3"
            id:lines4
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#ff0000"
        }

LineSeries {
            name: "AIN 4"
            id:lines4
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#ff0000"
        }

        LineSeries {
            name: "AIN 5"
            id:lines4
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#ff0000"
        }

        LineSeries {
            name: "AIN 6"
            id:lines4
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#ff0000"
        }

        LineSeries {
            name: "AIN 7"
            id:lines4
            axisX: xAxis
            axisY: yAxis
            width: 2
            color: "#ff0000"
        }

       
        Timer{
            id:tm
            interval: 250
            repeat: true
            running: true
            onTriggered: {
                cv.timcnt = cv.timcnt + 1
                cv.valueCH1 = backend.get_adc1()
                cv.valueCH2 = backend.get_adc2()
                cv.valueCH3 = backend.get_adc3()
                cv.valueCH4 = backend.get_adc4()
                cv.valueCH5 = backend.get_adc5()
                cv.valueCH6 = backend.get_adc6()
                cv.valueCH7 = backend.get_adc7()
                cv.valueCH8 = backend.get_adc8()

                lines1.append(cv.timcnt,cv.valueCH1)
                lines2.append(cv.timcnt,cv.valueCH2)
                lines3.append(cv.timcnt,cv.valueCH3)
                lines4.append(cv.timcnt,cv.valueCH4)
                lines5.append(cv.timcnt,cv.valueCH5)
                lines6.append(cv.timcnt,cv.valueCH6)
                lines7.append(cv.timcnt,cv.valueCH7)
                lines8.append(cv.timcnt,cv.valueCH8)

            }
        }
    }

	//########## END CHART VIEW ##############################
	
	Connections{
        target: backend
        
	}
}

