import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import QtGraphicalEffects 1.0
import "qrc:/GlobalVariable.js" as GlobalColor
Rectangle {
    id:mainrect;
    anchors.fill: parent
    property int iss: 0//判断是否是搜索状态
    property int modelindex: 0
    property string userid;
    property string nickname;
    property double dp:head.height/70

    MouseArea{
        anchors.fill: parent

    }

    Keys.enabled: true
    Keys.onBackPressed: {
        mainrect.parent.visible=false
        searchtext.text=""
        mainrect.parent.parent.forceActiveFocus();
    }



    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    DataSystem{
        id:dbsystem;
        onStatueChanged: {
            console.log(Statue)
            if(Statue=="getnameSucceed")
             name.text="昵称:"+dbsystem.getName();

            if(Statue=="searchuserSucceed"){
              while(dbsystem.getsearchUserName(modelindex)!==""){
                  var isf=0;
                   for(var i=0;i<searchmodel.count;i++)
                       if(searchmodel.get(i).username===getsearchUserID(modelindex))
                           isf=1;



                  model1.append({"headurl": "http://119.29.15.43/userhead/"+dbsystem.getsearchUserID(modelindex)+".jpg", "username":dbsystem.getsearchUserID(modelindex),"nickname":dbsystem.getsearchUserName(modelindex),"yiguanzhu":isf})
                  modelindex++;
              }
              modelindex=0;
            }

            if(Statue=="getfollowersSucceed"){
              while(dbsystem.getFollowerName(modelindex)!==""){
                  var isf1=0;
                   for(var i1=0;i1<searchmodel.count;i1++)
                       if(searchmodel.get(i1).username===getFollowerID(modelindex))
                           isf1=1;

                  model1.append({"headurl": "http://119.29.15.43/userhead/"+dbsystem.getFollowerID(modelindex)+".jpg", "username":dbsystem.getFollowerID(modelindex),"nickname":dbsystem.getFollowerName(modelindex),"yiguanzhu":isf1})

                  modelindex++;
              }
              modelindex=0;
            }

            if(Statue=="getfollowingsSucceed"){

              while(dbsystem.getFollowingName(modelindex)!==""){

                  if(headname.text==="我的关注")
                  model1.append({"headurl": "http://119.29.15.43/userhead/"+dbsystem.getFollowingID(modelindex)+".jpg", "username":dbsystem.getFollowingID(modelindex),"nickname":dbsystem.getFollowingName(modelindex),"yiguanzhu":1})


                  searchmodel.append({"headurl": "http://119.29.15.43/userhead/"+dbsystem.getFollowingID(modelindex)+".jpg", "username":dbsystem.getFollowingID(modelindex),"nickname":dbsystem.getFollowingName(modelindex),"yiguanzhu":1})
                  modelindex++;
              }
              modelindex=0;
              if(headname.text==="我的粉丝")
              dbsystem.getFollowers(userid)
            }



        }
    }

    function getUsers(){
        //改变model

    }


    function setTitle(a){


        headname.text=a;
        forceActiveFocus();
        if(a==="搜索用户"){
            model1.clear()
            searchmodel.clear();
            dbsystem.getFollowings(userid);
            searchbar.visible=true
            iss=1;
        }
        if(a==="我的关注")
        {
            model1.clear()
            searchmodel.clear()
            searchbar.visible=false
            iss=0;
            dbsystem.getFollowings(userid)
        }
        if(a==="我的粉丝")
        {
            model1.clear()
            searchmodel.clear()
            dbsystem.getFollowings(userid);
            searchbar.visible=false
            iss=1;

        }

    }

    Loader{
        id:mypost;
        anchors.fill: parent


        visible: false
        source:"qrc:/QML/PostsPage.qml"
        z:102
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
        color:GlobalColor.Main
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
                id:headma
                anchors.fill: parent
                onClicked: {
                    mainrect.parent.visible=false
                    searchtext.text=""
                }
            }
        }



        Label{
            id:headname
            text:"我的关注"
            anchors.centerIn: parent
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            font{
                        family: localFont.name
                //family: "微软雅黑"
                pointSize: 20
            }
            color: "white"
            MouseArea{
                anchors.fill: parent
                onClicked: {

                }
            }
        }


    }


    Rectangle{
        id:searchbar
        height: (head.height)/2
        anchors.right: parent.right
        anchors.rightMargin: 10*dp
        anchors.left: parent.left
        anchors.leftMargin: 10*dp

        anchors.top: head.bottom
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
            placeholderText:"请输入要搜索的id或昵称"
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
                if(searchtext.text.length>3){
                model1.clear();
                dbsystem.searchUser(searchtext.text);
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
                          model1.clear();
                          dbsystem.searchUser(searchtext.text);
                        }
                    }
                }
            }

        }
    }




    ListModel{
        id:model1
        ListElement{
            headurl:""
            username:"默认"
            nickname:"默认"
            yiguanzhu:0
        }
    }

    ListModel{
        id:searchmodel
        ListElement{
            headurl:""
            username:"默认"
            nickname:"默认"
            yiguanzhu:0
        }

    }



    ListView{
        id:view
        cacheBuffer:10000
        spacing: -1
        anchors.top: searchbar.visible?searchbar.bottom:head.bottom
        anchors.topMargin: searchbar.visible?10*dp:0

        clip: true
        width: parent.width
        height:parent.height-head.height-(searchbar.visible?searchbar.height+20*dp:0)
        model: model1
        Rectangle {
                  id: scrollbar
                  anchors.right: view.right
                  anchors.rightMargin: 3
                  y: view.visibleArea.yPosition * view.height
                  width: 5
                  height: view.visibleArea.heightRatio * view.height
                  color: "grey"
                  radius: 5
                  z:50
                  visible: view.dragging||view.flicking
              }
        delegate: Item{
            id:delegate
            width:mainrect.width
            height:(username==userid?0:(headimage.height+20*dp))
            visible: (username==userid?false:true)//隐藏自己

            Rectangle{
                anchors.fill: parent
                color:"white"
                border.color: "grey"
                border.width: 1

                Image{
                    id:headimage
                    height:60*dp
                    width:height

                    source: headurl
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
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            mypost.item.getpost(username,userid,mainrect.nickname);
                            mypost.visible=true
                            mypost.x=0
                        }
                    }
                }
                Text{
                    id:name;
                    anchors.left: headimage.right
                    anchors.leftMargin: 10*dp
                    anchors.top: headimage.top
                    anchors.topMargin: 8*dp
                    color: "grey"
                    text:"昵称:"+nickname
                    wrapMode: Text.WordWrap
                    width: parent.width-headimage.width
                    font{
                        family: localFont.name
                        
                        pointSize: 16
                    }

                }

                Text{
                    id:useridtext;
                    anchors.left: headimage.right
                    anchors.leftMargin: 10*dp

                    anchors.bottom: headimage.bottom
                    anchors.bottomMargin: 8*dp

                    color: "grey"
                    wrapMode: Text.WordWrap
                    width: parent.width-headimage.width
                    font{
                        family: localFont.name
                        
                        pointSize: 16
                    }
                    text:"id:"+username
                }

                Rectangle{
                    id:buttonrect
                    color:iss?(yiguanzhu?"grey":GlobalColor.Main):"white";
                    height: useridtext.height*1.5
                    width:height*2

                    anchors.right: parent.right
                    anchors.rightMargin: 12*dp
                    anchors.verticalCenter: parent.verticalCenter

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        radius: 8
                        color: iss?(yiguanzhu?"grey":GlobalColor.Main):"red";
                    }

                    Label{
                        id:button
                        anchors.centerIn:parent
                        text:iss?(yiguanzhu?"已关注":"关注"):"取消";

                        color: iss?(yiguanzhu?"white":"white"):"red";

                        enabled: iss?(yiguanzhu?0:1):1

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(iss){
                                    checkDialog.open()
                                    }
                                else{
                                    messageDialog.open()
                                }
                            }

                        }
                        font{
                        family: localFont.name
                            
                            pointSize: 14
                        }

                    }
                }

                MessageDialog {
                    id: messageDialog
                    title: "提示"
                    text: "确定要取消关注吗？"
                    standardButtons:  StandardButton.No|StandardButton.Yes
                    onYes: {
                        dbsystem.deleteFollowing(userid,model1.get(index).username);
                        model1.remove(index);
                    }
                    onNo: {

                    }
                }

                MessageDialog {
                    id: checkDialog
                    title: "提示"
                    text: "确定要关注吗？"
                    standardButtons:  StandardButton.No|StandardButton.Yes
                    onYes: {
                        dbsystem.addFollowing(userid,model1.get(index).username);
                        button.enabled=false
                        buttonrect.color="grey";
                        button.text="已关注"
                        searchmodel.append({"headurl":"", "username":model1.get(index).username,"nickname":"","yiguanzhu":1})

                    }
                    onNo: {

                    }
                }

            }
        }

    }




}
