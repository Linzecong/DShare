import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import JavaMethod 1.0
import SendImageSystem 1.0
import PostsSystem 1.0
import QtGraphicalEffects 1.0
import RecommendSystem 1.0
import "qrc:/GlobalVariable.js" as GlobalColor

Rectangle {
    id:mainwindow
    anchors.fill: parent
    property string str_userid;//记录这个页面的人的id
    property double dp:head.height/70

    Keys.enabled: true
    Keys.onBackPressed: {
        mainwindow.parent.visible=false
        mainwindow.parent.parent.forceActiveFocus();
    }

    function init(id){
        forceActiveFocus()
        str_userid=id
        recommendsystem.recommendXG(str_userid)
    }


    RecommendSystem{
        id:recommendsystem
        onStatueChanged: {
            if(Statue=="recommendxgDBError")
                myjava.toastMsg("数据太少，无法生成习惯推荐")

            if(Statue=="recommendyyDBError")
                myjava.toastMsg("数据太少，无法生成营养推荐")

            if(Statue=="recommendhyDBError")
                myjava.toastMsg("数据太少，无法生成好友推荐")


            if(Statue=="recommendxgSucceed"){
                var xgstr=recommendsystem.getXGRecommend().split("|||")
                for(var i=0;i<recommendmodel.count;i++)
                    recommendmodel.get(i).XGFood=xgstr[i]
                recommendsystem.recommendYY(str_userid)
            }

            if(Statue=="recommendyySucceed"){
                var yystr=recommendsystem.getYYRecommend().split("|||")
                for(var i=0;i<recommendmodel.count;i++)
                    recommendmodel.get(i).YYFood=yystr[i]
                recommendsystem.recommendHY(str_userid)
            }

            if(Statue=="recommendhySucceed"){
                var hystr=recommendsystem.getHYRecommend().split("|||")
                for(var i=0;i<recommendmodel.count;i++)
                    recommendmodel.get(i).HYFood=hystr[i]
            }


        }
    }



    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    MouseArea{
        anchors.fill: parent
    }

    JavaMethod{
        id:myjava;
    }

    //顶部栏
    Rectangle{
        Rectangle{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height:myjava.getStatusBarHeight()
            color:GlobalColor.StatusBar
        }

        id:head;
        z:5
        width:parent.width;
        height: parent.height/16*2

        color:GlobalColor.Main
        anchors.top: parent.top
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            color: GlobalColor.Main
        }

        Label{
            text:"＜";
            id:backbutton
            height: parent.height
            width:height
            anchors.left: parent.left
            anchors.leftMargin: 16*dp
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2

            verticalAlignment: Text.AlignVCenter
            font{
                family: localFont.name
                pixelSize: (head.height)/4

            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                id:headma
                onClicked: {
                    mainwindow.parent.visible=false
                    mainwindow.parent.parent.forceActiveFocus()
                }
            }
        }
        Label{
            id:headname
            text:"今日推荐"
            anchors.centerIn: parent
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            font{
                family: localFont.name
                //family: "微软雅黑"
                pointSize: 20
            }
            color: "white"
        }
    }


    ListModel{
        id:recommendmodel
        ListElement{
            Title:"早餐"
            YYFood:"暂无数据"
            XGFood:"暂无数据"
            HYFood:"暂无数据"
        }
        ListElement{
            Title:"午餐"
            YYFood:"暂无数据"
            XGFood:"暂无数据"
            HYFood:"暂无数据"
        }
        ListElement{
            Title:"晚餐"
            YYFood:"暂无数据"
            XGFood:"暂无数据"
            HYFood:"暂无数据"
        }
        ListElement{
            Title:"零食"
            YYFood:"暂无数据"
            XGFood:"暂无数据"
            HYFood:"暂无数据"
        }
        ListElement{
            Title:"点心"
            YYFood:"暂无数据"
            XGFood:"暂无数据"
            HYFood:"暂无数据"
        }
        ListElement{
            Title:"水果"
            YYFood:"暂无数据"
            XGFood:"暂无数据"
            HYFood:"暂无数据"
        }
    }


    Rectangle{
        id:mainrect
        anchors.top: head.bottom
        anchors.topMargin: 4*dp
        anchors.left: head.left
        height: parent.height-head.height
        width: parent.width
        property string username
        property string myid


        ListView{
            id:listview
            anchors.fill: parent
            clip:true
            cacheBuffer:contentHeight+2
            property int likeindex:0
            property int commentindex:0

            add: Transition{
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 200 }
            }

            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
            }

            populate: Transition {
                NumberAnimation { properties: "x,y"; duration: 800 }
            }
            remove: Transition {
                ParallelAnimation {
                    NumberAnimation { property: "opacity"; to: 0; duration: 500 }
                    NumberAnimation { properties: "x"; to: -2000; duration: 500 }
                }
            }

            spacing:2*dp

            Rectangle{
                anchors.fill: parent
                //color:GlobalColor.Background
                color:"white"
                z:-100
            }

            Rectangle {
                id: scrollbar
                anchors.right: listview.right
                anchors.rightMargin: 3
                y: listview.visibleArea.yPosition * listview.height
                width: 5
                height: listview.visibleArea.heightRatio * listview.height
                color: "grey"
                radius: 5
                z:2
                visible: listview.dragging||listview.flicking
            }


            delegate: Item{
                id:postitem
                width:parent.width

                height:title.height+yyrecommend.height+xgrecommend.height+hyrecommend.height+34*dp

                Rectangle{

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        color: GlobalColor.Main
                    }

                    anchors.fill: parent
                    anchors.margins: 5*dp
                    id:delegaterect


                    Text{
                        id:title


                        anchors.top: parent.top
                        anchors.topMargin:6*dp

                        anchors.horizontalCenter: parent.horizontalCenter

                        text: Title
                        color:GlobalColor.Word
                        font{
                            family: localFont.name
                            pointSize: 16
                        }
                    }


                    Text{
                        id:yyrecommend
                        anchors.left: parent.left
                        anchors.leftMargin: 10*dp
                        anchors.right: parent.right
                        anchors.rightMargin: 10*dp
                        anchors.top: title.bottom
                        anchors.topMargin: 5*dp
                        textFormat:Text.RichText
                        wrapMode: Text.Wrap

                        text: "根据营养推荐："+YYFood
                        color:"grey"
                        font{
                            family: localFont.name
                            pointSize: 12
                        }
                    }

                    Text{
                        id:xgrecommend

                        anchors.left: parent.left
                        anchors.leftMargin: 10*dp
                        anchors.right: parent.right
                        anchors.rightMargin: 10*dp

                        anchors.top: yyrecommend.bottom
                        anchors.topMargin: 5*dp
                        text: "根据习惯推荐："+XGFood
                        textFormat:Text.RichText
                        wrapMode: Text.Wrap
                        color:"grey"
                        font{
                            family: localFont.name
                            pointSize: 12
                        }
                    }

                    Text{
                        id:hyrecommend

                        anchors.left: parent.left
                        anchors.leftMargin: 10*dp
                        anchors.right: parent.right
                        anchors.rightMargin: 10*dp

                        anchors.top: xgrecommend.bottom
                        anchors.topMargin: 5*dp
                        text: "根据好友推荐："+HYFood
                        textFormat:Text.RichText
                        wrapMode: Text.Wrap
                        color:"grey"
                        font{
                            family: localFont.name
                            pointSize: 12
                        }
                    }
                }
            }
            model: recommendmodel
        }
    }


}



