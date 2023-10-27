import QtQuick 2.11
import QtQuick.Shapes 1.12
import QtQml 2.12

Item {
    id: control

    property int trackWidth: 20
    property int progressWidth: 20
    property int handleWidth: 22
    property int handleHeight: 22
    property int handleRadius: 11
    property int handleVerticalOffset: 0
    property real startAngle: 0
    property real endAngle: 360
    property real minValue: 0.0
    property real maxValue: 1.0
    property real value: 0.0
    readonly property alias angle: internal.angle
    property int capStyle: Qt.RoundCap
    property color trackColor: "#505050"
    property color progressColor: "#3a4ec4"
    property color handleColor: "#fefefe"
    property real stepSize: 0.1
    property bool snap: false
    property Component handle: null
    readonly property alias pressed: trackMouse.pressed
    property bool hideTrack: false
    property bool hideProgress: false
    property bool interactive: true
    property alias cursorShape: trackMouse.cursorShape

    implicitWidth: 250
    implicitHeight: 250

    Binding {
        target: control
        property: "value"
        value: control.snap ? internal.snappedValue : internal.mapFromValue(startAngle, endAngle, minValue, maxValue, internal.angleProxy)
        when: internal.setUpdatedValue
        restoreMode: Binding.RestoreBinding
    }

    QtObject {
        id: internal
        property var centerPt: Qt.point(control.width / 2, control.height / 2)
        property real baseRadius: Math.min(control.width, control.height) / 2 - Math.max(control.trackWidth, control.progressWidth) / 2
        property real actualSpanAngle: control.endAngle - control.startAngle
        property color transparentColor: "transparent"
        property color trackColor: control.trackColor
        property bool setUpdatedValue: false
        property real angleProxy: control.startAngle
        property real snappedValue: 0.0
        readonly property real angle: internal.mapFromValue(control.minValue, control.maxValue, control.startAngle, control.endAngle, control.value)

        function mapFromValue(inMin, inMax, outMin, outMax, inValue) {
            return (inValue - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
        }

        function updateAngle(angleVal) {
            if (angleVal < 0)
                angleVal += 360;

            if ((angleVal >= control.startAngle) && (angleVal <= control.endAngle)) {
                internal.setUpdatedValue = true;
                internal.angleProxy = Qt.binding(function() { return angleVal; });
                if(control.snap) {
                    var mappedValue = internal.mapFromValue(startAngle, endAngle, minValue, maxValue, internal.angleProxy);
                    var range = control.maxValue - control.minValue;
                    var effectiveStep = 2;
                    var actualVal = control.stepSize * Math.round(mappedValue / control.stepSize);
                    internal.snappedValue = actualVal;
                }
                internal.setUpdatedValue = false;
            }
        }
    }

    Shape {
        id: trackShape
        width: control.width
        height: control.height
        layer.enabled: true
        layer.samples: 8
        visible: !control.hideTrack

        ShapePath {
            id: trackShapePath
            strokeColor: control.trackColor
            fillColor: internal.transparentColor
            strokeWidth: control.trackWidth
            capStyle: control.capStyle

            PathAngleArc {
                radiusX: internal.baseRadius
                radiusY: internal.baseRadius
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: control.startAngle - 90
                sweepAngle: internal.actualSpanAngle
            }
        }
    }

    Shape {
        id: progressShape
        width: control.width
        height: control.height
        layer.enabled: true
        layer.samples: 8
        visible: !control.hideProgress

        ShapePath {
            id: progressShapePath
            strokeColor: control.progressColor
            fillColor: internal.transparentColor
            strokeWidth: control.progressWidth
            capStyle: control.capStyle

            PathAngleArc {
                radiusX: internal.baseRadius
                radiusY: internal.baseRadius
                centerX: control.width / 2
                centerY: control.height / 2
                startAngle: control.startAngle - 90
                sweepAngle: control.angle - control.startAngle
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: control.interactive
        onClicked: {
            var outerRadius = Math.min(control.width, control.height) / 2;
            var innerRadius = outerRadius - Math.max(control.trackWidth, 20);
            var clickedDistance = (mouseX - internal.centerPt.x) * (mouseX - internal.centerPt.x) + (mouseY - internal.centerPt.y) * (mouseY - internal.centerPt.y);
            var innerRadius2 = (innerRadius * innerRadius);
            var outerRadius2 = (outerRadius * outerRadius);
            var isOutOfInnerRadius = clickedDistance > innerRadius2;
            var inInSideOuterRadius = clickedDistance <= outerRadius2;
            if (inInSideOuterRadius && isOutOfInnerRadius) {
                var angleDeg = Math.atan2(mouseY - internal.centerPt.y, mouseX - internal.centerPt.x) * 180 / Math.PI + 90;
                internal.updateAngle(angleDeg);
            }
        }
    }

    Item {
        id: handleItem
        visible: control.interactive

        x: control.width / 2 - width / 2
        y: control.height / 2 - height / 2
        z: 2
        width: control.handleWidth
        height: control.handleHeight
        antialiasing: true

        transform: [
            Translate {
                y: -(Math.min(control.width, control.height) / 2) + Math.max(control.trackWidth, control.progressWidth) / 2 + control.handleVerticalOffset
            },
            Rotation {
                angle: control.angle
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]

        MouseArea {
            id: trackMouse
            enabled: control.interactive

            function getVal() {
                var handlePoint = mapToItem(control, trackMouse.mouseX, trackMouse.mouseY);
                var angleDeg = Math.atan2(handlePoint.y - internal.centerPt.y, handlePoint.x - internal.centerPt.x) * 180 / Math.PI + 90;
                internal.updateAngle(angleDeg);
            }

            anchors.fill: parent
            onPositionChanged: getVal()
            onClicked: getVal()
            cursorShape: Qt.ArrowCursor
        }

        Loader {
            id: handleLoader
            sourceComponent: control.handle ? handle : handleComponent
        }
    }

    Component {
        id: handleComponent
        Rectangle {
            width: control.handleWidth
            height: control.handleHeight
            color: control.handleColor
            radius: control.handleRadius
            antialiasing: true
        }
    }
}
