import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Hello World")

    property var list: ["Show custom color bar", "Show base gridview"]
    ListModel {
        id: lmd
        ListElement {lable: "Show custom color bar"; sourcePath : "qrc:/Com_custom_color.qml"}
        ListElement {lable: "Show custom color bar"; sourcePath : "qrc:/BaseGridview.qml"}
    }

    Rectangle {
        id: backGround
        anchors.fill: parent
        color: "gray"
    }

    ListView {
        id: lv
        width: 200
        height: 300
        anchors {
            left: parent.left
            leftMargin: 50
            top: parent.top
            topMargin: 50
        }

        model: lmd
        delegate: Rectangle {
            width: 200
            height: 100
            color: index % 2 === 0 ? "blue" : "green"
            Text {
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                color: "white"
                text: lable
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    loader.setSource(sourcePath)
                }
            }
        }
    }

    Loader {
        id: loader
        anchors {
            left: lv.right
            leftMargin: 50
        }
    }



}
