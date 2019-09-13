import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtMultimedia 5.13

ApplicationWindow {
    id: window
    visible: true
    width: 480
    height: 480
    title: qsTr("Hello World")

    property bool turn : true
    property var matrix : [4, 9, 2, 3, 5, 7, 8, 1, 6]
    property var values : ["", "", "", "", "", "", "", "", ""]

    signal reset

    function checkFor(symbol) {
        var sum=0
        for (var i = 0; i < 9; i++)
            if (values[i] === symbol)
                sum += matrix[i]
        if (sum === 15) {
            console.log(symbol + " ganhou!")
            for (var j = 0; j < 9; j++)
                values[j] = ""
            reset()
        }
    }

    MediaPlayer {
        source: "qrc:/384306__frankum__nebula-techno-house-loop.mp3"
        autoPlay: true
        loops: MediaPlayer.Infinite
    }
    MediaPlayer {
        id: click
        source: "qrc:/click.ogg"
    }

    Grid {
        id: grid
        anchors.fill: parent
        rows: 3
        columns: 3
        Repeater {
            model: 9
            Rectangle {
                width: parent.width/3
                height: parent.height/3
                color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        click.play()
                        label.text = turn ? "X":"O"
                        label.scale = 1
                        values[index] = label.text
                        turn = !turn
                        checkFor("X")
                        checkFor("O")
                    }
                }
                Label {
                    id: label
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font { pixelSize: 100; bold: true }
                    color: "white"
                    scale: 0
                    Connections {
                        target: window
                        onReset: label.text = ""
                    }
                    Behavior on scale {
                        ParallelAnimation {
                            NumberAnimation {
                                duration: 1000
                                easing.type: Easing.InOutElastic
                            }
                            PropertyAnimation {
                                target: label
                                property: "rotation"
                                from: 0; to: 360
                                duration: 1000
                            }
                        }
                    }
                }
            }
        }
    }
}
