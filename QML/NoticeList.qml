import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import JavaMethod 1.0
import PostsSystem 1.0
import QtGraphicalEffects 1.0
Rectangle {
    id:mainrect;
    anchors.fill: parent

    property string userid;
    property string nickname;
    function getNotice(username,nickname1){
        noticemodel.clear()
        userid=username
        nickname=nickname1
        dbsystem.getNotices(userid)
        forceActiveFocus()
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



    Loader{
        id:uniquepost;
        anchors.fill: parent
        visible: false
        source:"qrc:/QML/UniquePost.qml"
        z:102
    }

    DataSystem{
        id:dbsystem;
        onStatueChanged: {


            if(Statue=="getnoticesSucceed"){
                var i=0
                while(dbsystem.getNoticeSender(i)!==""){
                    noticemodel.append({
                                            "Sender":getNoticeSender(i),
                                            "Type":getNoticeType(i),
                                            "SendTime":getNoticeTime(i),
                                           "IsRead":getNoticeIsRead(i),
                                           "PostID":getNoticePost(i)
                                        }
                                        );
                    i++
                }
            }
            if(Statue=="getnoticesDBError"){
              myjava.toastMsg("暂无消息")
            }

        }
    }

    PostsSystem{
        id:postsystem
        onStatueChanged: {


            if(Statue=="getuniquepostSucceed"){

                var str=new String(postsystem.getuniquepoststr())


                var Hasimage=str.split("|||")[1]
                var Headurl=str.split("|||")[2]
                var Username=str.split("|||")[3]
                var Posttime=str.split("|||")[4]
                var Message=str.split("|||")[5]
                var Photo=str.split("|||")[6]
                var Liker=str.split("|||")[7]
                var ID=parseInt(str.split("|||")[8])

                uniquepost.item.setData(Hasimage,Headurl,Username,Posttime,Message,Photo,Liker,ID,mainrect.userid,mainrect.nickname,0)
                uniquepost.visible=true
            }
            if(Statue=="getuniquepostDBError"){
              myjava.toastMsg("该分享已删除！")
            }


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
        id:head
        z:5
        width:parent.width
        height: parent.height/16*2
        color: "#02ae4a"
        anchors.top: parent.top
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            color: "#55000000"
        }
        Label{
            id:back
            height: parent.height
            width:height
            text:" ＜"
            color: "white"
            font{
                        family: localFont.name
                pixelSize: (head.height)/4
            }
            anchors.left: parent.left
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
            text:"我的消息"
            anchors.centerIn: parent
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            font{
                        family: localFont.name
                
                pointSize: 20
            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                onClicked: {

                }
            }
        }


    }





    ListModel{
        id:noticemodel
    }


    ListView{
        id:view
        spacing: -1
        anchors.top: head.bottom
        clip: true
        width: parent.width
        height:parent.height-head.height
        model: noticemodel

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
            height:mainrect.height/14
            property int postid: PostID

            Rectangle{
                anchors.fill: parent
                color:IsRead?"#dddddd":"white"

                border.color: "grey"
                border.width: 1

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(postid!=0)
                        postsystem.getuniquepost(delegate.postid)
                    }
                }

                Label{
                    id:textlabel;
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin:30
                    wrapMode: Text.WordWrap
                    font{
                        family: localFont.name
                        pointSize: 16
                    }
                    text:"<strong><font color=\"#35dca2\">"+Sender+"</font></strong>"+" "+Type+" <strong><font color=\"#35dca2\">你</font></strong>"

                }

                Label{
                    id:timelabel;
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin:30
                    color: "grey"
                    wrapMode: Text.WordWrap
                    font{
                        family: localFont.name
                        
                        pointSize: 12
                    }
                    text:SendTime

                }




            }
        }

    }




}