import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import DataSystem 1.0
import JavaMethod 1.0
import SendImageSystem 1.0



Rectangle {
    id:mainwindow
    anchors.fill: parent
    property string imagePath:"Qt"
    property string str_userid;
    function setusername(a){
        mainpage.item.setusername(a);
        str_userid=a;
        dbsystem.getNameByID(a);
        userid.text="id:"+a;
        sendpage.item.str_userid=a;
        recordpage.item.str_userid=a;
    }


    DataSystem{
        id:dbsystem;
        onStatueChanged: {
            console.log(Statue)
            if(Statue=="getnameSucceed")
             name.text="昵称:"+dbsystem.getName();

            if(Statue=="changenameSucceed")
                dbsystem.getNameByID(str_userid);
        }
    }

Loader{
    id:friends;
    anchors.fill: parent
    visible: false
    source:"UsersPage.qml"
    z:102
}
    Rectangle{
        id:sidepage;
        height: parent.height
        width:parent.width/10*7
        color:"#32dc96"
        border.color: "grey"
        border.width: 1
        x:-width;
        z:1
        visible: false
        Behavior on x{
            NumberAnimation{
                easing.type: Easing.InCubic
                duration: 200
            }
        }

        JavaMethod{
            id:myjava
        }

        Image{
            id:headimage
            anchors.top: parent.top
            anchors.topMargin: parent.width/10
            anchors.left: parent.left
            anchors.leftMargin: parent.width/15
            fillMode: Image.PreserveAspectFit
            height:parent.width/4
            width:height
            source: "http://119.29.15.43/userhead/"+str_userid+".png"

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    myjava.getImage();
                    timer.start();
                }
            }

        }

        Text{
            id:name;
            anchors.left: headimage.right
            anchors.leftMargin: parent.width/10
            anchors.top: headimage.top
            anchors.topMargin: parent.width/20
            color: "white"
            text:"昵称:未获取"
            wrapMode: Text.WordWrap
            width: parent.width-headimage.width
            font{
                family: "黑体"
                pixelSize: headimage.height/4
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    searchbar.visible=searchbar.visible?false:true
                }
            }

        }

        Text{
            id:userid;
            anchors.left: headimage.right
            anchors.leftMargin: parent.width/10
            anchors.top: name.bottom
            anchors.topMargin: parent.width/18
            color: "white"
            wrapMode: Text.WordWrap
            width: parent.width-headimage.width
            font{
                family: "黑体"
                pixelSize: headimage.height/4
            }


            Rectangle{
                id:searchbar
                anchors.fill: parent
                TextField{
                    height:parent.height-6
                    width: parent.width-6
                    x:3
                    anchors.verticalCenter: parent.verticalCenter
                    id:searchtext
                    placeholderText:"请输入要更改的名字"
                    style: TextFieldStyle{
                        background: Rectangle{
                            radius: control.height/4
                            border.width: 1;
                            border.color: "grey"
                            id:searchrect
                            Image{
                                id:searchicon
                                anchors.right: searchrect.right
                                anchors.rightMargin: 3
                                anchors.verticalCenter: searchrect.verticalCenter
                                source: "http://www.icosky.com/icon/png/System/QuickPix%202007/Shamrock.png"
                                height: searchbar.height-10
                                width:height
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                      dbsystem.changeName(str_userid,searchtext.text);
                                    }
                                }
                            }
                        }
                    }

                }
                visible: false
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


SendImageSystem{
    id:sendsystem
    onStatueChanged: {
        console.log(Statue);
    }
}


        Timer{
            id:timer;
            interval: 1500
            onTriggered: {
                var temp=myjava.getImagePath();
                if(temp!=="Qt"){
                    timer.stop();
                    headimage.source="file://"+temp;
                    imagePath=temp;
                    sendsystem.sendHead(imagePath,str_userid);

                }
            }
        }

    }






    MouseArea{
        id:backarea
        visible: false
        anchors.left: sidepage.right
        height: parent.height
        width:parent.width
        onClicked: {
            sidepage.x=-sidepage.width
            visible=false
        }
        z:3
        Rectangle{
            anchors.fill: parent
            color:"black";
            opacity: 0.6
        }
    }

    Rectangle{
        id:head;
        width:parent.width;
        height: parent.height/16*1.5;
        color:"#32dc96";
        anchors.top: parent.top;
        Image{
            id:sidebarbutton
            height: parent.height
            width:height
            //source: "http://www.easyicon.net/api/resizeApi.php?id=1154861&size=96"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    sidepage.visible=true
                    sidepage.x=0
                    backarea.visible=true

                }
            }
        }

        Label{
            id:headname
            text:bottom.currentPage
            anchors.centerIn: parent
            font{
                family: "黑体"
                pixelSize: head.height/3
                bold:true
            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                onClicked: {

                }
            }
        }

        Image{
            id:messagebutton
            source: "http://119.29.15.43/project_image/usericon.png"
            height: parent.height
            width:height
            anchors.right: morebutton.left
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {

                }
            }
        }

        Image{
            id:morebutton
            source: "http://119.29.15.43/project_image/usericon.png"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height
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

    Rectangle{
        id:bottom
        anchors.bottom: parent.bottom;
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
            Text {
                text:"首页"
                anchors.centerIn: parent
                font{
                    family: "黑体"
                    pixelSize: head.height/3
                    bold:true
                }
                color: "white";
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
                text:"新闻"
                anchors.centerIn: parent
                font{
                    family: "黑体"
                    pixelSize: head.height/3
                    bold:true
                }
                color: "white";
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="新闻"
                    mainrect.x=-mainwindow.width
                }
            }
        }
        Rectangle{
            id:sendbutton
            anchors.left: newsbutton.right
            height:width
            width:parent.width/5
            color:"#32dc96";
            Text {
                text:"分享"
                anchors.centerIn: parent
                font{
                    family: "黑体"
                    pixelSize: head.height/3
                    bold:true
                }
                color: "white";
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="分享"
                    mainrect.x=-mainwindow.width*2
                }
            }
        }
        Rectangle{
            id:recordbutton
            anchors.left: sendbutton.right
            height:width
            width:parent.width/5
            color:"#32dc96";
            Text {
                text:"记录"
                anchors.centerIn: parent
                font{
                    family: "黑体"
                    pixelSize: head.height/3
                    bold:true
                }
                color: "white";
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="记录"
                    mainrect.x=-mainwindow.width*3
                }
            }
        }
        Rectangle{
            id:searchbutton
            anchors.left: recordbutton.right
            height:width
            width:parent.width/5
            color:"#32dc96";
            Text {
                text:"搜索"
                anchors.centerIn: parent
                font{
                    family: "黑体"
                    pixelSize: head.height/3
                    bold:true
                }
                color: "white";
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bottom.currentPage="搜索"
                    mainrect.x=-mainwindow.width*4
                }
            }
        }
    }



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



