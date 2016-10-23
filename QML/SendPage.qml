import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import JavaMethod 1.0
import SendImageSystem 1.0
import PostsSystem 1.0
import QtQuick.Dialogs 1.2
import QtCharts 2.0
import SpeechSystem 1.0

Rectangle { 
    MouseArea{
        anchors.bottom: parent.bottom
        height: parent.height/2
        width: parent.width
        onClicked: {

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

    id:mainpage
    anchors.fill: parent
    property string imagePath
    property string str_userid
    property string hiddentext
    property string messagetext:messageedit.text

    function setnull(){
        hiddentext=""

        note.text="请输入文本"
        messageedit.text=""
        image.source=""
        image.visible=false
        text.visible=true
        imagePath=""
    }

    function settext(b){
        note.text="请输入你的感想~"
        hiddentext=b
    }
    function setimg(b){
        image.source="file://"+b
        imagePath=b
    }


    JavaMethod{
        id:myjava
    }

    SpeechSystem{
        id:sendspeechsystem
        onStatueChanged: {
            indicator.visible=false

            if(Statue=="")
                myjava.toastMsg("识别失败！....")
            else
            messageedit.text=Statue;

        }
    }





    Rectangle{
        id:rect
        height: parent.height/4
        width: parent.width-parent.width/10
        anchors.top:parent.top
        anchors.topMargin: parent.width/20
        anchors.horizontalCenter: parent.horizontalCenter


        border.color: "grey"
        border.width: 2
        radius: parent.width/40


        TextArea{

            id:messageedit
            anchors.fill: parent
            anchors.margins: 5

            menu: null
            textColor: "grey"

            backgroundVisible: false

            wrapMode: Text.Wrap
            font{
                pixelSize: rect.height/6
            }
            Label{
                id:note
                visible: messageedit.text==""?true:false

                x:rect.height/10
                y:rect.height/10

                text:"请输入文本"
                color:"grey"
                font{
                    pixelSize: rect.height/6


                }
            }
        }


    }







    Rectangle{
        id:photobutton;
        height:rect.width/3.5
        width:height
        anchors.top: rect.bottom
        anchors.topMargin: mainpage.width/20
        anchors.left: rect.left
        anchors.leftMargin: mainpage.width/30
        border.width: 2
        border.color: "grey"
        Label{
            id:text
            visible:image.source==""?true:false
            text: "+";
            color:"#02ae4a"
            font{
                pixelSize: photobutton.height/3
                bold: true

            }
            anchors.centerIn: parent;
        }
        Image{
            id:image
            visible: image.source==""?false:true
            anchors.fill: parent



        }


        MouseArea{
            anchors.fill: parent
            onClicked: {
                image.visible=true
                myjava.getImage();
                timer.start();
            }
        }
        Timer{
            id:timer;
            interval: 1500
            onTriggered: {
                var temp=myjava.getImagePath();
                if(temp!=="Qt"){
                    timer.stop();
                    image.source="file://"+temp;
                    imagePath=temp;
                }
            }
        }
    }



    ListModel{
        id:model
        ListElement{value:"默认"}
        ListElement{value:"暂无实际功能"}
        ListElement{value:"暂无实际功能"}
        ListElement{value:"暂无实际功能"}
    }



    Rectangle{
        id:clear
        border.color: "grey"
        border.width: 2
        radius: photobutton.width/10
        anchors.left: photobutton.right
        anchors.leftMargin: photobutton.height/4
        anchors.verticalCenter: photobutton.verticalCenter

        width: photobutton.width/1.2
        height: photobutton.height/3
        Text {
            anchors.centerIn: parent
            id: cleartext
            color: "grey"
            text:"清除"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: photobutton.height/5
        }
        MouseArea{
            id:cma
            anchors.fill: parent
            onClicked: {
                messageDialog.open()
            }
        }
        color:cma.pressed?"#02ae4a":"white"
        Behavior on color{
            ColorAnimation{
                easing.type: Easing.Linear
                duration: 200
            }
        }

    }

    MessageDialog {
        id: messageDialog
        title: "提示"
        text: "确定要清空吗？"
        standardButtons:  StandardButton.No|StandardButton.Yes
        onYes: {
            setnull()
        }
        onNo: {

        }
    }



    Rectangle{
        id:sendbutton
        radius: photobutton.width/10
        anchors.left: clear.right
        anchors.leftMargin: photobutton.height/5
        anchors.verticalCenter: photobutton.verticalCenter

        width: photobutton.width/1.2
        height: photobutton.height/3
        Text {
            anchors.centerIn: parent
            id: sendtext
            color: "white"
            text:"发送"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: photobutton.height/5
        }

        MessageDialog {
            id: checklog
            title: "提示"
            text: "确定要发送吗？"
            standardButtons:  StandardButton.No|StandardButton.Yes
            detailedText:"内容：<br>"+messagetext+"<br>"+hiddentext
            onYes: {
                indicator.visible=true
                refreshtimer.refreshtime=0;
                refreshtimer.start();
                if(imagePath!==""){
                    sendimgsystem.imgname=str_userid+"_"+Qt.formatDateTime(new Date(), "yyyy-MM-dd-hh-mm-ss");
                    sendimgsystem.sendImage(imagePath,sendimgsystem.imgname);
                }
                else{
                    if(hiddentext=="")
                    sendmsgsystem.sendPost(str_userid,messageedit.text+hiddentext,0,"");
                    else
                    sendmsgsystem.sendPost(str_userid,messageedit.text+"<br>"+hiddentext,0,"");

                }
            }
            onNo: {

            }
        }



        SendImageSystem{
            id:sendimgsystem
            property string imgname;
            onStatueChanged:{

                if(Statue=="Succeed"){
                    if(hiddentext=="")
                        sendmsgsystem.sendPost(str_userid,messageedit.text+hiddentext,1,"http://119.29.15.43/projectimage/"+imgname+".jpg");
                else
                        sendmsgsystem.sendPost(str_userid,messageedit.text+"<br>"+hiddentext,1,"http://119.29.15.43/projectimage/"+imgname+".jpg");

                }
                if(Statue=="DBError"){
                    myjava.toastMsg("远程服务器出错，请联系开发者！");
                    refreshtimer.refreshtime=62
                    indicator.visible=false
                }
                if(Statue=="Error"){
                    myjava.toastMsg("照片有误！！");
                    refreshtimer.refreshtime=62
                    indicator.visible=false
                }

                if(Statue=="Wait"){
                    myjava.toastMsg("服务器繁忙，请重新发送！");
                    refreshtimer.refreshtime=62
                    indicator.visible=false
                }

                if(Statue=="Sending..."){
                    myjava.toastMsg("正在发送！请稍等！");
                }
            }
        }

        PostsSystem{
            id:sendmsgsystem
            onStatueChanged: {
                if(Statue=="sendpostSucceed"){
                    indicator.visible=false
                    myjava.toastMsg("发送成功！");
                    mainpage.parent.parent.currentPage="首页"
                    mainpage.parent.parent.x=0;
                    mainpage.parent.parent.children[0].item.refreshpost(str_userid);
                    messageedit.text="";
                    hiddentext=""
                    note.text="请输入文本"
                    image.visible=false
                    image.source=""
                    text.visible=true
                    imagePath=""
                    sma.visible=true;
                }
            }
        }

        Timer{
            id:refreshtimer;
            interval: 1000;
            repeat: true
            property int refreshtime: 32//防止连续刷新
            onTriggered: {
                refreshtimer.refreshtime=refreshtimer.refreshtime+1;
            }
        }

        MouseArea{
            id:sma
            anchors.fill: parent
            onClicked: {

                if(image.status==Image.Error){
                    myjava.toastMsg("照片有误！");
                    return
                }

                if(messagetext.length>=300){
                    myjava.toastMsg("内容不能超过300个字符");
                    return
                }

                if(messagetext.indexOf("|||")>=0||messagetext.indexOf("{|}")>=0){
                    myjava.toastMsg("内容包含非法字符！");
                    return
                }

                if(messagetext===""&&hiddentext===""){
                    myjava.toastMsg("请填写内容~！");
                    return
                }

                if(refreshtimer.refreshtime<=30){
                    var time= 60-refreshtimer.refreshtime;
                    myjava.toastMsg("请勿频繁发送分享，还有"+time.toString()+"秒");
                }
                else{
                    checklog.open()
                }

            }
        }

        color:sma.pressed?"#02ae4a":"#29cc88"
        Behavior on color{
            ColorAnimation{
                easing.type: Easing.Linear
                duration: 200
            }
        }

    }



    Rectangle{
        id:reminder
        height:rect.width/3.5
        width:height*2
        anchors.bottom: recordbutton.top
        anchors.bottomMargin: mainpage.width/20

        anchors.horizontalCenter: parent.horizontalCenter

        border.width: 2
        border.color: "grey"
        radius: width/5
        visible: false
        Label{
            visible:true
            text: "请说话";
            color:"#02ae4a"
            font{
                pixelSize: photobutton.height/4
            }
            anchors.centerIn: parent;
        }

    }


    Rectangle{
        id:recordbutton;
        height:rect.width/3.5
        width:height
        anchors.top: photobutton.bottom
        anchors.topMargin: mainpage.width/10

        anchors.horizontalCenter: parent.horizontalCenter

        border.width: 2
        border.color: "grey"
        radius: width/2
        Label{
            visible:true
            text: "语音输入";
            color:"#02ae4a"
            font{
                pixelSize: photobutton.height/6
                bold: true

            }
            anchors.centerIn: parent;
        }

        MouseArea{
            anchors.fill: parent
            onPressed: {
                sendspeechsystem.inclick()
                recordbutton.color="green"
                reminder.visible=true
                speechlengthtimer.time=0
                speechlengthtimer.start()
            }
            onReleased: {
                speechlengthtimer.stop()

                if(speechlengthtimer.time>10){
                reminder.visible=false
                sendspeechsystem.outclick("zh")
                recordbutton.color="white"
                indicator.visible=true
                }
                else{
                    reminder.visible=false
                    recordbutton.color="white"
                    sendspeechsystem.outclick("short")
                    myjava.toastMsg("时间太短...")
                }

            }
        }

        Timer{
            id:speechlengthtimer
            repeat: true
            interval: 100
            property int time:0
            onTriggered: {
                time++
            }
        }

    }




}




