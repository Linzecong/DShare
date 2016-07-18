import QtQuick 2.5
import QtQuick.Controls 2.0
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

import DataSystem 1.0
import JavaMethod 1.0
import SendImageSystem 1.0
import PostsSystem 1.0


Rectangle {
    id:mainwindow
    anchors.fill: parent
    property string str_userid;//记录这个页面的人的id

    function getpost(userid){
        str_userid=userid
        mainrect.setusername(userid)
        forceActiveFocus();//用于响应返回键
    }
    Keys.enabled: true
    Keys.onBackPressed: {
        mainwindow.parent.visible=false
        mainwindow.parent.parent.forceActiveFocus();
    }

    MouseArea{
        anchors.fill: parent
    }

    //顶部栏
    Rectangle{
        id:head;
        width:parent.width;
        height: parent.height/16*1.5;
        color:"#32dc96";
        anchors.top: parent.top;
        Label{
            text:"  <   ";
            id:backbutton
            height: parent.height
            width:height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font{
                family: "黑体"
                pixelSize: backbutton.height/1.5

            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    mainwindow.parent.visible=false
                }
            }
        }
        Label{
            id:headname
            text:"分享列表"
            anchors.centerIn: parent
            font{
                family: "黑体"
                pixelSize: head.height/3
            }
            color: "white";
        }
    }

    //与mainpost.qml类似
    Rectangle{
        id:mainrect
        anchors.top: head.bottom
        anchors.left: head.left
        height: parent.height-head.height
        width: parent.width

        property string username

        function setusername(a){
            username=a;
            refreshpost(a);
        }

        function refreshpost(a){
            postmodel.clear();
            postsystem.i=0;
            postsystem.pi=0;
            postsystem.getuserposts(a);
            refreshtimer.refreshtime=0;
            refreshtimer.start();
        }



        Rectangle{
            id: bigphotorect
            height: parent.height*1.3
            width: parent.width
            x:0
            y:-parent.height/8
            visible: false
            z:22
            color: "black"
            Image {
                id: bigphoto
                fillMode: Image.PreserveAspectFit
                height: parent.height
                width: parent.width
            }
            MouseArea{
                anchors.fill: parent
                onPressed: {

                    drag.target=bigphoto
                }
                onClicked: {
                    bigphoto.x=0
                    bigphoto.y=0
                    bigphoto.height=bigphoto.parent.height
                    bigphoto.width=bigphoto.parent.width
                    bigphotorect.visible=false
                }

            }


        }

        ListView{
            id:listview;
            anchors.fill: parent
            clip:true
            property int likeindex:0
            spacing:20;
            delegate: Item{
                id:postitem
                width:parent.width
                height:headimage.height/3*5+headimage.height+message.height+photo.height+buttonlayout.height+likers.height+20+headimage.width/2
                Rectangle{
                    border.color: "grey"
                    border.width: 1
                    radius: 10
                    anchors.fill: parent
                    anchors.margins: 10
                    id:delegaterect
                    property int hasimage: Hasimage
                    property string bigimg: BigPhoto
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            //username.text="haahah";

                        }
                    }
                    Image{
                        id:headimage
                        visible: posttime.text==""?false:true
                        anchors.top:parent.top
                        anchors.topMargin: width/2
                        anchors.left: parent.left
                        anchors.leftMargin: width/2
                        height: listview.width/8
                        width: height
                        fillMode: Image.PreserveAspectFit
                        source:posttime.text==""?"":Headurl
                        Label{
                            anchors.centerIn: parent
                            visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                            text:(parent.status==Image.Loading)?"加载中":"无"
                            color:"grey"
                        }
                    }

                    Label{
                        id:username
                        anchors.left: headimage.right
                        anchors.leftMargin: headimage.width/2
                        anchors.top: headimage.top
                        height: headimage.height/2
                        text: Username
                        font{
                            family: "黑体"
                            pixelSize: headimage.height/3
                        }
                    }

                    Label{
                        id:posttime
                        anchors.left: headimage.right
                        anchors.leftMargin: headimage.width/3
                        anchors.top: username.bottom
                        height: headimage.height/2
                        text: Posttime
                        font{
                            family: "黑体"
                            pixelSize: headimage.height/3
                        }
                    }
                    Label{
                        id:message
                        anchors.left: headimage.left
                        anchors.top: headimage.bottom
                        anchors.topMargin: headimage.height/3
                        width:parent.width-headimage.height/3*1.5
                        text: Message
                        wrapMode: Text.Wrap;
                        font{
                            family: "黑体"
                            pixelSize: headimage.height/3
                        }
                    }
                    Image{
                        id:photo
                        anchors.top: message.bottom
                        anchors.topMargin: headimage.height/3
                        height: parent.hasimage?listview.width/2:0;
                        anchors.horizontalCenter: parent.horizontalCenter
                        width:listview.width-100
                        source:Photo
                        fillMode: Image.PreserveAspectFit
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                bigphoto.source=postsystem.getbigpostphoto(delegaterect.bigimg);
                                bigphotorect.visible=true
                            }
                        }
                    }


                    RowLayout{
                        id:buttonlayout
                        anchors.top: photo.bottom
                        visible: false
                        anchors.right: parent.right
                        anchors.topMargin: parent.hasimage?headimage.height/3:0
                        height: headimage.height/1.5
                        Rectangle{
                            id:likebutton
                            visible: false
                            color:"#30d090"
                            height:headimage.height/1.5
                            width: photo.width/5
                            radius: height/4
                            Label{
                                text:" ♡ ";
                                anchors.centerIn: parent
                                color: "white";
                                font{
                                    family: "黑体"
                                    pixelSize: parent.height/1.5
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    listview.likeindex=index;
                                    postsystem.likepost(postitem.postID,mainrect.username);
                                    likebutton.visible=false
                                    collectbutton.visible=false
                                }
                            }
                        }
                        Rectangle{
                            id:collectbutton
                            visible: false
                            color:"#32dc96"
                            height:headimage.height/1.5
                            width: photo.width/5
                            Label{
                                text:"收藏";
                                anchors.centerIn: parent
                                color: "white";
                                font{
                                    family: "黑体"
                                    pixelSize: parent.height/2
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {

                                    likebutton.visible=false
                                    collectbutton.visible=false
                                }
                            }
                        }

                        Label{
                            height:headimage.height/1.5
                            id:morebutton
                            text:"<  "
                            color:"#32dc96"
                            font{
                                family: "黑体"
                                pixelSize: headimage.height
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    likebutton.visible=likebutton.visible?false:true
                                    //collectbutton.visible=collectbutton.visible?false:true
                                }
                            }
                        }
                    }

                    Label{
                        id:likers
                        visible: posttime.text==""?false:true
                        anchors.left: headimage.left
                        anchors.top: buttonlayout.bottom
                        anchors.topMargin: headimage.height/3
                        text: Liker
                        width:parent.width-headimage.height/3*4
                        wrapMode: Text.Wrap;
                        color: "#32dc96"
                        font{
                            family: "黑体"
                            pixelSize: headimage.height/3
                        }
                    }


                }
            }

            model: postmodel
            onDragEnded: {

                //取消了下拉刷新

                // 上拉加载判断逻辑：已经到底了，还上拉一定距离
                if (contentHeight>height && contentY-originY > contentHeight-height){
                    var dy = (contentY-originY) - (contentHeight-height);

                    if (dy > 70){
                        postsystem.pi=postsystem.i;
                        postsystem.getmoreposts(postsystem.i);
                    }
                }
            }


            Timer{
                id:refreshtimer;
                interval: 1000;
                repeat: true
                property int refreshtime: 32//防止连续刷新
                onTriggered: {
                    refreshtime=refreshtimer.refreshtime+1;
                }

            }

            ListModel{
                id:postmodel;
            }

            JavaMethod{
                id:myjava;
            }

            PostsSystem{
                id:postsystem
                property int i: 0
                property int pi: 0
                onStatueChanged: {
                    console.log(Statue)
                    if(Statue=="getuserpostsSucceed"){
                        postsystem.getmoreposts(i);
                    }

                    if(Statue=="likepostSucceed"){
                        if(postmodel.get(listview.likeindex).Liker==="暂无人点赞")
                            postmodel.setProperty(listview.likeindex,"Liker","♡ "+mainrect.nickname);
                        else
                            postmodel.setProperty(listview.likeindex,"Liker",postmodel.get(listview.likeindex).Liker+","+mainrect.nickname);
                    }

                    if(Statue=="getmorefriendspostsSucceed"){
                        var likers=getpostlikers(i);
                        if(likers==="")
                            likers="暂无人点赞"

                        postmodel.append({
                                             "Hasimage":getposthasimage(i),
                                             "Headurl":getposthead(i),
                                             "Username":getpostname(i),
                                             "Posttime":getposttime(i),
                                             "Message":getpostmessage(i),
                                             "Photo":getpostphoto(i),
                                             "BigPhoto":getbigpostphotourl(i),
                                             "Liker":likers,
                                             "ID":getpostID(i)
                                         }
                                         );
                        i++;
                        if((i-pi)<5)
                            postsystem.getmoreposts(i);
                    }

                    if(Statue=="getmorefriendspostsNoMore"){
                        if(postmodel.count==0){

                            postmodel.append({
                                                 "Hasimage":0,
                                                 "Headurl":"",
                                                 "Username":"                   系统",
                                                 "Posttime":"",
                                                 "Message":"该用户暂无任何分享喔~",
                                                 "Photo":"",
                                                 "Liker":"",
                                                 "ID":0
                                             }
                                             );
                        }


                    }

                }

            }
        }
    }


}



