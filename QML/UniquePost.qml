import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1
import PostsSystem 1.0
import JavaMethod 1.0
import QtGraphicalEffects 1.0
import "qrc:/GlobalVariable.js" as GlobalColor
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
    property double dp:head.height/70
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
    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
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


    Rectangle{
        Rectangle{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height:myjava.getStatusBarHeight()
            color:"green"
        }
        id:head;
        z:7
        width:parent.width;
        height: parent.height/16*2
        color:GlobalColor.Green400
        anchors.top: parent.top;

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            color: "#55000000"
        }
        Label{
            text:"＜";
            id:backbutton
            height: parent.height
            width:height
            anchors.left: parent.left
            anchors.leftMargin: 16*dp
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            verticalAlignment: Text.AlignVCenter
            font{
                        family: localFont.name
                
                pixelSize: (head.height)/4

            }
            color: "white"
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
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            font{
                        family: localFont.name
                //family: "微软雅黑"
                pointSize: 20
            }
            color: "white"
        }
    }


    Flickable{
        anchors.top: head.bottom
        anchors.bottom: commentbar.top
        anchors.left: head.left
        anchors.right: head.right

        height:parent.height-head.height-commentbar.height

        contentHeight: delegaterect.height+commentview.height+commentbar.height/3
        clip: true



        Rectangle{
            id:delegaterect


            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: "#55000000"
            }

            anchors.margins: 8*dp

            height:headimage.height/5*6+headimage.height+messagelabel.height+photolabel.height+likers.height+(hasimage?10*dp:0)

            z:2


            //头像
            Image{
                id:headimage
                visible: posttime===""?false:true
                anchors.top:parent.top
                anchors.topMargin: 10*dp

                anchors.left: parent.left
                anchors.leftMargin: 8*dp
                height: 40*dp
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
            Text{
                id:usernamelabel
                anchors.left: headimage.right
                anchors.leftMargin: 10*dp

                anchors.top: headimage.top
                anchors.topMargin:2*dp


                text: username
                color:"green"
                font{
                        family: localFont.name

                    pointSize: 16
                }
            }

            //发表时间
            Text{
                id:posttimelabel
                anchors.left: headimage.right

                anchors.leftMargin: 10*dp

                anchors.bottom: headimage.bottom
                anchors.bottomMargin: 2*dp


                text: posttime
                color:"grey"
                font{
                        family: localFont.name

                    pointSize: 12
                }
            }

            //文字信息
            Label{
                id:messagelabel
                anchors.left: headimage.left
                anchors.right: parent.right
                anchors.rightMargin: 8*dp

                anchors.top: headimage.bottom
                anchors.topMargin: 10*dp


                //width:parent.width-headimage.height/3*2
                text: message
                wrapMode: Text.Wrap;
                textFormat:Text.RichText
                font{
                        family: localFont.name
                    //family: "微软雅黑"
                    pointSize: 14
                }
            }

            //图片
            Image{
                id:photolabel
                anchors.top: messagelabel.bottom
                anchors.topMargin: hasimage?10*dp:0

                height: hasimage?parent.width/2:0;
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width-100
                source:photo
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
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
                anchors.topMargin: 12*dp

                width:parent.width-headimage.height/3*4
                text: liker
                wrapMode: Text.Wrap;
                color: GlobalColor.Teal500
                font{
                        family: localFont.name
                    pointSize: 14
                }

            }

        }

        Label{
            id:zanwupinglun
            anchors.top: delegaterect.bottom
            width:delegaterect.width
            anchors.topMargin: 10*dp
            anchors.left: delegaterect.left
            anchors.leftMargin: 10*dp
            text:"<font color=\""+GlobalColor.Teal500+"\">暂无评论</font>"
            visible: commentmodel.count==0?true:false
            font{
                family: localFont.name
                pointSize: 14
            }

        }



        ListView{
            id:commentview
            anchors.top: delegaterect.bottom
            width:delegaterect.width
            anchors.topMargin: 10*dp
            anchors.left: delegaterect.left

            // height: parent.height-head.height-delegaterect.height-commentbar.height-sendbutton.height/5-50
            height: contentHeight+commentbar.height

            clip:true
            spacing:-1

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: "#55000000"
            }

            delegate: Item{
                id:uniquecomment
                width:parent.width
                height: commenttextlabel.height+16*dp
                Rectangle{

                    border.color: "grey"
                    border.width: 1
                    anchors.fill: parent
                    Text{
                        id:commenttextlabel
                        anchors.verticalCenter: parent.verticalCenter

                        anchors.left: parent.left
                        anchors.leftMargin: 4*dp
                        anchors.right: parent.right
                        anchors.rightMargin: 4*dp


                        text: " <font color=\""+GlobalColor.Teal500+"\">"+CommentatorName+(BeCommentatorName===""?"：</font>":(" 回复 "+BeCommentatorName+"：</font>"))+"<font color=\"grey\">"+Message+"</font>"
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        font{
                        family: localFont.name
                            pointSize: 14
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

                }


                MessageDialog {
                    id: messageDialog
                    title: "提示"
                    text: "确定要删除这条评论吗？"
                    detailedText: Message
                    standardButtons:  StandardButton.No|StandardButton.Yes
                    onYes: {

                        postssystem.deleteComment(CommentID)
                        commentmodel.remove(index)
                    }
                    onNo: {

                    }
                }
            }
            model:commentmodel
        }
    }

    Rectangle{
        id:commentbar
        height: (head.height)/2

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10*dp

        color:"white"

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 8
            color: GlobalColor.Cyan400
        }

        TextField{

            id:commenttext
            property string writtentext

            property string hiddentext:""

            property int firstnull:1

            anchors.right: sendbutton.left
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            placeholderText:"评论..."
            font{
                family: localFont.name
                pointSize: 16
            }
            style: TextFieldStyle{
                textColor:"grey"
                background: Rectangle{
//                    layer.enabled: true
//                    layer.effect: DropShadow {
//                        transparentBorder: true
//                        radius: 6
//                        color: GlobalColor.Green400
//                    }
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
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width:height*1.5
            color:GlobalColor.Cyan400

            Text{
                anchors.centerIn: parent
                text:"发送"
                color:"white"
                font{
                    family: localFont.name
                    pointSize: 16
                }
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









    }
}

