import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1
import NewsSystem 1.0
import JavaMethod 1.0
import QtGraphicalEffects 1.0

import "qrc:/GlobalVariable.js" as GlobalColor
Rectangle{
    id:mainpage
    anchors.fill: parent
    color:GlobalColor.Background

    property string userid
    property string nickname


    property string newsid

    property string likenum
    property string dislikenum

    property double dp:head.height/70


    function getNews(id,a,b,title,time){
        forceActiveFocus();//用于响应返回键

        newsid=id
        userid=a
        nickname=b
        titlelabel.text=title
        posttimelabel.text=time

        newssystem.getContent(id);
    }


    MouseArea{
        anchors.fill: parent
    }

    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    Keys.enabled: true
    Keys.onBackPressed: {
        mainpage.parent.visible=false
        mainpage.parent.parent.forceActiveFocus();
    }


    JavaMethod{
        id:myjava
    }

    NewsSystem{
        id:newssystem
        onStatueChanged: {
            if(Statue=="getcontentDBError")
                myjava.toastMsg("获取新闻详情失败")

            if(Statue=="getcontentSucceed"){
                var str=newssystem.getNewsContent()

                var data=str.split("@")

                contentlabel.text=data[3]
                sourcelabel.text=data[4]
                likenum=data[5]
                dislikenum=data[6]
            }


        }

    }


    Rectangle{
        Rectangle{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height:myjava.getStatusBarHeight()
            color:GlobalColor.StatusBar
        }
        id:head;
        z:7
        width:parent.width;
        height: parent.height/16*2
        color:GlobalColor.Main
        anchors.top: parent.top;

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
            color: "white"
            MouseArea{
                id:headma
                anchors.fill: parent
                onClicked: {


                    mainpage.parent.visible=false
                    mainpage.parent.parent.forceActiveFocus();
                }
            }
        }
        Label{
            id:headname
            text:"新闻详情"
            anchors.centerIn: parent
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            font{
                family: localFont.name
                pointSize: 20
            }
            color: "white"
        }
    }


    Flickable{
        anchors.top: head.bottom
        anchors.left: head.left
        anchors.right: head.right
        height:parent.height-head.height

        contentHeight: delegaterect.height+10*dp
        clip: true

        Rectangle{
            id:delegaterect


            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: GlobalColor.Main
            }

            anchors.margins: 5*dp

            height:titlelabel.height+posttimelabel.height+line.height+contentlabel.height+80*dp+parent.width/6
            z:2


            //标题
            Text{
                id:titlelabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 16*dp
                anchors.rightMargin: 16*dp

                anchors.top: parent.top
                anchors.topMargin:16*dp
                text: "获取中"
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                lineHeight: 1.2
                color:"black"
                font{
                    family: localFont.name
                    bold:true
                    pointSize: 20
                }
            }

            //发表时间
            Text{
                id:posttimelabel
                anchors.left: parent.left
                anchors.leftMargin: 16*dp
                anchors.top: titlelabel.bottom
                anchors.topMargin: 16*dp
                width: parent.width/3
                verticalAlignment:Text.AlignBottom
                text: "获取中"
                color:"grey"
                font{
                    family: localFont.name
                    pointSize: 12
                }
            }

            //来源
            Text{
                id:sourcelabel
                anchors.left: posttimelabel.right
                anchors.leftMargin: -8*dp

                anchors.top: posttimelabel.top

                verticalAlignment:Text.AlignBottom
                text: "获取中"
                color: "grey"
                font{
                    family: localFont.name
                    pointSize: 12
                }
            }

            Rectangle{
                id:line
                anchors.top: sourcelabel.bottom
                anchors.topMargin: 4*dp
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width/1.1
                height:2
                color: "lightgrey"
            }

            Text{
                id:contentlabel
                anchors.top: line.bottom
                anchors.topMargin: 12*dp
                anchors.left: parent.left
                anchors.leftMargin: 12*dp
                anchors.right: parent.right
                anchors.rightMargin: 12*dp
                lineHeight: 1.5
                text: "加载中"
                wrapMode: Text.Wrap;
                font{
                    family: localFont.name
                    pointSize: 14
                }

            }

            Rectangle{
                id:likebutton
                anchors.top: contentlabel.bottom
                anchors.topMargin: 16*dp
                anchors.left: parent.left
                anchors.leftMargin: 32*dp
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: 16*dp
                height:parent.width/6
                color:"white"
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: GlobalColor.Main
                }

                Text{
                    id:likestring
                    anchors.fill: parent
                    text:"有价值\n"+"12"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.5
                    font{
                        family: localFont.name
                        pointSize: 18
                    }
                }
            }

            Rectangle{
                id:dislikebutton
                anchors.top: contentlabel.bottom
                anchors.topMargin: 16*dp
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 16*dp
                anchors.right: parent.right
                anchors.rightMargin: 32*dp
                height:parent.width/6
                color:"white"
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: GlobalColor.Main
                }

                Text{
                    id:dislikestring
                    anchors.fill: parent
                    text:"无价值\n"+"12"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.5
                    font{
                        family: localFont.name
                        pointSize: 18
                    }
                }
            }

        }





    }










}

