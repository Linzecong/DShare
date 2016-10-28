import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

import JavaMethod 1.0
import SendImageSystem 1.0
import DataSystem  1.0
import QtGraphicalEffects 1.0

StackView{
    property string imagePath:"Qt"
    property string str_userid;
    property string nickname;
    property string chooseimage:"Qt"
    property string headurl:""
    property double dp:head.height/70

    function setdata(id,name,hurl){
        str_userid=id
        nickname=name
        headurl=hurl

        forceActiveFocus();
    }
    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }
    JavaMethod{
        id:myjava
    }

    MouseArea{
        anchors.fill: parent
    }

    SendImageSystem{
        id:sendimgsystem1
        onStatueChanged:{


            if(Statue=="DBError"){
                myjava.toastMsg("远程服务器出错，请联系开发者！");
            }

            if(Statue=="Error"){
                myjava.toastMsg("照片有误！！");
            }

            if(Statue=="Wait"){
                myjava.toastMsg("服务器繁忙，请重试...");
            }

            if(Statue=="Succeed"){
                myjava.toastMsg("修改成功！");
            }

        }
    }

    Rectangle {
        id:pickhead
        color: "black"

        onWidthChanged: mask.recalc();
        onHeightChanged: mask.recalc();

        visible: false
        anchors.fill: parent
        z:1000
        Image {
            id: source;
            anchors.fill: parent;
            fillMode: Image.PreserveAspectFit;
            visible: false;
            asynchronous: true;
            onStatusChanged: {
                if(status == Image.Ready){
                    console.log("image loaded")
                    mask.recalc();
                }
            }
        }

        Keys.enabled: true
        Keys.onBackPressed: {
            mask.px=0
            mask.py=0
            mask.r=1
            pickhead.visible=false
            stack.currentItem.forceActiveFocus()

        }

        Canvas {
            id: forSaveCanvas;
            width: 256;
            height: 256;
            contextType: "2d";
            visible: false;
            z: 2;
            anchors.top: parent.top;
            anchors.right: parent.right;
            anchors.margins: 4;

            property var imageData: null;
            onPaint: {
                if(imageData != null){
                    context.drawImage(imageData, 0, 0);
                }
            }

            function setImageData(data){
                imageData = data;
                requestPaint();
            }


        }

        Canvas {
            id: mask;
            anchors.fill: parent;
            z: 1;
            property real w: width;
            property real h: height;
            property real dx: 0;
            property real dy: 0;
            property real dw: 0;
            property real dh: 0;
            property real frameX: 130;
            property real frameY: 130;

            property real px: 0;
            property real py: 0;
            property real r: 1;



            function calc(){
                var sw = source.sourceSize.width;
                var sh = source.sourceSize.height;
                if(sw > 0 && sh > 0){
                    if(sw <= w && sh <=h){
                        dw = sw;
                        dh = sh;
                    }else{
                        var sRatio = sw / sh;
                        dw = sRatio * h;
                        if(dw > w){
                            dh = w / sRatio;
                            dw = w;
                        }else{
                            dh = h;
                        }
                    }
                    dx = (w - dw)/2;
                    dy = (h - dh)/2;
                }
            }

            function recalc(){
                calc();
                requestPaint();
            }

            function getImageData(){
                return context.getImageData(frameX - 128, frameY - 128,
                                            256, 256);
            }

            onPaint: {
                var ctx = getContext("2d");

                ctx.clearRect(0, 0, width, height);
                ctx.drawImage(source, dx+px, dy+py, dw*r, dh*r);
                var xStart = frameX - 130;
                var yStart = frameY - 130;
                ctx.save();
                ctx.fillStyle = "#a0000000";
                ctx.fillRect(0, 0, w, yStart);
                var yOffset = yStart + 260;
                ctx.fillRect(0, yOffset, w, h - yOffset);
                ctx.fillRect(0, yStart, xStart, 260);
                var xOffset = xStart + 260;
                ctx.fillRect(xOffset, yStart, w - xOffset, 260);

                //see through area
                ctx.strokeStyle = "red";
                ctx.fillStyle = "#00000000";
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.rect(xStart, yStart, 260, 260);
                ctx.fill();
                ctx.stroke();
                ctx.closePath ();
                ctx.restore();
            }
        }

        MultiPointTouchArea {
            anchors.fill: parent;
            minimumTouchPoints: 1;
            maximumTouchPoints: 1;
            touchPoints:[
                TouchPoint{
                    id: point1;
                }
            ]

            onUpdated: {
                mask.frameX = point1.x;
                mask.frameY = point1.y;
                mask.requestPaint();
            }
            onReleased: {
                forSaveCanvas.setImageData(mask.getImageData());
                actionPanel.visible = true;
            }
            onPressed: {
                actionPanel.visible = false;
            }
        }



        Item {
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.bottom: parent.bottom;
            height: parent.height/5
            width: parent.width
            id: actionPanel;
            z: 5;

            Rectangle{
                id:upbutton
                width:parent.width/6
                height:parent.height/4
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.top: parent.top
                color:"#bbbbbb"
                opacity: 0.5

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }

                Label{
                    text: "上移"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mask.py-=50
                        mask.recalc()
                    }
                }
            }

            Rectangle{
                id:savebutton
                width:parent.width/6
                height:parent.height/4
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.top: upbutton.bottom
                anchors.topMargin: height/4
                color:"#bbbbbb"
                opacity: 0.7
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }
                Label{
                    text: "保存"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {

                        var path=myjava.getSDCardPath();

                        path=path+"/DShare/headtemp.png";


                        forSaveCanvas.save(path);


                        //headimage.source="file://"+path;
                        headurl="file://"+path;

                        //                        if(headimage.status==Image.Error){
                        //                            myjava.toastMsg("照片有误！");
                        //                            return
                        //                        }

                        imagePath=path;
                        sendimgsystem1.sendHead(imagePath,str_userid);
                        myjava.toastMsg("正在上传...");



                        pickhead.visible = false;
                    }
                }
            }

            Rectangle{
                id:downbutton
                width:parent.width/6
                height:parent.height/4
                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.top: savebutton.bottom
                anchors.topMargin: height/4
                color:"#bbbbbb"
                opacity: 0.5

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }

                Label{
                    text: "下移"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mask.py+=50
                        mask.recalc()
                    }
                }
            }

            Rectangle{
                id:leftbutton
                width:parent.width/6
                height:parent.height/4
                anchors.right: savebutton.left
                anchors.rightMargin: width/4
                anchors.top: savebutton.top
                color:"#bbbbbb"
                opacity: 0.5
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }
                Label{
                    text: "左移"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mask.px-=50
                        mask.recalc()
                    }
                }
            }

            Rectangle{
                id:rightbutton
                width:parent.width/6
                height:parent.height/4
                anchors.left: savebutton.right
                anchors.leftMargin: width/4
                anchors.top: savebutton.top
                color:"#bbbbbb"
                opacity: 0.5
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }
                Label{
                    text: "右移"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mask.px+=50
                        mask.recalc()
                    }
                }
            }

            Rectangle{
                id:smallbutton
                width:parent.width/6
                height:parent.height/4
                anchors.left: rightbutton.right
                anchors.leftMargin: width/4
                anchors.top: savebutton.top
                color:"#bbbbbb"
                opacity: 0.7
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }
                Label{
                    text: "缩小"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mask.r/=1.1
                        mask.recalc()
                    }
                }
            }

            Rectangle{
                id:bigbutton
                width:parent.width/6
                height:parent.height/4
                anchors.right: leftbutton.left
                anchors.rightMargin: width/4
                anchors.top: savebutton.top
                color:"#bbbbbb"
                opacity: 0.7
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }

                Label{
                    text: "放大"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mask.r*=1.1
                        mask.recalc()
                    }
                }
            }



            Rectangle{
                id:cancelbutton
                width:parent.width/6
                height:parent.height/4
                anchors.right: smallbutton.right

                anchors.top: smallbutton.bottom
                anchors.topMargin: height/4
                color:"#bbbbbb"
                opacity: 0.7
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }
                Label{
                    text: "取消"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mask.px=0
                        mask.py=0
                        mask.r=1
                        pickhead.visible=false
                        stack.currentItem.forceActiveFocus()
                    }
                }
            }

            Rectangle{
                id:okbutton

                height:parent.height/4
                anchors.right: leftbutton.right

                anchors.left: bigbutton.left
                anchors.topMargin: height/4

                color:"#bbbbbb"
                opacity: 0.7
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#55000000"
                }
                Label{
                    text: "直接应用整张图片"
                    color: "white"
                    font{
                        family: localFont.name
                        pixelSize: parent.height/2
                        
                    }
                    anchors.centerIn: parent
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        //headimage.source=source.source;
                        headurl=source.source


                        //                        if(headimage.status==Image.Error){
                        //                            myjava.toastMsg("照片有误！");
                        //                            return
                        //                        }

                        imagePath=chooseimage;
                        sendimgsystem1.sendHead(imagePath,str_userid);
                        myjava.toastMsg("正在上传...");



                        pickhead.visible = false;
                    }
                }
            }



        }
    }

    Keys.enabled: true
    Keys.onBackPressed: {
        stack.parent.visible=false
        stack.parent.setname();
        stack.parent.parent.forceActiveFocus();
    }


    id:stack;
    anchors.fill: parent

    initialItem: Rectangle{

        id:mainrect
        anchors.fill: parent



        Rectangle{
            Rectangle{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height:myjava.getStatusBarHeight()
                color:"green"
            }
            id:head
            z:5
            width:parent.width;
            height: parent.height/16*2
            color:"#02ae4a"
            anchors.top: parent.top;
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 10
                color: "#55000000"
            }
            Label{
                id:backbutton
                text:" ＜";
                height: parent.height
                width:height
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2

                verticalAlignment: Text.AlignVCenter
                font{
                        family: localFont.name
                    
                    pixelSize: (head.height)/4
                }
                color: "white";
                MouseArea{
                    id:headma
                    anchors.fill: parent
                    onClicked: {
                        stack.parent.visible=false
                        stack.parent.setname();
                    }
                }
            }



            Label{
                text:"设置";
                anchors.centerIn: parent
                anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
                font{
                        family: localFont.name
                    //family: "微软雅黑"
                    pointSize: 20

                }
                color: "white";
            }

        }

        Rectangle{
            id:changedata
            anchors.top: head.bottom
            anchors.topMargin: 20*dp

            height: changedatatitle1.height+40*dp
            width: parent.width

            color: "white"
            border.width: 1;
            border.color: "grey"
            Label{
                id:changedatatitle1
                text: "修改资料"
                anchors.left: parent.left
                anchors.leftMargin: 10*dp
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                font{
                        family: localFont.name
                    
                    pointSize: 16

                }
                color:"grey"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    stack.push(changedatapage)
                }
            }
        }

        //        Rectangle{
        //            id:help
        //            anchors.top: changedata.bottom
        //            anchors.topMargin: head.height/2
        //            height: head.height
        //            width: parent.width
        //            color: "white"
        //            border.width: 1;
        //            border.color: "grey"
        //            Label{
        //                text: "使用帮助"
        //                anchors.left: parent.left
        //                anchors.leftMargin: 20
        //                anchors.verticalCenter: parent.verticalCenter
        //                verticalAlignment: Text.AlignVCenter
        //                font{
                        //family: localFont.name
        //
        //                    pixelSize: head.height/3

        //                }
        //                color:"grey"
        //            }
        //            MouseArea{
        //                anchors.fill: parent
        //                onClicked: {
        //                    stack.push(helppage)
        //                }
        //            }
        //        }



    }


    Component{
        id:changedatapage;
        Rectangle {
            id:mainrect

            Component.onCompleted: {
                forceActiveFocus();
            }

            Keys.enabled: true
            Keys.onBackPressed: {
                stack.pop()

            }

            Rectangle{
                Rectangle{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height:myjava.getStatusBarHeight()
                    color:"green"
                }
                id:changedatahead;
                z:5
                width:parent.width;
                height: parent.height/16*2
                color:"#02ae4a"
                anchors.top: parent.top;

                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 10
                    color: "#55000000"
                }

                Label{
                    text:" ＜";
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
                    verticalAlignment: Text.AlignVCenter
                    font{
                        family: localFont.name
                        
                        pixelSize: (head.height)/4
                    }
                    color: "white";
                    MouseArea{
                        id:headma1
                        anchors.fill: parent
                        onClicked: {
                            stack.pop();
                        }
                    }
                }

                Label{
                    text:"修改资料";
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
                    font{
                        family: localFont.name
                        //family: "微软雅黑"
                        pointSize: 20

                    }
                    color: "white";
                }

            }

            Rectangle{
                id:changehead
                anchors.top: changedatahead.bottom
                anchors.topMargin: 20*dp
                height: changeheadtitle.height+40*dp

                width: parent.width
                color: "white"
                border.width: 1;
                border.color: "grey"
                Label{
                    id:changeheadtitle
                    text: "修改头像"
                    anchors.left: parent.left
                    anchors.leftMargin: 10*dp

                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font{
                        family: localFont.name
                        
                        pointSize: 16

                    }
                    color:"grey"
                }

                Image{
                    id:headimage
                    anchors.right: parent.right
                    anchors.rightMargin: 8*dp
                    height: parent.height-16*dp
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    source: headurl
                    fillMode: Image.PreserveAspectFit
                    Label{
                        anchors.centerIn: parent
                        visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                        text:(parent.status==Image.Loading)?"加载中":"无"
                        color:"grey"
                    }
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
                    repeat: true
                    onTriggered: {
                        var temp=myjava.getImagePath();
                        if(temp!=="Qt"){
                            timer.stop();
                            chooseimage=temp
                            var url="file://"+temp;
                            source.source=url
                            mask.recalc()
                            myjava.toastMsg("移动红框选取头像")
                            pickhead.visible=true
                            pickhead.forceActiveFocus()
                        }
                    }
                }

            }

            Rectangle{
                id:changename
                anchors.top: changehead.bottom
                anchors.topMargin: 16*dp
                height: changenametext.height+40*dp

                width: parent.width
                color: "white"
                border.width: 1;
                border.color: "grey"
                Label{
                    id:changenametext
                    text: "修改昵称"
                    anchors.left: parent.left
                    anchors.leftMargin: 10*dp

                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font{
                        family: localFont.name
                        
                        pointSize: 16

                    }
                    color:"grey"


                    DataSystem{
                        id:dbsystem;
                        onStatueChanged: {

                            if(Statue=="changenameSucceed"){
                                dbsystem.getNameByID(str_userid);
                                myjava.toastMsg("修改成功！")
                            }

                            if(Statue=="getnameSucceed"){

                                nickname=dbsystem.getName();
                            }

                        }
                    }

                }

                TextField{
                    height:changenametext.height*1.5
                    width: parent.width/3
                    anchors.left: changenametext.right
                    anchors.leftMargin: 16*dp
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    id:changenameedit
                    text:nickname
                    style: TextFieldStyle{
                        textColor: "grey"
                        background: Rectangle{
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true
                                radius: 8
                                color: "#55000000"
                            }
                        }
                    }

                    z:2

                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(changenameedit.visible==false){
                            changenameedit.visible=true
                            changenametext.text="点我确认"
                        }
                        else{

                            if(changenameedit.text.indexOf("|||")>=0||changenameedit.text==""||changenameedit.text.indexOf("@")>=0||changenameedit.text.indexOf(" ")>=0||changenameedit.text.length>7||changenameedit.text.indexOf(">")>=0||changenameedit.text.indexOf("<")>=0||changenameedit.text.indexOf("/")>=0||changenameedit.text.indexOf("\\")>=0)
                                myjava.toastMsg("非法字符，不能存在空格或特殊字符，且不得多于7个字符")
                            else{
                                if(nickname!==changenameedit.text)
                                    dbsystem.changeName(str_userid,changenameedit.text)
                                changenameedit.visible=false
                                changenametext.text="修改昵称"

                            }
                        }
                    }
                }





            }
        }
    }


    Component{
        id:helppage;
        Rectangle {
            id:mainrect
            Component.onCompleted: {
                forceActiveFocus();
            }

            Keys.enabled: true
            Keys.onBackPressed: {
                stack.pop()

            }
            Rectangle{
                id:xieyitoprect;
                width:parent.width;
                height: parent.height/16*1.5;
                color:"#02ae4a";
                anchors.top: parent.top;
                Label{
                    text:"  <";
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font{
                        family: localFont.name
                        
                        pixelSize: xieyitoprect.height/1.5
                        bold:true;
                    }
                    color: "white";
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stack.pop();
                        }
                    }
                }

                Label{
                    text:"使用帮助";
                    anchors.centerIn: parent
                    font{
                        family: localFont.name
                        
                        pixelSize: xieyitoprect.height/3
                        bold:true
                    }
                    color: "white";
                }

            }
            Label{
                text:"  暂无内容";
                wrapMode: Text.Wrap;
                anchors.top: xieyitoprect.bottom
                anchors.topMargin: xieyitoprect.height*1.5
                anchors.fill: parent
                font{
                        family: localFont.name
                    
                    pixelSize: xieyitoprect.height/3
                }
                color: "grey";
            }

        }
    }




}

