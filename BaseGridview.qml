import QtQuick 2.0

GridView {
    id: gridView
    property int spacing: 60
    width: 1020 + spacing
    height: 460
    anchors {
        top: parent.top
        topMargin: 100
        horizontalCenter: parent.horizontalCenter
    }
    bottomMargin: -spacing
    interactive: gridView.contentHeight - spacing > gridView.height
    clip: true
    snapMode: GridView.SnapToRow

    cellWidth: 300 + spacing
    cellHeight: 200 + spacing
    model: 8
    delegate: Rectangle {
        width: 300
        height: 200
        color: "red"
        opacity: 0.3
        Text {
            anchors.centerIn: parent
            text: index
            font.pixelSize: 32
            color: "white"
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "blue"
        opacity: 0.3
    }
}
