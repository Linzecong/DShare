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

    property int searchmode:0

    MouseArea{
        anchors.fill: parent

    }




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
                    searchmodel.append({"FoodPhoto": dbsystem.getsearchFoodPhoto(modelindex), "FoodName":dbsystem.getsearchFoodName(modelindex),"FoodDes":dbsystem.getsearchFoodDes(modelindex).replace("\n","").replace("\t","")+"..."})
                    modelindex++;
                }
                modelindex=0;
            }

            if(Statue.indexOf("searchfuncDBError")>=0){
                myjava.toastMsg("无结果")
            }

            if(Statue===("searchfuncSucceed")){
                mainrect.parent.parent.parent.showdetailpage(dbsystem.getsearchFunc())
                myjava.toastMsg("搜索成功")
            }

            if(Statue===("searchfuncSucceedFull")){
                mainrect.parent.parent.parent.showdetailpage(dbsystem.getsearchFunc())
                myjava.toastMsg("结果太多，只显示部分结果，请缩短搜索范围")
            }

        }

    }


    function init(){
        searchtext.text=""
        searchmodel.clear()
        searchmode=0
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
            anchors.topMargin: searchmode==1?180*dp:10*dp

            Behavior on anchors.topMargin{
                NumberAnimation{
                    duration: 800
                    easing.type: Easing.OutCubic
                }
            }

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: GlobalColor.Main
            }
            TextField{
                anchors.fill: parent
                validator:RegExpValidator{regExp:/[^%@<>\/\\ \|]{1,18}/}

                id:searchtext
                placeholderText:searchmode==1?"请输入要搜索的功效":"请输入要搜索的食材"
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

                    if(searchmode!=1){
                        if(searchtext.text.length>1){
                            searchmodel.clear();
                            dbsystem.searchFood(searchtext.text);
                        }

                        if(searchtext.text==="")
                            searchmodel.clear();

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
                            if(searchmode==1){
                                if(searchtext.text.length>1){
                                    dbsystem.searchFunc(searchtext.text);

                                }
                                else
                                    myjava.toastMsg("搜索内容太短")
                            }
                            else{
                                if(searchtext.text!=""){

                                    if(searchtext.text.length>1){
                                        searchmodel.clear();
                                        dbsystem.searchFood(searchtext.text);

                                    }
                                    else
                                        myjava.toastMsg("搜索内容太短")
                                }
                            }
                        }
                    }
                    Timer{
                        id:animationtimer
                        interval: 800
                        repeat:true
                        running: searchmode==1
                        onTriggered: {
                            if(searchicon.scale==1.3)
                                searchicon.scale=1
                            else
                                searchicon.scale=1.3
                        }
                    }
                    Behavior on scale{
                        NumberAnimation{
                            duration: 800
                            easing.type: Easing.OutCubic
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
            spacing: -1
            anchors.top: searchbar.bottom
            anchors.topMargin: 10*dp

            clip: true
            width: parent.width
            // height:parent.height-(searchbar.visible?searchbar.height+20*dp:0)
            height: contentHeight+2

            model: searchmodel
            add: Transition{
                NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
            }

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

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        color: searchmode==1?GlobalColor.SecondButton:"green"
                    }

                    Text{
                        text:searchmode==1?"切换到普通模式":"切换到高级模式"
                        color:searchmode==1?GlobalColor.SecondButton:"green"
                        anchors.centerIn: parent
                        font.pointSize: 13
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            searchmode==1?searchmode=0:searchmode=1
                            searchicon.scale=1
                            searchtext.text=""
                        }
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
                        anchors.topMargin: 4*dp
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
                        anchors.bottomMargin: 4*dp
                        verticalAlignment: Text.AlignBottom

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


