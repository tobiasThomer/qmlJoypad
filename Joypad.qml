import QtQuick 2.7

Item {
    id: joystick

    property real xAxis: 0
    property real yAxis: 0

    property int alignment: Qt.AlignCenter

    property bool horizontalAnimation: true
    property bool verticalAnimation: true

    Rectangle {
        id: bounds

        anchors.left: if (alignment & Qt.AlignLeft) parent.left
        anchors.right: if (alignment & Qt.AlignRight) parent.right
        anchors.horizontalCenter: if(alignment & Qt.AlignHCenter) parent.horizontalCenter
        anchors.top: if (alignment & Qt.AlignTop) parent.top
        anchors.bottom: if (alignment & Qt.AlignBottom) parent.bottom
        anchors.verticalCenter: if (alignment & Qt.AlignVCenter) parent.verticalCenter
        anchors.centerIn: if (alignment & Qt.AlignCenter) parent

        width: Math.min(parent.width, parent.height)
        height: Math.min(parent.width, parent.height)

        radius: width / 2
        color: "#1d000000"

        property real innerRadius: (width - thumb.width) / 2

        NumberAnimation {
            id: xAnimation
            target: joystick
            property: "xAxis"
            to: 0
            duration: 200
            easing.type: Easing.OutSine
        }

        NumberAnimation {
            id: yAnimation
            target: joystick
            property: "yAxis"
            to: 0
            duration: 200
            easing.type: Easing.OutSine
        }


        MouseArea {
            id: mouseArea
            anchors.fill: parent
            propagateComposedEvents: true

            property bool thumbPressed
            property var thumbCenter: Qt.vector2d(thumb.x + thumb.width/2,
                                                  thumb.y + thumb.height/2)

            function constrain(value, min, max)
            {
                return (value < min) ? min : (value > max) ? max : value
            }

            onPressed: {
                var pos = Qt.vector2d(mouse.x, mouse.y)
                var fromThumbToPos = pos.minus(thumbCenter)

                thumbPressed = fromThumbToPos.length() < thumb.width/2 ? true : false
                thumb.offset = pos.minus(thumbCenter)

                if (thumbPressed)
                {
                    xAnimation.stop()
                    yAnimation.stop()
                }
            }

            onReleased: {
                if (horizontalAnimation) xAnimation.start()
                if (verticalAnimation) yAnimation.start()

                thumbPressed = false
            }

            onPositionChanged: {
                if (thumbPressed)
                {
                    // slightly adjust the thumb towards the pointer
                    thumb.offset = thumb.offset.times(0.98)

                    var pos = Qt.vector2d(mouse.x, mouse.y)

                    var newX = (pos.x - thumb.offset.x - (thumb.width/2) - bounds.innerRadius) / bounds.innerRadius
                    var newY = (pos.y - thumb.offset.y - (thumb.height/2)  - bounds.innerRadius) / bounds.innerRadius

                    joystick.xAxis = constrain(newX, -1, 1)
                    joystick.yAxis = constrain(newY, -1, 1)
                }
            }

        }

        Rectangle {
            id: verticalLine
            height: bounds.height
            width: 1
            anchors.centerIn: bounds

            color: "#992828"
        }

        Rectangle {
            id: horizontalLine
            width: bounds.width
            height: 1
            anchors.centerIn: bounds

            color: "#992828"
        }

        Rectangle {
            id: circle
            width: bounds.width * 0.3
            height: width
            anchors.centerIn: bounds

            color: "#00000000"

            border.color: "#992828"
            border.width: 1

            radius: width / 2
        }


        Rectangle {
            id: thumb
            width: bounds.width * 0.3
            height: width

            property var offset: Qt.vector2d(0, 0)

            x: bounds.innerRadius + (joystick.xAxis * bounds.innerRadius)
            y: bounds.innerRadius + (joystick.yAxis * bounds.innerRadius)

            radius: width / 2
            color: "#992828"
        }
    }

}
