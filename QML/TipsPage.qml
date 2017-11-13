import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import QtGraphicalEffects 1.0
import JavaMethod 1.0
import "qrc:/GlobalVariable.js" as GlobalColor

StackView{
    id:mainrect
    anchors.fill: parent

    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    initialItem: Rectangle {
        id:mainrect1
        anchors.fill: parent

        Text {
            anchors.centerIn: parent

            text:"欢迎使用DShare1.4<br>更新内容：<br><br>1.优化了性能<br><br>2.更新了服务器<br><br>3.重构了代码<br><br>5.修复了漏洞若干"
            horizontalAlignment: Text.AlignLeft
            color:"white"

            font{
                family: localFont.name
                pointSize: 20
            }
        }


        Rectangle{
            color:GlobalColor.SecondButton
            width: parent.width/4
            height: width/2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: parent.height/2.8

            border.width: 3
            border.color: "white"

            Text {
                anchors.centerIn: parent

                text:"下一步"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:"white"
                font{
                    family: localFont.name
                    pointSize: 16
                }

            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    mainrect.push(mainrect2)
                }
            }
        }



        color: GlobalColor.SecondButton
    }


    Component{
        id:mainrect2
        Rectangle{

            Image{
                anchors.fill: parent
                source: "qrc:/image/yindao1.jpg"
            }


            Rectangle{
                color:GlobalColor.SecondButton
                width: parent.width/4
                height: width/2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: parent.height/2.8

                border.width: 3
                border.color: "white"

                Text {
                    anchors.centerIn: parent

                    text:"完成"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color:"white"
                    font{
                        family: localFont.name
                        pointSize: 16
                    }

                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainrect.parent.source=""
                    }
                }
            }

        }
    }

}



