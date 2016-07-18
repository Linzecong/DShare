import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

import JavaMethod 1.0
import SendImageSystem 1.0
import DataSystem  1.0

StackView{
    property string imagePath:"Qt"
    property string str_userid;
    property string nickname;

    function setdata(id,name){
        str_userid=id
        nickname=name
        forceActiveFocus();
    }

    JavaMethod{
        id:myjava
    }

    MouseArea{
        anchors.fill: parent
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
            id:headrect
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
                    pixelSize: headrect.height/1.5
                    bold:true;
                }
                color: "white";
                MouseArea{
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
                font{
                    family: "黑体"
                    pixelSize: headrect.height/3

                }
                color: "white";
            }

        }

        Rectangle{
            id:changedata
            anchors.top: headrect.bottom
            anchors.topMargin: headrect.height/2
            height: headrect.height
            width: parent.width
            color: "white"
            border.width: 1;
            border.color: "grey"
            Label{
                text: "修改资料"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                font{
                    family: "黑体"
                    pixelSize: headrect.height/3

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

        Rectangle{
            id:help
            anchors.top: changedata.bottom
            anchors.topMargin: headrect.height/2
            height: headrect.height
            width: parent.width
            color: "white"
            border.width: 1;
            border.color: "grey"
            Label{
                text: "使用帮助"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                verticalAlignment: Text.AlignVCenter
                font{
                    family: "黑体"
                    pixelSize: headrect.height/3

                }
                color:"grey"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    stack.push(helppage)
                }
            }
        }



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
                id:changedatahead;
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
                        pixelSize: headrect.height/1.5
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
                    text:"修改资料";
                    anchors.centerIn: parent
                    font{
                        family: "黑体"
                        pixelSize: headrect.height/3

                    }
                    color: "white";
                }

            }

            Rectangle{
                id:changehead
                anchors.top: changedatahead.bottom
                anchors.topMargin: headrect.height/2
                height: headrect.height*2
                width: parent.width
                color: "white"
                border.width: 1;
                border.color: "grey"
                Label{
                    text: "修改头像"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font{
                        family: "黑体"
                        pixelSize: headrect.height/3

                    }
                    color:"grey"
                }

                Image{
                    id:headimage
                    anchors.right: parent.right
                    anchors.rightMargin: 50
                    height: parent.height-50
                    width: height
                    anchors.verticalCenter: parent.verticalCenter
                    source: "http://119.29.15.43/userhead/"+str_userid+".jpg"
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

                SendImageSystem{
                    id:sendimgsystem1

                }

                Timer{
                    id:timer;
                    interval: 1500
                    onTriggered: {
                        var temp=myjava.getImagePath();
                        if(temp!=="Qt"){
                            timer.stop();
                            headimage.source="file://"+temp;
                            imagePath=temp;
                            sendimgsystem1.sendHead(imagePath,str_userid);
                            myjava.toastMsg("修改成功！重启后生效！");

                        }
                    }
                }

            }

            Rectangle{
                id:changename
                anchors.top: changehead.bottom
                anchors.topMargin: headrect.height/2
                height: headrect.height*2
                width: parent.width
                color: "white"
                border.width: 1;
                border.color: "grey"
                Label{
                    id:changenametext
                    text: "修改昵称"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    verticalAlignment: Text.AlignVCenter
                    font{
                        family: "黑体"
                        pixelSize: headrect.height/3

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
                    height:changenametext.height*2
                    width: parent.width/3
                    anchors.left: changenametext.right
                    anchors.leftMargin: 50
                    anchors.verticalCenter: parent.verticalCenter
                    visible: false
                    id:changenameedit
                    text:nickname
                    style: TextFieldStyle{
                        background: Rectangle{
                            radius: control.height/4
                            border.width: 1;
                            border.color: "grey"
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

                            if(changenameedit.text.indexOf("|||")>=0||changenameedit.text==""||changenameedit.text.indexOf("@")>=0||changenameedit.text.indexOf(" ")>=0||changenameedit.text.length>7)
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
                    text:"使用帮助";
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
                text:"  暂无内容";
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




}

