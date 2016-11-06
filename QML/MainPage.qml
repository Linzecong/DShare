import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import PostsSystem 1.0
import JavaMethod 1.0
import QtGraphicalEffects 1.0
import "qrc:/GlobalVariable.js" as GlobalColor

Rectangle{
    id:mainrect
    anchors.fill: parent
    property string username
    property string nickname
    property alias commentindex0: listview.commentindex
    property double dp:(myjava.getHeight()/16*2)/70

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

    JavaMethod{
        id:myjava
    }









    //用于显示大图
    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }



    //显示列表
    ListView{
        id:listview;
        anchors.fill: parent
        clip:true

        spacing:5*dp

        Rectangle{
            anchors.fill: parent
            color:GlobalColor.Background
            z:-100
        }

        cacheBuffer:contentHeight+2
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
            height:headimage.height/5*6+headimage.height+message.height+photo.height+comments.height+10*dp+(Hasimage?10*dp:0)
            property int postID: ID//用于实现点赞功能
            property string publisherid: PublisherID//用于显示头像
            //每一个分享的框框


            Rectangle{
                anchors.fill: parent
                id:delegaterect
                property int hasimage: Hasimage
                property string bigimg: BigPhoto
                anchors.margins: 5*dp

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: GlobalColor.Main
                }
                //头像
                Image{
                    id:headimage
                    visible: posttime.text==""?false:true
                    fillMode: Image.PreserveAspectFit

                    source:posttime.text==""?"":Headurl
                    anchors.top:parent.top
                    anchors.topMargin: 10*dp
                    anchors.left: parent.left
                    anchors.leftMargin: 8*dp
                    height: 40*dp

                    width: height
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
                Text{
                    id:username
                    anchors.left: headimage.right
                    anchors.leftMargin: 10*dp

                    anchors.top: headimage.top
                    anchors.topMargin: 2*dp


                    text: Username
                    color:GlobalColor.Word
                    font{
                        family: localFont.name
                        //pixelSize: headimage.height/3
                        pointSize: 16
                    }


                }

                //发表时间
                Text{
                    id:posttime
                    anchors.left: headimage.right
                    anchors.leftMargin: 10*dp

                    anchors.bottom: headimage.bottom
                    anchors.bottomMargin: 2*dp

                    text: Posttime
                    color:"grey"
                    font{
                        family: localFont.name
                        pointSize: 12
                    }
                }

                //文字信息
                Label{
                    id:message
                    anchors.left: headimage.left
                    anchors.right: parent.right
                    anchors.rightMargin: 8*dp

                    anchors.top: headimage.bottom
                    anchors.topMargin: 10*dp


                    //width:parent.width-headimage.height/3*2
                    text: Message
                    wrapMode: Text.Wrap;
                    textFormat:Text.RichText
                    font{
                        family: localFont.name
                        //family: "微软雅黑"
                        pointSize: 16
                    }
                }

                //图片
                Image{
                    id:photo
                    anchors.top: message.bottom

                    anchors.topMargin:parent.hasimage?10*dp:0

                    height: parent.hasimage?listview.width/2:0

                    anchors.horizontalCenter: parent.horizontalCenter

                    width:listview.width-100
                    source:Photo
                    fillMode: Image.PreserveAspectFit

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            mainrect.parent.parent.parent.setbusy(true)

                            mainrect.parent.parent.parent.showbigphoto(postsystem.getbigpostphoto(delegaterect.bigimg))
                            mainrect.parent.parent.parent.setbusy(false)
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
                    anchors.topMargin: 12*dp

                    text: LikerNum+" 个点赞 · "


                    wrapMode: Text.Wrap;
                    color:"grey"
                    font{
                        family: localFont.name
                        pointSize: 14
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
                    anchors.top: likers.top

                    text: CommentCount+" 条评论"
                    //width:parent.width-headimage.height/3*4
                    wrapMode: Text.Wrap;
                    color: "grey"
                    font{
                        family: localFont.name

                        pointSize: 14
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

                Row{
                    id:buttonlayout
                    visible: posttime.text==""?false:true

                    anchors.verticalCenter: likers.verticalCenter

                    anchors.right: parent.right
                    anchors.rightMargin: 8*dp
                    spacing: 10*dp


                    //点赞按钮
                    Rectangle{
                        id:likebutton
                        visible: false
                        height:headimage.height/1.5
                        width: photo.width/5
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            radius: 8
                            color: GlobalColor.Main
                        }

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
                            id:lbm
                            anchors.fill: parent
                            onClicked: {
                                listview.likeindex=index;
                                postsystem.likepost(postitem.postID,mainrect.username);
                                likebutton.visible=false
                                commentbutton.visible=false
                            }
                        }
                        color:lbm.pressed?GlobalColor.SecondButton:GlobalColor.Main
                        Behavior on color{
                            ColorAnimation{
                                easing.type: Easing.Linear
                                duration: 200
                            }
                        }
                    }


                    Rectangle{
                        id:commentbutton
                        visible: false

                        height:headimage.height/1.5
                        width: photo.width/5
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            radius: 8
                            color: GlobalColor.Main
                        }
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
                            id:cbm
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
                        color:cbm.pressed?GlobalColor.SecondButton:GlobalColor.Main
                        Behavior on color{
                            ColorAnimation{
                                easing.type: Easing.Linear
                                duration: 200
                            }
                        }
                    }

                    //显示功能按钮按键
                    Rectangle{
                        height:headimage.height/2.5
                        width: height*1.5
                        color:GlobalColor.SecondButton

                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            radius: 8
                            color: GlobalColor.SecondButton
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        Label{
                            anchors.centerIn: parent
                            id:morebutton
                            text:"···"
                            color:"white"
                            verticalAlignment: Text.AlignVCenter
                            font{
                                family: localFont.name
                                pixelSize: parent.height/1.5
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
                                             "LikerNum":0,
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



