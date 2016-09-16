import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import DataSystem 1.0
import JavaMethod 1.0
import SendImageSystem 1.0
import PostsSystem 1.0


Rectangle {
    id:mainwindow
    anchors.fill: parent
    property string str_userid;//记录这个页面的人的id
    property string myid
    property string nickname
    function getpost(userid,mmid,mnickname){
        str_userid=userid
        myid=mmid
        nickname=mnickname
        mainrect.setusername(userid)
        forceActiveFocus();//用于响应返回键
    }
    function setcommentcount(count){

        postmodel.get(listview.commentindex).CommentCount=count


    }

    Keys.enabled: true
    Keys.onBackPressed: {
        mainwindow.parent.visible=false
        mainwindow.parent.parent.forceActiveFocus();
    }

    MouseArea{
        anchors.fill: parent
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

    Loader{
        id:uniquepost;
        anchors.fill: parent
        visible: false
        source:"UniquePost.qml"
        z:102
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
                    mainwindow.parent.parent.forceActiveFocus();
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

        ListView{
            id:listview;
            anchors.fill: parent
            clip:true
            property int likeindex:0
            property int commentindex:0
            spacing:20;

            Rectangle {
                id: scrollbar
                anchors.right: listview.right
                anchors.rightMargin: 3
                y: listview.visibleArea.yPosition * listview.height
                width: 10
                height: listview.visibleArea.heightRatio * listview.height
                color: "grey"
                radius: 5
                z:2
                visible: listview.dragging||listview.flicking
            }


            delegate: Item{
                id:postitem
                width:parent.width
                height:headimage.height/3*5+headimage.height+message.height+photo.height+buttonlayout.height+likers.height+20+headimage.width/2
                property int postID: ID//用于实现点赞功能
                property string publisherid: PublisherID//用于显示删除
                Rectangle{
                    border.color: "grey"
                    border.width: 1
                    radius: 10
                    anchors.fill: parent
                    anchors.margins: 10
                    id:delegaterect
                    property int hasimage: Hasimage
                    property string bigimg: BigPhoto

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
                        BusyIndicator{
                            anchors.centerIn: parent
                            visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                            running:(parent.status==Image.Loading)?true:false
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
                        textFormat:Text.RichText
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
                                indicator.visible=true
                                indicator.visible=true
                                indicator.visible=true
                                indicator.visible=true
                                indicator.visible=true
                                bigphoto.source=postsystem.getbigpostphoto(delegaterect.bigimg);
                                bigphotorect.visible=true
                                indicator.visible=false
                                bigphotorect.forceActiveFocus()
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
                            id:deletebutton
                            visible: false
                            color:"red"
                            height:headimage.height/1.5
                            width: photo.width/5
                            radius: height/4
                            Label{
                                text:"删除";
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
                                    messageDialog.open()
                                }
                            }

                            MessageDialog {
                                id: messageDialog
                                title: "提示"
                                text: "确定要删除吗？"
                                standardButtons:  StandardButton.No|StandardButton.Yes
                                onYes: {
                                    postmodel.remove(index)
                                    postsystem.deletepost(postitem.postID)
                                }
                                onNo: {

                                }
                            }
                        }

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
                                    postsystem.likepost(postitem.postID,myid);

                                    likebutton.visible=false
                                    commentbutton.visible=false
                                    deletebutton.visible=false
                                }
                            }
                        }

                        //收藏按钮，暂时无用
                        Rectangle{
                            id:commentbutton
                            visible: false
                            color:"#30d090"
                            radius: height/4
                            height:headimage.height/1.5
                            width: photo.width/5
                            Label{
                                text:"评论";
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
                                    listview.commentindex=index
                                    uniquepost.item.setData(Hasimage,Headurl,Username,Posttime,Message,Photo,Liker,ID,myid,nickname,1)
                                    uniquepost.visible=true

                                    likebutton.visible=false
                                    commentbutton.visible=false
                                    deletebutton.visible=false
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
                                    deletebutton.visible=deletebutton.visible?false:true
                                    deletebutton.visible=(ID!=0&&myid==PublisherID)?true:false

                                    likebutton.visible=likebutton.visible?false:true
                                    commentbutton.visible=commentbutton.visible?false:true

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

                    Label{
                        id:comments
                        visible: posttime.text==""?false:true
                        anchors.left: headimage.left
                        anchors.top: likers.bottom
                        anchors.topMargin: headimage.height/6
                        text: "     "+CommentCount+" 条评论"
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
                            postmodel.setProperty(listview.likeindex,"Liker","♡ "+nickname);
                        else
                            postmodel.setProperty(listview.likeindex,"Liker",postmodel.get(listview.likeindex).Liker+","+nickname);
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
                                                 "Username":"                   系统",
                                                 "Posttime":"",
                                                 "Message":"该用户暂无任何分享喔~",
                                                 "Photo":"",
                                                 "Liker":"",
                                                 "ID":0,
                                                 "PublisherID":"",
                                                 "CommentCount":0

                                             }
                                             );
                        }


                    }

                    if(Statue=="deletepostSucceed"){
                        myjava.toastMsg("删除成功")


                    }
                    if(Statue=="deletepostDBError"){
                        myjava.toastMsg("删除失败")


                    }

                }

            }
        }
    }


}



