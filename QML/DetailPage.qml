import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import JavaMethod 1.0
import PostsSystem 1.0
import QtGraphicalEffects 1.0
import "qrc:/GlobalVariable.js" as GlobalColor
Rectangle {
    id:mainrect;
    anchors.fill: parent

    property string userid
    property string nickname
    property double dp:head.height/70

    function getNotice(username,nickname1){
        noticemodel.clear()
        userid=username
        nickname=nickname1
        dbsystem.getNotices(userid)
        forceActiveFocus()
    }

    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }


    MouseArea{
        anchors.fill: parent

    }

    Keys.enabled: true
    Keys.onBackPressed: {
        mainrect.parent.visible=false
        mainrect.parent.parent.forceActiveFocus();
    }


    JavaMethod{
        id:myjava
    }


    Rectangle{
        Rectangle{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height:myjava.getStatusBarHeight()
            color:GlobalColor.StatusBar
        }
        id:head
        z:5
        width:parent.width
        height: parent.height/16*2
        color: GlobalColor.Main
        anchors.top: parent.top
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            color: GlobalColor.Main
        }
        Label{
            id:back
            height: parent.height
            width:height
            text:"＜"
            color: "white"
            font{
                        family: localFont.name
                pixelSize: (head.height)/4
            }
            anchors.left: parent.left
            anchors.leftMargin: 16*dp
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            verticalAlignment: Text.AlignVCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    mainrect.parent.visible=false
                }
            }
        }



        Label{
            id:headname
            text:"食材数据"
            anchors.centerIn: parent
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            font{
                        family: localFont.name

                pointSize: 20
            }
            color: "white";
        }


    }
    ListModel{
        id:foodmodel
        ListElement{
            FoodText:"哈哈"
        }
        ListElement{
            FoodText:"哦哦"
        }
        ListElement{
            FoodText:"哈哈"
        }
    }

    Flickable{
       anchors.top: head.bottom

       height: parent.height-head.height
       width: parent.width
       contentHeight: foodview.height+relationview.height
    clip: true
    flickableDirection:Flickable.VerticalFlick
    ListView{
        id:foodview
        spacing: 15*dp
        anchors.top: parent.top
        anchors.topMargin: 15*dp
        clip: true
        width: parent.width
        height:contentHeight+2
        contentHeight: delegate.height*foodmodel.count
        model: foodmodel

        delegate: Item{
            id:delegate
            width:mainrect.width

            height: (head.height)/2


            Rectangle{
                id:foodbar
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: 80*dp
                anchors.left: parent.left
                anchors.leftMargin: 80*dp


                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: GlobalColor.Main
                }

                Text{
                    anchors.fill: parent
                    id:foodtext
                    text:FoodText
                    color:"grey"
                    font{
                        family: localFont.name
                        pointSize: 16
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter




                    Image{
                        Rectangle{
                            anchors.fill: parent
                            color:GlobalColor.Main
                            z:-100
                        }
                        anchors.right: foodtext.right
                        anchors.rightMargin: 8*dp
                        anchors.verticalCenter: foodtext.verticalCenter
                        source: "qrc:/image/detail.png"
                        height: foodbar.height/1.5
                        width:height
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {

                            }
                        }
                    }

                }
            }

        }

    }

    ListView{
        id:relationview
        spacing: 15*dp
        anchors.top: foodview.bottom
        anchors.topMargin: 20*dp
        clip: true
        width: parent.width
        height:contentHeight+2
        contentHeight: relationdelegate.height*foodmodel.count
        model: foodmodel

        delegate: Item{
            id:relationdelegate
            width:mainrect.width

            height: (head.height)/2


            Rectangle{
                id:relationbar
                height: parent.height
                anchors.right: parent.right
                anchors.rightMargin: 80*dp
                anchors.left: parent.left
                anchors.leftMargin: 80*dp


                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: GlobalColor.Main
                }

                Text{
                    anchors.fill: parent
                    id:relationtext
                    text:FoodText
                    color:"grey"
                    font{
                        family: localFont.name
                        pointSize: 16
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter




                    Image{
                        Rectangle{
                            anchors.fill: parent
                            color:GlobalColor.Main
                            z:-100
                        }
                        anchors.right: relationtext.right
                        anchors.rightMargin: 8*dp
                        anchors.verticalCenter: relationtext.verticalCenter
                        source: "qrc:/image/detail.png"
                        height: relationbar.height/1.5
                        width:height
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {

                            }
                        }
                    }

                }
            }

        }

    }


}

}
