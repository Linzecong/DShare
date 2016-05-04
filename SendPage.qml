import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import JavaMethod 1.0
import SendImageSystem 1.0
import PostsSystem 1.0
Rectangle { 
    id:mainpage
    anchors.fill: parent
    property string imagePath
    property string str_userid;
    function settext(b){
        messageedit.text=b;
    }
    function setimg(b){
        image.source="file://"+b;
        imagePath=b;
    }


    JavaMethod{
        id:myjava
    }

    Rectangle{
        id:rect
        height: parent.height/4
        width: parent.width-parent.width/10
        anchors.top:parent.top
        anchors.topMargin: parent.width/20
        anchors.horizontalCenter: parent.horizontalCenter


        border.color: "grey"
        border.width: 1
        radius: parent.width/40


    }

    Flickable{

        anchors.centerIn: rect
        height: rect.height-rect.height/10
        width: rect.width-rect.width/10
        contentHeight: messageedit.contentHeight

        clip: true
        flickableDirection: Flickable.VerticalFlick
        TextEdit{
            color: "grey"
            id:messageedit
            width: rect.width-rect.width/10
            height: rect.height-rect.height/10
            wrapMode: Text.Wrap
            font{
                pixelSize: messageedit.height/6
                family: "黑体"
            }
            Label{
                id:note
                visible: messageedit.text==""?true:false
                text:"请输入文本"
                color:"grey"
                font{
                    pixelSize: messageedit.height/6
                    family: "黑体"

                }
            }  
        }
        z:1
    }

    Rectangle{
        id:photobutton;
        height:rect.width/3.5
        width:height
        anchors.top: rect.bottom
        anchors.topMargin: mainpage.width/20
        anchors.left: rect.left
        anchors.leftMargin: mainpage.width/30
        border.width: 1
        border.color: "grey"
        Label{
            id:text
            visible:image.source==""?true:false
            text: "+";
            color:"#32dc96"
            font{
                pixelSize: photobutton.height/3
                bold: true
                family: "黑体"
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
        ListElement{value:"仅自己可见"}
        ListElement{value:"关注人可见"}
        ListElement{value:"其他"}
    }

    Rectangle{
        id:boxrect
        anchors.top: teambox.bottom
        anchors.horizontalCenter: teambox.horizontalCenter
        width: teambox.width
        height: photobutton.height*1.5
        z:2
        visible: false
        ListView{

            id:boxview
            clip:true
            anchors.fill: parent
            width: teambox.width

            spacing: -1
            boundsBehavior:Flickable.StopAtBounds
            delegate: Item{
                id:postitem
                width:teambox.width
                height:photobutton.height/3
                Rectangle{
                    border.color: "grey"
                    border.width: 1
                    anchors.fill: parent
                    radius: photobutton.width/10
                    Label{
                        id:mytext
                        anchors.centerIn: parent
                        text: value
                        font{
                            family: "黑体"
                            pixelSize: photobutton.height/5
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            boxview.currenttext=mytext.text
                            boxrect.visible=false;
                        }
                    }
                }
            }
            model: model
            property string currenttext:model.get(0).value



        }
    }


    Label{
        id:label
        anchors.left: photobutton.right
        anchors.leftMargin: mainpage.width/30
        height: photobutton.height/3
        anchors.top: photobutton.top
        anchors.topMargin: photobutton.height/10
        text: "分组:"

        font{
            family: "黑体"
            pixelSize: photobutton.height/5
        }
    }


    Rectangle{
        id:teambox
        border.color: "grey"
        border.width: 1
        radius: photobutton.width/10
        anchors.left: label.right

        anchors.top: photobutton.top

        width: photobutton.width*1.5
        height: photobutton.height/3
        Text {
            x: photobutton.height/8
            id: boxtext
            height: parent.height
            color: "grey"
            text:boxview.currenttext
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: photobutton.height/6
            font.family: "黑体"
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                boxrect.visible=true
            }
        }

    }


    Rectangle{
        id:clear
        border.color: "grey"
        border.width: 1
        radius: photobutton.width/10
        anchors.left: photobutton.right
        anchors.leftMargin: photobutton.height/4
        anchors.top: teambox.bottom
        anchors.topMargin: photobutton.height/5.5

        width: photobutton.width/1.2
        height: photobutton.height/3.5
        Text {
            anchors.centerIn: parent
            id: cleartext
            color: "grey"
            text:"清除"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: photobutton.height/5
            font.family: "黑体"
        }
        MouseArea{
            id:cma
            anchors.fill: parent
            onClicked: {
                messageedit.text="";

                image.visible=false
                text.visible=true
                imagePath=""
            }
        }
        color:cma.pressed?"#32dc96":"white"
        Behavior on color{
            ColorAnimation{
                easing.type: Easing.Linear
                duration: 200
            }
        }

    }


    Rectangle{
        id:sendbutton
        radius: photobutton.width/10
        anchors.right: boxrect.right
        anchors.leftMargin: photobutton.height/5
        anchors.top: teambox.bottom
        anchors.topMargin: photobutton.height/5.5

        width: photobutton.width/1.2
        height: photobutton.height/3.5
        Text {
            anchors.centerIn: parent
            id: sendtext
            color: "white"
            text:"发送"
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: photobutton.height/5
            font.family: "黑体"
        }



        SendImageSystem{
            id:sendimgsystem
            property string imgname;
            onStatueChanged:{
                if(Statue=="Succeed"){
                    sendmsgsystem.sendPost(str_userid,messageedit.text,1,"http://119.29.15.43/projectimage/"+imgname+".jpg");
                }
                if(Statue=="DBError"){
                    myjava.toastMsg("远程服务器出错，请联系开发者！");
                    refreshtimer.refreshtime=62
                }
                if(Statue=="Error"){
                    myjava.toastMsg("照片有误！！");
                    refreshtimer.refreshtime=62
                }

                if(Statue=="Sending..."){
                    myjava.toastMsg("正在发送！请稍等！");
                    sma.visible=true;
                }
            }
        }

        PostsSystem{
            id:sendmsgsystem
            onStatueChanged: {
                if(Statue=="sendpostSucceed"){
                    myjava.toastMsg("发送成功！");
                    mainpage.parent.parent.parent.bottom.currentPage="首页"
                    mainpage.parent.parent.x=0;
                    mainpage.parent.parent.children[0].item.refreshpost(str_userid);

                }
            }
        }

        Timer{
            id:refreshtimer;
            interval: 1000;
            repeat: true
            property int refreshtime: 62//防止连续刷新
            onTriggered: {
                refreshtimer.refreshtime=refreshtimer.refreshtime+1;
            }
        }

        MouseArea{
            id:sma
            anchors.fill: parent
            onClicked: {
                if(refreshtimer.refreshtime<=60){
                    var time= 60-refreshtimer.refreshtime;
                    myjava.toastMsg("还有"+time.toString()+"秒");
                }
                else{
                    refreshtimer.refreshtime=0;
                    refreshtimer.start();
                    if(imagePath!==""){
                        sendimgsystem.imgname=str_userid+"_"+Qt.formatDateTime(new Date(), "yyyy-MM-dd-hh-mm-ss");
                        sendimgsystem.sendImage(imagePath,sendimgsystem.imgname);
                    }
                    else{
                        sendmsgsystem.sendPost(str_userid,messageedit.text,0,"");
                    }
                }

            }
        }

        color:sma.pressed?"#32dc96":"#29cc88"
        Behavior on color{
            ColorAnimation{
                easing.type: Easing.Linear
                duration: 200
            }
        }

    }


}




