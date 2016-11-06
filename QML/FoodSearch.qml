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
Rectangle {
    id:mainrect;
    anchors.fill: parent

    property int modelindex: 0
    property string userid;
    property string nickname;
    property double dp:(myjava.getHeight()/16*2)/70

    MouseArea{
        anchors.fill: parent

    }

//    Keys.enabled: true
//    Keys.onBackPressed: {
//        mainrect.parent.visible=false
//        searchtext.text=""
//        mainrect.parent.parent.forceActiveFocus();
//    }


    JavaMethod{
        id:myjava
    }

    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    DataSystem{
        id:dbsystem;
        onStatueChanged: {


            if(Statue.indexOf("searchfoodSucceed")>=0){
                while(dbsystem.getsearchFoodPhoto(modelindex)!==""){
                    searchmodel.append({"FoodPhoto": dbsystem.getsearchFoodPhoto(modelindex), "FoodName":dbsystem.getsearchFoodName(modelindex),"FoodDes":dbsystem.getsearchFoodDes(modelindex)+"..."})
                    modelindex++;
                }
                modelindex=0;
            }

        }

    }


    function init(){
       searchtext.text=""
       searchmodel.clear();
    }



Flickable{
    anchors.fill: parent
    flickableDirection: Flickable.VerticalFlick

    contentHeight: searchbar.height+view.contentHeight+20*dp
    clip: true

    Rectangle{
        id:searchbar
        height: (dp*70)/2
        anchors.right: parent.right
        anchors.rightMargin: 10*dp
        anchors.left: parent.left
        anchors.leftMargin: 10*dp

        anchors.top: parent.top
        anchors.topMargin: 10*dp

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 8
            color: GlobalColor.Main
        }
        TextField{
            anchors.fill: parent

            id:searchtext
            placeholderText:"请输入要搜索的食材"
            font{
                family: localFont.name
                pointSize: 16
            }

            style: TextFieldStyle {
                      textColor: "grey"
                      background: Rectangle {
                      }
                  }

            onTextChanged: {
                if(searchtext.text.length>1){
                searchmodel.clear();
                dbsystem.searchFood(searchtext.text);
                }
            }
            Image{
                Rectangle{
                    anchors.fill: parent
                    color:GlobalColor.Main
                    z:-100
                }
                id:searchicon
                anchors.right: searchtext.right
                anchors.rightMargin: 8*dp
                anchors.verticalCenter: searchtext.verticalCenter
                source: "qrc:/image/searchblack.png"
                height: searchbar.height/1.5
                width:height
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(searchtext.text!=""){
                          searchmodel.clear();
                          dbsystem.searchFood(searchtext.text);
                        }
                    }
                }
            }

        }
    }


    ListModel{
        id:searchmodel


    }

    ListView{
        id:view
        cacheBuffer:contentHeight+2
        spacing: -1
        anchors.top: searchbar.bottom
        anchors.topMargin: 10*dp

        clip: true
        width: parent.width
       // height:parent.height-(searchbar.visible?searchbar.height+20*dp:0)
        height: contentHeight+2

        model: searchmodel

        header:Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width/3*1.1
            height: searchmodel.count==0?dp*70:0
            visible: searchmodel.count==0?true:false
            Rectangle{
                width: parent.width/1.2
                height:dp*70/2
                color:"white"

                anchors.top: parent.top
                anchors.topMargin: 8*dp
                anchors.horizontalCenter: parent.horizontalCenter

                Text{
                    text:"暂无结果"
                    color:"grey"
                    anchors.centerIn: parent
                    font.pointSize: 16
                }

            }
        }

        delegate: Item{
            id:delegate
            width:mainrect.width
            height:foodphoto.height+20*dp

            Rectangle{
                anchors.fill: parent
                color:"white"
                border.color: "lightgrey"
                border.width: 1

                Image{
                    id:foodphoto
                    height:60*dp
                    width:height

                    source: FoodPhoto
                    anchors.top: parent.top
                    anchors.topMargin: 10*dp

                    anchors.left: parent.left
                    anchors.leftMargin: 10*dp

                    fillMode: Image.PreserveAspectFit

                    Label{
                        anchors.centerIn: parent
                        visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                        text:(parent.status==Image.Loading)?"加载中":"无"
                        color:"grey"
                    }
                }


                Text{
                    id:foodname;
                    anchors.left: foodphoto.right
                    anchors.leftMargin: 10*dp
                    anchors.top: foodphoto.top
                    anchors.topMargin: 8*dp
                    color: "grey"
                    text:FoodName
                    wrapMode: Text.Wrap
                    width: parent.width-foodphoto.width-24*dp
                    font{
                        family: localFont.name

                        pointSize: 16
                    }

                }

                Text{
                    id:fooddes;
                    anchors.left: foodphoto.right
                    anchors.leftMargin: 10*dp

                    anchors.bottom: foodphoto.bottom
                    anchors.bottomMargin: 8*dp

                    color: "grey"
                    wrapMode: Text.Wrap
                    width: parent.width-foodphoto.width-24*dp
                    font{
                        family: localFont.name

                        pointSize: 12
                    }
                    text:FoodDes
                }


                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                     mainrect.parent.parent.parent.showfooddetail(FoodName,FoodPhoto)
                    }
                }

            }
        }

    }


}

}
