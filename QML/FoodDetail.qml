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


    property double dp:head.height/70


    function init(a,b){
        fooddes.text=""

        badrelationmodel.clear()
        goodrelationmodel.clear()
        headname.text=a
        foodname.text=a
        foodimage.source=b
        dbsystem.getFoodDetail(a)
        forceActiveFocus()

    }

    DataSystem{
        id:dbsystem
        onStatueChanged: {
            if(Statue=="getfooddetailSucceed"){
                fooddes.text=dbsystem.getFoodDes()
                dbsystem.getGoodRelation(foodname.text)
            }

            if(Statue=="getfooddetailDBError"){
                myjava.toastMsg("服务器出错...")
            }

            if(Statue=="getgoodrelationSucceed"){
                var str=dbsystem.getGoodReason()
                var alllist=str.split("{|}")
                for(var i=0;i<alllist.length-1;i++)
                goodrelationmodel.append({"FirstFood":foodname.text,"SecondFood":alllist[i].split("|||")[0],"Reason":alllist[i].split("|||")[1]})


                dbsystem.getBadRelation(foodname.text)
            }

            if(Statue=="getbadrelationSucceed"){
                var str2=dbsystem.getBadReason()
                var alllist2=str2.split("{|}")
                for(var i2=0;i2<alllist2.length-1;i2++)
                badrelationmodel.append({"FirstFood":foodname.text,"SecondFood":alllist2[i2].split("|||")[0],"Reason":alllist2[i2].split("|||")[1]})

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
            text:"相生相克"
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
        id:goodrelationmodel

    }

    ListModel{
        id:badrelationmodel

    }


    Flickable{
        anchors.top: head.bottom

        height: parent.height-head.height
        width: parent.width
        contentHeight: fooddetail.height+goodrelationview.height+badrelationview.height+20*dp
        clip: true
        flickableDirection:Flickable.VerticalFlick


        Rectangle{
            id:fooddetail
            anchors.top: parent.top
            anchors.topMargin: 10*dp
            anchors.left: parent.left
            anchors.leftMargin: 10*dp
            anchors.right: parent.right
            anchors.rightMargin: 10*dp

            height: (foodimage.height+foodname.height+20*dp)>(fooddes.height+10*dp)?(foodimage.height+foodname.height+20*dp):(fooddes.height+15*dp)

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: GlobalColor.Main
            }

            Image{
                id:foodimage
                fillMode: Image.PreserveAspectFit
                anchors.top:parent.top
                anchors.topMargin: 10*dp
                anchors.left: parent.left
                anchors.leftMargin: 8*dp
                height: 60*dp
                width:height
                Label{
                    anchors.centerIn: parent
                    visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                    text:(parent.status==Image.Loading)?"加载中":"无"
                    color:"grey"
                }
            }

            Text{
                id:foodname
                anchors.top: foodimage.bottom
                anchors.topMargin: 10*dp
                horizontalAlignment: Text.AlignHCenter
                width: 60*dp+16*dp
                anchors.left: parent.left
                wrapMode: Text.Wrap
                color:"grey"
                font{
                    family: localFont.name
                    pointSize: 16
                    bold: true
                }
                verticalAlignment: Text.AlignVCenter
            }



            Text{
                id:fooddes

                anchors.top: foodimage.top
                anchors.left: foodname.right
                anchors.leftMargin: 8*dp
                anchors.right: parent.right
                anchors.rightMargin: 8*dp
                wrapMode: Text.Wrap
                textFormat:Text.RichText
                color:"grey"
                font{
                    pointSize: 14
                    family: localFont.name
                }


            }
        }



        ListView{
            id:goodrelationview
            anchors.top: fooddetail.bottom
            anchors.topMargin: 10*dp
            width: parent.width
            height:goodrelationmodel.count>0?contentHeight+2:0
            model: goodrelationmodel

            visible: goodrelationmodel.count>0?true:false
            header:Rectangle{
                height:head.height/2.5
                width:parent.width
                Image{
                    Rectangle{
                        anchors.fill: parent
                        color:"lightgreen"
                        anchors.margins: 5
                        z:-100
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8*dp
                    anchors.left: parent.left
                    height:parent.height
                    width:height
                    source:"qrc:/image/good.png"
                    fillMode: Image.PreserveAspectFit
                }
            }

            delegate: Item{
                id:goodrelationdelegate
                width:mainrect.width
                height:goodrelationbar.height+15*dp

                Rectangle{
                    id:goodrelationbar
                    anchors.right: parent.right
                    anchors.rightMargin: 10*dp
                    anchors.left: parent.left
                    anchors.leftMargin: 10*dp
                    height: goodrelationtext.height+15*dp
                    anchors.verticalCenter: parent.verticalCenter

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        color: "lightgreen"
                    }

                    Label{
                        anchors.leftMargin: 4*dp
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 4*dp
                        anchors.right: parent.right
                        anchors.left: parent.left
                        id:goodrelationtext
                        text:"<strong>"+FirstFood+"</strong> + <strong>"+SecondFood+"</strong> = <strong>"+Reason+"</strong>"
                        color:"grey"
                        wrapMode: Text.Wrap
                        verticalAlignment: Text.AlignVCenter
                        font{
                            family: localFont.name
                            pointSize: 16
                        }

                    }
                }

            }
        }





        ListView{
            id:badrelationview
            anchors.top: goodrelationview.bottom
            width: parent.width
            height:badrelationmodel.count>0?contentHeight+2:0
            model: badrelationmodel
            visible: badrelationmodel.count>0?true:false
            header:Rectangle{
                height:head.height/2.5
                width:parent.width
                Image{
                    Rectangle{
                        anchors.fill: parent
                        color:"red"
                        anchors.margins: 5
                        z:-100
                    }
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 8*dp
                    anchors.left: parent.left
                    height:parent.height
                    width:height
                    source:"qrc:/image/bad.png"
                    fillMode: Image.PreserveAspectFit
                }
            }

            delegate: Item{
                id:badrelationdelegate
                width:mainrect.width
                height:badrelationbar.height+15*dp

                Rectangle{
                    id:badrelationbar
                    anchors.right: parent.right
                    anchors.rightMargin: 10*dp
                    anchors.left: parent.left
                    anchors.leftMargin: 10*dp
                    height: badrelationtext.height+15*dp
                    anchors.verticalCenter: parent.verticalCenter

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        color: "red"
                    }

                    Label{
                        anchors.leftMargin: 4*dp
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 4*dp
                        anchors.right: parent.right
                        anchors.left: parent.left
                        id:badrelationtext
                        text:"<strong>"+FirstFood+"</strong> + <strong>"+SecondFood+"</strong> = <strong>"+Reason+"</strong>"
                        color:"grey"
                        wrapMode: Text.Wrap
                        verticalAlignment: Text.AlignVCenter
                        font{
                            family: localFont.name
                            pointSize: 16
                        }

                    }
                }

            }
        }







    }

}
