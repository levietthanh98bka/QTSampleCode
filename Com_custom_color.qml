import QtQuick 2.12
import QtQml 2.12

Item {
    id: root
    width: 1000
    height: 100
    property int sliderWidth: 650 - previewSelectedColor.width
    property int value: 0
    property int minValue: previewSelectedColor.width/2
    property int maxValue: sliderBG.width - 1 - (previewSelectedColor.width/2)
    property int numOfStep: maxValue - minValue
    property int step: 5
    property bool dragActive: false
    property string colorSelected : "#6e00a9"

    function setValue(val) {
        var roundValue = Math.round(val)
        if(roundValue < minValue){
            roundValue = minValue
        } else if (roundValue > maxValue) {
            roundValue = maxValue
        }
        if (roundValue !== value){
            value = roundValue
        }
    }

    function increaseValue(step) {
        var result = (value + step) > maxValue ? maxValue : (value + step)
        setValue(result)
    }

    function decreaseValue(step) {
        var result = (value - step) < minValue ? minValue : (value - step)
        setValue(result)
    }

    function updateValue(mouseX) {
        var step = sliderWidth/numOfStep
        var temp = Math.round(mouseX/step)
        temp = temp + minValue
        var ret = (temp >= maxValue) ? maxValue : (temp <= minValue) ? minValue : temp
        setValue(ret, true)
    }

    Image {
        id: btnMinus
        width: 86
        height: 86
        anchors {
            verticalCenter: sliderBG.verticalCenter
            right: sliderBG.left
            rightMargin: 40
        }
        source: "qrc:/leftBtn.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                decreaseValue(step)

            }
        }
    }

    Image {
        id: btnPlus
        width: 86
        height: 86
        anchors {
            verticalCenter: sliderBG.verticalCenter
            left: sliderBG.right
            leftMargin: 40
        }
        source: "qrc:/rightBtn.png"
        MouseArea {
            anchors.fill: parent
            onClicked: {
                increaseValue(step)
            }
        }
    }

    Image {
        id: sliderBG
        width: 650
        height: 78
        anchors {
            top: parent.top
            topMargin: 22
            left: parent.left
            leftMargin: 150
        }
        visible: false
        source: "qrc:/colorSpectrum.png"
        onStatusChanged: {
            if (status === Image.Ready) {
                canvas.requestPaint();
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: sliderBG
        onPaint: {
            var ctx = getContext("2d");
            ctx.drawImage(sliderBG, 0, 0, width, height);
        }
    }

    onValueChanged: {
        var ctx = canvas.getContext("2d");
        var imageData = ctx.getImageData(value, 39, 1, 1);
        var r = imageData.data[0];
        var g = imageData.data[1];
        var b = imageData.data[2];
        var a = imageData.data[3];
        colorSelected = "#" + r.toString(16).padStart(2, '0')
                        + g.toString(16).padStart(2, '0')
                        + b.toString(16).padStart(2, '0');
    }

    Rectangle {
        id: previewSelectedColor
        width: 66
        height: 66
        color: colorSelected
        anchors.verticalCenter: sliderBG.verticalCenter
        z: 666
        x: sliderBG.x - (width/2)+ value*(sliderWidth/numOfStep)
        radius: 20
        border.color: "gray"
        border.width: 4

        Text {
            anchors.centerIn: parent
            text: colorSelected
            color: "white"
        }
    }

    MouseArea {
        id: dragArea
        property bool isMouseDragged: false
        property int pressPositionX: 0
        width: sliderBG.width
        height: sliderBG.height
        anchors.centerIn: sliderBG
        property int positionX: 0
        onPressed: {
            isMouseDragged = false
            pressPositionX = mouse.x
            if (previewSelectedColor.x - x <= mouse.x && previewSelectedColor.x - x + previewSelectedColor.width >= mouse.x) {
                dragActive = true
            }
        }
        onReleased: {
            updateValue(mouse.x - previewSelectedColor.width/2)
            timerDrag.stop()
            dragActive = false
        }
        onCanceled: {
            dragActive = false
            timerDrag.stop()
            timer.stop()
        }
        onPositionChanged: {
            if (!isMouseDragged && Math.abs(mouse.x - pressPositionX) > 20) {
                isMouseDragged = true
            }
            if (dragActive) {
                positionX=mouse.x - previewSelectedColor.width/2
                timerDrag.start()
            }
        }
    }

    Timer {
        id: timer           // press and hold
        running: false
        interval: 500
        repeat: true
        property int stepChanged: 0
        onTriggered: {
            if(stepChanged > 0)
                increaseValue(step, true)
            else if(stepChanged < 0) {
                decreaseValue(step, true)
            }
        }
    }

    Timer {
        id: timerDrag
        interval: 25
        repeat: true
        onTriggered: {
            if(dragActive){
                updateValue(dragArea.positionX)
            } else{
                stop()
            }
        }
    }
}
