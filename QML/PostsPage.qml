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
import QtGraphicalEffects 1.0

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
        source:"qrc:/QML/UniquePost.qml"
        z:102
    }

    //顶部栏
    Rectangle{
        id:head;
        width:parent.width;
        height: parent.height/16*1.5;
        color:"#02ae4a"
        anchors.top: parent.top;
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: -2
            radius: 8
            color: "black"

        }

        Label{
            text:" ＜";
            id:backbutton
            height: parent.height
            width:height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font{

                pixelSize: head.height/1.5

            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                id:headma
                onClicked: {
                    mainwindow.parent.visible=false
                    mainwindow.parent.parent.forceActiveFocus()
                }
            }
        }
        Label{
            id:headname
            text:"分享列表"
            anchors.centerIn: parent
            font{
                family: "微软雅黑"
                pixelSize: head.height/2.5
            }
            color: "white"
        }
    }

    //与mainpost.qml类似
    Rectangle{
        id:mainrect
        anchors.top: head.bottom
        anchors.topMargin: 3
        anchors.left: head.left
        height: parent.height-head.height
        width: parent.width

        property string username

        function setusername(a){
            username=a
            refreshpost(a)
        }

        function refreshpost(a){
            postmodel.clear()
            postsystem.i=0;
            postsystem.pi=0
            postsystem.getuserposts(a)
            refreshtimer.refreshtime=0
            refreshtimer.start()
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

                mainrect.forceActiveFocus()

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
            //            spacing:20;

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
                height:headimage.height/5*7+headimage.height+message.height+photo.height+likers.height+comments.height*1.2
                property int postID: ID//用于实现点赞功能
                property string publisherid: PublisherID//用于显示删除
                Rectangle{
                    Rectangle{
                        anchors.top: parent.bottom
                        //anchors.topMargin: 10
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
                        BusyIndicator{
                            anchors.centerIn: parent
                            visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                            running:(parent.status==Image.Loading)?true:false
                        }
                    }

                    Rectangle{
                        id:deletebutton
                        visible:(ID!=0&&myid==PublisherID)?true:false
                        color:"red"
                        height:headimage.height/2
                        width: height
                        radius: height/2

                        anchors.top:parent.top
                        anchors.topMargin: width/4
                        anchors.right: parent.right
                        anchors.rightMargin: width/4

                        Label{
                            text:"╳";
                            anchors.fill: parent
                            anchors.margins: 10
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "white";
                            font{
                                pixelSize: parent.height
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
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                messageDialog.open()
                            }
                        }
                    }

                    Label{
                        id:username
                        anchors.left: headimage.right
                        anchors.leftMargin: headimage.width/5
                        anchors.top: headimage.top
                        anchors.topMargin:height/5
                        height: headimage.height/2
                        text: Username
                        color:"green"
                        font{

                            pixelSize: headimage.height/3
                        }
                    }

                    Label{
                        id:posttime
                        anchors.left: headimage.right
                        anchors.leftMargin: headimage.width/5
                        anchors.bottom: headimage.bottom
                        anchors.bottomMargin: -height/5
                        height: headimage.height/2
                        text: Posttime
                        color:"grey"
                        font{
                            pixelSize: headimage.height/4
                        }
                    }
                    Label{
                        id:message
                        anchors.left: headimage.left
                        anchors.top: headimage.bottom
                        anchors.topMargin: headimage.height/3
                        width:parent.width-headimage.height/3*2
                        text: Message
                        textFormat:Text.RichText
                        wrapMode: Text.Wrap;
                        font{
                            family: "微软雅黑"
                            pixelSize: headimage.height/3
                        }
                    }
                    Image{
                        id:photo
                        anchors.top: message.bottom
                        anchors.topMargin: headimage.height/5
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



                    Label{
                        id:likers
                        anchors.left: headimage.left
                        anchors.top: photo.bottom
                        anchors.topMargin: headimage.height/5
                        text: " "+Liker
                        width:parent.width-headimage.height/3*4

                        wrapMode: Text.Wrap;
                        color: "#02ae4a"
                        font{

                            pixelSize: headimage.height/3
                        }

                        Rectangle{
                            anchors.left: parent.left
                            anchors.top: parent.top
                            height: parent.height
                            width: parent.width
                            color:"grey"
                            opacity: 0.1
                            visible: likers.text==" 暂无人点赞"?true:false

                        }
                    }

                    Label{
                        id:comments
                        visible: posttime.text==""?false:true
                        anchors.left: headimage.left
                        anchors.top: likers.bottom
                        anchors.topMargin: headimage.height/5
                        text: "     "+CommentCount+" 条评论"
                        width:parent.width-headimage.height/3*4
                        wrapMode: Text.Wrap;
                        color: "#02ae4a"
                        font{

                            pixelSize: headimage.height/3
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                listview.commentindex=index
                                uniquepost.item.setData(Hasimage,Headurl,Username,Posttime,Message,Photo,Liker,ID,mainrect.username,nickname,1)
                                uniquepost.visible=true

                                likebutton.visible=false
                                commentbutton.visible=false
                            }
                        }
                    }

                    RowLayout{
                        id:buttonlayout
                        anchors.top: likers.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: headimage.height/8
                        visible: posttime.text==""?false:true
                        //  anchors.topMargin: parent.hasimage?headimage.height/3:0
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
                                text:"❤点赞";
                                anchors.centerIn: parent
                                color: "white";
                                font{
                                    pixelSize: parent.height/2
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    listview.likeindex=index;
                                    postsystem.likepost(postitem.postID,myid);

                                    likebutton.visible=false
                                    commentbutton.visible=false
                                }
                            }
                        }

                        //收藏按钮，暂时无用
                        Rectangle{
                            id:commentbutton
                            visible: false
                            color:"#02ae4a"
                            radius: height/6
                            height:headimage.height/1.5
                            width: photo.width/5

                            anchors.leftMargin: width/2

                            Label{
                                text:"✉评论";
                                anchors.centerIn: parent
                                color: "white";
                                font{

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
                                }
                            }
                        }
                        Rectangle{
                            height:headimage.height/2.5
                            width: height*1.5
                            color:"lightgreen"
                            radius: height/5
                            Label{
                                anchors.centerIn: parent
                                id:morebutton
                                text:"..."
                                color:"white"
                                font{
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
                        if(postmodel.get(listview.likeindex).Liker==="暂无人点赞"){
                            postmodel.setProperty(listview.likeindex,"Liker","❤ "+nickname);
                        }
                        else
                            postmodel.setProperty(listview.likeindex,"Liker",postmodel.get(listview.likeindex).Liker+","+nickname);
                    }

                    if(Statue=="getmorefriendspostsSucceed"){
                        var likers2=getpostlikers(i);
                        if(likers2==="")
                            likers2="暂无人点赞"

                        postmodel.append({
                                             "Hasimage":getposthasimage(i),
                                             "Headurl":getposthead(i),
                                             "Username":getpostname(i),
                                             "Posttime":getposttime(i),
                                             "Message":getpostmessage(i),
                                             "Photo":getpostphoto(i),
                                             "BigPhoto":getbigpostphotourl(i),
                                             "Liker":likers2,
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
                        if(postmodel.count<=5)
                            mainrect.setusername(str_userid)
                    }
                    if(Statue=="deletepostDBError"){
                        myjava.toastMsg("删除失败")


                    }

                }

            }
        }
    }


}



