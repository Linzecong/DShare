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
property int modelindex: 0
    property string allfood

    function getModel(a){
        foodmodel.clear()
        badrelationmodel.clear()
        goodrelationmodel.clear()

        allfood=a;
        dbsystem.getFoodRelation(a)
        myjava.toastMsg("获取中...")
        forceActiveFocus()
    }

    DataSystem{
        id:dbsystem
        onStatueChanged: {
            if(Statue=="getfoodrelationDBError"){
                myjava.toastMsg("网络状态不佳！")
            }

            if(Statue=="getfoodmsgSucceed"){
                while(dbsystem.getMSGFoodPhoto(modelindex)!==""){
                    foodmodel.append({"PhotoSource": dbsystem.getMSGFoodPhoto(modelindex), "FoodName":dbsystem.getMSGFoodName(modelindex),"FoodDes":dbsystem.getMSGFoodDes(modelindex).replace("\n","").replace("\t","")+"..."})
                    modelindex++;
                }
                modelindex=0;
            }


            if(Statue=="getfoodrelationSucceed"){
                var typelist=dbsystem.getRelationType().split("|||")
                var reasonlist=dbsystem.getReason().split("|||")

                var allfoodlist=allfood.split("、")



                var index=0
                for(var i=0;i<allfoodlist.length-1;i++){

                for(var j=i+1;j<allfoodlist.length-1;j++){

                    if(typelist[index]!=="NoRelation"){
                        if(typelist[index]==="1")
                            goodrelationmodel.append({"FirstFood":allfoodlist[i],"SecondFood":allfoodlist[j],"Reason":reasonlist[index]})
                        else
                            badrelationmodel.append({"FirstFood":allfoodlist[i],"SecondFood":allfoodlist[j],"Reason":reasonlist[index]})
                    }
                    index++

                }
                }

                dbsystem.getFoodMSG(allfood)

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

    Loader{
        id:fooddetail
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/FoodDetail.qml"
        z:102

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
                bold:true
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
        id:foodmodel

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
        contentHeight: foodview.height+goodrelationview.height+badrelationview.height+20*dp
        clip: true
        flickableDirection:Flickable.VerticalFlick



        ListView{
            id:goodrelationview
            anchors.top: parent.top
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




        ListView{
            id:foodview
            anchors.top: badrelationview.bottom
            clip: true
            width: parent.width
            //contentHeight: delegate.height*foodmodel.count
            model: foodmodel

            height:foodmodel.count>0?contentHeight+2:0

            visible: foodmodel.count>0?true:false

            property int getindex

//            header:Rectangle{
//                height:head.height/2.5
//                width:parent.width
//                Image{
//                    Rectangle{
//                        anchors.fill: parent
//                        color:"lightgreen"
//                        anchors.margins: 5
//                        z:-100
//                    }
//                    anchors.verticalCenter: parent.verticalCenter
//                    anchors.leftMargin: 8*dp
//                    anchors.left: parent.left
//                    height:parent.height
//                    width:height
//                    source:"qrc:/image/save.png"
//                    fillMode: Image.PreserveAspectFit
//                }
//            }

            delegate: Item{
                id:delegate
                width:mainrect.width
                height: foodimage.height+20*dp


                Image{
                    id:foodimage
                    fillMode: Image.PreserveAspectFit
                    anchors.top:parent.top
                    anchors.topMargin: 10*dp
                    anchors.left: parent.left
                    anchors.leftMargin: 10*dp
                    height: 60*dp
                    width:height
                    source:PhotoSource
                    Label{
                        anchors.centerIn: parent
                        visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                        text:(parent.status==Image.Loading)?"加载中":"无"
                        color:"grey"
                    }
                }

                Text{
                    id:foodname
                    text:FoodName

                    anchors.left: foodimage.right
                    anchors.leftMargin: 10*dp

                    anchors.top: foodimage.top
                    anchors.topMargin: 4*dp

                    width: parent.width-foodimage.width-24*dp
                    wrapMode: Text.Wrap
                    color:"grey"

                    font{
                        pointSize: 16
                        family: localFont.name
                    }

                }

                Text{
                    id:fooddes
                    text:FoodDes
                    anchors.left: foodimage.right
                    anchors.leftMargin: 10*dp

                    anchors.bottom: foodimage.bottom
                    anchors.bottomMargin: 4*dp
                    width: parent.width-foodimage.width-24*dp

                    wrapMode: Text.Wrap

                    verticalAlignment: Text.AlignBottom

                    color:"grey"
                    font{
                        pointSize: 12
                        family: localFont.name
                    }
                }


                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        fooddetail.item.init(FoodName,PhotoSource)
                           fooddetail.visible=true
                    }
                }

            }

        }


    }

}
