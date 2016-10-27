import QtQuick 2.5
import QtQuick.Controls 2.0
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import JavaMethod 1.0
import SendImageSystem 1.0
import ReportSystem 1.0
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.0


Rectangle {
    id:mainwindow
    anchors.fill: parent

    property string nickname;
    property string str_userid

    property string headurl: ""

    //初始化各种数据
    function setusername(a){
        mainpage.item.setusername(a)//初始话分享列表
        str_userid=a;
        dbsystem.getNameByID(str_userid)


        userid.text="ID："+a//初始化侧边栏
        sendpage.item.str_userid=a//初始化发送页面的id
        recordpage.item.str_userid=a//初始化记录页面的id
        recordpage.item.getcheckinday()
    }

    function setmypost(publisherid0,username0,nickname0){
        mypostpage.item.getpost(publisherid0,username0,nickname0);//点击头像时显示用户分享列表
        mypostpage.visible=true
        mypostpage.x=0
    }

    function setuniquepost(Hasimage0,Headurl0,Username0,Posttime0,Message0,Photo0,Liker0,ID0,username0,nickname0,a1){
        uniquepost.item.setData(Hasimage0,Headurl0,Username0,Posttime0,Message0,Photo0,Liker0,ID0,username0,nickname0,a1)
        uniquepost.visible=true
    }

    function setcommentcount(count){

        mainpage.item.setcommentcount(count)


    }


    function removepost(){

        mainpage.item.removepost()

    }

    function setbusy(a){
        indicator2.visible=a
    }


    Rectangle{
        id: indicator2
        anchors.fill: parent
        visible: false
        color:"black"
        opacity: 0.6
        z:2001
        BusyIndicator{
            width:parent.width/7
            height:width
            anchors.centerIn: parent
            running: true
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {

            }
        }
    }

    function showbigphoto(a){
        bigphoto.source=a
        bigphotorect.visible=true
        bigphotorect.forceActiveFocus()
    }

    Rectangle{
        property int isbig:0
        id: bigphotorect
        anchors.fill: parent

        z:22
        visible: false

        color: "black"

        Keys.enabled: true
        Keys.onBackPressed: {

            mainrect.forceActiveFocus();

            bigphoto.x=0
            bigphoto.y=0
            bigphoto.scale=1
            bigphotorect.isbig=0
            bigphotorect.visible=false
        }

        Flickable{
            id:flick
            height:parent.height
            width: parent.width
            contentHeight: bigphoto.height-1
            contentWidth: bigphoto.width-1
            Image {
                id: bigphoto
                fillMode: Image.PreserveAspectFit
                height: bigphotorect.height
                width: bigphotorect.width
                Timer{
                    id:doubletimer
                    interval: 300
                    repeat: false
                    onTriggered: {
                        mainrect.forceActiveFocus();

                        bigphoto.x=0
                        bigphoto.y=0
                        bigphoto.scale=1
                        bigphotorect.isbig=0
                        bigphotorect.visible=false
                    }
                }

                MouseArea{
                    anchors.fill: parent

                    onClicked: {
                        if(!doubletimer.running)
                            doubletimer.running=true
                        else{
                            doubletimer.running=false
                            if(!bigphotorect.isbig){
                                bigphoto.scale=1.5
                                bigphotorect.isbig=1
                            }
                            else{
                                bigphoto.scale=1
                                bigphotorect.isbig=0
                            }
                        }
                    }


                }
            }

        }
    }





    Loader{
        id:mypostpage
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/PostsPage.qml"
        z:102
    }

    Loader{
        id:uniquepost;

        anchors.fill: parent

        visible: false
        source:"qrc:/QML/UniquePost.qml"
        z:102
    }
    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    DataSystem{
        id:dbsystem;
        onStatueChanged: {
            if(Statue=="getnameSucceed"){
                name.text="昵称："+dbsystem.getName()
                nickname=dbsystem.getName()
                dbsystem.getHeadByID(str_userid)
                mainpage.item.nickname=dbsystem.getName()
            }

            if(Statue=="changenameSucceed"){
                dbsystem.getNameByID(str_userid)
                nickname=dbsystem.getName()
                mainpage.item.nickname=dbsystem.getName()
            }
            if(Statue=="getheadSucceed"){

                headurl=dbsystem.getHead()
            }



        }
    }

    //用于再点一次退出
    property int quit: 0
    Keys.enabled: true
    Keys.onBackPressed: {
        if(headname.text!="DShare"){
            bottom.currentPage="DShare"
            mainrect.x=0;
        }
        else{
            quit++;
            quittime.start();
            if(quit==2)
                Qt.quit();
            else
                myjava.toastMsg("再点一次退出")
        }

    }



    Timer{
        id:quittime
        interval: 3000
        onTriggered: {
            quit=0;
        }
    }

    //用于显示侧边栏的关注或粉丝列表
    Loader{
        id:friends;
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/UsersPage.qml"
        z:102
    }

    //用于显示侧边栏的我的分享
    Loader{
        id:mypost
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/PostsPage.qml"
        z:102
    }

    //用于显示侧边栏的我的消息
    Loader{
        id:noticelist;
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/NoticeList.qml"
        z:102
    }

    //用于显示侧边栏的我的报告
    Loader{
        id:reportpage
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/ReportPage.qml"
        z:102
    }


    //设置页面
    Loader{
        id:settingpage;
        //用于更新名字后重新设置昵称
        function setname(){
            dbsystem.getNameByID(str_userid,nickname);
        }
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/SettingPage.qml"
        z:102
    }

    //侧边栏
    Rectangle{
        id:sidepage;
        height: parent.height
        width:parent.width/10*6.9
        color:"white"
        border.color: "grey"
        border.width: 1
        x:-width;
        z:10
        visible: false

        //用于响应返回按钮
        Keys.enabled: true
        Keys.onBackPressed: {
            sidepage.x=-sidepage.width
            backarea.visible=false
            mainwindow.forceActiveFocus();

        }

        MouseArea{
            anchors.fill: parent
        }

        Behavior on x{
            NumberAnimation{
                easing.type:Easing.OutCubic
                duration: 200
            }
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
                color:"green"
            }
            id:sidepagetop
            color:"#02ae4a"
            width: sidepage.width
            height: sidepage.height/4
            anchors.top: sidepage.top
            anchors.left: sidepage.left
            z:2

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: -10
                verticalOffset: 1
                radius: 10
                color: "#55000000"
            }

            //侧边栏头像
            Image{
                id:headimage2
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
                anchors.left: parent.left
                anchors.leftMargin: parent.width/15
                fillMode: Image.PreserveAspectFit
                height:parent.width/4
                width:height
                source: headurl
                Label{
                    anchors.centerIn: parent
                    visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                    text:(parent.status==Image.Loading)?"加载中":"无"
                    color:"white"
                }
                //点击打开设置
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        settingpage.visible=true
                        settingpage.item.setdata(str_userid,nickname,headurl)
                    }
                }
            }

            //侧边栏昵称
            Text{
                id:name;
                anchors.left: headimage2.right
                anchors.leftMargin: parent.width/15
                anchors.top: headimage2.top
                anchors.topMargin: 5
                color: "white"
                text:"昵称:未获取"
                wrapMode: Text.WordWrap
                width: parent.width-headimage2.width- parent.width/15- parent.width/10
                font{
                        family: localFont.name

                    pointSize: 16
                }
            }

            //侧边栏ID
            Text{
                id:userid;
                anchors.left: headimage2.right
                anchors.leftMargin: parent.width/15
                anchors.bottom: headimage2.bottom
                anchors.bottomMargin: 5
                color: "white"
                wrapMode: Text.WordWrap
                width: parent.width-headimage2.width- parent.width/15- parent.width/10
                font{
                        family: localFont.name

                    pointSize: 16
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        settingpage.visible=true
                        settingpage.item.setdata(str_userid,nickname,headurl)
                    }
                }
            }
        }


        Flickable{
            anchors.top: sidepagetop.bottom
            //anchors.topMargin: sidepagetop.height/10

            anchors.right: parent.right
            height: sidepage.height-sidepagetop.height
            width: sidepage.width
            contentHeight: height+1
            flickableDirection :Flickable.VerticalFlick
            pressDelay: 100

        Rectangle{
            id:followingbutton
            //anchors.top: sidepagetop.bottom
            //anchors.topMargin: sidepagetop.height/10
            anchors.top: parent.top
            anchors.right: parent.right
            height: sidepage.height/10
            width: sidepage.width
            color:ma1.pressed?"#aaaaaa":"white"
            Behavior on color{
                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            Image {
                id:followingicon
                anchors.left: parent.left
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/user.png"
                width: height
                height: parent.height/2

            }

            Label{
                anchors.left: followingicon.right
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                text:"我的关注"
                font{
                        family: localFont.name

                    pointSize: 16
                }
                color: Material.color(Material.BlueGrey)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            MouseArea{
                id:ma1
                anchors.fill: parent
                onClicked: {
                    friends.item.userid=str_userid
                    friends.item.nickname=nickname
                    friends.item.setTitle("我的关注")
                    friends.visible=true
                    friends.x=0
                }
            }
        }


        Rectangle{
            id:followerbutton
            anchors.top: followingbutton.bottom
            anchors.right: parent.right
            height: sidepage.height/10
            width: sidepage.width
            color:ma2.pressed?"#aaaaaa":"white"
            Behavior on color{
                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            Image {
                id:followericon
                anchors.left: parent.left
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/nickname.png"
                width: height
                height: parent.height/2
            }


            Label{
                anchors.left: followericon.right
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                text:"我的粉丝"
                font{
                        family: localFont.name

                    pointSize: 16
                }
                color: Material.color(Material.BlueGrey)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }


            MouseArea{
                id:ma2
                anchors.fill: parent
                onClicked: {
                    friends.item.userid=str_userid
                    friends.item.nickname=nickname
                    friends.item.setTitle("我的粉丝")
                    friends.visible=true
                    friends.x=0
                }
            }

        }


        Rectangle{
            id:sharebutton
            anchors.top: followerbutton.bottom
            anchors.right: parent.right
            height: sidepage.height/10
            width: sidepage.width
            color:ma3.pressed?"#aaaaaa":"white"
            Behavior on color{
                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            Image {
                id:shareicon
                anchors.left: parent.left
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/photo.png"
                width: height
                height: parent.height/2
            }

            Label{
                anchors.left: shareicon.right
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                text:"我的分享"
                font{
                        family: localFont.name

                    pointSize: 16
                }
                color: Material.color(Material.BlueGrey)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            MouseArea{
                id:ma3
                anchors.fill: parent
                onClicked: {
                    mypost.item.getpost(str_userid,str_userid,nickname);
                    mypost.visible=true
                    mypost.x=0
                }
            }
        }

        Rectangle{
            id:messagebutton
            anchors.top: sharebutton.bottom
            anchors.right: parent.right
            height: sidepage.height/10
            width: sidepage.width
            color:ma4.pressed?"#aaaaaa":"white"
            Behavior on color{
                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            Image {
                id:messageicon
                anchors.left: parent.left
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/conpassword.png"
                width: height
                height: parent.height/2
            }

            Label{
                anchors.left: messageicon.right
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                text:"我的消息"
                font{
                        family: localFont.name

                    pointSize: 16
                }
                color: Material.color(Material.BlueGrey)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            MouseArea{
                id:ma4
                anchors.fill: parent
                onClicked: {
                    noticelist.item.getNotice(str_userid,nickname)
                    noticelist.visible=true
                }
            }
        }


        Rectangle{
            id:reportbutton
            anchors.top: messagebutton.bottom
            anchors.right: parent.right
            height: sidepage.height/10
            width: sidepage.width
            color:ma7.pressed?"#aaaaaa":"white"
            Behavior on color{
                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            Image {
                id:reporticon
                anchors.left: parent.left
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/conpassword.png"
                width: height
                height: parent.height/2
            }

            Label{
                anchors.left: reporticon.right
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                text:"我的报告"
                font{
                        family: localFont.name

                    pointSize: 16
                }
                color: Material.color(Material.BlueGrey)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }

            MouseArea{
                id:ma7
                anchors.fill: parent
                property int isget: 1
                onClicked: {
                    reportpage.item.getalldiet(str_userid,nickname)
                    reportpage.item.forceActiveFocus()
                    reportpage.visible=true
                }
            }



        }


        GestureArea{
            anchors.top: reportbutton.bottom
            anchors.bottom: linecenter.top
            width:parent.width

            onSwipe: {
                switch (direction) {
                case "left":
                    sidepage.x=-sidepage.width
                    backarea.visible=false
                    break

                }
            }
        }


        Rectangle{
            id:linecenter
            width: parent.width
            height:1
            color: Material.color(Material.BlueGrey)
            anchors.bottom: settingbutton.top
            anchors.bottomMargin: 3
            anchors.right: parent.right
        }




        Rectangle{
            id:settingbutton
            anchors.bottom: logoutbutton.top
            anchors.right: parent.right
            height: sidepage.height/10
            width: sidepage.width
            color:ma5.pressed?"#aaaaaa":"white"
            Behavior on color{
                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            Image {
                id:settingicon
                anchors.left: parent.left
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/save.png"
                width: height
                height: parent.height/2
            }
            Label{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: settingicon.right
                anchors.leftMargin: sidepagetop.height/10
                text:"设置"
                font{
                        family: localFont.name

                    pointSize: 16
                }
                color: Material.color(Material.BlueGrey)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }
            MouseArea{
                id:ma5
                anchors.fill: parent
                onClicked: {
                    settingpage.visible=true
                    settingpage.item.setdata(str_userid,nickname,headurl)
                }
            }
        }


        Rectangle{
            id:logoutbutton
            //anchors.bottom: sidepage.bottom

            anchors.bottom: parent.bottom
            anchors.right: parent.right
            height: sidepage.height/10
            width: sidepage.width
            color:ma6.pressed?"red":"white"
            Behavior on color{
                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            Image {
                id:logouticon
                anchors.left: parent.left
                anchors.leftMargin: sidepagetop.height/10
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/image/password.png"
                width: height
                height: parent.height/2
            }
            Label{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: logouticon.right
                anchors.leftMargin: sidepagetop.height/10
                text:"注销"
                font{
                        family: localFont.name

                    pointSize: 16
                }
                color: Material.color(Material.BlueGrey)
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
            }


            MouseArea{
                id:ma6
                anchors.fill: parent
                onClicked: {
                    checkDialog.open()
                }
            }

            MessageDialog {
                id: checkDialog
                title: "提示"
                text: "确定要注销吗？"
                standardButtons:  StandardButton.No|StandardButton.Yes
                onYes: {
                    dbsystem.delusernamepassword()
                    mainwindow.parent.x=mainwindow.parent.parent.width;
                    mainwindow.parent.source="";
                }
                onNo: {

                }
            }
        }


        }
    }









    //显示侧边栏时，点击侧边可以返回
    MouseArea{
        id:backarea
        visible: false
        anchors.left: sidepage.right
        height: parent.height
        width:parent.width
        onClicked: {
            sidepage.x=-sidepage.width
            backarea.visible=false
        }
        Rectangle{
            id:backarearect
            anchors.fill: parent
            color:"black";
            opacity: 0.6
        }
        z:8
    }

    //主页面的顶部栏
    Rectangle{
        Rectangle{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height:myjava.getStatusBarHeight()
            color:"green"
        }

        id:head
        width:parent.width;
        height: parent.height/16*2;

        color:"#02ae4a"
        x:0
        y:0

        z:7

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            color: "#55000000"
        }

        Behavior on y{
            NumberAnimation{
                easing.type:Easing.OutCubic
                duration: 500
            }
        }


        //侧边栏按钮
        Image{
            id:sidebarbutton
            height: parent.height/2.5
            width:height

            source: "qrc:/image/side.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2

            anchors.leftMargin: parent.height/4
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    sidepage.visible=true
                    sidepage.x=0
                    backarea.visible=true
                    sidepage.forceActiveFocus();
                }
            }
        }


        Label{
            id:headname
            text:bottom.currentPage
            anchors.centerIn: parent
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2

            font{
                        family: localFont.name

                pointSize: 20
            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
                    if(headname.text=="DShare")
                        mainpage.item.refreshpost(str_userid);
                }
            }
        }

        //右上角的搜索用户按钮
        Image{
            id:morebutton
            source: "qrc:/image/search.png"
            anchors.right: parent.right
            anchors.rightMargin: parent.height/4
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            height: parent.height/2.5
            width:height
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    friends.item.userid=str_userid
                    friends.item.nickname=nickname
                    friends.item.setTitle("搜索用户")
                    friends.visible=true
                    friends.x=0
                }
            }
        }

    }

//    Rectangle{
//        id:borderline
//        width: parent.width
//        anchors.top: mainrect.bottom
//        anchors.left: bottom.left
//        height: 2
//        color:"grey"
//        z:6
//    }


    function hidebottom(){
        bottom.height=0
    }

    function showbottom(){
        bottom.height=mainwindow.height/16*1.5
    }


    //底部栏
    Rectangle{
        id:bottom

        anchors.bottom: parent.bottom
        color:"white"


        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            color: "#55000000"
        }

        width:parent.width+4;
        height: parent.height/16*1.5;
        property string currentPage:"DShare"
        z:7


        Rectangle{
            id:mainbutton
            anchors.left: parent.left
            height:width
            width:parent.width/5
            color:"white";
            Image {
                height: parent.height
                width: height
                source: bottom.currentPage=="DShare"?"qrc:/image/mainpage.png":"qrc:/image/mainpageblack.png"
                fillMode: Image.PreserveAspectFit


                Timer{
                    interval: 800
                    repeat:true
                    triggeredOnStart :true
                    onTriggered: {
                        if(parent.scale==1.4)
                            parent.scale=1.2
                        else
                            parent.scale=1.4
                    }
                    running: bottom.currentPage=="DShare"
                    onRunningChanged: {
                        if(running==false)
                            parent.scale=1
                    }
                }
                Behavior on scale{
                    NumberAnimation{
                        duration: 800
                        easing.type: Easing.Linear
                    }
                }

            }
            MouseArea{
                id:mainpagebutton
                anchors.fill: parent
                onClicked: {
                    if(sendpage.item.messagetext!==""||sendpage.item.hiddentext!=="")
                        messageDialog.open()

                    bottom.currentPage="DShare"
                    mainrect.x=0;


                }
            }
        }


        Rectangle{
            id:sendbutton
            anchors.horizontalCenter: parent.horizontalCenter
            height:width
            width:parent.width/5

            color:"white";
            Image {

                height: parent.height
                width: height
                source: bottom.currentPage=="分享"?"qrc:/image/sharepage.png":"qrc:/image/sharepageblack.png"
                fillMode: Image.PreserveAspectFit
                Timer{
                    interval: 800
                    repeat:true
                    triggeredOnStart :true
                    onTriggered: {
                        if(parent.scale==1.4)
                            parent.scale=1.2
                        else
                            parent.scale=1.4
                    }
                    running: bottom.currentPage=="分享"
                    onRunningChanged: {
                        if(running==false)
                            parent.scale=1
                    }
                }
                Behavior on scale{
                    NumberAnimation{
                        duration: 800
                        easing.type: Easing.Linear
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="分享"
                    mainrect.x=-mainwindow.width*1

                }
            }

        }



        Rectangle{
            id:recordbutton
            anchors.right: parent.right
            height:width
            width:parent.width/5
            color:"white";
            Image {

                height: parent.height
                width: height
                source: bottom.currentPage=="记录"?"qrc:/image/recordpage.png":"qrc:/image/recordpageblack.png"
                fillMode: Image.PreserveAspectFit
                Timer{
                    interval: 800
                    repeat:true
                    triggeredOnStart :true
                    onTriggered: {
                        if(parent.scale==1.4)
                            parent.scale=1.2
                        else
                            parent.scale=1.4
                    }
                    running: bottom.currentPage=="记录"
                    onRunningChanged: {
                        if(running==false)
                            parent.scale=1
                    }
                }
                Behavior on scale{
                    NumberAnimation{
                        duration: 800
                        easing.type: Easing.Linear
                    }
                }

            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(sendpage.item.messagetext!==""||sendpage.item.hiddentext!=="")
                        messageDialog.open()

                    bottom.currentPage="记录"
                    mainrect.x=-mainwindow.width*2
                }
            }
        }






        MessageDialog{
            id: messageDialog
            title: "提示"
            text: "要清空你之前填的内容吗？"
            detailedText:"之前的内容：<br>"+sendpage.item.messagetext+"<br>"+sendpage.item.hiddentext
            standardButtons:  StandardButton.No|StandardButton.Yes
            onYes: {
                sendpage.item.setnull()
            }
            onNo: {

            }
        }

    }


    //中间的各种页面
    Rectangle{
        id:mainrect
        anchors.top:head.bottom
        anchors.topMargin: 3
        height:parent.height-head.height-bottom.height

        width:parent.width*5
        z:6
        property alias currentPage:bottom.currentPage


        Loader{
            id:mainpage
            anchors.left: parent.left
            height:parent.height
            width:mainwindow.width
            source: "qrc:/QML/MainPage.qml";
        }
        Loader{
            id:sendpage
            anchors.left: mainpage.right
            height:parent.height
            width:mainwindow.width
            source: "qrc:/QML/SendPage.qml";
        }
        Loader{
            id:recordpage
            anchors.left: sendpage.right
            height:parent.height
            width:mainwindow.width
            source: "qrc:/QML/RecordPage.qml";
        }

        Behavior on x{
            NumberAnimation{
                duration: 200
                easing.type: Easing.InCubic
            }
        }
    }





}
