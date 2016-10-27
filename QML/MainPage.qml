import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import PostsSystem 1.0
import JavaMethod 1.0
import QtGraphicalEffects 1.0

Rectangle{
    id:mainrect
    anchors.fill: parent
    property string username
    property string nickname
    property alias commentindex0: listview.commentindex

    function abs(a){
        if(a<0)
            return -a
        else
            return a
    }

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






    function setcommentcount(count){

        postmodel.get(listview.commentindex).CommentCount=count


    }


    function removepost(){

        postmodel.remove(listview.commentindex)

    }



    //用户显示特定用户的分享列表

//    Loader{
//        id:mypost;
//        height: myjava.getHeight()
//        width: parent.width
//        x:0
//        y:-myjava.getHeight()/16*2;
//        visible: false
//        source:"qrc:/QML/PostsPage.qml"
//        z:102
//    }

//    Loader{
//        id:uniquepost;
//        height: myjava.getHeight()
//        width: parent.width
//        x:0
//        y:-myjava.getHeight()/16*2;
//        visible: false
//        source:"qrc:/QML/UniquePost.qml"
//        z:102
//    }


    //用于显示大图
    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }
    Rectangle{
        property int isbig:0
        id: bigphotorect
        height: parent.height*1.3
        width: parent.width
        x:0
        y:-parent.height/8
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



    Rectangle{
        id: indicator
        height: parent.height*1.3
        width: parent.width
        x:0
        y:-parent.height/8

        visible: false
        color:"black"
        opacity: 0.6
        z:1001
        BusyIndicator{
            width:parent.width/7
            height:width
            anchors.centerIn: parent
            running: true
        }

    }

    //显示列表
    ListView{
        id:listview;
        anchors.fill: parent
        clip:true
//        spacing:20;
        cacheBuffer:10000
        property int likeindex:0
        property int commentindex:0
        


//        onMovementStarted: {

//            mainrect.parent.parent.parent.hidebottom();
//        }
//        onMovementEnded: {
//            mainrect.parent.parent.parent.showbottom();
//        }

        Rectangle {
                  id: scrollbar
                  anchors.right: listview.right
                  anchors.rightMargin: 3
                  y: listview.visibleArea.yPosition * listview.height
                  width: 5
                  height: listview.visibleArea.heightRatio * listview.height
                  color: "grey"
                  radius: 5
                  z:2
                  visible: listview.dragging||listview.flicking
              }

        delegate: Item{
            id:postitem
            width:parent.width
            height:headimage.height/5*5+headimage.height+message.height+photo.height+comments.height//+delegaterect.hasimage?headimage.height/5:0
            property int postID: ID//用于实现点赞功能
            property string publisherid: PublisherID//用于显示头像
            //每一个分享的框框


            Rectangle{


                Rectangle{
                    anchors.top: parent.bottom
                //    anchors.topMargin: 10
                    color:"grey"
                    width:mainrect.width
                    anchors.left: parent.left
                    anchors.leftMargin: -10
                    height:2
                }


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
                    anchors.topMargin: width/5
                    anchors.left: parent.left
                    anchors.leftMargin: width/4
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
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
//                            mypost.item.getpost(publisherid,mainrect.username,nickname);//点击头像时显示用户分享列表
//                            mypost.visible=true
//                            mypost.x=0

                            mainrect.parent.parent.parent.setmypost(publisherid,mainrect.username,nickname)

                        }
                    }
                    //用于网速慢，头像加载慢时先显示文字
                    BusyIndicator{
                        anchors.centerIn: parent
                        visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                        running:(parent.status==Image.Loading)?true:false
                    }
                }

                //用户名
                Label{
                    id:username
                    anchors.left: headimage.right
                    anchors.leftMargin: headimage.width/4
                    anchors.top: headimage.top
                    anchors.topMargin:height/5
                    height: headimage.height/2
                    text: Username
                    color:"green"
                    font{
                        family: localFont.name
                        pixelSize: headimage.height/3
                    }


                }

                //发表时间
                Label{
                    id:posttime
                    anchors.left: headimage.right
                    anchors.leftMargin: headimage.width/4
                    anchors.bottom: headimage.bottom
                    anchors.bottomMargin: -height/5
                    height: headimage.height/2
                    text: Posttime
                    color:"grey"
                    font{
family: localFont.name
                        pixelSize: headimage.height/4
                    }
                }

                //文字信息
                Label{
                    id:message
                    anchors.left: headimage.left
                    anchors.right: parent.right
                    anchors.top: headimage.bottom
                    anchors.topMargin: headimage.height/5


                    //width:parent.width-headimage.height/3*2
                    text: Message
                    wrapMode: Text.Wrap;
                    textFormat:Text.RichText
                    font{
                        family: localFont.name
                        //family: "微软雅黑"
                        pixelSize: headimage.height/3
                    }
                }

                //图片
                Image{
                    id:photo
                    anchors.top: message.bottom

                    anchors.topMargin:parent.hasimage?headimage.height/5:0

                    height: parent.hasimage?listview.width/2:0

                    anchors.horizontalCenter: parent.horizontalCenter
                    width:listview.width-100
                    source:Photo
                    fillMode: Image.PreserveAspectFit
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            indicator.visible=true
                            indicator.visible=true
                            indicator.visible=true
                            indicator.visible=true
                            indicator.visible=true

                            bigphoto.source=postsystem.getbigpostphoto(delegaterect.bigimg);
                            bigphotorect.visible=true
                            bigphotorect.forceActiveFocus()
                            indicator.visible=false
                        }
                    }
                }

                //功能按钮行



                Label{
                    id:likers

                    property string likerStr: Liker

                    visible: posttime.text==""?false:true
                    anchors.left: headimage.left
                    anchors.top: photo.bottom
                    anchors.topMargin: headimage.height/5
                    //width:parent.width-headimage.height/3*4
                    text: LikerNum+" 个点赞 · "


                    wrapMode: Text.Wrap;
                    color: "#02ae4a"
                    font{
                        family: localFont.name
                        pixelSize: headimage.height/3
                    }


                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            listview.likeindex=index;
                            postsystem.likepost(postitem.postID,mainrect.username);
                            likebutton.visible=false
                            commentbutton.visible=false
                        }
                    }

                }


                //评论
                Label{
                    id:comments
                    visible: posttime.text==""?false:true
                    anchors.left: likers.right
                    anchors.top: photo.bottom
                    anchors.topMargin: headimage.height/5
                    text: CommentCount+" 条评论"
                    //width:parent.width-headimage.height/3*4
                    wrapMode: Text.Wrap;
                    color: "#02ae4a"
                    font{
                        family: localFont.name

                        pixelSize: headimage.height/3
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            listview.commentindex=index
//                            uniquepost.item.setData(Hasimage,Headurl,Username,Posttime,Message,Photo,Liker,ID,mainrect.username,nickname,1)
//                            uniquepost.visible=true

                            mainrect.parent.parent.parent.setuniquepost(Hasimage,Headurl,Username,Posttime,Message,Photo,Liker,ID,mainrect.username,nickname,1)


                            likebutton.visible=false
                            commentbutton.visible=false
                        }
                    }
                }

                RowLayout{
                    id:buttonlayout
                    visible: posttime.text==""?false:true

                    anchors.verticalCenter: likers.verticalCenter

                    anchors.right: parent.right
                    anchors.rightMargin: headimage.height/8
                   // anchors.topMargin: parent.hasimage?headimage.height/3:0
                    height: headimage.height/1.5

                    //点赞按钮
                    Rectangle{
                        id:likebutton
                        visible: false
                        color:"#02ae4a"
                        height:headimage.height/1.5
                        width: photo.width/5
                        radius: height/6

                        Label{
                            text:"❤";
                            anchors.centerIn: parent
                            color: "white";
                            font{
                        family: localFont.name
                                pixelSize: parent.height/1.2
                            }
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listview.likeindex=index;
                                postsystem.likepost(postitem.postID,mainrect.username);
                                likebutton.visible=false
                                commentbutton.visible=false
                            }
                        }
                    }


                    Rectangle{
                        id:commentbutton
                        visible: false
                        color:"#02ae4a"
                        radius: height/6
                        height:headimage.height/1.5
                        width: photo.width/5

                        Label{
                            text:"✉";
                            anchors.centerIn: parent
                            color: "white";
                            font{
                        family: localFont.name

                                pixelSize: parent.height/1.3
                            }
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listview.commentindex=index
                                //uniquepost.item.setData(Hasimage,Headurl,Username,Posttime,Message,Photo,Liker,ID,mainrect.username,nickname,1)
                                //uniquepost.visible=true
                                mainrect.parent.parent.parent.setuniquepost(Hasimage,Headurl,Username,Posttime,Message,Photo,Liker,ID,mainrect.username,nickname,1)

                                likebutton.visible=false
                                commentbutton.visible=false
                            }
                        }
                    }

                    //显示功能按钮按键
                    Rectangle{
                        height:headimage.height/2.5
                        width: height*1.5
                        color:"lightgreen"
                        radius: height/5
                        Label{
                            anchors.centerIn: parent
                            id:morebutton
                            text:"←"
                            color:"white"
                            verticalAlignment: Text.AlignVCenter
                            font{
                        family: localFont.name
                                bold: true
                                pixelSize: parent.height
                            }


                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                likebutton.visible=likebutton.visible?false:true
                                commentbutton.visible=commentbutton.visible?false:true

                            }
                        }



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
                if(Statue=="getfriendspostsSucceed"){
                    postsystem.getmoreposts(i);
                }

                if(Statue=="likepostSucceed"){
                    if(postmodel.get(listview.likeindex).Liker==="暂无人点赞"){
                        postmodel.setProperty(listview.likeindex,"Liker","❤ "+mainrect.nickname)
                    }
                    else
                        postmodel.setProperty(listview.likeindex,"Liker",postmodel.get(listview.likeindex).Liker+","+mainrect.nickname)

                    postmodel.setProperty(listview.likeindex,"LikerNum",postmodel.get(listview.likeindex).LikerNum+1);
                }

                if(Statue=="likepostDBError"){
                    myjava.toastMsg("该分享已被删除！")
                    postmodel.remove(listview.likeindex)
                }

                if(Statue=="getmorefriendspostsSucceed"){
                    var likenum=0
                    var likers2=getpostlikers(i)
                    if(likers2===""){
                        likers2="暂无人点赞"
                        likenum=0
                    }
                    else{
                        var list=[]
                        list=likers2.split(",")
                        if(list.length==0)
                        likenum=1
                        else
                            likenum=list.length
                    }


                    postmodel.append({
                                         "Hasimage":getposthasimage(i),
                                         "Headurl":getposthead(i),
                                         "Username":getpostname(i),
                                         "Posttime":getposttime(i),
                                         "Message":getpostmessage(i),
                                         "Photo":getpostphoto(i),
                                         "BigPhoto":getbigpostphotourl(i),
                                         "Liker":likers2,
                                         "LikerNum":likenum,
                                         "ID":getpostID(i),
                                         "PublisherID":getpostpublisher(i),
                                         "CommentCount":getpostcommentcount(i)
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
                                             "LikerNum":"0",
                                             "ID":0,
                                             "PublisherID":"",
                                             "CommentCount":0
                                         }
                                         );
                    }
                }

            }

        }


    }
}



