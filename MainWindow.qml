import QtQuick 2.5
import QtQuick.Controls 2.0
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import JavaMethod 1.0
import SendImageSystem 1.0



Rectangle {
    id:mainwindow
    anchors.fill: parent

    property string nickname;
    property string str_userid

    //初始化各种数据
    function setusername(a){
        mainpage.item.setusername(a);//初始话分享列表
        str_userid=a;
        dbsystem.getNameByID(str_userid);
        userid.text="id:"+a;//初始化侧边栏
        sendpage.item.str_userid=a;//初始化发送页面的id
        recordpage.item.str_userid=a;//初始化记录页面的id
        recordpage.item.getcheckinday();
    }

    DataSystem{
        id:dbsystem;
        onStatueChanged: {
            console.log(Statue)
            if(Statue=="getnameSucceed"){
                name.text="昵称:"+dbsystem.getName();
                nickname=dbsystem.getName();
                mainpage.item.nickname=dbsystem.getName();
            }
            if(Statue=="changenameSucceed"){
                dbsystem.getNameByID(str_userid);
                nickname=dbsystem.getName();
                mainpage.item.nickname=dbsystem.getName();
            }
        }
    }

    //用于再点一次退出
    property int quit: 0
    Keys.enabled: true
    Keys.onBackPressed: {
        quit++;
        quittime.start();
        if(quit==2)
            Qt.quit();
        else
            myjava.toastMsg("再点一次退出")
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
        source:"UsersPage.qml"
        z:102
    }

    //用于显示侧边栏的我的分享
    Loader{
        id:mypost;
        anchors.fill: parent
        visible: false
        source:"PostsPage.qml"
        z:102
    }

    //设置页面
    Loader{
        id:settingpage;
        //用于更新名字后重新设置昵称
        function setname(){
            dbsystem.getNameByID(str_userid);
        }
        anchors.fill: parent
        visible: false
        source:"SettingPage.qml"
        z:102
    }

    //侧边栏
    Rectangle{
        id:sidepage;
        height: parent.height
        width:parent.width/10*8
        color:"#32dc96"
        border.color: "grey"
        border.width: 1
        x:-width;
        z:1
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
                easing.type: Easing.InQuart
                duration: 200
            }
        }

        JavaMethod{
            id:myjava
        }

        //侧边栏头像
        Image{
            id:headimage
            anchors.top: parent.top
            anchors.topMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/15
            fillMode: Image.PreserveAspectFit
            height:parent.width/4
            width:height
            source: "http://119.29.15.43/userhead/"+str_userid+".jpg"
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
                    settingpage.item.setdata(str_userid,nickname)
                }
            }
        }

        //侧边栏昵称
        Text{
            id:name;
            anchors.left: headimage.right
            anchors.leftMargin: parent.width/10
            anchors.top: headimage.top
            anchors.topMargin: parent.width/20
            color: "white"
            text:"昵称:未获取"
            wrapMode: Text.WordWrap
            width: parent.width-headimage.width- parent.width/15- parent.width/10
            font{
                family: "黑体"
                pixelSize: headimage.height/4
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    settingpage.visible=true
                    settingpage.item.setdata(str_userid,nickname)
                }
            }
        }

        //侧边栏ID
        Text{
            id:userid;
            anchors.left: headimage.right
            anchors.leftMargin: parent.width/10
            anchors.top: name.bottom
            anchors.topMargin: parent.width/18
            color: "white"
            wrapMode: Text.WordWrap
            width: parent.width-headimage.width- parent.width/15- parent.width/10
            font{
                family: "黑体"
                pixelSize: headimage.height/4
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    settingpage.visible=true
                    settingpage.item.setdata(str_userid,nickname)
                }
            }
        }

        //直线
        Rectangle{
            id:line1
            width: parent.width-headimage.width+headimage.width/2;
            height:1
            color:"white"
            anchors.top: headimage.bottom
            anchors.topMargin: parent.width/18
            anchors.right: parent.right
        }

        Label{
            id:text1
            anchors.top: line1.bottom
            anchors.topMargin: parent.width/18
            anchors.right: parent.right
            text:"我的关注      >  "
            height: headimage.height/2
            width:parent.width-headimage.width+headimage.width/2;
            font{
                family: "黑体"
                pixelSize: height/1.5
            }
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    friends.item.userid=str_userid
                    friends.item.setTitle("我的关注")
                    friends.visible=true
                    friends.x=0
                }
            }
        }

        Rectangle{
            id:line2
            width: parent.width-headimage.width+headimage.width/3;
            height:1
            color:"white"
            anchors.top: text1.bottom
            anchors.topMargin: parent.width/18
            anchors.right: parent.right
        }

        Label{
            id:text2
            anchors.top: line2.bottom
            anchors.topMargin: parent.width/18
            anchors.right: parent.right
            text:"我的粉丝      >  "
            height: headimage.height/2
            width:parent.width-headimage.width+headimage.width/2;
            font{
                family: "黑体"
                pixelSize: height/1.5
            }
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    friends.item.userid=str_userid
                    friends.item.setTitle("我的粉丝")
                    friends.visible=true
                    friends.x=0
                }
            }

        }

        Rectangle{
            id:line3
            width: parent.width-headimage.width+headimage.width/3;
            height:1
            color:"white"
            anchors.top: text2.bottom
            anchors.topMargin: parent.width/18
            anchors.right: parent.right
        }

        Label{
            id:text3
            anchors.top: line3.bottom
            anchors.topMargin: parent.width/18
            anchors.right: parent.right
            text:"我的分享      >  "
            height: headimage.height/2
            width:parent.width-headimage.width+headimage.width/2;
            font{
                family: "黑体"
                pixelSize: height/1.5
            }
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignRight
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    mypost.item.getpost(str_userid,nickname);
                    mypost.visible=true
                    mypost.x=0
                }
            }
        }

        Rectangle{
            id:line4
            width: parent.width-headimage.width+headimage.width/3;
            height:1
            color:"white"
            anchors.top: text3.bottom
            anchors.topMargin: parent.width/18
            anchors.right: parent.right
        }


        GestureArea{
            anchors.bottom: linebt.top
            width: parent.width
            height: parent.width/2.5
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
            id:linebt
            width: parent.width
            height:1
            color:"white"
            anchors.top: setting.top
            anchors.topMargin: -parent.width/40
            anchors.right: parent.right
        }

        Label{
            id:setting
            anchors.bottom: parent.bottom
            anchors.bottomMargin: headimage.height/3
            anchors.left: parent.left
            text:"设置"
            height: headimage.height/2
            width:parent.width/2
            font{
                family: "黑体"
                pixelSize: height/1.5
            }
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    settingpage.visible=true
                    settingpage.item.setdata(str_userid,nickname)
                }
            }

        }

        Label{
            id:loginout
            anchors.bottom: parent.bottom
            anchors.bottomMargin: headimage.height/3
            anchors.right: parent.right
            text:"注销"
            height: headimage.height/2
            width:parent.width/2
            font{
                family: "黑体"
                pixelSize: height/1.5
            }
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    dbsystem.delusernamepassword()
                    mainwindow.parent.x=mainwindow.parent.parent.width;
                    mainwindow.parent.source="";
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
        z:3
    }

    //主页面的顶部栏
    Rectangle{
        id:head;
        width:parent.width;
        height: parent.height/16*1.5;
        color:"#32dc96";
        anchors.top: parent.top;

        //侧边栏按钮
        Image{
            id:sidebarbutton
            height: parent.height/2
            width:height
            source: "qrc:/image/side.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
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
            font{
                family: "黑体"
                pixelSize: head.height/2.5
            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                onDoubleClicked: {
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
            height: parent.height/2
            width:height
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    friends.item.userid=str_userid
                    friends.item.setTitle("搜索用户")
                    friends.visible=true

                    friends.x=0
                }
            }
        }

    }

    //底部栏
    Rectangle{
        id:bottom
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 20
        width:parent.width;
        height: parent.height/16*1.5;
        color:"#32dc96";
        property string currentPage:"首页"

        Rectangle{
            id:mainbutton
            anchors.left: parent.left
            height:width
            width:parent.width/5
            color:"#32dc96";
            Image {
                anchors.fill: parent
                anchors.bottomMargin: 10;
                source: "qrc:/image/mainpage.png"
                fillMode: Image.PreserveAspectFit

            }
            MouseArea{
                id:mainpagebutton
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="首页"
                    mainrect.x=0;


                }
            }
        }
        Rectangle{
            id:newsbutton
            anchors.left: mainbutton.right
            height:width
            width:parent.width/5
            color:"#32dc96";
            Text {
                text:""
                anchors.centerIn: parent
                font{
                    family: "黑体"
                    pixelSize: head.height/3
                    bold:true
                }
                color: "white";
            }
            //            MouseArea{
            //                anchors.fill: parent
            //                onClicked: {
            //                    bottom.currentPage="新闻"
            //                    mainrect.x=-mainwindow.width
            //                }
            //            }
        }
        Rectangle{
            id:sendbutton
            anchors.left: newsbutton.right
            height:width
            width:parent.width/5
            color:"#32dc96";
            Image {

                anchors.fill: parent
                anchors.bottomMargin: 10;
                source: "qrc:/image/sharepage.png"
                fillMode: Image.PreserveAspectFit

            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="分享"
                    mainrect.x=-mainwindow.width*2
                    if(sendpage.item.messagetext!==""||sendpage.item.hiddentext!=="")
                        messageDialog.open()

                    //sendpage.item.setnull()
                }
            }
        }


        Rectangle{
            id:searchbutton
            anchors.left: sendbutton.right
            height:width
            width:parent.width/5
            color:"#32dc96";
            Text {
                text:""
                anchors.centerIn: parent
                font{
                    family: "黑体"
                    pixelSize: head.height/3
                    bold:true
                }
                color: "white";
            }
            //            MouseArea{
            //                anchors.fill: parent
            //                onClicked: {
            //                    bottom.currentPage="搜索"
            //                    mainrect.x=-mainwindow.width*4
            //                }
            //            }
        }

        Rectangle{
            id:recordbutton
            anchors.left: searchbutton.right
            height:width
            width:parent.width/5
            color:"#32dc96";
            Image {

                anchors.fill: parent
                anchors.bottomMargin: 10;
                source: "qrc:/image/recordpage.png"
                fillMode: Image.PreserveAspectFit

            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="记录"
                    mainrect.x=-mainwindow.width*3
                }
            }
        }

    }

    MessageDialog {
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


    //中间的各种页面
    Rectangle{
        id:mainrect
        anchors.top:head.bottom
        height:parent.height-head.height-bottom.height
        width:parent.width*5
        Loader{
            id:mainpage
            anchors.left: parent.left
            height:parent.height
            width:mainwindow.width
            source: "MainPage.qml";
        }
        Loader{
            id:newspage
            anchors.left: mainpage.right
            height:parent.height
            width:mainwindow.width
            source: "NewsPage.qml";


        }
        Loader{
            id:sendpage
            anchors.left: newspage.right
            height:parent.height
            width:mainwindow.width
            source: "SendPage.qml";
        }
        Loader{
            id:recordpage
            anchors.left: sendpage.right
            height:parent.height
            width:mainwindow.width
            source: "RecordPage.qml";
        }
        Loader{
            id:searchpage
            anchors.left: recordpage.right
            height:parent.height
            width:mainwindow.width
            source: "SearchPage.qml";
        }
        Behavior on x{
            NumberAnimation{
                duration: 200
                easing.type: Easing.InCubic
            }
        }
    }

}



