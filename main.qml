import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Joypad Example")


    Joypad {
        id: joypad

        anchors.bottom: textX.top
        anchors.bottomMargin: 20

        anchors.right: parent.right
        anchors.rightMargin: 10

        anchors.left: parent.left
        anchors.leftMargin: 10

        anchors.top: parent.top
        anchors.topMargin: 10

        alignment: Qt.AlignCenter
    }

    TextField {
        id: textX
        text: joypad.xAxis

        anchors.bottom: parent.bottom
    }

    TextField {
        id: textY
        text: joypad.yAxis

        anchors.left: textX.right
        anchors.bottom: parent.bottom
    }



}
