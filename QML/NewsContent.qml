import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Dialogs 1.1
import NewsSystem 1.0
import JavaMethod 1.0
import QtGraphicalEffects 1.0

import "qrc:/GlobalVariable.js" as GlobalColor
Rectangle{
    id:mainpage
    anchors.fill: parent
    color:GlobalColor.Background

    property string userid
    property string nickname

    property string bcid

    property string newsid

    property string likenum
    property string dislikenum

    property double dp:head.height/70

    property var marked:[]

    property string ismarked:"0"


    function getNews(id,a,b,title,time){
        marked=newssystem.loadMarked().split("@")
        ismarked="0"

        forceActiveFocus();//用于响应返回键
        commentmodel.clear()

        titlelabel.text=""
        posttimelabel.text=""
        contentlabel.text=""

        sourcelabel.text=""

        newsid=id
        userid=a
        nickname=b
        titlelabel.text=title
        posttimelabel.text=time

        for(var i=0;i<marked.length;i++)
            if(marked[i].split("|||")[0]===newsid){
                ismarked=marked[i].split("|||")[1]
                break
            }

        newssystem.getContent(id);
        fdan.start()

    }
    NumberAnimation {
        target: flick
        id:fdan
        property: "opacity";
        from: 0;
        to: 1.0;
        duration: 200
        easing.type :Easing.Linear
    }

    MouseArea{
        anchors.fill: parent
    }

    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    ListModel{
        id:commentmodel
    }

    Keys.enabled: true
    Keys.onBackPressed: {
        mainpage.parent.visible=false
        mainpage.parent.parent.forceActiveFocus();


        commenttext.hiddentext=""
        bcid=""
        commenttext.writtentext=""
        commenttext.text=""
        commenttext.firstnull=1


        mainpage.parent.parent.setnewscount("点赞",likenum,newsid)
        mainpage.parent.parent.setnewscount("评论",commentmodel.count.toString(),newsid)
    }


    JavaMethod{
        id:myjava
    }

    NewsSystem{
        id:newssystem
        onStatueChanged: {
            if(Statue=="getcontentDBError")
                myjava.toastMsg("获取新闻详情失败")

            if(Statue=="getcontentSucceed"){
                var str=newssystem.getNewsContent()

                var data=str.split("@")

                if(data.length<10){
                    newssystem.getContent(newsid.toString())
                }
                else{
                sourcelabel.text=data[3]

                likenum=data[4]
                dislikenum=data[5]

                titlelabel.text=data[6]
                posttimelabel.text=data[7]


                var ddd=String(data[8])

                contentlabel.text=ddd;


                newssystem.getcomments(newsid.toString())
                }

            }


            if(Statue=="getcommentsSucceed"){
                commentmodel.clear()
                var i=0
                while(newssystem.getcommentid(i)!==-1){
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
                myjava.toastMsg("获取评论出错！请重试...")
            }

            if(Statue=="deletecommentSucceed"){
                myjava.toastMsg("删除成功")
            }

            if(Statue=="deletecommentDBError"){
                myjava.toastMsg("删除失败")
            }


            if(Statue=="sendcommentSucceed"){
                myjava.toastMsg("评论成功！")

                newssystem.getcomments(newsid.toString());

                commenttext.hiddentext=""
                bcid=""
                commenttext.writtentext=""
                commenttext.text=""
                commenttext.firstnull=1


            }




        }

    }


    Rectangle{
        Rectangle{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height:myjava.getStatusBarHeight()
            color:GlobalColor.StatusBar
        }
        id:head;
        z:7
        width:parent.width;
        height: parent.height/16*2
        color:GlobalColor.Main
        anchors.top: parent.top;

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            radius: 10
            color: GlobalColor.Main
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


                    mainpage.parent.visible=false
                    mainpage.parent.parent.forceActiveFocus();
                    mainpage.parent.parent.setnewscount("点赞",likenum,newsid)
                    mainpage.parent.parent.setnewscount("评论",commentmodel.count.toString(),newsid)
                }
            }
        }
        Label{
            id:headname
            text:"新闻详情"
            anchors.centerIn: parent
            anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
            font{
                family: localFont.name
                pointSize: 20
            }
            color: "white"
        }
    }


    Flickable{
        id:flick
        anchors.top: head.bottom
        anchors.left: head.left
        anchors.right: head.right
        height:parent.height-head.height

        contentHeight: delegaterect.height+20*dp+commentbar.height+commentview.height
        clip: true

        Rectangle{
            id:delegaterect

            smooth: false
            antialiasing: false


            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: GlobalColor.Main
            }

            anchors.margins: 5*dp

            height:titlelabel.height+posttimelabel.height+line.height+contentlabel.height+90*dp+parent.width/6
            z:2


            //标题
            Text{
                id:titlelabel
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 12*dp
                anchors.rightMargin: 12*dp

                anchors.top: parent.top
                anchors.topMargin:12*dp
                text: "获取中"
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                lineHeight: 1.2
                color:"black"
                font{
                    family: localFont.name
                    bold:true
                    pointSize: 20
                }
            }

            //发表时间
            Text{
                id:posttimelabel
                anchors.left: parent.left
                anchors.leftMargin: 12*dp
                anchors.top: titlelabel.bottom
                anchors.topMargin: 12*dp
                width: parent.width/3
                verticalAlignment:Text.AlignBottom
                text: "获取中"
                color:"grey"
                font{
                    family: localFont.name
                    pointSize: 12
                }
            }

            //来源
            Text{
                id:sourcelabel
                anchors.left: posttimelabel.right
                anchors.leftMargin: -8*dp

                anchors.top: posttimelabel.top

                verticalAlignment:Text.AlignBottom
                text: "获取中"
                color: "grey"
                font{
                    family: localFont.name
                    pointSize: 12
                }
            }

            Rectangle{
                id:line
                anchors.top: sourcelabel.bottom
                anchors.topMargin: 8*dp
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width/1.1
                height:2
                color: "lightgrey"
            }

            Text{
                id:contentlabel
                anchors.top: line.bottom
                anchors.topMargin: 12*dp
                anchors.left: parent.left
                anchors.leftMargin: 8*dp
                anchors.right: parent.right
                anchors.rightMargin: 8*dp
                lineHeight: 1.4
                text: "加载中"
                wrapMode: Text.Wrap;
                font{
                    family: localFont.name
                    pointSize: 16
                }
            }



            Rectangle{
                visible: userid!="dshareyouke"
                id:likebutton
                anchors.top: contentlabel.bottom
                anchors.topMargin: 12*dp
                anchors.left: parent.left
                anchors.leftMargin: 32*dp
                anchors.right: parent.horizontalCenter
                anchors.rightMargin: 16*dp
                height:parent.width/6
                color:ismarked=="1"?"lightgreen":"white"
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "lightgreen"
                }

                Text{
                    id:likestring
                    anchors.fill: parent
                    text:"有价值\n"+likenum
                    color:ismarked=="1"?"white":"lightgreen"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.6
                    font{
                        family: localFont.name
                        pointSize: 16
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    enabled: ismarked=="0"
                    onClicked: {
                        marked.push(newsid+"|||"+"1")
                        var str=marked.join("@")
                        if(newssystem.saveMarked(str)){
                        likenum=(parseInt(likenum)+1)+""
                        ismarked="1"
                        newssystem.likeNews(newsid)
                        }
                    }
                }
            }

            Rectangle{
                visible: userid!="dshareyouke"
                id:dislikebutton
                anchors.top: contentlabel.bottom
                anchors.topMargin: 16*dp
                anchors.left: parent.horizontalCenter
                anchors.leftMargin: 16*dp
                anchors.right: parent.right
                anchors.rightMargin: 32*dp
                height:parent.width/6
                color:ismarked=="-1"?"red":"white"
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "red"
                }

                Text{
                    id:dislikestring
                    anchors.fill: parent
                    text:"无价值\n"+dislikenum
                    color:ismarked=="-1"?"white":"red"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.6
                    font{
                        family: localFont.name
                        pointSize: 16
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    enabled: ismarked=="0"
                    onClicked: {
                        marked.push(newsid+"|||"+"-1")
                        var str=marked.join("@")
                        if(newssystem.saveMarked(str)){
                        dislikenum=(parseInt(dislikenum)+1)+""
                        ismarked="-1"
                        newssystem.dislikeNews(newsid)
                        }
                    }
                }
            }

        }



        ListView{
            id:commentview
            anchors.top: delegaterect.bottom
            width:delegaterect.width
            anchors.topMargin: 10*dp
            anchors.left: delegaterect.left

            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
            }

            populate: Transition {
                NumberAnimation { properties: "x,y"; duration: 800 }
            }



            height: contentHeight+commentbar.height

            clip:true
            spacing:-1

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: GlobalColor.Main
            }

            delegate: Item{
                id:uniquecomment
                width:parent.width
                height: commenttextlabel.height+16*dp
                Rectangle{

                    border.color: "lightgrey"
                    border.width: 1
                    anchors.fill: parent
                    Text{
                        id:commenttextlabel
                        anchors.verticalCenter: parent.verticalCenter

                        anchors.left: parent.left
                        anchors.leftMargin: 4*dp
                        anchors.right: parent.right
                        anchors.rightMargin: 4*dp
                        lineHeight: 1.2


                        text: " <font color=\""+GlobalColor.Word+"\">"+CommentatorName+(BeCommentatorName===""?"：</font>":(" 回复 "+BeCommentatorName+"：</font>"))+"<font color=\"black\">"+Message+"</font>"
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        font{
                        family: localFont.name
                            pointSize: 16
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

                        newssystem.deleteComment(CommentID)
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
        visible: userid!="dshareyouke"
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
            color: GlobalColor.Main
        }

        TextField{

            id:commenttext
            property string writtentext

            property string hiddentext:""

            property int firstnull:1
validator:RegExpValidator{regExp:/[^%@<>\/\\ \|{}]{1,500}/}
            anchors.right: sendbutton.left
            anchors.left: parent.left

            anchors.verticalCenter: parent.verticalCenter

            height: parent.height*1.3

            placeholderText:"评论..."
            font{
                family: localFont.name
                pointSize: 16
            }
            style: TextFieldStyle{
                textColor:"grey"
                background: Rectangle{
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
            color:GlobalColor.Main
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: GlobalColor.Main
            }
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


                    newssystem.sendComment(newsid,userid,bcid,commenttext.writtentext)

                }
            }
        }









    }









}

