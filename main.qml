import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
import LoginSystem 1.0;
import RegistSystem 1.0;
import JavaMethod 1.0


StackView{
    JavaMethod{
        id:myjava
    }

    id:stack;
    height: 620
    width: 360
    initialItem: Rectangle{

        id:mainrect
        anchors.fill: parent

        Rectangle{
            id:toprect;
            width:parent.width;
            height: parent.height/16*5.5;
            color:"#32dc96";
            anchors.top: parent.top;

            Image{
                id:icon
                width:parent.width/3
                height:width

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter:  parent.verticalCenter


                fillMode: Image.PreserveAspectFit

                source:"http://www.icosky.com/icon/png/System/QuickPix%202007/Shamrock.png"
            }

        }



        Row{
            id:userrow
            anchors.top:toprect.bottom;
            anchors.topMargin: parent.height/16*1.5;
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/23;
            width:parent.width/9*6;
            Image{
                id:usericon;
                height: parent.height
                width: height
                fillMode: Image.PreserveAspectFit
                source:"http://119.29.15.43/project_image/usericon.png"
            }

            TextField{
                height:parent.height
                width: parent.width-usericon.width
                id:usertext
                placeholderText:"请输入用户名"
                validator:RegExpValidator{regExp:/^[0-9a-zA-Z]{1,20}$/}

                style: TextFieldStyle{
                    background: Rectangle{
                        radius: control.height/4
                        border.width: 1;
                        border.color: "grey"

                    }
                }
            }
        }

        Row{
            id:passrow
            anchors.top:userrow.bottom
            anchors.topMargin: usericon.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/23;
            width:parent.width/9*6;
            Image{
                id:passwordicon
                height: parent.height
                width: height
                fillMode: Image.PreserveAspectFit
                source:"http://119.29.15.43/project_image/passicon.png"
            }

            TextField{
                height:parent.height
                width: parent.width-usericon.width
                id:passwordtext
                placeholderText:"请输入密码"
                echoMode:TextInput.Password
                validator:RegExpValidator{regExp:/^[0-9a-zA-Z]{1,20}$/}
                style: TextFieldStyle{
                    background: Rectangle{
                        radius: control.height/4
                        border.width: 1;
                        border.color: "grey"
                    }
                }

            }
        }

        Rectangle{
            id:loginbutton
            width:icon.width/1.2
            height:userrow.height*1.5
            anchors.right: userrow.right
            anchors.top: passrow.bottom
            anchors.topMargin: passrow.height

            color:loginma.pressed?"33dd97":"#32dc96";

            radius: height/4
            Label{
                id:logintext
                text: "登录"
                color: "white"
                font{
                    pixelSize: loginbutton.height/2
                    family: "黑体"
                    bold: true;
                }
                anchors.centerIn: parent
            }
            Behavior on color{

                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            MouseArea{
                id:loginma
                anchors.fill: parent
                onClicked: {
                    //loginsystem.login("12341234","12341234");
                    if(usertext.text.length<6){
                        myjava.toastMsg("用户名至少有6个字符");
                        return;
                    }

                    if(passwordtext.text.length<8){
                        myjava.toastMsg("密码至少有8个字符")
                        return;
                    }
                    if(passwordtext.text.indexOf("|||")>=0||usertext.text.indexOf("|||")>=0){
                        myjava.toastMsg("非法字符")
                        return;
                    }

                    loginsystem.login(usertext.text,passwordtext.text);
                }
            }

        }



        Rectangle{
            id:registbutton
            width:icon.width/1.2
            height:userrow.height*1.5
            anchors.left: userrow.left
            anchors.top: passrow.bottom
            anchors.topMargin: passrow.height

            color:registma.pressed?"1084e5":"#1589e8";

            radius: height/4
            Label{
                id:registtext
                text: "注册"
                color: "white"
                font{
                    pixelSize: loginbutton.height/2
                    family: "黑体"
                    bold: true;
                }
                anchors.centerIn: parent
            }
            Behavior on color{

                ColorAnimation {
                    easing.type: Easing.Linear
                    duration: 200
                }
            }
            MouseArea{
                id:registma
                anchors.fill: parent
                onClicked: {
                    stack.push(registpage)
                }
            }

        }


        LoginSystem{
            id:loginsystem;
            onStatueChanged:{
                if(Statue=="DBError")
                    myjava.toastMsg("DBError")
                if(Statue=="WrongPassword")
                    myjava.toastMsg("WrongPassword")
                if(Statue=="NoUsers")
                    myjava.toastMsg("NoUsers")


                if(Statue=="Succeed"){
                    mainpage.source="MainWindow.qml";
                    mainpage.x=0;
                    myjava.toastMsg("登录成功！")
                }
            }
        }



    }


    Component{
        id:registpage;
        Rectangle {
            id:mainrect
            Rectangle{
                Label{
                    text:"  <";
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font{
                        family: "黑体"
                        pixelSize: registtoprect.height/1.5
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
                id:registtoprect;
                width:parent.width;
                height: parent.height/16*1.5;
                color:"#32dc96";
                anchors.top: parent.top;

                Label{
                    text:"新用户注册";
                    anchors.centerIn: parent
                    font{
                        family: "黑体"
                        pixelSize: registtoprect.height/3
                        bold:true
                    }
                    color: "white";
                }

            }

            Row{
                id:registidrow
                anchors.top:registtoprect.bottom
                anchors.topMargin: registtoprect.height

                height: parent.height/23;
                width:parent.width/9*6;
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text:"ID：";
                    width: registtoprect.width/4;
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: "黑体"
                        pixelSize: registidrow.height/1.5
                    }
                    color: "grey";

                }

                TextField{
                    height:parent.height
                    width: registtoprect.width/3*1.7
                    id:registidtext
                    placeholderText:"请输入ID"
                    validator:RegExpValidator{regExp:/^[0-9a-zA-Z]{1,20}$/}
                    style: TextFieldStyle{
                        background: Rectangle{
                            radius: control.height/4
                            border.width: 1;
                            border.color: "grey"
                        }
                    }

                }
            }

            Row{
                id:registpassrow
                anchors.top:registidrow.bottom
                anchors.topMargin: registidrow.height

                height: parent.height/23;
                width:parent.width/9*6;
                Label{
                    text:"密码：";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: "黑体"
                        pixelSize: registidrow.height/1.5
                    }
                    color: "grey";

                }

                TextField{
                    height:parent.height
                    width: registtoprect.width/3*1.7
                    id:registpasstext
                    placeholderText:"请输入密码"
                    echoMode:TextInput.Password
                    validator:RegExpValidator{regExp:/^[0-9a-zA-Z]{1,20}$/}
                    style: TextFieldStyle{
                        background: Rectangle{
                            radius: control.height/4
                            border.width: 1;
                            border.color: "grey"
                        }
                    }

                }
            }

            Row{
                id:registcompassrow
                anchors.top:registpassrow.bottom
                anchors.topMargin: registpassrow.height

                height: parent.height/23;
                width:parent.width/9*6;
                Label{
                    text:"确认密码：";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: "黑体"
                        pixelSize: registidrow.height/1.5
                    }
                    color: "grey";

                }

                TextField{
                    height:parent.height
                    width: registtoprect.width/3*1.7
                    id:registcompasstext
                    placeholderText:"请再次输入密码"
                    echoMode:TextInput.Password
                    validator:RegExpValidator{regExp:/^[0-9a-zA-Z]{1,20}$/}
                    style: TextFieldStyle{
                        background: Rectangle{
                            radius: control.height/4
                            border.width: 1;
                            border.color: "grey"
                        }
                    }

                }
            }

            Row{
                id:registnamerow
                anchors.top:registcompassrow.bottom
                anchors.topMargin: registcompassrow.height

                height: parent.height/23;
                width:parent.width/9*6;
                Label{
                    text:"昵称：";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: "黑体"
                        pixelSize: registidrow.height/1.5
                    }
                    color: "grey";

                }

                TextField{
                    height:parent.height
                    width: registtoprect.width/3*1.7
                    id:registnametext
                    placeholderText:"请输入昵称"
                    style: TextFieldStyle{
                        background: Rectangle{
                            radius: control.height/4
                            border.width: 1;
                            border.color: "grey"
                        }
                    }

                }
            }


            Row{
                id:checkbox
                anchors.top:registnamerow.bottom
                anchors.topMargin: registnamerow.height
                anchors.horizontalCenter: parent.horizontalCenter

                height: parent.height/23;
                width:parent.width/9*4;

                Rectangle{
                    property int checked:1
                    id:check
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: checkbox.left
                    anchors.leftMargin: checkbox.height/2
                    height: parent.height/1.5
                    width: height
                    border.color: "grey"
                    border.width: 1
                    radius: height/4
                    color:"white"

                    Rectangle{
                        anchors.centerIn: parent
                        height: parent.height/1.5
                        width: height
                        color:check.checked?"#32dc96":"white"
                        radius: height/4

                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            check.checked=check.checked?0:1;
                        }
                    }
                }

                Label{
                    text:"已阅读用户协议";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: check.height/2
                    anchors.left: check.right
                    horizontalAlignment: Text.AlignLeft
                    font{
                        family: "黑体"
                        pixelSize: registidrow.height/1.5
                    }
                    color: "grey";
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stack.push(xieyipage);
                        }
                    }
                }

            }


            Rectangle{
                id:registbutton
                width:parent.width/4
                height:checkbox.height*1.5
                anchors.top: checkbox.bottom
                anchors.topMargin: checkbox.height
                anchors.horizontalCenter: parent.horizontalCenter

                color:registma.pressed?"1084e5":"#1589e8";
                radius: height/4
                Label{
                    id:registtext
                    text: "注册"
                    color: "white"
                    font{
                        pixelSize: registbutton.height/2
                        family: "黑体"
                        bold: true;
                    }
                    anchors.centerIn: parent
                }
                Behavior on color{

                    ColorAnimation {
                        easing.type: Easing.Linear
                        duration: 200
                    }
                }
                MouseArea{
                    id:registma
                    anchors.fill: parent
                    onClicked: {
                        if(check.checked==0){
                            myjava.toastMsg("请阅读用户协议")
                            return;
                        }

                        if(registidtext.text.length<6){
                            myjava.toastMsg("用户名至少有6个字符")
                            return;
                        }
                        if(registpasstext.text.length<8){
                            myjava.toastMsg("密码至少有8个字符")
                            return;
                        }
                        if(registpasstext.text!=registcompasstext.text){
                            myjava.toastMsg("两次密码不一致")
                            return;
                        }
                        if(registnametext.text.indexOf(" ")>=0||registnametext.text==" "){
                            myjava.toastMsg("昵称不能为空或存在空格")
                            return;
                        }
                        if(registnametext.text.length>10){
                            myjava.toastMsg("昵称不能超过10个字符")
                            return;
                        }

                        if(registnametext.text==registpasstext.text){
                            myjava.toastMsg("用户名不能与密码相同")
                            return;
                        }

                        if(registnametext.text.indexOf("|||")>=0||registpasstext.text.indexOf("|||")>=0||registidtext.text.indexOf("|||")>=0){
                            myjava.toastMsg("非法字符")
                            return;
                        }

                        registsystem.regist(registidtext.text,registpasstext.text,registnametext.text);
                    }
                }
            }


            LoginSystem{
                id:loginsystem;
                onStatueChanged:{

                    if(Statue=="Succeed"){
                        mainpage.source="MainWindow.qml";
                        mainpage.x=0;
                        myjava.toastMsg("注册成功！")
                    }
                }
            }


            RegistSystem{
                id:registsystem
                onStatueChanged: {
                    if(Statue=="DBError")
                        myjava.toastMsg("DBError")

                    if(Statue=="ExistUsers")
                        myjava.toastMsg("ExistUsers")

                    if(Statue=="Succeed"){
                        loginsystem.login(registidtext.text,registpasstext.text);
                    }
                }
            }


        }
    }


    Component{
        id:xieyipage;
        Rectangle {
            id:mainrect
            Rectangle{
                id:xieyitoprect;
                width:parent.width;
                height: parent.height/16*1.5;
                color:"#32dc96";
                anchors.top: parent.top;
                Label{
                    text:"  <";
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    font{
                        family: "黑体"
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
                    text:"用户协议";
                    anchors.centerIn: parent
                    font{
                        family: "黑体"
                        pixelSize: xieyitoprect.height/3
                        bold:true
                    }
                    color: "white";
                }

            }
            Label{
                text:"  asdfasdfasdas阿斯顿和房间爱是否就暗示的恢复高考金山热噶富商大贾阿萨德法师打发士大夫阿萨德法师打发士大夫阿萨德法师打发士大夫毒霸v几哈asfasfasdf伴随刚好我爱USD吧v尽快哈巴v一u阿黑哥是对付你f";
                wrapMode: Text.Wrap;
                anchors.top: xieyitoprect.bottom
                anchors.topMargin: xieyitoprect.height*1.5
                anchors.fill: parent
                font{
                    family: "黑体"
                    pixelSize: xieyitoprect.height/3
                }
                color: "grey";
            }

        }
    }

    Loader{
        id:mainpage;
        height:parent.height
        width: parent.width
        x:parent.width
        z:10
        Behavior on x{
            NumberAnimation{
                easing.type: Easing.InCubic
                duration: 500
            }
        }
        onLoaded: {
            item.setusername(usertext.text);
        }
    }

}


