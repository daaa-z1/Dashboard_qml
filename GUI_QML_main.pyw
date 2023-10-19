# Import library yang diperlukan
import sys
import json
import serial
from serial.tools.list_ports import comports

from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtQml import *
from PyQt5.QtWidgets import *
from PyQt5.QtQuick import *
from PyQt5.QtChart import*  # pip install PyQtChart

from reportlab.pdfgen import canvas
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4, landscape

# Special library
import os
import random
import math

try:
    from LabJackPython import u6
except:
    print("Driver error", '''The driver could not be imported.
Please install the UD driver (Windows) or Exodriver (Linux and Mac OS X) from www.labjack.com''')
    sys.exit(1)

# Main Class
class MainWindow(QObject):

    # SIGNAL #
    # Signal Set Name
    setName = pyqtSignal(str)

    # Signal Set Name
    setPage = pyqtSignal(str)

    # Signal Set Port selected
    setCom = pyqtSignal(str)

    # Signal Set Data
    printTime = pyqtSignal(str)
    printDate = pyqtSignal(str)
    valueGauge = pyqtSignal(str)
    printHour = pyqtSignal(str)

    # Signal Visible
    isVisible = pyqtSignal(bool)

    # Open File To Text Edit
    readText = pyqtSignal(str)
    
    setPuerto = pyqtSignal(list)

    # Text String
    textField = ""

    d = u6.U6()

	# inisialisasi MainWindow
    def __init__(self, parent=None):
        super().__init__(parent)
        self.app = QApplication(sys.argv)
        self.app.setWindowIcon(QIcon("images/chip.ico"))
        self.engine = QQmlApplicationEngine(self)
        self.engine.rootContext().setContextProperty("backend", self)
        self.engine.load(QUrl("qml/main.qml"))
        
        self.setupVar()
        self.iniClock()
        sys.exit(self.app.exec_())

	# Fungsi menginisialisasi parameter dan data awal
    def setupVar(self):
        # Parameter Initial Setting
        self.parameter = {
            'flow': {'minimum_display': 0, 'maximum_display': 100, 'minimum_input': 0, 'maximum_input': 5},
            'inlet': {'minimum_display': 0, 'maximum_display': 400, 'minimum_input': 0, 'maximum_input': 5},
            'pressure_a': {'minimum_display': 0, 'maximum_display': 400, 'minimum_input': 0, 'maximum_input': 5},
            'pressure_b': {'minimum_display': 0, 'maximum_display': 400, 'minimum_input': 0, 'maximum_input': 5},
            'common': {'minimum_display': -10, 'maximum_display': 10, 'minimum_input': -10, 'maximum_input': 10},
            'common_ma': {'minimum_display': -1000, 'maximum_display': 1000, 'minimum_input': 0, 'maximum_input': 5},
            'aktual_valve': {'minimum_display': -10, 'maximum_display': 10, 'minimum_input': -10, 'maximum_input': 10},
            'aktual_ma': {'minimum_display': -1000, 'maximum_display': 1000, 'minimum_input': 0, 'maximum_input': 5},
            'temp': {'minimum_display': 0, 'maximum_display': 100, 'minimum_input': 0, 'maximum_input': 5},
            'common_2': {'minimum_display': -10, 'maximum_display': 10, 'minimum_input': -10, 'maximum_input': 10},
            'common_ma_2': {'minimum_display': 0, 'maximum_display': 1000, 'minimum_input': 0, 'maximum_input': 5},
            'aktual_valve_2': {'minimum_display': -10, 'maximum_display': 10, 'minimum_input': -10, 'maximum_input': 10},
            'aktual_ma_2': {'minimum_display': 0, 'maximum_display': 1000, 'minimum_input': 0, 'maximum_input': 5},
            'ampere': {'minimum_display': 0, 'maximum_display': 5000, 'minimum_input': 0, 'maximum_input': 5}
        }

        self.record = "no"
        self.loaded = "no"
        self.count = 0
        self.initData()

        self.switch = {
            'start': ['FIO0', 0],
            'lamp': ['FIO1', 0],
            'load': ['FIO2', 0],
            'leak_test': ['FIO3', 0],
            'a_to_tank': ['FIO4', 0],
            'b_to_tank': ['FIO5', 0],
            'btn1': ['EIO0', 0],
            'btn2': ['EIO1', 0],
            'btn3': ['EIO2', 0],
            'btn4': ['EIO3', 0],
            'btn5': ['EIO4', 0],
            'btn6': ['EIO5', 0],
            'btn7': ['EIO6', 0],
            'btn8': ['EIO7', 0],
            'btn9': ['CIO0', 0],
            'btn10': ['CIO1', 0],
            'btn11': ['CIO2', 0],
            'btn12': ['CIO3', 0]
        }

        # Set gauge according to AIN
        self.ain = {
            'flow': 0,
            'inlet': 1,
            'pressure_a': 2,
            'pressure_b': 3,
            'common_ma': 4,
            'common': 5,
            'aktual_ma': 6,
            'aktual_valve': 7,
            'temp': 8,
            'common_ma_2': 4,
            'common_2': 5,
            'aktual_ma_2': 6,
            'aktual_valve_2': 7,
            'ampere': 9
        }

	# Inisialisasi timer untuk waktu dan tanggal
    def iniClock(self):
        self.timer = QTimer()
        self.timer.timeout.connect(lambda: self.setTime())
        self.timer.start(1000)

    def setTime(self):
        current_time = QTime.currentTime()
        time = current_time.toString('HH:mm:ss')
        date = QDate.currentDate().toString(Qt.ISODate)
        formatDate = 'Now is '+date+' '+time

        numTest = str(random.randint(10, 100))
        self.valueGauge.emit(numTest)
        self.printTime.emit(formatDate)
        self.printDate.emit(date)
        self.printHour.emit(time)

    @pyqtSlot()
    def initData(self):
        self.data = {
            'flow': [],
            'inlet': [],
            'pressure_a': [],
            'pressure_b': [],
            'common_ma': [],
            'common': [],
            'aktual_ma': [],
            'aktual_valve': [],
            'temp': [],
            'ampere': [],
            'time': []
        }

    # Fungsi untuk mengatur nama halaman pada GUI

    @pyqtSlot(str)
    def namePage(self, pagex):
        self.setPage.emit(pagex)

    ####################################################################
    # SAMPLER DATA
    ####################################################################

    def iniSampler(self):
        self.temporizador = QTimer()
        self.temporizador.timeout.connect(self.readData)
        self.temporizador.start(200)

    ####################################################################
    # REFERENCE TIME FOR GRAPHICS : VOLATILE CHART
    ####################################################################

    @pyqtSlot(result=int)
    def get_tiempo(self):
        date_time = QDateTime.currentDateTime()
        unixTIME = date_time.toSecsSinceEpoch()
        #unixTIMEx = date_time.currentMSecsSinceEpoch()
        return unixTIME

    ####################################################################
    # SEND  DATA  FROM PYTHON : ANALOG INPUTS
    ####################################################################
    @pyqtSlot(str, result=float)
    def get_adc(self, gauge):

        input = self.d.get_analog("AIN"+str(self.ain[gauge]))
        if input < -10:
            return 0
        else:
            return input

    @pyqtSlot(str, str, float)
    def set_parameter(self, gauge, col, value):
        self.parameter[gauge][col] = value

    @pyqtSlot(str, str, result=float)
    def get_parameter(self, gauge, col):
        return self.parameter[gauge][col]

    @pyqtSlot(str, result=str)
    def get_switch(self, input):
        if self.switch[input][1] == 1:
            return 'on'
        else:
            return 'off'

    @pyqtSlot(str, int)
    def set_switch(self, input, state):
        try:
            self.switch[input][1] = state
            self.d.set_digital(self.switch[input][0], state)
        except:
            print("Error!")

    @pyqtSlot(str)
    def set_record(self, state):
        self.record = state

    @pyqtSlot(result=str)
    def is_recording(self):
        return self.record

    @pyqtSlot(str, str)
    def append_data(self, var, val):
        self.data[var].append(val)

    @pyqtSlot()
    def save_data(self):
        date_time = QDateTime.currentDateTime()
        fname = "Data_" + date_time.toString("dd-MM-yyyy_hh_mm") + ".json"
        self.data['time'].append(date_time.toString("HH:mm:ss.z"))
        with open(fname, "w") as fp:
            json.dump(self.data, fp)  # encode dict into JSON
        self.initData()

    @pyqtSlot(str)
    def load_data(self, input):
        fname = input.replace("file:///", '')
        fname = fname.replace("/", '\\')
        self.initData()
        with open(fname, "r") as fp:
            self.data = json.load(fp)
        self.loaded = "loading"

    @pyqtSlot(str)
    def set_loaded(self, state):
        self.loaded = state

    @pyqtSlot(result=str)
    def is_loaded(self):
        return self.loaded

    @pyqtSlot(result=str)
    def load_datetime(self):
        return self.data['time'][0]

    @pyqtSlot()
    def add_counter(self):
        self.count = self.count+1

    @pyqtSlot()
    def reset_counter(self):
        self.count = 0

    @pyqtSlot()
    def max_counter(self):
        self.count = 1000

    @pyqtSlot(result=int)
    def get_datacount(self):
        return len(self.data['flow'])

    @pyqtSlot(result=int)
    def get_count(self):
        return self.count

    @pyqtSlot(str, int, result=float)
    def get_data(self, var, count):
        return float(self.data[var][count])

    @pyqtSlot(str, result=float)
    def get_value(self, gauge):
        display_max = self.parameter[gauge]['maximum_display']
        display_min = self.parameter[gauge]['minimum_display']
        input_min = self.parameter[gauge]['minimum_input']
        input_max = self.parameter[gauge]['maximum_input']
        aktual_input = self.get_adc(gauge)

        try:
            scaling = (display_max-display_min) / (input_max-input_min)
            result = round(
                (scaling * (aktual_input-input_min)) + display_min, 2)
        except:
            result = '0'

        return result

    @pyqtSlot(result=str)
    def save_pdf(self):
        date_time = QDateTime.currentDateTime()
        pdfname = "Report_" + date_time.toString("dd-MM-yyyy_hh_mm") + ".pdf"

        try:
            pdf = canvas.Canvas(pdfname, pagesize=landscape(A4))
            pdf.setFont("Times-Bold", 22)
            pdf.drawString(380, 560, "REPORT")
            pdf.line(0, 540, 1000, 540)

            pdf.setFont("Times-Italic", 12)
            pdf.drawString(40, 545, date_time.toString('dd/MM/yyyy hh:mm'))

            pdf.line(35, 510, 35, 300)
            pdf.line(80, 510, 80, 300)
            pdf.line(175, 510, 175, 300)
            pdf.line(225, 510, 225, 300)
            pdf.line(290, 510, 290, 300)

            pdf.line(35, 510, 290, 510)
            pdf.setFont("Times-Bold", 12)
            pdf.drawString(40, 490, "INPUT")
            pdf.drawString(85, 490, "NAMA")
            pdf.drawString(180, 490, "NILAI")
            pdf.drawString(230, 490, "SATUAN")
            pdf.line(35, 480, 290, 480)

            pdf.setFont("Times-Roman", 12)
            pdf.drawString(40, 465, "AIN"+str(self.ain['flow']))
            pdf.drawString(85, 465, "FLOW")
            pdf.drawString(180, 465, str(self.get_value('flow')))
            pdf.drawString(230, 465, "L/min")
            pdf.line(35, 460, 290, 460)

            pdf.drawString(40, 445, "AIN"+str(self.ain['inlet']))
            pdf.drawString(85, 445, "INLET")
            pdf.drawString(180, 445, str(self.get_value('inlet')))
            pdf.drawString(230, 445, "BAR")
            pdf.line(35, 440, 290, 440)

            pdf.drawString(40, 425, "AIN"+str(self.ain['pressure_a']))
            pdf.drawString(85, 425, "PRESSURE A")
            pdf.drawString(180, 425, str(self.get_value('pressure_a')))
            pdf.drawString(230, 425, "BAR")
            pdf.line(35, 420, 290, 420)

            pdf.drawString(40, 405, "AIN"+str(self.ain['pressure_b']))
            pdf.drawString(85, 405, "PRESSURE B")
            pdf.drawString(180, 405, str(self.get_value('pressure_b')))
            pdf.drawString(230, 405, "BAR")
            pdf.line(35, 400, 290, 400)

            pdf.drawString(40, 385, "AIN"+str(self.ain['common_ma']))
            pdf.drawString(85, 385, "COMMON mA")
            pdf.drawString(180, 385, str(self.get_value('common_ma')))
            pdf.drawString(230, 385, "mA")
            pdf.line(35, 380, 290, 380)

            pdf.drawString(40, 365, "AIN"+str(self.ain['common']))
            pdf.drawString(85, 365, "COMMON")
            pdf.drawString(180, 365, str(self.get_value('common')))
            pdf.drawString(230, 365, "Voltage")
            pdf.line(35, 360, 290, 360)

            pdf.drawString(40, 345, "AIN"+str(self.ain['aktual_ma']))
            pdf.drawString(85, 345, "AKTUAL mA")
            pdf.drawString(180, 345, str(self.get_value('aktual_ma')))
            pdf.drawString(230, 345, "mA")
            pdf.line(35, 340, 290, 340)

            pdf.drawString(40, 325, "AIN"+str(self.ain['aktual_valve']))
            pdf.drawString(85, 325, "AKTUAL")
            pdf.drawString(180, 325, str(self.get_value('aktual_valve')))
            pdf.drawString(230, 325, "Voltage")
            pdf.line(35, 320, 290, 320)

            pdf.drawString(40, 305, "AIN"+str(self.ain['temp']))
            pdf.drawString(85, 305, "TEMP")
            pdf.drawString(180, 305, str(self.get_value('temp')))
            pdf.drawString(230, 305, "°C")
            pdf.line(35, 300, 290, 300)

            pdf.drawInlineImage("temp-chart.png", 300, 230, 520, 300)
            pdf.save()
            os.remove("temp-chart.png")
            return pdfname

        except:
            pass
        #unixTIMEx = date_time.currentMSecsSinceEpoch()

    ####################################################################
    # SEND  DATA FROM PYTHON TO CHART CALCULATED FUNCTION (CSV, RANDOM)
    ####################################################################

    @pyqtSlot(QObject)
    def update0(self, series):
        series.clear()
        for i in range(128):
            series.append(i, 45*(math.sin(0.05*3.1416*i)) + random.random()*8)

    @pyqtSlot(QObject)
    def update1(self, series):
        series.clear()
        for i in range(128):
            series.append(i, 20*(math.sin(0.075*3.1416*i)) +
                          random.random()*15)

    @pyqtSlot(QObject)
    def update2(self, series):
        series.clear()
        for i in range(128):
            series.append(i, 25*(math.sin(0.105*3.1416*i)) +
                          random.random()*12)

    @pyqtSlot(QObject)
    def update3(self, series):
        series.clear()
        for i in range(128):
            series.append(i, 30*(math.sin(0.035*3.1416*i)) +
                          random.random()*17)

    ####################################################################
    # FUNCTIONS FOR PAGE SETTINGS
    ####################################################################

    ######   Function Set Name To Label  ###############################
    @pyqtSlot(str)
    def welcomeText(self, name):
        self.setName.emit("Welcome, " + name)

    ######  Show / Hide Rectangle ######################################
    @pyqtSlot(bool, int)
    def showHideRectangle(self, isChecked, number):
        # print("Is rectangle visible"), isChecked, number)
        self.isVisible.emit(isChecked)


####################################################################
# MAIN ROUTINE
####################################################################
if __name__ == '__main__':
    main = MainWindow()
