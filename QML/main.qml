import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import LoginSystem 1.0;
import RegistSystem 1.0;
import JavaMethod 1.0
import DataSystem 1.0
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
StackView{
    JavaMethod{
        id:myjava
    }
    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }
    property string str_userid;//ID
    //防止其他页面点击
    MouseArea{
        anchors.fill: parent
    }

    Component.onCompleted: {
        var str= loginsystem.getusername();//判断之前是否登录过，是则自动登录
        if(str!=="NO")
            loginsystem.login(str,loginsystem.getpassword());
        else{
            openrect.visible=false//取消显示等待页面
            indicator.visible=false
        }
    }

    //启动等待界面
    Rectangle{
        id:openrect
        color:"#02ae4a"
        anchors.fill: parent
        z:100
        Behavior on opacity {
            NumberAnimation{
                easing.type: Easing.InCubic
                duration: 1000
                onStopped: {
                    openrect.visible=false
                }
            }
        }
        Image{
            width:parent.width/2.5
            height:width
            opacity: parent.opacity
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:  parent.verticalCenter
            fillMode: Image.PreserveAspectFit
            source:"qrc:/image/icon.png"
        }

    }


    //等待界面
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



    id:stack;
    //初始大小
    height: 620
    width: 360
    initialItem: Rectangle{
        //主登录页面
        id:mainrect
        anchors.fill: parent
        Rectangle{
            id:toprect;
            width:parent.width;
            height: parent.height/16*5.5;
            color:"#02ae4a";
            anchors.top: parent.top;
            Image{
                //顶部应用图标
                id:icon
                width:parent.width/3
                height:width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter:  parent.verticalCenter
                fillMode: Image.PreserveAspectFit
                source:"qrc:/image/icon.png"
            }
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                verticalOffset: 2
                radius: 8
                color: "#55000000"
            }
        }

        //ID行
        Row{
            id:userrow
            anchors.top:toprect.bottom;
            anchors.topMargin: parent.height/16*1.5;
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/23;
            //width:parent.width/9*6;
            spacing: 40
            //用户图标
            Image{
                id:usericon;
                height: parent.height
                width: height
                fillMode: Image.PreserveAspectFit
                source:"qrc:/image/user.png"
            }
            //文本域
            TextField{
                height:parent.height
                width: mainrect.width/2
                id:usertext
                placeholderText:"请输入ID"
                validator:RegExpValidator{regExp:/^[0-9a-zA-Z]{1,20}$/}
                //Material.theme: Material.Dark
                //Material.accent: Material.Purple
                style: TextFieldStyle{
                    background: Rectangle{
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            radius: 8
                            color: "#55000000"
                        }
                    }
                }

            }
        }

        //密码行
        Row{
            id:passrow
            anchors.top:userrow.bottom
            anchors.topMargin: usericon.width
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/23;
            //width:parent.width/9*6;
            spacing: 40
            Image{
                id:passwordicon
                height: parent.height
                width: height
                fillMode: Image.PreserveAspectFit
                source:"qrc:/image/password.png"
            }
            TextField{
                height:parent.height
                width: mainrect.width/2
                id:passwordtext
                placeholderText:"请输入密码"
                echoMode:TextInput.Password
                validator:RegExpValidator{regExp:/^[0-9a-zA-Z]{1,20}$/}
                //Material.theme: Material.Dark
                //Material.accent: Material.Purple
                style: TextFieldStyle{
                    background: Rectangle{
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            radius: 8
                            color: "#55000000"
                        }
                    }
                }

            }
        }

        //登录按钮
        Rectangle{
            id:loginbutton
            width:height*2
            height:userrow.height*1.3
            anchors.right: userrow.right
            anchors.rightMargin: 40
            anchors.top: passrow.bottom
            anchors.topMargin: passrow.height
            color:loginma.pressed?"1589e8":"#02ae4a"
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: "#02ae4a"
            }
            Label{
                id:logintext
                text: "登录"
                color: "white"
                font{
                    family: localFont.name
                    pointSize: 14
                    
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
                    if(usertext.text.length<6||usertext.text.length>18){
                        myjava.toastMsg("ID由6~18个字符组成");
                        return;
                    }

                    if(passwordtext.text.length<8||passwordtext.text.length>16){
                        myjava.toastMsg("密码至少有8~16个字符")
                        return;
                    }
                    if(passwordtext.text.indexOf("|")>=0||usertext.text.indexOf("|")>=0||passwordtext.text.indexOf("@")>=0||usertext.text.indexOf("@")>=0){
                        myjava.toastMsg("非法字符")
                        return;
                    }
                    indicator.visible=true
                    loginsystem.login(usertext.text,passwordtext.text);
                }
            }
        }

        //注册按钮
        Rectangle{
            id:registbutton
            width:height*2
            height:userrow.height*1.3
            anchors.left: userrow.left
            anchors.leftMargin: 40
            anchors.top: passrow.bottom
            anchors.topMargin: passrow.height
            color:registma.pressed?"02ae4a":"#1589e8";
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                color: "#1589e8"
            }
            Label{
                id:registtext
                text: "注册"
                color: "white"
                font{
                    family: localFont.name
                    pointSize: 14
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
                    stack.push(registpage)//打开注册页面
                }
            }
        }

        LoginSystem{
            id:loginsystem;
            onStatueChanged:{
                if(Statue=="DBError")
                    myjava.toastMsg("服务器出错，请联系管理员")
                if(Statue=="WrongPassword")
                    myjava.toastMsg("密码错误")
                if(Statue=="NoUsers")
                    myjava.toastMsg("ID不存在")
                if(Statue=="Succeed"){
                    if(usertext.text!=""){
                        stack.str_userid=usertext.text
                        loginsystem.saveusernamepassword(usertext.text,passwordtext.text);//下次自动登录
                    }
                    else
                        stack.str_userid=loginsystem.getusername();



                    mainpage.source="qrc:/QML/MainWindow.qml";//加载首页
                    mainpage.x=0;
                    myjava.toastMsg("登录成功")
                }
                if(Statue=="SDCardError"){
                    messageDialog.open()
                }


                indicator.visible=false
            }
        }
        MessageDialog {
            id: messageDialog
            title: "提示"
            text: "程序无法访问SDCard，部分功能（如图片查看）缺失！"
            standardButtons: StandardButton.Ok

        }
    }

    //注册页面
    Component{
        id:registpage;
        Rectangle {
            id:mainrect
            property double dp:registtoprect.height/70
            //用于响应返回键
            Keys.enabled: true
            Keys.onBackPressed: {
                stack.pop();
            }
            focus:true
            Component.onCompleted: {
                forceActiveFocus();
            }

            //注册页面顶部栏
            Rectangle{
                id:registtoprect
                z:5
                Rectangle{
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height:myjava.getStatusBarHeight()
                    color:"green"
                }
                width:parent.width;
                height: parent.height/16*2;
                color:"#02ae4a";
                anchors.top: parent.top;
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 10
                    color: "#55000000"
                }
                Label{
                    text:"＜";
                    anchors.left: parent.left
                    anchors.leftMargin: 16*mainrect.dp

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
                    font{
                        family: localFont.name
                        
                        pixelSize: registtoprect.height/4
                        bold:true;
                    }
                    color: "white";
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stack.pop();//返回前一个页面
                        }
                    }
                }

                Label{
                    text:"新用户注册";
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset:myjava.getStatusBarHeight()/2
                    font{
                        family: localFont.name
                        pointSize: 20
                    }
                    color: "white";
                }
            }

            //id行
            Row{
                id:registidrow
                anchors.top:registtoprect.bottom
                anchors.topMargin: registtoprect.height/2.5

                height: parent.height/23;
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 16*mainrect.dp

                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    text:"ID：";
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: localFont.name
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
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true

                                radius: 8
                                color: "#55000000"
                            }
                        }
                    }
                    //Material.theme: Material.Dark
                    //Material.accent: Material.Purple
                    focus: true
                }
            }

            //密码行
            Row{
                id:registpassrow
                anchors.top:registidrow.bottom
                anchors.topMargin: registidrow.height

                anchors.right: registidrow.right

                height: parent.height/23;
                Label{
                    text:"密码：";
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: localFont.name
                        
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
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true

                                radius: 8
                                color: "#55000000"
                            }
                        }
                    }
                    //Material.theme: Material.Dark
                    //Material.accent: Material.Purple
                }
            }

            //确认密码
            Row{
                id:registcompassrow
                anchors.top:registpassrow.bottom
                anchors.topMargin: registpassrow.height
                anchors.right: registidrow.right
                height: parent.height/23;
                Label{
                    text:"确认密码：";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: localFont.name
                        
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
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true

                                radius: 8
                                color: "#55000000"
                            }
                        }
                    }
                    //Material.theme: Material.Dark
                    //Material.accent: Material.Purple
                }
            }

            //昵称行
            Row{
                id:registnamerow
                anchors.top:registcompassrow.bottom
                anchors.topMargin: registcompassrow.height
                anchors.right: registidrow.right
                height: parent.height/23;
                Label{
                    text:"昵称：";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: localFont.name
                        
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
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true

                                radius: 8
                                color: "#55000000"
                            }
                        }
                    }
                    //Material.theme: Material.Dark
                    //Material.accent: Material.Purple
                }
            }

            //性别行
            Row{
                id:sexrow
                anchors.top:registnamerow.bottom
                anchors.topMargin: registnamerow.height
                anchors.right: registidrow.right
                height: parent.height/23;
                Label{
                    text:"性别：";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: localFont.name
                        
                        pixelSize: registidrow.height/1.5
                    }
                    color: "grey";
                }

                Rectangle{
                    height:parent.height
                    width: registtoprect.width/3*1.7
                    id:sextext
                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true

                        radius: 8
                        color: "#55000000"
                    }
                    property string currentText: "男"
                    Text{
                        text: sextext.currentText+"  轻点切换"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color:"grey"
                        font{
                            family: localFont.name
                            
                            pixelSize: registidrow.height/1.5
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            sextext.currentText=="男"?sextext.currentText="女":sextext.currentText="男"
                        }
                    }

                }

            }


            //年龄行
            Row{
                id:agerow
                anchors.top:sexrow.bottom
                anchors.topMargin: sexrow.height
                anchors.right: registidrow.right
                height: parent.height/23;
                Label{
                    text:"年龄：";
                    width: registtoprect.width/4;
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignRight;
                    font{
                        family: localFont.name
                        
                        pixelSize: registidrow.height/1.5
                    }
                    color: "grey";
                }

                TextField{
                    height:parent.height
                    width: registtoprect.width/3*1.7
                    id:agetext

                    placeholderText:"请输入年龄"
                    validator:RegExpValidator{regExp:/^[0-9]{1,2}$/}
                    style: TextFieldStyle{
                        background: Rectangle{
                            layer.enabled: true
                            layer.effect: DropShadow {
                                transparentBorder: true

                                radius: 8
                                color: "#55000000"
                            }
                        }
                    }
                }
            }

            //协议行，自己实现一个checkbox
            //            Row{
            //                id:checkbox
            //                anchors.top:registnamerow.bottom
            //                anchors.topMargin: registnamerow.height
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                height: parent.height/23;
            //                width:parent.width/9*4;
            //                Rectangle{
            //                    property int checked:1
            //                    id:check
            //                    anchors.verticalCenter: parent.verticalCenter
            //                    anchors.left: checkbox.left
            //                    anchors.leftMargin: checkbox.height/2
            //                    height: parent.height/1.5
            //                    width: height
            //                    border.color: "grey"
            //                    border.width: 1
            //                    radius: height/4
            //                    color:"white"
            //                    Rectangle{
            //                        anchors.centerIn: parent
            //                        height: parent.height/1.5
            //                        width: height
            //                        color:check.checked?"#32dc96":"white"
            //                        radius: height/4
            //                    }
            //                    MouseArea{
            //                        anchors.fill: parent
            //                        onClicked: {
            //                            check.checked=check.checked?0:1;
            //                        }
            //                    }
            //                }
            //                Label{
            //                    text:"已阅读用户协议";
            //                    width: registtoprect.width/4;
            //                    anchors.verticalCenter: parent.verticalCenter
            //                    anchors.leftMargin: check.height/2
            //                    anchors.left: check.right
            //                    horizontalAlignment: Text.AlignLeft
            //                    font{
            //family: localFont.name
            //
            //                        pixelSize: registidrow.height/1.5
            //                    }
            //                    color: "grey";
            //                    MouseArea{
            //                        anchors.fill: parent
            //                        onClicked: {
            //                            stack.push(xieyipage);
            //                        }
            //                    }
            //                }
            //            }

            //注册
            Rectangle{
                id:registbutton
                width:parent.width/4
                height:agerow.height*1.5
                anchors.top: agerow.bottom
                anchors.topMargin: agerow.height
                anchors.horizontalCenter: parent.horizontalCenter
                color:registma.pressed?"32dc96":"#1589e8";
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    radius: 8
                    color: "#1589e8"
                }
                Label{
                    id:registtext
                    text: "注册"
                    color: "white"
                    font{
                        family: localFont.name
                        pointSize: 14
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
                        //                        if(check.checked==0){
                        //                            myjava.toastMsg("请阅读用户协议")
                        //                            return;
                        //                        }

                        if(registidtext.text.length<6||registidtext.text.length>18){
                            myjava.toastMsg("ID要由6~18位数字和字母组成")
                            return;
                        }

                        if(registpasstext.text.length<8||registpasstext.text.length>16){
                            myjava.toastMsg("密码要由8~16位数字和字母组成")
                            return;
                        }
                        if(registpasstext.text!=registcompasstext.text){
                            myjava.toastMsg("两次密码不一致")
                            return;
                        }
                        if(registnametext.text.indexOf("|||")>=0||registnametext.text==""||registnametext.text.indexOf("@")>=0||registnametext.text.indexOf(" ")>=0||registnametext.text.length>7||registnametext.text.indexOf(">")>=0||registnametext.text.indexOf("<")>=0||registnametext.text.indexOf("/")>=0||registnametext.text.indexOf("\\")>=0){
                            myjava.toastMsg("昵称不能为空或存在空格和特殊字符，且不得多于7个字符")
                            return;
                        }
                        if(registnametext.text.length>10){
                            myjava.toastMsg("昵称不能超过10个字符")
                            return;
                        }

                        if(registnametext.text==registpasstext.text){
                            myjava.toastMsg("ID不能与密码相同")
                            return;
                        }

                        if(registnametext.text.indexOf("$$")>=0||registpasstext.text.indexOf("$$")>=0||registidtext.text.indexOf("$$")>=0||registnametext.text.indexOf("|")>=0||registpasstext.text.indexOf("|")>=0||registidtext.text.indexOf("|")>=0||registnametext.text.indexOf("@")>=0||registpasstext.text.indexOf("@")>=0||registidtext.text.indexOf("@")>=0){
                            myjava.toastMsg("非法字符")
                            return;
                        }

                        registsystem.regist(registidtext.text,registpasstext.text,registnametext.text,sextext.currentText,agetext.text);
                    }
                }
            }

            //注册后自动登录
            LoginSystem{
                id:loginsystem;
                onStatueChanged:{
                    if(Statue=="Succeed"){
                        loginsystem.saveusernamepassword(registidtext.text,registpasstext.text);
                        stack.str_userid=registidtext.text
                        stack.pop();
                        mainpage.source="qrc:/QML/MainWindow.qml";
                        mainpage.x=0;
                        myjava.toastMsg("注册成功！")
                    }
                    if(Statue=="SDCardError"){
                        messageDialog1.open()
                    }


                    indicator.visible=false
                }

            }
            MessageDialog {
                id: messageDialog1
                title: "提示"
                text: "程序无法访问SDCard，部分功能（如图片查看）缺失！"
                standardButtons: StandardButton.Ok

            }

            //注册页面
            RegistSystem{
                id:registsystem
                onStatueChanged: {
                    if(Statue=="DBError")
                        myjava.toastMsg("服务器出错，请联系管理员")

                    if(Statue=="ExistUsers")
                        myjava.toastMsg("ID已存在")

                    if(Statue=="Succeed"){
                        indicator.visible=true
                        loginsystem.login(registidtext.text,registpasstext.text);
                    }
                }
            }
        }
    }

    //协议页面
    Component{
        id:xieyipage;
        Rectangle {
            id:mainrect
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
                    text:"用户协议";
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
                text:"  1、一切移动客户端用户在下载并浏览APP手机APP软件时均被视为已经仔细阅读本条款并完全同意。凡以任何方式登陆本APP，或直接、间接使用本APP资料者，均被视为自愿接受本网站相关声明和用户服务协议的约束。  \n 2、APP手机APP转载的内容并不代表APP手机APP之意见及观点，也不意味着本网赞同其观点或证实其内容的真实性。 \n  3、APP手机APP转载的文字、图片、音视频等资料均由本APP用户提供，其真实性、准确性和合法性由信息发布人负责。APP手机APP不提供任何保证，并不承担任何法律责任。 \n  4、APP手机APP所转载的文字、图片、音视频等资料，如果侵犯了第三方的知识产权或其他权利，责任由作者或转载者本人承担，本APP对此不承担责任。 \n 5、APP手机APP不保证为向用户提供便利而设置的外部链接的准确性和完整性，同时，对于该外部链接指向的不由APP手机APP实际控制的任何网页上的内容，APP手机APP不承担任何责任。  \n 6、用户明确并同意其使用APP手机APP网络服务所存在的风险将完全由其本人承担；因其使用APP手机APP网络服务而产生的一切后果也由其本人承担，APP手机APP对此不承担任何责任。 \n  7、除APP手机APP注明之服务条款外，其它因不当使用本APP而导致的任何意外、疏忽、合约毁坏、诽谤、版权或其他知识产权侵犯及其所造成的任何损失，APP手机APP概不负责，亦不承担任何法律责任。 \n  8、对于因不可抗力或因黑客攻击、通讯线路中断等APP手机APP不能控制的原因造成的网络服务中断或其他缺陷，导致用户不能正常使用APP手机APP，APP手机APP不承担任何责任，但将尽力减少因此给用户造成的损失或影响。 \n 9、本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。";
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

    //首页加载器
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
            item.setusername(stack.str_userid);
            item.forceActiveFocus();//用于返回键
            passwordtext.text=""//注销用
            usertext.text=""
            openrect.opacity=0;
        }
    }

}


