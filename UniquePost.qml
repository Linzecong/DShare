import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1
import PostsSystem 1.0
import JavaMethod 1.0
Rectangle{
    id:uniquepost
    anchors.fill: parent
    color:"white"

    property string userid
    property string nickname

    property string bcid

    property int hasimage
    property string headurl
    property string username
    property string posttime
    property string message
    property string photo
    property string liker
    property string iD

    property int needset

    function setData(mhasimage,mheadurl,musername,mposttime,mmessage,mphoto,mliker,mid,muserid,mnickname,need){
        forceActiveFocus();//用于响应返回键
        commentmodel.clear()
        hasimage=mhasimage
        headurl=mheadurl
        username=musername
        posttime=mposttime
        message=mmessage
        photo=mphoto
        liker=mliker
        iD=mid

        userid=muserid
        nickname=mnickname

        needset=need//用于是否重置评论数
        postssystem.getcomments(mid);

    }
    MouseArea{
        anchors.fill: parent
    }

    Keys.enabled: true
    Keys.onBackPressed: {
        commenttext.hiddentext=""
        bcid=""
        commenttext.writtentext=""
        commenttext.text=""
        commenttext.firstnull=1

        uniquepost.parent.visible=false
        uniquepost.parent.parent.forceActiveFocus();
        if(needset!=0)
            uniquepost.parent.parent.setcommentcount(commentmodel.count)

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

    Rectangle{
        id:head;
        width:parent.width;
        height: parent.height/16*1.5;
        color:"#32dc96"
        anchors.top: parent.top;
        Label{
            text:" ＜";
            id:backbutton
            height: parent.height
            width:height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font{
                
                pixelSize: backbutton.height/1.5

            }
            color: "white";
            MouseArea{
                id:headma
                anchors.fill: parent
                onClicked: {
                    commenttext.hiddentext=""
                    bcid=""
                    commenttext.writtentext=""
                    commenttext.text=""
                    commenttext.firstnull=1

                    uniquepost.parent.visible=false
                    uniquepost.parent.parent.forceActiveFocus();
                    if(needset!=0)
                        uniquepost.parent.parent.setcommentcount(commentmodel.count)
                }
            }
        }
        Label{
            id:headname
            text:"评论列表"
            anchors.centerIn: parent
            font{
                family: "微软雅黑"
                pixelSize: head.height/3
            }
            color: "white";
        }
    }


    Flickable{
        anchors.top: head.bottom
        anchors.bottom: commentbar.top
        anchors.left: head.left
        anchors.right: head.right

        height:parent.height-head.height-commentbar.height

        contentHeight: delegaterect.height+commentview.height+commentbar.height
        clip: true

        Rectangle{
            id:delegaterect
            border.color: "grey"
            border.width: 2
            radius: 10

            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right



            anchors.margins: 10

            height:headimage.height/3*4+headimage.height+messagelabel.height+photolabel.height+likers.height

            z:2


            //头像
            Image{
                id:headimage
                visible: posttime===""?false:true
                anchors.top:parent.top
                anchors.topMargin: width/3
                anchors.left: parent.left
                anchors.leftMargin: width/3
                height: parent.width/8
                width: height
                fillMode: Image.PreserveAspectFit
                source:posttime===""?"":headurl

                //用于网速慢，头像加载慢时先显示文字
                BusyIndicator{
                    anchors.centerIn: parent
                    visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                    running:(parent.status==Image.Loading)?true:false
                }
            }

            //用户名
            Label{
                id:usernamelabel
                anchors.left: headimage.right
                anchors.leftMargin: headimage.width/2
                anchors.top: headimage.top
                anchors.topMargin:height/5
                height: headimage.height/2
                text: username
                color:"green"
                font{

                    pixelSize: headimage.height/3
                }
            }

            //发表时间
            Label{
                id:posttimelabel
                anchors.left: headimage.right
                anchors.leftMargin: headimage.width/2
                anchors.bottom: headimage.bottom
                anchors.bottomMargin: -height/5
                height: headimage.height/2
                text: posttime
                color:"grey"
                font{

                    pixelSize: headimage.height/4
                }
            }

            //文字信息
            Label{
                id:messagelabel
                anchors.left: headimage.left
                anchors.top: headimage.bottom
                anchors.topMargin: headimage.height/3
                width:parent.width-headimage.height/3*2
                text: message
                wrapMode: Text.Wrap;
                textFormat:Text.RichText
                font{
                    family: "微软雅黑"
                    pixelSize: headimage.height/3
                }
            }

            //图片
            Image{
                id:photolabel
                anchors.top: messagelabel.bottom
                anchors.topMargin: hasimage?headimage.height/3:0
                height: hasimage?parent.width/2:0;
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width-100
                source:photo
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        indicator.visible=true
                        indicator.visible=true
                        indicator.visible=true
                        indicator.visible=true
                        indicator.visible=true

                        bigphoto.source=photo
                        bigphotorect.visible=true
                        bigphotorect.forceActiveFocus()
                        indicator.visible=false
                    }
                }
            }



            //点赞者
            Label{
                id:likers
                visible: posttime===""?false:true
                anchors.left: headimage.left
                anchors.top: photolabel.bottom
                anchors.topMargin: headimage.height/3
                width:parent.width-headimage.height/3*4
                text: liker
                wrapMode: Text.Wrap;
                color: "#32dc96"
                font{
                    pixelSize: headimage.height/3
                }

            }

        }

        Label{
            anchors.top: delegaterect.bottom
            width:delegaterect.width
            anchors.topMargin: 10
            anchors.left: delegaterect.left
            text:"<strong><font color=\"#35dca2\">暂无评论</font></strong>"
            visible: commentmodel.count==0?true:false

        }


        ListView{
            id:commentview
            anchors.top: delegaterect.bottom
            width:delegaterect.width
            anchors.topMargin: 10

            anchors.left: delegaterect.left

            // height: parent.height-head.height-delegaterect.height-commentbar.height-sendbutton.height/5-50
            height: contentHeight+commentbar.height

            clip:true
            spacing:-1

            Rectangle {
                id: scrollbar
                anchors.right: commentview.right
                anchors.rightMargin: 3
                y: commentview.visibleArea.yPosition * commentview.height
                width: 10
                height: commentview.visibleArea.heightRatio * commentview.height
                color: "grey"
                radius: 5
                z:50
                visible: commentview.dragging||commentview.flicking
            }

            delegate: Item{
                id:uniquecomment
                width:parent.width
                height: commenttextlabel.height*1.5
                Rectangle{

                    border.color: "grey"
                    border.width: 2
                    radius: headimage.height/10
                    height: commenttextlabel.height*1.5
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    Label{
                        id:commenttextlabel
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: headimage.height/4
                        anchors.right: parent.right
                        anchors.rightMargin: headimage.height/4

                        text: "  <strong><font color=\"#35dca2\">"+CommentatorName+(BeCommentatorName===""?"：</font></strong>":(" 回复 "+BeCommentatorName+"：</font></strong>"))+Message
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        font{

                            pixelSize: headimage.height/3
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            bcid=CommentatorID
                            if(bcid!=userid){
                                commenttext.hiddentext=nickname+" 回复 "+CommentatorName+"："
                                commenttext.text=nickname+" 回复 "+CommentatorName+"："
                                commenttext.firstnull=0
                            }
                            else{

                                commenttext.hiddentext=""
                                bcid=""
                                commenttext.writtentext=""
                                commenttext.text=""
                                commenttext.firstnull=1
                                messageDialog.open()
                            }
                        }
                    }
                    MessageDialog {
                        id: messageDialog
                        title: "提示"
                        text: "确定要删除这条评论吗？"
                        detailedText: Message
                        standardButtons:  StandardButton.No|StandardButton.Yes
                        onYes: {

                            postsystem.deleteComment(CommentID)
                            commentmodel.remove(index)
                        }
                        onNo: {

                        }
                    }
                }
            }
            model:commentmodel
        }
    }

    Rectangle{
        id:commentbar
        height: head.height/1.5
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: headimage.height/4
        anchors.left: parent.left
        color:"#35dca2"
        radius: headimage.height/4





        TextField{

            id:commenttext
            property string writtentext

            property string hiddentext:""

            property int firstnull:1

            anchors.right: sendbutton.left
            anchors.left: parent.left
            anchors.margins: 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            placeholderText:"评论..."
            style: TextFieldStyle{
                background: Rectangle{
                    radius: control.height/4
                    border.width: 2;
                    border.color: "grey"
                    id:searchrect
                }
            }
            onTextChanged: {
                if(commenttext.text.indexOf(commenttext.hiddentext)>=0&&hiddentext!=""){

                    writtentext=commenttext.text.replace(commenttext.hiddentext,"")
                }
                else{
                    if(firstnull==0){
                        hiddentext=""
                        bcid=""
                        writtentext=""
                        commenttext.text=""
                        firstnull=1
                    }
                    else{
                        hiddentext=""
                        bcid=""
                        writtentext=commenttext.text
                    }
                }
            }



        }



        Rectangle{
            id:sendbutton
            anchors.right: parent.right
            anchors.margins: 3
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width:height*2

            radius: headimage.height/4


            color:"#35dca2"

            Text{
                anchors.centerIn: parent
                text:"发送"
                color:"white"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(commenttext.writtentext==""){
                        myjava.toastMsg("请输入内容")
                        return;
                    }

                    if(commenttext.writtentext.indexOf("|||")>=0||commenttext.writtentext.indexOf("{|}")>=0){
                        myjava.toastMsg("非法字符！")
                        return;
                    }




                    postssystem.sendComment(iD,userid,bcid,commenttext.writtentext)



                }
            }
        }





        ListModel{
            id:commentmodel
        }

        JavaMethod{
            id:myjava
        }

        PostsSystem{
            id:postssystem
            onStatueChanged: {
                if(Statue=="getcommentsSucceed"){
                    commentmodel.clear()
                    var i=0
                    while(postssystem.getcommentid(i)!==-1){
                        commentmodel.append({
                                                "CommentID":getcommentid(i),
                                                "CommentatorName":getcommentatorname(i),
                                                "BeCommentatorName":getbecommentatorname(i),
                                                "CommentatorID":getcommentatorid(i),
                                                "Message":getcommentmessage(i),
                                            }
                                            );
                        i++
                    }
                }

                if(Statue=="getcommentsDBError"){
                    myjava.toastMsg("获取评论系统出错！请联系开发者")
                }

                if(Statue=="deletecommentSucceed"){
                    myjava.toastMsg("删除成功")
                }

                if(Statue=="deletecommentDBError"){
                    myjava.toastMsg("删除失败")
                }


                if(Statue=="sendcommentSucceed"){
                    myjava.toastMsg("评论成功！")

                    postssystem.getcomments(iD);

                    commenttext.hiddentext=""
                    bcid=""
                    commenttext.writtentext=""
                    commenttext.text=""
                    commenttext.firstnull=1


                }
                if(Statue=="sendcommentDBError"){
                    myjava.toastMsg("该分享已被删除！")

                    commenttext.hiddentext=""
                    bcid=""
                    commenttext.writtentext=""
                    commenttext.text=""
                    commenttext.firstnull=1

                    uniquepost.parent.visible=false
                    uniquepost.parent.parent.forceActiveFocus();

                    uniquepost.parent.parent.removepost()


                }
            }

        }



    }
}

