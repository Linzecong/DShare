import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import PostsSystem 1.0
import JavaMethod 1.0


Rectangle{
    id:mainrect
    anchors.fill: parent
    property string username
    function setusername(a){
        username=a;
        postsystem.getposts(username);
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
        Rectangle{
            id:zoomin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/12
            anchors.left: parent.left
            anchors.leftMargin: parent.width/4
            height: parent.height/10
            width: height
            radius: height/2
            color: "red"
            Text{
                anchors.centerIn: parent
                text:"放大"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bigphoto.height*=1.2
                    bigphoto.width*=1.2
                }
            }
        }

        Rectangle{
            id:zoomout
            anchors.bottom: zoomin.bottom
            anchors.right: parent.right
            anchors.rightMargin: parent.width/4
            height: parent.height/10
            width: height
            radius: height/2
            color: "blue"
            Text{
                anchors.centerIn: parent
                text:"缩小"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bigphoto.height*=0.8
                    bigphoto.width*=0.8
                }
            }
        }

    }



    ListView{
        id:listview;
        anchors.fill: parent
        clip:true
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
                        username.text="haahah";

                    }
                }
                Image{
                    id:headimage
                    anchors.top:parent.top
                    anchors.topMargin: width/2
                    anchors.left: parent.left
                    anchors.leftMargin: width/2
                    height: listview.width/8
                    width: height
                    fillMode: Image.PreserveAspectFit
                    source:Headurl
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
                    width:parent.width
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
                    anchors.right: parent.right
                    anchors.topMargin: parent.hasimage?headimage.height/3:0
                    height: headimage.height/1.5
                    Rectangle{
                        id:likebutton
                        visible: false
                        color:"#32dc96"
                        height:headimage.height/1.5
                        width: photo.width/5
                        Label{
                            text:"点赞";
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
                                message.text="12341234"
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
                    }

                    Label{
                        height:headimage.height/1.5
                        id:morebutton
                        text:"···"
                        font{
                            family: "黑体"
                            pixelSize: headimage.height/2
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                likebutton.visible=likebutton.visible?false:true
                                collectbutton.visible=collectbutton.visible?false:true
                            }
                        }
                    }
                }

                Label{
                    id:likers
                    anchors.left: headimage.left
                    anchors.top: buttonlayout.bottom
                    anchors.topMargin: headimage.height/3
                    text: Liker
                    wrapMode: Text.WordWrap;
                    font{
                        family: "黑体"
                        pixelSize: headimage.height/3
                    }
                }


            }
        }

        //boundsBehavior:Flickable.StopAtBounds
        model: postmodel
        onDragEnded: {
            // 下拉刷新判断逻辑：已经到头了，还下拉一定距离

            if (contentY < originY){
                if(refreshtimer.refreshtime>30){
                    var dy = contentY - originY;
                    if (dy < -70){
                        postmodel.clear();
                        postsystem.i=0;
                        postsystem.pi=0;
                        postsystem.getposts(username);
                        refreshtimer.refreshtime=0;
                        refreshtimer.start();
                    }
                }
            }


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
                if(Statue=="getfriendspostsSucceed"){
                    postsystem.getmoreposts(i);
                }

                if(Statue=="getmorefriendspostsSucceed"){
                    var likers=getpostlikers(i);
                    if(likers===" 觉得很赞")
                        likers="暂无人点赞"


                    postmodel.append({
                                         "Hasimage":getposthasimage(i),
                                         "Headurl":getposthead(i),
                                         "Username":getpostname(i),
                                         "Posttime":getposttime(i),
                                         "Message":getpostmessage(i),
                                         "Photo":getpostphoto(i),
                                         "BigPhoto":getbigpostphotourl(i),
                                         "Liker":likers
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
                                             "Username":"系统",
                                             "Posttime":"0000-00-00-00",
                                             "Message":"没有消息",
                                             "Photo":"",
                                             "Liker":"无人点赞"
                                         }
                                         );
                    }
                    else
                        myjava.toastMsg("没有更多了...")

                }

            }

        }


    }
}



