import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0

Rectangle {
    id:mainrect;
    anchors.fill: parent
    property int iss: 0//判断是否是搜索状态
    property int modelindex: 0
    property string userid;
property string nickname;

    MouseArea{
        anchors.fill: parent

    }

    Keys.enabled: true
    Keys.onBackPressed: {
        mainrect.parent.visible=false
        searchtext.text=""
        mainrect.parent.parent.forceActiveFocus();
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
            color:"green"
        }
        id:head
        width:parent.width
        height: parent.height/16*2
        color:"#02ae4a"
        anchors.top: parent.top
        Label{
            id:back
            height: parent.height
            width:height
            text:" ＜"
            color: "white"
            font{
                pixelSize: (head.height)/2
            }
            anchors.left: parent.left
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
                //family: "微软雅黑"
                pixelSize: (head.height)/4
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
        height: (head.height)/1.5
        width: parent.width
        anchors.top: head.bottom


        TextField{
            height:parent.height-6
            width: parent.width-6
            x:3
            anchors.verticalCenter: parent.verticalCenter
            id:searchtext
            placeholderText:"请输入要搜索的id或昵称"
            style: TextFieldStyle{
                background: Rectangle{
                    radius: control.height/4
                    border.width: 1;
                    border.color: "grey"
                    id:searchrect
                }
            }
            //Material.theme: Material.Dark
            //Material.accent: Material.Purple
            onTextChanged: {
                if(searchtext.text.length>3){
                model1.clear();
                dbsystem.searchUser(searchtext.text);
                }
            }

            Image{
                id:searchicon
                anchors.right: searchtext.right
                anchors.rightMargin: 3
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
        cacheBuffer:20000
        spacing: -1
        anchors.top: searchbar.visible?searchbar.bottom:head.bottom
        clip: true
        width: parent.width
        height:parent.height-head.height-(searchbar.visible?searchbar.height:0)
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
            height:(username==userid?0:mainrect.height/7)
            visible: (username==userid?false:true)//隐藏自己
            Rectangle{
                anchors.fill: parent
                color:"white"
                border.color: "grey"
                border.width: 1

                Image{
                    id:headimage
                    height:parent.height/1.2
                    width:height
                    source: headurl
                    anchors.top: parent.top
                    anchors.topMargin: height/10
                    anchors.left: parent.left
                    anchors.leftMargin: height/8
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
                            mypost.item.getpost(username,userid,nickname);
                            mypost.visible=true
                            mypost.x=0
                        }
                    }
                }
                Text{
                    id:name;
                    anchors.left: headimage.right
                    anchors.leftMargin: headimage.width/5
                    anchors.top: headimage.top
                    anchors.topMargin: headimage.width/6
                    color: "grey"
                    text:"昵称:"+nickname
                    wrapMode: Text.WordWrap
                    width: parent.width-headimage.width
                    font{
                        
                        pixelSize: headimage.height/4
                    }

                }

                Text{
                    id:useridtext;
                    anchors.left: headimage.right
                    anchors.leftMargin: headimage.width/5
                    anchors.top: name.bottom
                    anchors.topMargin: headimage.width/6
                    color: "grey"
                    wrapMode: Text.WordWrap
                    width: parent.width-headimage.width
                    font{
                        
                        pixelSize: headimage.height/4
                    }
                    text:"id:"+username
                }

                Rectangle{
                    id:buttonrect
                    color:iss?(yiguanzhu?"grey":"#02ae4a"):"red";
                    height: useridtext.height*1.5
                    width:height*2
                    anchors.right: parent.right
                    anchors.rightMargin: height/1.5
                    anchors.verticalCenter: parent.verticalCenter
                    radius: height/4
                    border.width: 1
                    border.color: "grey"
                    //visible: headname.text=="我的粉丝"?false:(username==userid?false:true);
                    Label{
                        id:button
                        anchors.centerIn:parent
                        text:iss?(yiguanzhu?"已关注":"关注"):"取消";
                        color: "white"
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
                            
                            pixelSize: buttonrect.height/1.6;
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
