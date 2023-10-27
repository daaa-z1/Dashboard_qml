import QtQuick 2.11

Item {
    id: slider
    height: heightSlider

    signal released(int value)
    signal pressed()

    property real value: 1
    onValueChanged: updatePos()
    property real minimum: 1
    property real maximum: 1
    property real step: 1
    property real xMax: width - handle.width
    onXMaxChanged: updatePos()
    onMinimumChanged: updatePos()

    property color backgroundEmpty: "lightgrey"
    property color backgroundFull: "#39F724"
    property real backgroundOpacity: 1
    property real backgroundOpacityFull: 1
    property color pressCircle: "#39F724"
    property color handleGrad1: "lightgray"
    property color handleGrad2: "gray"
    property real heightSlider: 10
    property real fullCircle: 30
    property real circleWidth: 70
    property real circleHeight: 70

    function updatePos() {
        if (maximum > minimum) {
            var pos = (value - minimum) * slider.xMax / (maximum - minimum);
            pos = Math.min(pos, width - handle.width / 2);
            pos = Math.max(pos, 0);
            handle.x = pos;
        } else {
            handle.x = 0;
        }
    }

    Rectangle {
        id: background
        x: 15
        height: heightSlider
        width: slider.width - 30
        border.color: "white"
        border.width: 0
        radius: heightSlider * 2
        color: backgroundEmpty
        opacity: backgroundOpacity
    }

    Rectangle {
        id: sliderFilled
        width: handle.x + (handle.width / 2)
        height: heightSlider
        border.color: "white"
        border.width: 0
        radius: heightSlider * 2
        color: backgroundFull
        opacity: backgroundOpacityFull
    }

    Rectangle {
        id: handle
        smooth: true
        width: fullCircle
        height: fullCircle
        radius: fullCircle / 2
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: cerchio
            smooth: true
            visible: false
            anchors.centerIn: parent
            width: circleWidth
            height: circleHeight
            radius: circleWidth / 2
            color: "transparent"
            border.width: 4
            border.color: pressCircle
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: slider.xMax

            onPositionChanged: {
                var stepPixel = ((slider.width - 30) * slider.step) / (maximum - minimum);
                var numSteps = Math.round(handle.x / stepPixel);
                handle.x = numSteps * stepPixel;
                value = Math.round(numSteps * slider.step) + minimum;
            }

            onPressed: {
                cerchio.visible = true;
                slider.pressed();
            }

            onReleased: {
                cerchio.visible = false;
                var stepPixel = ((slider.width - 30) * slider.step) / (maximum - minimum);
                var numSteps = Math.round(handle.x / stepPixel);
                handle.x = numSteps * stepPixel;
                value = Math.round(numSteps * slider.step) + minimum;
                slider.released(value);
            }
        }
    }
}
