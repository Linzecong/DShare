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
    property string nickname

    function setusername(a){
        username=a;
        postsystem.getposts(username);//初始化Post
        refreshtimer.start();//防止多次刷新
    }

    //重新刷新分享页面
    function refreshpost(a){
        postmodel.clear();
        postsystem.i=0;
        postsystem.pi=0;
        postsystem.getposts(a);
        refreshtimer.refreshtime=0;
        refreshtimer.start();
    }

    //用户显示特定用户的分享列表
    Loader{
        id:mypost;
        height: parent.height*1.25
        width: parent.width
        x:0
        y:-parent.height/8
        visible: false
        source:"PostsPage.qml"
        z:102
    }

    //用于显示大图
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

        //        Rectangle{
        //            id:zoomin
        //            anchors.bottom: parent.bottom
        //            anchors.bottomMargin: parent.height/12
        //            anchors.left: parent.left
        //            anchors.leftMargin: parent.width/4
        //            height: parent.height/10
        //            width: height
        //            radius: height/2
        //            color: "red"
        //            visible: false
        //            Text{
        //                anchors.centerIn: parent
        //                text:"放大"
        //            }
        //            MouseArea{
        //                anchors.fill: parent
        //                onClicked: {
        //                    bigphoto.height*=1.2
        //                    bigphoto.width*=1.2
        //                }
        //            }
        //        }

        //        Rectangle{
        //            id:zoomout
        //            anchors.bottom: zoomin.bottom
        //            anchors.right: parent.right
        //            anchors.rightMargin: parent.width/4
        //            height: parent.height/10
        //            width: height
        //            radius: height/2
        //            color: "blue"
        //            visible: false
        //            Text{
        //                anchors.centerIn: parent
        //                text:"缩小"
        //            }
        //            MouseArea{
        //                anchors.fill: parent
        //                onClicked: {
        //                    bigphoto.height*=0.8
        //                    bigphoto.width*=0.8
        //                }
        //            }
        //        }

    }


    //显示列表
    ListView{
        id:listview;
        anchors.fill: parent
        clip:true
        spacing:20;
        property int likeindex:0
        delegate: Item{
            id:postitem
            width:parent.width
            height:headimage.height/3*5+headimage.height+message.height+photo.height+buttonlayout.height+likers.height+20+headimage.width/2
            property int postID: ID//用于实现点赞功能
            property string publisherid: PublisherID//用于显示头像
            //每一个分享的框框
            Rectangle{
                border.color: "grey"
                border.width: 1
                radius: 10
                anchors.fill: parent
                anchors.margins: 10
                id:delegaterect
                property int hasimage: Hasimage
                property string bigimg: BigPhoto
                //头像
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
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            mypost.item.getpost(publisherid);//点击头像时显示用户分享列表
                            mypost.visible=true
                            mypost.x=0
                        }
                    }
                    //用于网速慢，头像加载慢时先显示文字
                    Label{
                        anchors.centerIn: parent
                        visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                        text:(parent.status==Image.Loading)?"加载中":"无"
                        color:"grey"
                    }
                }

                //用户名
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

                //发表时间
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

                //文字信息
                Label{
                    id:message
                    anchors.left: headimage.left
                    anchors.top: headimage.bottom
                    anchors.topMargin: headimage.height/3
                    width:parent.width-headimage.height/3*1.5
                    text: Message
                    wrapMode: Text.Wrap;
                    font{
                        pixelSize: headimage.height/3
                    }
                }

                //图片
                Image{
                    id:photo
                    anchors.top: message.bottom
                    anchors.topMargin: parent.hasimage?headimage.height/3:0
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

                //功能按钮行
                RowLayout{
                    id:buttonlayout
                    visible: posttime.text==""?false:true
                    anchors.top: photo.bottom
                    anchors.right: parent.right
                    anchors.topMargin: parent.hasimage?headimage.height/3:0
                    height: headimage.height/1.5

                    //点赞按钮
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

                    //收藏按钮，暂时无用
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

                    //显示功能按钮按键
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
                               // collectbutton.visible=collectbutton.visible?false:true
                            }
                        }
                    }
                }

                //点赞者
                Label{
                    id:likers
                    visible: posttime.text==""?false:true
                    anchors.left: headimage.left
                    anchors.top: buttonlayout.bottom
                    anchors.topMargin: headimage.height/3
                    width:parent.width-headimage.height/3*4
                    text: Liker
                    wrapMode: Text.Wrap;
                    color: "#32dc96"
                    font{
                        pixelSize: headimage.height/3
                    }
                }


            }
        }
        model: postmodel//信息model
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


        //防止多次刷新用
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

                if(Statue=="likepostSucceed"){
                    if(postmodel.get(listview.likeindex).Liker==="暂无人点赞")
                        postmodel.setProperty(listview.likeindex,"Liker","♡ "+mainrect.nickname)
                    else
                        postmodel.setProperty(listview.likeindex,"Liker",postmodel.get(listview.likeindex).Liker+","+mainrect.nickname)
                }

                if(Statue=="getmorefriendspostsSucceed"){
                    var likers=getpostlikers(i)
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
                                         "ID":getpostID(i),
                                         "PublisherID":getpostpublisher(i)
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
                                             "Username":"                     系统",
                                             "Posttime":"",
                                             "Message":"你没有收到任何来自好友的分享喔~~点击右上角添加好友~左上角设置头像和修改昵称喔~或者先试试记录功能~",
                                             "Photo":"",
                                             "Liker":"",
                                             "ID":0,
                                             "PublisherID":""
                                         }
                                         );
                    }
                }

            }

        }


    }
}



