import QtQuick 2.7

Item {
    id: joypad

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
            target: joypad
            property: "xAxis"
            to: 0
            duration: 400
            easing.type: Easing.OutSine
        }

        NumberAnimation {
            id: yAnimation
            target: joypad
            property: "yAxis"
            to: 0
            duration: 400
            easing.type: Easing.OutSine
        }


        MultiPointTouchArea {
            id: touchArea
            anchors.fill: parent

            property var validPoint: TouchPoint
            property var thumbCenter: Qt.vector2d(thumb.x + thumb.width / 2,
                                                  thumb.y + thumb.height / 2)

            function constrain(value, min, max)
            {
                return (value < min) ? min : (value > max) ? max : value
            }

            onPressed: (touchPoints) => {
                for (var i = 0; i<touchPoints.length; i++)
                {
                    var pos = Qt.vector2d(touchPoints[i].x, touchPoints[i].y)

                    var fromThumbToPos = pos.minus(thumbCenter)

                    if (fromThumbToPos.length() < thumb.width / 2)
                    {
                        validPoint = touchPoints[i]
                        thumb.offset = fromThumbToPos
                        xAnimation.stop()
                        yAnimation.stop()
                    }
                }
            }

            onReleased: (touchPoints) => {
                for (var i = 0; i<touchPoints.length; i++)
                {
                    if (touchPoints[i].pointId == validPoint.pointId)
                    {
                        validPoint = 0
                        if (horizontalAnimation) xAnimation.start()
                        if (verticalAnimation) yAnimation.start()
                    }
                }
            }

            onUpdated: (touchPoints) => {
                for (var i = 0; i<touchPoints.length; i++)
                {
                    if (touchPoints[i].pointId == validPoint.pointId)
                    {
                        // slightly adjust the thumb towards the pointer
                        thumb.offset = thumb.offset.times(0.98)

                        var pos = Qt.vector2d(touchPoints[i].x, touchPoints[i].y)

                        var newX = (pos.x - thumb.offset.x - (thumb.width/2) - bounds.innerRadius) / bounds.innerRadius
                        var newY = (pos.y - thumb.offset.y - (thumb.width/2) - bounds.innerRadius) / bounds.innerRadius

                        joypad.xAxis = constrain(newX, -1, 1)
                        joypad.yAxis = constrain(newY, -1, 1)
                    }
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

            x: bounds.innerRadius + (joypad.xAxis * bounds.innerRadius)
            y: bounds.innerRadius + (joypad.yAxis * bounds.innerRadius)

            radius: width / 2
            color: "#992828"
        }
    }

}
