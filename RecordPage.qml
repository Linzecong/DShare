import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import PostsSystem 1.0
import JavaMethod 1.0
import RecordSystem 1.0
import DataSystem 1.0

Rectangle {
    color:"white"
    anchors.fill: parent
    id:mainrect
    function getcheckinday(){
          dbsystem.getcheckinday(str_userid);
    }

    DataSystem{
        id:dbsystem;
        onStatueChanged: {
            console.log(Statue)
            if(Statue=="getcheckindaySucceed")
                dosportdaysrect.checkinday=dbsystem.getcheckinday();

            if(Statue=="checkinSucceed")
                dosportdaysrect.checkinday++;

        }
    }

    property string str_userid
    Rectangle{
        id: bigphotorect
        height: parent.height*1.3
        width: parent.width
        x:0
        y:-parent.height/8
        visible: false
        color: "black"
        z:100
        Image {
            id: bigphoto
            fillMode: Image.PreserveAspectFit
            height: parent.height
            width: parent.width
        }
        MouseArea{
            anchors.fill: parent
            onPressed: {

                drag.target=bigphoto
            }
            onClicked: {
                bigphoto.x=0
                bigphoto.y=0
                bigphoto.height=bigphoto.parent.height
                bigphoto.width=bigphoto.parent.width
                bigphotorect.visible=false
            }

        }
        Rectangle{
            id:zoomin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height/12
            anchors.left: parent.left
            anchors.leftMargin: parent.width/4
            height: parent.height/10
            width: height
            radius: height/2
            color: "red"
            Text{
                anchors.centerIn: parent
                text:"放大"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bigphoto.height*=1.2
                    bigphoto.width*=1.2
                }
            }
        }

        Rectangle{
            id:zoomout
            anchors.bottom: zoomin.bottom
            anchors.right: parent.right
            anchors.rightMargin: parent.width/4
            height: parent.height/10
            width: height
            radius: height/2
            color: "blue"
            Text{
                anchors.centerIn: parent
                text:"缩小"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    bigphoto.height*=0.8
                    bigphoto.width*=0.8
                }
            }
        }

    }

    JavaMethod{
        id:myjava
    }


    RecordSystem{
        id:recordsystem
        onStatueChanged: {
            if(Statue==="uploadexerciseSucceed"){
                myjava.toastMsg("保存成功")
            }

            if(Statue==="uploadexerciseDBError"){
                myjava.toastMsg("保存失败")
            }

            if(Statue==="uploaddietSucceed"){
                myjava.toastMsg("保存成功")
            }

            if(Statue==="uploaddietDBError"){
                myjava.toastMsg("保存失败")
            }


            if(Statue==="getdietsSucceed"){
                foodtablerect.breakfaststr=recordsystem.getdietstr(0);
                foodtablerect.lunchstr=recordsystem.getdietstr(1);
                foodtablerect.dinnerstr=recordsystem.getdietstr(2);
                foodtablerect.snackstr=recordsystem.getdietstr(3);
                foodtablerect.dessertstr=recordsystem.getdietstr(4);
                foodtablerect.othersstr=recordsystem.getdietstr(5);
                recordsystem.getexercise(str_userid,timechoosertext.text);
            }
            if(Statue==="getdietsDBError"){
                foodtablerect.breakfaststr="暂无数据";
                foodtablerect.lunchstr="暂无数据";
                foodtablerect.dinnerstr="暂无数据";
                foodtablerect.snackstr="暂无数据";
                foodtablerect.dessertstr="暂无数据";
                foodtablerect.othersstr="暂无数据";
                recordsystem.getexercise(str_userid,timechoosertext.text);
            }

            if(Statue==="getexercisesSucceed"){
                sporttabelmodel.clear()
                var i=0
                while(recordsystem.getexercisetype(i)!==""){
                    sporttabelmodel.append({
                                               "Type":recordsystem.getexercisetype(i),
                                               "BeginTime":recordsystem.getexercisebegintime(i),
                                               "LastTime":recordsystem.getexerciselasttime(i),
                                           }
                                           );
                    i++
                }
                if(i==0){
                    sporttabelmodel.append({
                                               "Type":"暂无数据",
                                               "BeginTime":"暂无数据",
                                               "LastTime":"暂无数据",
                                           })
                }
            }
        }
    }

    Rectangle {
        id: header
        anchors.top: parent.top
        width: parent.width
        height: parent.height/12
        property string currentpage: "饮食"

        Label{
            id:foodbutton
            text: "饮食"
            color:header.currentpage==text?"#32dc96":"grey"
            font{
                family: "黑体"
                pixelSize: header.height/2
            }
            anchors.left: parent.left
            anchors.leftMargin: parent.width/10
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    header.currentpage="饮食"
                }
            }
        }

        Label{
            id:sportbutton
            text: "运动"
            color:header.currentpage==text?"#32dc96":"grey"
            font{
                family: "黑体"
                pixelSize: header.height/2
            }
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    header.currentpage="运动"
                }
            }
        }

        Label{
            id:searchbutton
            text: "查看"
            color:header.currentpage==text?"#32dc96":"grey"
            font{
                family: "黑体"
                pixelSize: header.height/2
            }
            anchors.right: parent.right
            anchors.rightMargin: parent.width/10
            anchors.verticalCenter: parent.verticalCenter
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    header.currentpage="查看"
                }
            }
        }
    }


    Rectangle{
        id:sportview
        visible: header.currentpage=="运动"?true:false
        height: parent.height-header.height
        width:parent.width
        anchors.top: header.bottom
        color:"white"

        Row{
            id:typerow
            anchors.top: parent.top
            anchors.topMargin: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/15
            width: parent.width/1.5
            spacing: typetext.width/2
            Text{
                id:typetext
                text:"项目"
                color:"grey"
                anchors.verticalCenter: parent.verticalCenter
                font{
                    family: "黑体"
                    pixelSize: header.height/2
                }
            }

            Rectangle{
                id:sporttype
                border.color: "grey"
                border.width: 2
                radius: height/4
                color:"white"
                height: parent.height
                width: parent.width-typetext.width
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id:sporttext
                    anchors.centerIn: parent
                    text:"新建项目"
                    color:"grey"
                    font{
                        family: "黑体"
                        pixelSize: parent.height/1.5
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        view.model=sportsmodel
                        searpage.visible=true
                    }
                }
            }
        }


        Row{
            id:begintimerow
            anchors.top: typerow.bottom
            anchors.topMargin: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            height: typerow.height
            width: parent.width/1.2
            spacing: begintimetext.width/10
            property int editmode: 0
            property string begintime
            onBegintimeChanged: {
                myjava.toastMsg(begintime)
            }

            Text{
                id:begintimetext
                text:"开始时间"
                anchors.verticalCenter: parent.verticalCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: header.height/2
                }
            }

            Rectangle{
                id:begintimehour
                border.color: "grey"
                border.width: begintimerow.editmode?2:0
                radius: height/4
                color:"white"
                height: parent.height
                width: begintimerow.width/4
                Text {
                    id:begintimehourtext
                    anchors.centerIn: parent
                    text:"0"
                    color:"grey"
                    font{
                        family: "黑体"
                        pixelSize: parent.height/1.5
                    }
                    onTextChanged: {
                        begintimerow.begintime=begintimehourtext.text+":"+begintimemintext.text+":"+"00";

                    }
                }
                MouseArea{
                    anchors.fill: parent
                    visible: begintimerow.editmode?true:false
                    onClicked: {
                        view.model=beginhourmodel
                        searpage.visible=true
                    }
                }
            }

            Text{
                text:"时"
                anchors.verticalCenter: parent.verticalCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: header.height/2
                }
            }

            Rectangle{
                id:begintimemin
                border.color: "grey"
                border.width: begintimerow.editmode?2:0
                radius: height/4
                color:"white"
                height: parent.height
                width:begintimerow.width/4
                Text {
                    id:begintimemintext
                    anchors.centerIn: parent
                    text:"0"
                    color:"grey"
                    font{
                        family: "黑体"
                        pixelSize: parent.height/1.5
                    }
                    onTextChanged: {
                        begintimerow.begintime=begintimehourtext.text+":"+begintimemintext.text+":"+"00";
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    visible: begintimerow.editmode?true:false
                    onClicked: {
                        view.model=beginminmodel
                        searpage.visible=true
                    }
                }
            }

            Text{
                text:"分"
                anchors.verticalCenter: parent.verticalCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: header.height/2
                }
            }
        }
        Row{
            id:lasttimerow
            anchors.top: begintimerow.bottom
            anchors.topMargin: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            height: typerow.height
            width: parent.width/1.2
            spacing: begintimetext.width/10
            property int lasttime;
            Text{
                id:lasttimetext
                text:"持续时间"
                anchors.verticalCenter: parent.verticalCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: header.height/2
                }
            }

            Rectangle{
                id:lasttimehour
                border.color: "grey"
                border.width: begintimerow.editmode?2:0
                radius: height/4
                color:"white"
                height: parent.height
                width: lasttimerow.width/4
                Text {
                    id:lasttimehourtext
                    anchors.centerIn: parent
                    text:"0"
                    color:"grey"
                    font{
                        family: "黑体"
                        pixelSize: parent.height/1.5
                    }
                    onTextChanged: {
                        lasttimerow.lasttime=parseInt(lasttimehourtext.text)*60+parseInt(lasttimemintext.text);
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    visible: begintimerow.editmode?true:false
                    onClicked: {
                        view.model=lasthourmodel
                        searpage.visible=true
                    }
                }
            }

            Text{
                text:"时"
                verticalAlignment: Text.AlignVCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: header.height/2
                }
            }

            Rectangle{
                id:lasttimemin
                border.color: "grey"
                border.width: begintimerow.editmode?2:0
                radius: height/4
                color:"white"
                height: parent.height
                width:lasttimerow.width/4
                Text {
                    id:lasttimemintext
                    anchors.centerIn: parent
                    text:"0"
                    color:"grey"
                    font{
                        family: "黑体"
                        pixelSize: parent.height/1.5
                    }
                    onTextChanged: {
                        lasttimerow.lasttime=parseInt(lasttimehourtext.text)*60+parseInt(lasttimemintext.text);
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    visible: begintimerow.editmode?true:false
                    onClicked: {
                        view.model=lastminmodel
                        searpage.visible=true
                    }
                }
            }

            Text{
                text:"分"
                anchors.verticalCenter: parent.verticalCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: header.height/2
                }
            }
        }

        Row{
            id:buttonrow
            anchors.top: lasttimerow.bottom
            anchors.topMargin: parent.height/15
            //anchors.left: parent.left
            //anchors.leftMargin: mainrect.height/50
            anchors.horizontalCenter: sportview.horizontalCenter
            height: typerow.height
            width: parent.width/1.2
            spacing: modebutton.width/6
            Rectangle{
                id:modebutton
                height: parent.height*1.2
                width: modebuttontext.width*1.2
                color: "#32dc96"
                radius: height/4
                border.width: 1
                border.color: "grey"
                Text{
                    id:modebuttontext
                    text:"编辑模式"
                    color:"white"
                    anchors.centerIn: parent
                    font{
                        family: "黑体"
                        pixelSize: header.height/2
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(begintimerow.editmode==0){
                            begintimerow.editmode=1
                            modebuttontext.text="计时模式"
                        }
                        else{
                            begintimerow.editmode=0
                            modebuttontext.text="编辑模式"
                        }
                    }
                }
            }

            Rectangle{
                id:sportsavebutton
                height: parent.height*1.2
                width: sportsavebuttontext.width*1.5
                color: "#32dc96"
                radius: height/4
                border.width: 1
                border.color: "grey"
                Text{
                    id:sportsavebuttontext
                    text:"保存"
                    color:"white"
                    anchors.centerIn: parent
                    font{
                        family: "黑体"
                        pixelSize: header.height/2
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        recordsystem.uploadexercise(str_userid,sporttext.text,begintimerow.begintime,lasttimerow.lasttime);

                    }
                }
            }

            Rectangle{
                id:sportsharebutton
                height: parent.height*1.2
                width: sportsharebuttontext.width*1.2
                color: "#32dc96"
                radius: height/4
                border.width: 1
                border.color: "grey"
                Text{
                    id:sportsharebuttontext
                    text:"保存并分享"
                    color:"white"
                    anchors.centerIn: parent
                    font{
                        family: "黑体"
                        pixelSize: header.height/2
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        recordsystem.uploadexercise(str_userid,sporttext.text,begintimerow.begintime,lasttimerow.lasttime);

                        var str="\n\n项目类型："+sporttext.text+"\n";
                        str=str+"开始时间："+begintimerow.begintime+"\n";
                        str=str+"持续时间："+lasttimerow.lasttime+"分钟\n";


                        mainrect.parent.parent.parent.bottom.currentPage="分享"
                        mainrect.parent.parent.x=-mainrect.width*2
                        mainrect.parent.parent.children[2].item.settext(str)
                    }
                }
            }

        }

        Rectangle{
            id:dosportdaysrect
            height: sportview.width/2.5
            width:height
            radius: height/10
            border.color: "grey"
            border.width: 2
            anchors.top: buttonrow.bottom
            anchors.topMargin: sportview.height/15
            anchors.left: sportview.left
            anchors.leftMargin: buttonrow.height/2
            color:"white"
            property int checkinday
            Text{
                anchors.centerIn: parent
                text:"坚持打卡\n"+dosportdaysrect.checkinday.toString()+"天"
                verticalAlignment: Text.AlignVCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: parent.height/10
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    dbsystem.checkin(str_userid)
                }
            }

        }

        Rectangle{
            id:timerrect
            height: sportview.width/2.5
            width:height
            radius: height/10
            border.color: "grey"
            border.width: 2
            anchors.top: buttonrow.bottom
            anchors.topMargin: sportview.height/15
            anchors.right: sportview.right
            anchors.rightMargin: buttonrow.height/2
            color:"white"
            Text{
                id:timertext
                anchors.centerIn: parent
                text:"运动计时\n1小时08分钟"
                verticalAlignment: Text.AlignVCenter
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: parent.height/10
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(!sporttimer.running){
                    begintimerow.editmode=0
                    modebuttontext.text="编辑模式"
                    modebutton.color="grey"
                    modebutton.enabled=false;
                    sportsavebutton.enabled=false
                    sportsavebutton.color="grey"
                    sportsharebutton.enabled=false
                    sportsharebutton.color="grey"
                    sporttimer.mins=0;
                        timertext.text=sporttimer.mins.toString()+"分钟"
                       var time= new Date()
                        sporttimer.beginhour=time.getHours()
                        sporttimer.beginmin=time.getMinutes()

                    begintimehourtext.text=time.getHours().toString()
                    begintimemintext.text=time.getMinutes().toString()
                    sporttimer.start();
                    delete time;
                    }
                    else{
                        sporttimer.stop()
                        modebutton.color="#32dc96"
                        modebutton.enabled=true;
                        sportsavebutton.enabled=true
                        sportsavebutton.color="#32dc96"
                        sportsharebutton.enabled=true
                        sportsharebutton.color="#32dc96"

                        lasttimehourtext.text=(sporttimer.mins/60).toString()
                        lasttimemintext.text=(sporttimer.mins%60).toString()
                    }
                }
            }
        }

        Timer{
            id:sporttimer
            interval: 5000
            repeat: true
            property int beginhour:0
            property int beginmin:0
            property int mins: 0
            onTriggered: {
                var time= new Date();
                if(time.getHours()>sporttimer.beginhour){
                mins=(time.getHours()-sporttimer.beginhour)*60+(60-sporttimer.beginmin)+time.getMinutes();
                }
                if(time.getHours()==sporttimer.beginhour){
                mins=time.getMinutes()-sporttimer.beginmin;
                }

                if(time.getHours()<sporttimer.beginhour){
                mins=(time.getHours()+24-sporttimer.beginhour)*60+(60-sporttimer.beginmin)+time.getMinutes();
                }

                timertext.text=sporttimer.mins.toString()+"分钟"

            }

        }

    }



    Rectangle{
        id:searchview
        visible: header.currentpage=="查看"?true:false
        height: parent.height-header.height
        width:parent.width
        anchors.top: header.bottom
        color:"white"


        Rectangle{
            id:timechooser
            border.color: "grey"
            border.width: 2
            radius: height/4
            color:"white"
            anchors.top: parent.top
            anchors.topMargin: parent.height/15
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height/15
            width: parent.width/1.5
            Text {
                id:timechoosertext
                anchors.centerIn: parent
                text:"2016-4-29"
                color:"grey"
                font{
                    family: "黑体"
                    pixelSize: parent.height/1.5
                }
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(!tumbler.visible)
                        tumbler.visible=true
                    else{
                        if(tumbler.day==="0")
                            myjava.toastMsg("请选择正确的日期")
                        else{
                            timechoosertext.text=tumbler.year+"-"+tumbler.month+"-"+tumbler.day;
                            recordsystem.getdiet(str_userid,timechoosertext.text);

                            tumbler.visible=false
                        }
                    }
                }
            }
        }


        Tumbler {
            id: tumbler
            anchors.top: timechooser.bottom
            anchors.left: timechooser.left
            z:200
            visible: false
            width: parent.width/1.7
            readonly property var days: [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
            property string year;
            property string month;
            property string day;


            TumblerColumn {
                width:tumbler.width/3
                model: ListModel {
                    id:yearmodel
                    Component.onCompleted: {
                        for (var i = 2000; i < 2100; ++i) {
                            append({value: i.toString()});
                        }
                    }
                }
                onCurrentIndexChanged: {
                    var yearint=yearmodel.get(currentIndex).value
                    tumbler.year=yearint.toString();
                    tumbler.day=tumblerDayColumn.model[tumblerDayColumn.currentIndex].toString();
                    if(yearint%4!=0){
                        if(tumbler.day==="29")
                            tumbler.day="0"
                        tumbler.days[1]=28
                    }
                    else
                        tumbler.days[1]=29
                }
            }
            TumblerColumn {
                id: monthColumn
                width:tumbler.width/3
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
                onCurrentIndexChanged: {
                    tumbler.month=model[currentIndex].toString();
                    tumbler.day=tumblerDayColumn.model[tumblerDayColumn.currentIndex].toString();
                    if(tumbler.days[currentIndex]<parseInt(tumbler.day))
                        tumbler.day="0"


                }
            }
            TumblerColumn {
                id: tumblerDayColumn
                width:tumbler.width/3
                model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
                onCurrentIndexChanged: {
                    tumbler.day=model[currentIndex].toString();
                    if(parseInt(tumbler.day)>tumbler.days[monthColumn.currentIndex])
                        tumbler.day="0";
                }
            }




        }



        Flickable{
            anchors.top: timechooser.bottom
            anchors.topMargin: timechooser.height
            height: parent.height-timechooser.height*3
            width:parent.width
            contentHeight: foodtablerect.height+sporttablerect.height+header.height/3*2
            contentWidth: parent.width
            clip: true




            Rectangle{
                id:foodtablerect
                border.color: "grey"
                border.width: 2
                radius: header.height/5
                height:foodtabletitle.height*2+ header.height/3*7+breakfast.height+lunch.height+dinner.height+snack.height+dessert.height+others.height
                width: parent.width-20
                x:parent.width/2-width/2
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                property string breakfaststr:"暂无数据"
                property string lunchstr:"暂无数据"
                property string dinnerstr:"暂无数据"
                property string snackstr:"暂无数据"
                property string dessertstr:"暂无数据"
                property string othersstr:"暂无数据"

                Text{
                    id:foodtabletitle
                    text:"饮食"
                    color:"grey"
                    anchors.top: parent.top
                    anchors.topMargin: header.height/3
                    anchors.horizontalCenter: parent.horizontalCenter

                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }

                Text{
                    id:breakfast
                    text:"早餐："+foodtablerect.breakfaststr
                    wrapMode: Text.Wrap
                    width: foodtablerect.width-header.height/3*2
                    color:"grey"

                    anchors.top: foodtabletitle.bottom
                    anchors.topMargin: header.height/3
                    anchors.left: parent.left
                    anchors.leftMargin: header.height/3

                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }
                Text{
                    id:lunch
                    text:"午餐："+foodtablerect.lunchstr
                    color:"grey"
                    wrapMode: Text.Wrap
                    width: foodtablerect.width-header.height/3*2
                    anchors.top: breakfast.bottom
                    anchors.topMargin: header.height/3
                    anchors.left: parent.left
                    anchors.leftMargin: header.height/3
                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }
                Text{
                    id:dinner
                    text:"晚餐："+foodtablerect.dinnerstr
                    color:"grey"
                    wrapMode: Text.Wrap
                    width: foodtablerect.width-header.height/3*2
                    anchors.top: lunch.bottom
                    anchors.topMargin: header.height/3
                    anchors.left: parent.left
                    anchors.leftMargin: header.height/3
                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }
                Text{
                    id:snack
                    text:"零食："+foodtablerect.snackstr
                    color:"grey"
                    wrapMode: Text.Wrap
                    width: foodtablerect.width-header.height/3*2
                    anchors.top: dinner.bottom
                    anchors.topMargin: header.height/3
                    anchors.left: parent.left
                    anchors.leftMargin: header.height/3
                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }
                Text{
                    id:dessert
                    text:"点心："+foodtablerect.dessertstr
                    color:"grey"
                    wrapMode: Text.Wrap
                    width: foodtablerect.width-header.height/3*2
                    anchors.top: snack.bottom
                    anchors.topMargin: header.height/3
                    anchors.left: parent.left
                    anchors.leftMargin: header.height/3
                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }
                Text{
                    id:others
                    text:"其他："+foodtablerect.othersstr
                    color:"grey"
                    wrapMode: Text.Wrap
                    width: foodtablerect.width-header.height/3*2
                    anchors.top: dessert.bottom
                    anchors.topMargin: header.height/3
                    anchors.left: parent.left
                    anchors.leftMargin: header.height/3
                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }

            }


            Rectangle{
                id:sporttablerect
                border.color: "grey"
                border.width: 2
                radius: header.height/5
                height:sporttableview.height+header.height/3*2+sporttabletitle.height
                width: parent.width-20
                x:parent.width/2-width/2
                anchors.top: foodtablerect.bottom
                anchors.topMargin: header.height/3
                anchors.horizontalCenter: parent.horizontalCenter

                ListModel{
                    id:sporttabelmodel
                    ListElement{
                        Type:"暂无数据"
                        BeginTime:"暂无数据"
                        LastTime:"暂无数据"
                    }
                }
                Text{
                    id:sporttabletitle
                    text:"运动"
                    color:"grey"
                    anchors.top: parent.top
                    anchors.topMargin: header.height/3
                    anchors.horizontalCenter: parent.horizontalCenter

                    font{
                        family: "黑体"
                        pixelSize: header.height/2.5
                    }
                }
                ListView{
                    id:sporttableview
                    anchors.top: sporttabletitle.bottom
                    anchors.topMargin: header.height/3
                    anchors.left: parent.left
                    anchors.leftMargin: header.height/3
                    height: sporttabelmodel.count*(header.height/2.5*3+header.height/3*2+header.height/3*2+header.height/3)
                    width:parent.width-header.height/3*2
                    model: sporttabelmodel
                    spacing: header.height/3*2

                    boundsBehavior:Flickable.StopAtBounds
                    delegate: Item{
                        id:sporttabeldelegate
                        height: sporttabeldelegatetype.height*3+header.height/3*2
                        width: parent.width
                        Text{
                            id:sporttabeldelegatetype
                            text:"项目类型："+Type
                            color:"grey"
                            anchors.top: sporttabeldelegate.top
                            anchors.left: parent.left
                            font{
                                family: "黑体"
                                pixelSize: header.height/2.5
                            }
                        }
                        Text{
                            id:sporttabeldelegatebeigintime
                            text:"开始时间："+BeginTime
                            color:"grey"
                            anchors.top: sporttabeldelegatetype.bottom
                            anchors.topMargin: header.height/3
                            anchors.left: parent.left
                            font{
                                family: "黑体"
                                pixelSize: header.height/2.5
                            }
                        }
                        Text{
                            id:sporttabeldelegatelasttime
                            text:"持续时间："+LastTime
                            color:"grey"
                            anchors.top: sporttabeldelegatebeigintime.bottom
                            anchors.topMargin: header.height/3
                            anchors.left: parent.left
                            font{
                                family: "黑体"
                                pixelSize: header.height/2.5
                            }
                        }

                    }
                }

            }


        }
    }



    ListView{
        id:foodview
        visible: header.currentpage=="饮食"?true:false
        height: parent.height-header.height
        width:parent.width
        anchors.top: header.bottom
        clip:true
        spacing: 5
        property var currentdiet;
        property int currentfood;
        ListModel{
            id:dietmodel
            ListElement{Title:"早餐";Photo:"http://www.icosky.com/icon/png/System/QuickPix%202007/Shamrock.png"}
            ListElement{Title:"午餐";Photo:""}
            ListElement{Title:"晚餐";Photo:""}
            ListElement{Title:"零食";Photo:""}
            ListElement{Title:"点心";Photo:""}
            ListElement{Title:"其他";Photo:""}
        }

        ListModel{
            id:breakfastmodel
            ListElement{Food:"点击选择食物"}
            ListElement{Food:"点击选择食物"}
        }
        ListModel{
            id:lunchmodel
            ListElement{Food:"点击选择食物"}
            ListElement{Food:"点击选择食物"}
            ListElement{Food:"点击选择食物"}
        }
        ListModel{
            id:dinnermodel
            ListElement{Food:"点击选择食物"}
            ListElement{Food:"点击选择食物"}
            ListElement{Food:"点击选择食物"}
        }
        ListModel{
            id:snackmodel
            ListElement{Food:"点击选择食物"}
        }
        ListModel{
            id:dessertmodel
            ListElement{Food:"点击选择食物"}
        }
        ListModel{
            id:othersmodel
            ListElement{Food:"点击选择食物"}
        }



        model:dietmodel
        delegate: Item{
            id:dietitem
            width:parent.width
            height: title.height+foodlist.height+header.height/2+header.height/5*2+addfoodbutton.height+header.height/3*3
            property string imagePath:Photo
            Rectangle{
                border.color: "grey"
                border.width: 2
                radius: header.height/3
                anchors.fill: parent
                anchors.margins: header.height/5
                id:delegaterect
                property string foodstr;
                onFoodstrChanged: {
                    foodlist.model.setProperty(foodview.currentfood,"Food",foodstr);
                }


                Label{
                    id:title
                    text:Title
                    anchors.top:parent.top
                    anchors.topMargin: height/2
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/10
                    color:"grey"
                    font{
                        family: "黑体"
                        pixelSize: header.height/2
                    }

                }

                Image{
                    id:dietimage
                    anchors.left: title.right
                    anchors.top: title.top
                    height: title.height
                    width:height*1.5
                    fillMode: Image.PreserveAspectFit
                    source:Photo
                    MouseArea{
                        anchors.fill: parent
                        visible: dietimage.source==""?0:1
                        onClicked: {
                            bigphoto.source=dietimage.source
                            bigphotorect.visible=true
                        }
                    }
                }


                Label{
                    id:addphoto
                    text:dietimage.source==""?"+":"-"
                    anchors.top:parent.top
                   // anchors.topMargin: height/10
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width/40
                    color:"grey"
                    font{
                        family: "黑体"
                        bold: true
                        pixelSize: header.height/1.5
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(addphoto.text=="+"){
                            myjava.getImage();
                            timer.start();
                            }
                            else{
                               dietimage.source="" ;
                            }
                        }
                    }

                }

                Timer{
                    id:timer;
                    interval: 1500
                    onTriggered: {
                        var temp=myjava.getImagePath();
                        if(temp!=="Qt"){
                            timer.stop();
                            dietimage.source="file://"+temp;
                            dietitem.imagePath=temp;
                        }
                    }
                }


                Component.onCompleted: {
                    switch(index){
                    case 0:
                        foodlist.model=breakfastmodel;
                        break;
                    case 1:
                        foodlist.model=lunchmodel;
                        break;
                    case 2:
                        foodlist.model=dinnermodel;
                        break;
                    case 3:
                        foodlist.model=snackmodel;
                        break;
                    case 4:
                        foodlist.model=dessertmodel;
                        break;
                    case 5:
                        foodlist.model=othersmodel;
                        break;
                    }
                }

                ListView{
                    id:foodlist
                    width: dietitem.width/1.5
                    height:foodlist.model.count*(title.height*1.5+mainrect.height/36)
                    anchors.left: title.left
                    anchors.top: title.bottom
                    anchors.topMargin: mainrect.height/60
                    spacing: mainrect.height/36
                    delegate:Item{
                        id:food
                        height:title.height*1.5
                        width: parent.width
                        Label{
                            id:diettitle
                            anchors.verticalCenter: parent.verticalCenter
                            text:"食物"+(index+1).toString()
                            color:"grey"
                            font{
                                family: "黑体"
                                pixelSize: header.height/2
                            }
                        }
                        Rectangle{
                            id:foodtext
                            border.color: "grey"
                            border.width: 2
                            radius: header.height/7
                            color:"white"
                            height: parent.height
                            width: parent.width-diettitle.width-deletebutton.width/1.5
                            anchors.left: diettitle.right
                            anchors.leftMargin: diettitle.width/2
                            Text {
                                anchors.centerIn: parent
                                text:Food
                                color:"grey"
                                font{
                                    family: "黑体"
                                    pixelSize: parent.height/2.5
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    foodview.currentdiet=dietitem
                                    foodview.currentfood=index
                                    view.model=foodsmodel
                                    searpage.visible=true
                                }
                            }
                        }
                        Rectangle{
                            id:deletebutton
                            anchors.left: food.right
                            anchors.leftMargin: diettitle.width/10
                            anchors.top: foodtext.top
                            height: foodtext.height
                            width: deletetext.width*1.5
                            color: "red"
                            radius: height/4
                            border.width: 1
                            border.color: "grey"
                            Text{
                                id:deletetext
                                text:"删除"
                                color:"white"

                                anchors.centerIn: parent
                                font{
                                    family: "黑体"
                                    bold: true
                                    pixelSize: title.height/1.5
                                }
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {

                                    foodlist.model.remove(index)
                                }
                            }

                        }

                    }
                }



                Rectangle{
                    id:addfoodbutton
                    anchors.left: foodlist.left
                    anchors.top: foodlist.bottom
                    anchors.topMargin: header.height/3
                    height: title.height*1.2
                    width: addtext.width*2
                    color: "#32dc96"
                    radius: height/4
                    border.width: 1
                    border.color: "grey"
                    Text{
                        id:addtext
                        text:"增加"
                        color:"white"

                        anchors.centerIn: parent
                        font{
                            family: "黑体"
                            bold: true
                            pixelSize: title.height/1.5
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var isfull=1;
                            for(var i=0;i<foodlist.model.count;i++){
                                if(foodlist.model.get(i).Food==="点击选择食物")
                                    isfull=0;
                            }
                            if(isfull){
                                foodlist.model.append({"Food":"点击选择食物" })
                            }
                            else
                                myjava.toastMsg("请先填满之前的食物")
                        }
                    }

                }

                Rectangle{
                    id:savebutton
                    anchors.horizontalCenter: foodlist.horizontalCenter
                    anchors.top: addfoodbutton.top
                    height: title.height*1.2
                    width: savetext.width*2
                    color: "blue"
                    radius: height/4
                    border.width: 1
                    border.color: "grey"
                    Text{
                        id:savetext
                        text:"保存"
                        color:"white"

                        anchors.centerIn: parent
                        font{
                            family: "黑体"
                            bold: true
                            pixelSize: title.height/1.5
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var foodstr123="";
                            for(var i=0;i<foodlist.model.count;i++){
                                if(foodlist.model.get(i).Food!=="点击选择食物")
                                    foodstr123=foodstr123+foodlist.model.get(i).Food+"、";
                            }
                            recordsystem.uploaddiet(str_userid,foodstr123,index);
                        }
                    }

                }

                Rectangle{
                    id:sharebutton
                    anchors.right: foodlist.right
                    anchors.rightMargin: -savebutton.width/1.5
                    anchors.top: addfoodbutton.top
                    height: title.height*1.2
                    width: sharetext.width*1.3
                    color: "lightblue"
                    radius: height/4
                    border.width: 1
                    border.color: "grey"
                    Text{
                        id:sharetext
                        text:"保存并分享"
                        color:"white"

                        anchors.centerIn: parent
                        font{
                            family: "黑体"
                            bold: true
                            pixelSize: title.height/1.5
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var foodstr1234="";
                            for(var i1=0;i1<foodlist.model.count;i1++){
                                if(foodlist.model.get(i1).Food!=="点击选择食物")
                                    foodstr1234=foodstr1234+foodlist.model.get(i1).Food+"、";
                            }
                            recordsystem.uploaddiet(str_userid,foodstr1234,index);


                            var str=title.text+"\n";
                            var foodstr123="";
                            for(var i=0;i<foodlist.model.count;i++){
                                if(foodlist.model.get(i).Food!=="点击选择食物")
                                    foodstr123=foodstr123+"食物"+(i+1).toString()+"："+foodlist.model.get(i).Food+"\n";
                            }

                            str="\n\n"+str+foodstr123;
                            console.log(str)

                            mainrect.parent.parent.parent.bottom.currentPage="分享"
                            mainrect.parent.parent.x=-mainrect.width*2
                            mainrect.parent.parent.children[2].item.settext(str)
                            if(dietimage.source!=="")
                            mainrect.parent.parent.children[2].item.setimg(dietitem.imagePath)
                        }
                    }

                }



            }
        }
    }



    Rectangle{
        id:searpage
        anchors.fill: parent
        visible: false
        z:10
        Rectangle{
            id:searchbar
            height: parent.height/12
            width: parent.width
            anchors.top: parent.top
            visible: (view.model===foodsmodel||view.model===searchedmodel)?1:0
            TextField{
                height:parent.height-6
                width: parent.width-6
                x:3
                anchors.verticalCenter: parent.verticalCenter
                id:searchtext
                placeholderText:"请输入要搜索的内容"
                style: TextFieldStyle{
                    background: Rectangle{
                        radius: control.height/4
                        border.width: 1;
                        border.color: "grey"
                        id:searchrect
                    }
                }
                onTextChanged: {
                    if(view.model===foodsmodel||view.model===searchedmodel){
                        if(searchtext.text!==""){
                            searchedmodel.clear()
                            for(var i=0;i<foodsmodel.count;i++){
                                var a=foodsmodel.get(i).value;
                                if(a.indexOf(searchtext.text)>=0)
                                    searchedmodel.append({"value":a})
                            }
                            view.model=searchedmodel;
                        }
                        else
                            view.model=foodsmodel
                    }
                }
            }
        }



        ListView{
            id:view
            spacing: -1
            anchors.top: (view.model===foodsmodel||view.model===searchedmodel)?searchbar.bottom:parent.top
            clip: true
            width: parent.width
            height:parent.height-searchbar.height
            model: foodsmodel
            delegate: Item{
                id:delegate
                width:view.width
                height:searchbar.height*1.2
                Rectangle{
                    anchors.fill: parent
                    color:"white"
                    border.color: "grey"
                    border.width: 1
                    Text{
                        id:name;
                        anchors.centerIn: parent
                        color: "grey"
                        text:value
                        font{
                            family: "黑体"
                            pixelSize: delegate.height/1.5
                        }

                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            if(view.model===searchedmodel){
                                foodview.currentdiet.children[0].foodstr=""
                                foodview.currentdiet.children[0].foodstr=searchedmodel.get(index).value
                            }

                            if(view.model===foodsmodel){
                                foodview.currentdiet.children[0].foodstr=""
                                foodview.currentdiet.children[0].foodstr=foodsmodel.get(index).value
                            }


                            if(view.model===sportsmodel){
                                sporttext.text=sportsmodel.get(index).value
                            }

                            if(view.model===beginhourmodel){
                                begintimehourtext.text=beginhourmodel.get(index).value
                            }

                            if(view.model===beginminmodel){
                                begintimemintext.text=beginminmodel.get(index).value
                            }
                            if(view.model===lastminmodel){
                                lasttimemintext.text=lastminmodel.get(index).value
                            }
                            if(view.model===lasthourmodel){
                                lasttimehourtext.text=lasthourmodel.get(index).value
                            }

                            searpage.visible=false
                        }
                    }
                }

            }
        }


    }


    ListModel{
        id:searchedmodel
    }



    ListModel{
        id:beginhourmodel
        ListElement{value:"00"}
        ListElement{value:"01"}
        ListElement{value:"02"}
        ListElement{value:"03"}
        ListElement{value:"04"}
        ListElement{value:"05"}
        ListElement{value:"06"}
        ListElement{value:"07"}
        ListElement{value:"08"}
        ListElement{value:"09"}
        ListElement{value:"10"}
        ListElement{value:"11"}
        ListElement{value:"12"}
        ListElement{value:"13"}
        ListElement{value:"14"}
        ListElement{value:"15"}
        ListElement{value:"16"}
        ListElement{value:"17"}
        ListElement{value:"18"}
        ListElement{value:"19"}
        ListElement{value:"20"}
        ListElement{value:"21"}
        ListElement{value:"22"}
        ListElement{value:"23"}

    }

    ListModel{
        id:beginminmodel
        ListElement{value:"00"}
        ListElement{value:"01"}
        ListElement{value:"02"}
        ListElement{value:"03"}
        ListElement{value:"04"}
        ListElement{value:"05"}
        ListElement{value:"06"}
        ListElement{value:"07"}
        ListElement{value:"08"}
        ListElement{value:"09"}
        ListElement{value:"10"}
        ListElement{value:"11"}
        ListElement{value:"12"}
        ListElement{value:"13"}
        ListElement{value:"14"}
        ListElement{value:"15"}
        ListElement{value:"16"}
        ListElement{value:"17"}
        ListElement{value:"18"}
        ListElement{value:"19"}
        ListElement{value:"20"}
        ListElement{value:"21"}
        ListElement{value:"22"}
        ListElement{value:"23"}
        ListElement{value:"24"}
        ListElement{value:"25"}
        ListElement{value:"26"}
        ListElement{value:"27"}
        ListElement{value:"28"}
        ListElement{value:"29"}
        ListElement{value:"30"}
        ListElement{value:"31"}
        ListElement{value:"32"}
        ListElement{value:"33"}
        ListElement{value:"34"}
        ListElement{value:"35"}
        ListElement{value:"36"}
        ListElement{value:"37"}
        ListElement{value:"38"}
        ListElement{value:"39"}
        ListElement{value:"40"}
        ListElement{value:"41"}
        ListElement{value:"42"}
        ListElement{value:"43"}
        ListElement{value:"44"}
        ListElement{value:"45"}
        ListElement{value:"46"}
        ListElement{value:"47"}
        ListElement{value:"48"}
        ListElement{value:"49"}
        ListElement{value:"50"}
        ListElement{value:"51"}
        ListElement{value:"52"}
        ListElement{value:"53"}
        ListElement{value:"54"}
        ListElement{value:"55"}
        ListElement{value:"56"}
        ListElement{value:"57"}
        ListElement{value:"58"}
        ListElement{value:"59"}
    }

    ListModel{
        id:lasthourmodel
        ListElement{value:"1"}
        ListElement{value:"2"}
        ListElement{value:"3"}
        ListElement{value:"4"}
        ListElement{value:"5"}
        ListElement{value:"6"}
        ListElement{value:"7"}
        ListElement{value:"8"}
        ListElement{value:"9"}
        ListElement{value:"10"}
        ListElement{value:"11"}
        ListElement{value:"12"}
        ListElement{value:"13"}
        ListElement{value:"14"}
        ListElement{value:"15"}
        ListElement{value:"16"}
        ListElement{value:"17"}
        ListElement{value:"18"}
        ListElement{value:"19"}
        ListElement{value:"20"}
        ListElement{value:"21"}
        ListElement{value:"22"}
        ListElement{value:"23"}

    }

    ListModel{
        id:lastminmodel
        ListElement{value:"00"}
        ListElement{value:"01"}
        ListElement{value:"02"}
        ListElement{value:"03"}
        ListElement{value:"04"}
        ListElement{value:"05"}
        ListElement{value:"06"}
        ListElement{value:"07"}
        ListElement{value:"08"}
        ListElement{value:"09"}
        ListElement{value:"10"}
        ListElement{value:"11"}
        ListElement{value:"12"}
        ListElement{value:"13"}
        ListElement{value:"14"}
        ListElement{value:"15"}
        ListElement{value:"16"}
        ListElement{value:"17"}
        ListElement{value:"18"}
        ListElement{value:"19"}
        ListElement{value:"20"}
        ListElement{value:"21"}
        ListElement{value:"22"}
        ListElement{value:"23"}
        ListElement{value:"24"}
        ListElement{value:"25"}
        ListElement{value:"26"}
        ListElement{value:"27"}
        ListElement{value:"28"}
        ListElement{value:"29"}
        ListElement{value:"30"}
        ListElement{value:"31"}
        ListElement{value:"32"}
        ListElement{value:"33"}
        ListElement{value:"34"}
        ListElement{value:"35"}
        ListElement{value:"36"}
        ListElement{value:"37"}
        ListElement{value:"38"}
        ListElement{value:"39"}
        ListElement{value:"40"}
        ListElement{value:"41"}
        ListElement{value:"42"}
        ListElement{value:"43"}
        ListElement{value:"44"}
        ListElement{value:"45"}
        ListElement{value:"46"}
        ListElement{value:"47"}
        ListElement{value:"48"}
        ListElement{value:"49"}
        ListElement{value:"50"}
        ListElement{value:"51"}
        ListElement{value:"52"}
        ListElement{value:"53"}
        ListElement{value:"54"}
        ListElement{value:"55"}
        ListElement{value:"56"}
        ListElement{value:"57"}
        ListElement{value:"58"}
        ListElement{value:"59"}

    }

    ListModel{
        id:sportsmodel
        ListElement{value:"慢跑"}
        ListElement{value:"长跑"}
        ListElement{value:"羽毛球"}

    }

    ListModel{
        id:foodsmodel
        ListElement{value:"艾草"}
        ListElement{value:"艾蒿"}
        ListElement{value:"鹌鹑"}
        ListElement{value:"鹌鹑"}
        ListElement{value:"鹌鹑蛋"}
        ListElement{value:"安康鱼"}
        ListElement{value:"白扁豆"}
        ListElement{value:"白菜"}
        ListElement{value:"白菜梗"}
        ListElement{value:"白菜薹"}
        ListElement{value:"白鲳鱼"}
        ListElement{value:"白刺虾"}
        ListElement{value:"白醋"}
        ListElement{value:"白带鱼"}
        ListElement{value:"白豆"}
        ListElement{value:"白豆沙"}
        ListElement{value:"白凤菜"}
        ListElement{value:"白粉桃"}
        ListElement{value:"白附子"}
        ListElement{value:"白瓜"}
        ListElement{value:"白果"}
        ListElement{value:"白姑鱼"}
        ListElement{value:"百合"}
        ListElement{value:"百合干"}
        ListElement{value:"白花菜"}
        ListElement{value:"白花桔梗"}
        ListElement{value:"白花椰菜"}
        ListElement{value:"白胡椒"}
        ListElement{value:"白胡椒粉"}
        ListElement{value:"败酱"}
        ListElement{value:"败酱草"}
        ListElement{value:"白姜薯"}
        ListElement{value:"白酱油"}
        ListElement{value:"白金瓜"}
        ListElement{value:"白兰瓜"}
        ListElement{value:"白灵菇"}
        ListElement{value:"白萝卜"}
        ListElement{value:"白芦笋"}
        ListElement{value:"白面"}
        ListElement{value:"白牛肝菌"}
        ListElement{value:"白巧克力"}
        ListElement{value:"白茄子"}
        ListElement{value:"白沙蒿"}
        ListElement{value:"白砂糖"}
        ListElement{value:"白参"}
        ListElement{value:"白条鱼"}
        ListElement{value:"白虾"}
        ListElement{value:"白虾米"}
        ListElement{value:"百香果"}
        ListElement{value:"百香果"}
        ListElement{value:"白鸭"}
        ListElement{value:"白鸭血"}
        ListElement{value:"百页"}
        ListElement{value:"百叶结"}
        ListElement{value:"白油"}
        ListElement{value:"白鱼"}
        ListElement{value:"白玉草"}
        ListElement{value:"白玉菇"}
        ListElement{value:"白玉苦瓜"}
        ListElement{value:"白芸豆"}
        ListElement{value:"白芷"}
        ListElement{value:"柏子仁"}
        ListElement{value:"八角"}
        ListElement{value:"芭蕉"}
        ListElement{value:"芭蕉花"}
        ListElement{value:"芭蕉叶"}
        ListElement{value:"巴戟天"}
        ListElement{value:"芭乐"}
        ListElement{value:"板豆腐"}
        ListElement{value:"棒骨"}
        ListElement{value:"蚌壳"}
        ListElement{value:"板绞油"}
        ListElement{value:"斑节对虾"}
        ListElement{value:"板蓝根"}
        ListElement{value:"板栗"}
        ListElement{value:"板鱼"}
        ListElement{value:"包公鱼"}
        ListElement{value:"宝塔菜花"}
        ListElement{value:"包心菜"}
        ListElement{value:"鲍鱼"}
        ListElement{value:"鲍鱼菇"}
        ListElement{value:"煲仔酱"}
        ListElement{value:"抱子甘蓝"}
        ListElement{value:"扒皮鱼"}
        ListElement{value:"霸王蟹"}
        ListElement{value:"巴西利"}
        ListElement{value:"鲃鱼"}
        ListElement{value:"贝贝南瓜"}
        ListElement{value:"北豆腐"}
        ListElement{value:"北蕉"}
        ListElement{value:"北京填鸭"}
        ListElement{value:"北极虾"}
        ListElement{value:"贝壳面"}
        ListElement{value:"北风菌"}
        ListElement{value:"扁豆"}
        ListElement{value:"鞭笋"}
        ListElement{value:"鳊鱼"}
        ListElement{value:"比目鱼"}
        ListElement{value:"冰草"}
        ListElement{value:"槟榔"}
        ListElement{value:"冰糖"}
        ListElement{value:"槟榔芋"}
        ListElement{value:"碧玉笋"}
        ListElement{value:"菠菜"}
        ListElement{value:"薄荷"}
        ListElement{value:"菠萝"}
        ListElement{value:"菠萝蜜"}
        ListElement{value:"菠萝蜜子"}
        ListElement{value:"鲅鱼"}
        ListElement{value:"布朗"}
        ListElement{value:"荸荠"}
        ListElement{value:"菜瓜"}
        ListElement{value:"菜花"}
        ListElement{value:"菜椒"}
        ListElement{value:"菜心"}
        ListElement{value:"菜籽油"}
        ListElement{value:"蚕豆"}
        ListElement{value:"蚕豆淀粉"}
        ListElement{value:"蚕蛹"}
        ListElement{value:"草豆蔻"}
        ListElement{value:"草菇"}
        ListElement{value:"草果"}
        ListElement{value:"草菇心"}
        ListElement{value:"草莓"}
        ListElement{value:"草莓酱"}
        ListElement{value:"糙米"}
        ListElement{value:"草虾"}
        ListElement{value:"草鱼"}
        ListElement{value:"草鱼尾"}
        ListElement{value:"柴鸡"}
        ListElement{value:"柴鱼"}
        ListElement{value:"柴鱼片"}
        ListElement{value:"长把梨"}
        ListElement{value:"长毛对虾"}
        ListElement{value:"长米"}
        ListElement{value:"长糯米"}
        ListElement{value:"菖蒲"}
        ListElement{value:"长茄子"}
        ListElement{value:"鲳鱼"}
        ListElement{value:"叉烧肉"}
        ListElement{value:"朝天椒"}
        ListElement{value:"朝天椒"}
        ListElement{value:"茶树菇"}
        ListElement{value:"茶油"}
        ListElement{value:"陈醋"}
        ListElement{value:"澄粉"}
        ListElement{value:"蛏子"}
        ListElement{value:"橙子"}
        ListElement{value:"车前草"}
        ListElement{value:"赤贝"}
        ListElement{value:"翅根"}
        ListElement{value:"翅尖"}
        ListElement{value:"赤小豆"}
        ListElement{value:"虫草花"}
        ListElement{value:"川贝"}
        ListElement{value:"穿心莲"}
        ListElement{value:"莼菜"}
        ListElement{value:"春鸡"}
        ListElement{value:"春笋"}
        ListElement{value:"刺儿菜"}
        ListElement{value:"慈姑"}
        ListElement{value:"慈菇"}
        ListElement{value:"刺老芽"}
        ListElement{value:"刺梨"}
        ListElement{value:"葱烤酱"}
        ListElement{value:"葱油"}
        ListElement{value:"醋"}
        ListElement{value:"脆骨"}
        ListElement{value:"脆皮肠"}
        ListElement{value:"脆山药"}
        ListElement{value:"醋精"}
        ListElement{value:"醋栗"}
        ListElement{value:"粗盐"}
        ListElement{value:"大白菜"}
        ListElement{value:"大玻璃草叶"}
        ListElement{value:"大肠"}
        ListElement{value:"大巢菜"}
        ListElement{value:"大葱"}
        ListElement{value:"大豆"}
        ListElement{value:"大红菇"}
        ListElement{value:"大花蟹"}
        ListElement{value:"带鱼"}
        ListElement{value:"带子"}
        ListElement{value:"大甲芋头"}
        ListElement{value:"大麦"}
        ListElement{value:"大麻油"}
        ListElement{value:"大米"}
        ListElement{value:"淡菜"}
        ListElement{value:"淡豆豉"}
        ListElement{value:"当归"}
        ListElement{value:"党参"}
        ListElement{value:"蛋黄"}
        ListElement{value:"蛋黄果"}
        ListElement{value:"淡奶油"}
        ListElement{value:"蛋清"}
        ListElement{value:"丹参"}
        ListElement{value:"蛋挞皮"}
        ListElement{value:"淡竹叶"}
        ListElement{value:"刀豆"}
        ListElement{value:"稻米"}
        ListElement{value:"稻米油"}
        ListElement{value:"大薯"}
        ListElement{value:"大蒜"}
        ListElement{value:"大叶茼蒿"}
        ListElement{value:"大芋头"}
        ListElement{value:"大枣"}
        ListElement{value:"大闸蟹"}
        ListElement{value:"灯笼椒"}
        ListElement{value:"淀粉（大米）"}
        ListElement{value:"鲷鱼"}
        ListElement{value:"刁子鱼"}
        ListElement{value:"地肤"}
        ListElement{value:"地瓜"}
        ListElement{value:"低筋面粉"}
        ListElement{value:"丁香"}
        ListElement{value:"丁香花"}
        ListElement{value:"丁香鱼"}
        ListElement{value:"丁香鱼"}
        ListElement{value:"地皮菜"}
        ListElement{value:"帝王蟹"}
        ListElement{value:"地衣"}
        ListElement{value:"冬菜"}
        ListElement{value:"冬虫夏草"}
        ListElement{value:"冻豆腐"}
        ListElement{value:"东方对虾"}
        ListElement{value:"东风菜"}
        ListElement{value:"冬菇"}
        ListElement{value:"冬瓜"}
        ListElement{value:"冬果梨"}
        ListElement{value:"冬寒菜"}
        ListElement{value:"冬南瓜"}
        ListElement{value:"冬笋"}
        ListElement{value:"动物奶油"}
        ListElement{value:"冬枣"}
        ListElement{value:"豆瓣"}
        ListElement{value:"豆瓣菜"}
        ListElement{value:"豆瓣酱"}
        ListElement{value:"豆瓣辣酱"}
        ListElement{value:"豆豉"}
        ListElement{value:"豆腐"}
        ListElement{value:"豆腐柴"}
        ListElement{value:"豆腐干"}
        ListElement{value:"豆腐脑"}
        ListElement{value:"豆腐皮"}
        ListElement{value:"豆干"}
        ListElement{value:"豆浆"}
        ListElement{value:"豆角"}
        ListElement{value:"豆苗"}
        ListElement{value:"豆泡"}
        ListElement{value:"豆皮"}
        ListElement{value:"豆粕"}
        ListElement{value:"豆沙"}
        ListElement{value:"豆薯"}
        ListElement{value:"豆芽"}
        ListElement{value:"豆油"}
        ListElement{value:"豆渣"}
        ListElement{value:"对虾"}
        ListElement{value:"多宝鱼"}
        ListElement{value:"多春鱼"}
        ListElement{value:"剁椒"}
        ListElement{value:"独行菜"}
        ListElement{value:"杜仲"}
        ListElement{value:"鹅"}
        ListElement{value:"鹅蛋"}
        ListElement{value:"鹅肝"}
        ListElement{value:"鹅肝"}
        ListElement{value:"阿胶"}
        ListElement{value:"儿菜"}
        ListElement{value:"鹅肉"}
        ListElement{value:"鳄鱼肉"}
        ListElement{value:"莪术"}
        ListElement{value:"发菜"}
        ListElement{value:"方腿"}
        ListElement{value:"番茄酱"}
        ListElement{value:"番茄辣酱"}
        ListElement{value:"番茄沙司"}
        ListElement{value:"番茄汁"}
        ListElement{value:"番杏"}
        ListElement{value:"法香"}
        ListElement{value:"肥膘肉"}
        ListElement{value:"飞碟瓜"}
        ListElement{value:"飞碟西葫芦"}
        ListElement{value:"肥牛"}
        ListElement{value:"肥肉"}
        ListElement{value:"分葱"}
        ListElement{value:"凤螺"}
        ListElement{value:"蜂蜜"}
        ListElement{value:"枫糖浆"}
        ListElement{value:"蜂王浆"}
        ListElement{value:"凤尾鱼"}
        ListElement{value:"凤眼果"}
        ListElement{value:"蜂蛹"}
        ListElement{value:"粉蕉"}
        ListElement{value:"粉皮"}
        ListElement{value:"粉丝"}
        ListElement{value:"粉条"}
        ListElement{value:"佛手"}
        ListElement{value:"佛手瓜"}
        ListElement{value:"福橘"}
        ListElement{value:"茯苓"}
        ListElement{value:"伏苹果"}
        ListElement{value:"富强粉"}
        ListElement{value:"腐乳(白)"}
        ListElement{value:"腐乳(臭)"}
        ListElement{value:"腐乳(红)"}
        ListElement{value:"鳆鱼"}
        ListElement{value:"腐竹"}
        ListElement{value:"盖菜"}
        ListElement{value:"芥蓝"}
        ListElement{value:"咖喱"}
        ListElement{value:"咖喱粉"}
        ListElement{value:"干巴菌"}
        ListElement{value:"干贝"}
        ListElement{value:"甘草"}
        ListElement{value:"干茶树菇"}
        ListElement{value:"干海带"}
        ListElement{value:"干花椒叶"}
        ListElement{value:"干黄酱"}
        ListElement{value:"干姜"}
        ListElement{value:"甘蓝"}
        ListElement{value:"橄榄菜"}
        ListElement{value:"橄榄酱"}
        ListElement{value:"橄榄油"}
        ListElement{value:"干墨鱼"}
        ListElement{value:"甘薯"}
        ListElement{value:"干松茸"}
        ListElement{value:"干笋"}
        ListElement{value:"干豌豆"}
        ListElement{value:"干虾"}
        ListElement{value:"干香菇"}
        ListElement{value:"干虾仁"}
        ListElement{value:"干鱿鱼"}
        ListElement{value:"感鱼"}
        ListElement{value:"甘蔗"}
        ListElement{value:"甘蔗汁"}
        ListElement{value:"高筋面粉"}
        ListElement{value:"高粱"}
        ListElement{value:"高良姜"}
        ListElement{value:"高粱米"}
        ListElement{value:"高粱面"}
        ListElement{value:"膏蟹"}
        ListElement{value:"鸽蛋"}
        ListElement{value:"葛根"}
        ListElement{value:"葛根粉"}
        ListElement{value:"粳米"}
        ListElement{value:"葛仙米"}
        ListElement{value:"鸽子"}
        ListElement{value:"鸽子蛋"}
        ListElement{value:"贡菜"}
        ListElement{value:"宫廷鸡"}
        ListElement{value:"狗母鱼"}
        ListElement{value:"枸杞"}
        ListElement{value:"狗肉"}
        ListElement{value:"狗尾草"}
        ListElement{value:"挂面"}
        ListElement{value:"观音菜"}
        ListElement{value:"瓜子仁"}
        ListElement{value:"龟板"}
        ListElement{value:"桂花"}
        ListElement{value:"桂花蜜"}
        ListElement{value:"桂皮"}
        ListElement{value:"桂皮粉"}
        ListElement{value:"桂鱼"}
        ListElement{value:"鲑鱼"}
        ListElement{value:"桂圆"}
        ListElement{value:"鲑鱼籽酱"}
        ListElement{value:"桂枝"}
        ListElement{value:"桂竹笋"}
        ListElement{value:"果冻粉"}
        ListElement{value:"裹粉"}
        ListElement{value:"国光苹果"}
        ListElement{value:"果酱"}
        ListElement{value:"过猫"}
        ListElement{value:"果脯"}
        ListElement{value:"果糖"}
        ListElement{value:"谷芽"}
        ListElement{value:"海蚌"}
        ListElement{value:"海草"}
        ListElement{value:"海带"}
        ListElement{value:"海带结"}
        ListElement{value:"海胆"}
        ListElement{value:"海胆酱"}
        ListElement{value:"海底椰"}
        ListElement{value:"海瓜子"}
        ListElement{value:"海虹"}
        ListElement{value:"海鲫鱼"}
        ListElement{value:"海蜊子"}
        ListElement{value:"海螺"}
        ListElement{value:"海米"}
        ListElement{value:"海葡萄"}
        ListElement{value:"海参"}
        ListElement{value:"海苔"}
        ListElement{value:"海兔"}
        ListElement{value:"海虾"}
        ListElement{value:"海鲜菇"}
        ListElement{value:"象鱼"}
        ListElement{value:"海蟹"}
        ListElement{value:"海蜇"}
        ListElement{value:"海蜇"}
        ListElement{value:"海蜇头"}
        ListElement{value:"蛤蜊"}
        ListElement{value:"哈密瓜"}
        ListElement{value:"杭椒"}
        ListElement{value:"蚝油"}
        ListElement{value:"蒿子秆"}
        ListElement{value:"蒿子杆"}
        ListElement{value:"河蚌"}
        ListElement{value:"河粉"}
        ListElement{value:"河粉（干）"}
        ListElement{value:"黑豆"}
        ListElement{value:"黑豆芽"}
        ListElement{value:"黑橄榄"}
        ListElement{value:"黑胡椒"}
        ListElement{value:"黑胡椒酱"}
        ListElement{value:"黑加仑"}
        ListElement{value:"黑芥"}
        ListElement{value:"黑菌"}
        ListElement{value:"黑麦粉"}
        ListElement{value:"黑麻油"}
        ListElement{value:"黑米"}
        ListElement{value:"黑木耳"}
        ListElement{value:"黑糯米"}
        ListElement{value:"黑柿蕃茄"}
        ListElement{value:"黑蒜"}
        ListElement{value:"黑糖"}
        ListElement{value:"黑土豆"}
        ListElement{value:"黑油菜"}
        ListElement{value:"黑鱼"}
        ListElement{value:"黑枣"}
        ListElement{value:"黑芝麻"}
        ListElement{value:"荷兰豆"}
        ListElement{value:"荷兰瓜"}
        ListElement{value:"和乐蟹"}
        ListElement{value:"核桃"}
        ListElement{value:"核桃油"}
        ListElement{value:"河虾"}
        ListElement{value:"河虾"}
        ListElement{value:"河蚬"}
        ListElement{value:"荷仙菇"}
        ListElement{value:"河蟹"}
        ListElement{value:"荷叶"}
        ListElement{value:"红菜苔"}
        ListElement{value:"红菜头"}
        ListElement{value:"红茶"}
        ListElement{value:"红绸鱼"}
        ListElement{value:"红葱头"}
        ListElement{value:"红豆"}
        ListElement{value:"红番茄"}
        ListElement{value:"红富士苹果"}
        ListElement{value:"红咖喱酱"}
        ListElement{value:"红甘鱼"}
        ListElement{value:"红果"}
        ListElement{value:"红螺"}
        ListElement{value:"红萝卜"}
        ListElement{value:"红米"}
        ListElement{value:"红蘑"}
        ListElement{value:"红秋葵"}
        ListElement{value:"红曲"}
        ListElement{value:"红色尖椒"}
        ListElement{value:"红衫鱼"}
        ListElement{value:"红薯"}
        ListElement{value:"红薯淀粉"}
        ListElement{value:"红薯粉"}
        ListElement{value:"红薯叶"}
        ListElement{value:"红糖"}
        ListElement{value:"红提"}
        ListElement{value:"红香蕉"}
        ListElement{value:"鸿喜菇"}
        ListElement{value:"红心萝卜"}
        ListElement{value:"红鲟"}
        ListElement{value:"红腰豆"}
        ListElement{value:"红叶苋菜"}
        ListElement{value:"红芸豆"}
        ListElement{value:"红玉苹果"}
        ListElement{value:"红枣"}
        ListElement{value:"虹鳟鱼"}
        ListElement{value:"猴头菇"}
        ListElement{value:"后腿肉"}
        ListElement{value:"后臀尖"}
        ListElement{value:"花菜"}
        ListElement{value:"花蛤"}
        ListElement{value:"花菇"}
        ListElement{value:"槐花"}
        ListElement{value:"花胶"}
        ListElement{value:"花椒"}
        ListElement{value:"花椒油"}
        ListElement{value:"话梅"}
        ListElement{value:"黄豆"}
        ListElement{value:"黄豆酱"}
        ListElement{value:"黄豆面"}
        ListElement{value:"黄豆芽"}
        ListElement{value:"黄鲂"}
        ListElement{value:"黄瓜"}
        ListElement{value:"黄骨鱼"}
        ListElement{value:"黄河蜜瓜"}
        ListElement{value:"黄花菜"}
        ListElement{value:"黄花鱼"}
        ListElement{value:"黄脚笠"}
        ListElement{value:"黄螺"}
        ListElement{value:"黄米"}
        ListElement{value:"黄米面"}
        ListElement{value:"黄蘑"}
        ListElement{value:"黄牛肉"}
        ListElement{value:"黄皮果"}
        ListElement{value:"黄芪"}
        ListElement{value:"黄秋葵"}
        ListElement{value:"黄颡鱼"}
        ListElement{value:"黄鳝"}
        ListElement{value:"黄糖"}
        ListElement{value:"黄桃"}
        ListElement{value:"黄桃酱"}
        ListElement{value:"黄蚬子"}
        ListElement{value:"黄心菜"}
        ListElement{value:"黄油"}
        ListElement{value:"黄鱼"}
        ListElement{value:"花茄子"}
        ListElement{value:"花生"}
        ListElement{value:"花生酱"}
        ListElement{value:"花生酱"}
        ListElement{value:"花生油"}
        ListElement{value:"滑子菇"}
        ListElement{value:"瓠瓜"}
        ListElement{value:"灰树花"}
        ListElement{value:"茴香"}
        ListElement{value:"茴香籽"}
        ListElement{value:"鮰鱼"}
        ListElement{value:"胡椒粉"}
        ListElement{value:"胡椒面"}
        ListElement{value:"葫芦"}
        ListElement{value:"胡萝卜"}
        ListElement{value:"胡麻油"}
        ListElement{value:"馄饨皮"}
        ListElement{value:"火鸡"}
        ListElement{value:"火龙果"}
        ListElement{value:"火腿"}
        ListElement{value:"湖盐"}
        ListElement{value:"葫子"}
        ListElement{value:"架豆"}
        ListElement{value:"豇豆"}
        ListElement{value:"江米"}
        ListElement{value:"酱油"}
        ListElement{value:"剑花"}
        ListElement{value:"尖椒"}
        ListElement{value:"碱蓬"}
        ListElement{value:"茭白"}
        ListElement{value:"饺子皮"}
        ListElement{value:"甲鱼"}
        ListElement{value:"甲鱼蛋"}
        ListElement{value:"鸡脖"}
        ListElement{value:"荠菜"}
        ListElement{value:"鸡翅"}
        ListElement{value:"鸡脆骨"}
        ListElement{value:"鸡蛋"}
        ListElement{value:"芥菜"}
        ListElement{value:"桔梗"}
        ListElement{value:"节瓜"}
        ListElement{value:"芥兰"}
        ListElement{value:"芥茉"}
        ListElement{value:"芥末酱"}
        ListElement{value:"鸡肝"}
        ListElement{value:"脊骨"}
        ListElement{value:"姬菇"}
        ListElement{value:"鸡骨草"}
        ListElement{value:"鸡骨架"}
        ListElement{value:"鸡精"}
        ListElement{value:"鸡毛菜"}
        ListElement{value:"锦丰梨"}
        ListElement{value:"京白梨"}
        ListElement{value:"京水菜"}
        ListElement{value:"金瓜"}
        ListElement{value:"精盐"}
        ListElement{value:"金桔"}
        ListElement{value:"金桔瓜"}
        ListElement{value:"金钱菇"}
        ListElement{value:"金枪鱼"}
        ListElement{value:"金枪鱼罐头"}
        ListElement{value:"金丝瓜"}
        ListElement{value:"金丝小枣"}
        ListElement{value:"金塔寺瓜"}
        ListElement{value:"金童玉女瓜"}
        ListElement{value:"金银花"}
        ListElement{value:"金针菇"}
        ListElement{value:"鸡皮"}
        ListElement{value:"鸡屁股"}
        ListElement{value:"鸡肉"}
        ListElement{value:"鸡肾"}
        ListElement{value:"姬松茸"}
        ListElement{value:"鸡头米"}
        ListElement{value:"鸡土从"}
        ListElement{value:"鸡腿"}
        ListElement{value:"鸡腿菇"}
        ListElement{value:"久保桃"}
        ListElement{value:"韭菜"}
        ListElement{value:"韭菜花"}
        ListElement{value:"韭黄"}
        ListElement{value:"韭苔"}
        ListElement{value:"基围虾"}
        ListElement{value:"鸡心"}
        ListElement{value:"鸡胸肉"}
        ListElement{value:"鸡血"}
        ListElement{value:"积雪草"}
        ListElement{value:"鲫鱼"}
        ListElement{value:"鸡杂"}
        ListElement{value:"鸡爪"}
        ListElement{value:"鸡胗"}
        ListElement{value:"鸡中翅"}
        ListElement{value:"鸡肫"}
        ListElement{value:"鸡枞"}
        ListElement{value:"蕨菜"}
        ListElement{value:"蕨根粉"}
        ListElement{value:"蕨麻"}
        ListElement{value:"决明子"}
        ListElement{value:"巨峰葡萄"}
        ListElement{value:"菊花"}
        ListElement{value:"菊花菜"}
        ListElement{value:"军曹鱼"}
        ListElement{value:"橘皮"}
        ListElement{value:"蒟蒻"}
        ListElement{value:"锯缘青蟹"}
        ListElement{value:"桔子"}
        ListElement{value:"菊苣"}
        ListElement{value:"橘子"}
        ListElement{value:"咖啡豆"}
        ListElement{value:"咖啡粉"}
        ListElement{value:"咖啡甜酒"}
        ListElement{value:"开心果"}
        ListElement{value:"康乃馨"}
        ListElement{value:"烤麸"}
        ListElement{value:"可可粉"}
        ListElement{value:"孔雀蛤"}
        ListElement{value:"空心菜"}
        ListElement{value:"口蘑"}
        ListElement{value:"快菜"}
        ListElement{value:"块根芹"}
        ListElement{value:"宽粉"}
        ListElement{value:"苦丁"}
        ListElement{value:"苦豆子"}
        ListElement{value:"库尔勒梨"}
        ListElement{value:"苦瓜"}
        ListElement{value:"葵花油"}
        ListElement{value:"葵花籽油"}
        ListElement{value:"苦菊"}
        ListElement{value:"苦苣菜"}
        ListElement{value:"苦苣"}
        ListElement{value:"苦参"}
        ListElement{value:"苦细叶生菜"}
        ListElement{value:"苦竹叶"}
        ListElement{value:"辣根"}
        ListElement{value:"喇蛄"}
        ListElement{value:"莱菔子"}
        ListElement{value:"莱阳梨"}
        ListElement{value:"辣椒"}
        ListElement{value:"辣椒酱"}
        ListElement{value:"辣椒油"}
        ListElement{value:"兰花"}
        ListElement{value:"兰花蚌"}
        ListElement{value:"蓝莓"}
        ListElement{value:"蓝莓酱"}
        ListElement{value:"酪梨"}
        ListElement{value:"老母鸡"}
        ListElement{value:"醪糟"}
        ListElement{value:"腊肉"}
        ListElement{value:"肋排"}
        ListElement{value:"雷笋"}
        ListElement{value:"棱角丝瓜"}
        ListElement{value:"鳓鱼"}
        ListElement{value:"梨"}
        ListElement{value:"莲蕉"}
        ListElement{value:"莲藕"}
        ListElement{value:"炼乳"}
        ListElement{value:"莲雾"}
        ListElement{value:"鲢鱼"}
        ListElement{value:"莲子"}
        ListElement{value:"里脊"}
        ListElement{value:"李林蕉"}
        ListElement{value:"藜麦"}
        ListElement{value:"菱角"}
        ListElement{value:"鲮鲫鱼"}
        ListElement{value:"鲮鱼"}
        ListElement{value:"灵芝"}
        ListElement{value:"荔浦芋"}
        ListElement{value:"梨山甘蓝"}
        ListElement{value:"柳兰"}
        ListElement{value:"榴莲"}
        ListElement{value:"柳松菇"}
        ListElement{value:"柳叶鱼"}
        ListElement{value:"鲤鱼"}
        ListElement{value:"荔枝"}
        ListElement{value:"荔枝菌"}
        ListElement{value:"栗子"}
        ListElement{value:"李子"}
        ListElement{value:"李子杏"}
        ListElement{value:"龙骨"}
        ListElement{value:"龙井"}
        ListElement{value:"龙利鱼"}
        ListElement{value:"龙虾"}
        ListElement{value:"龙牙豆"}
        ListElement{value:"漏芦"}
        ListElement{value:"卤蛋"}
        ListElement{value:"芦柑"}
        ListElement{value:"芦蒿"}
        ListElement{value:"芦荟"}
        ListElement{value:"芦荟"}
        ListElement{value:"露葵"}
        ListElement{value:"轮叶党参"}
        ListElement{value:"萝卜"}
        ListElement{value:"萝卜苗"}
        ListElement{value:"萝卜缨"}
        ListElement{value:"萝卜缨"}
        ListElement{value:"罗非鱼"}
        ListElement{value:"罗非鱼"}
        ListElement{value:"罗汉果"}
        ListElement{value:"罗汉笋"}
        ListElement{value:"罗勒"}
        ListElement{value:"螺肉"}
        ListElement{value:"洛神花"}
        ListElement{value:"螺蛳"}
        ListElement{value:"螺旋藻"}
        ListElement{value:"鹿肉"}
        ListElement{value:"芦笋"}
        ListElement{value:"鲈鱼"}
        ListElement{value:"驴鞭"}
        ListElement{value:"绿茶"}
        ListElement{value:"绿茶粉"}
        ListElement{value:"绿长茄"}
        ListElement{value:"绿橙"}
        ListElement{value:"绿豆"}
        ListElement{value:"绿豆芽"}
        ListElement{value:"绿豆鱼"}
        ListElement{value:"驴肉"}
        ListElement{value:"绿苏"}
        ListElement{value:"绿叶生菜"}
        ListElement{value:"绿叶苋菜"}
        ListElement{value:"绿圆茄"}
        ListElement{value:"马鞭草"}
        ListElement{value:"马齿菜"}
        ListElement{value:"马齿苋"}
        ListElement{value:"马哈鱼"}
        ListElement{value:"麦瓶草"}
        ListElement{value:"麦仁"}
        ListElement{value:"麦芽"}
        ListElement{value:"麦芽糖"}
        ListElement{value:"马兰头"}
        ListElement{value:"马奶子葡萄"}
        ListElement{value:"玛瑙石榴"}
        ListElement{value:"芒果"}
        ListElement{value:"鳗鱼"}
        ListElement{value:"蔓越莓"}
        ListElement{value:"蔓越莓"}
        ListElement{value:"毛豆"}
        ListElement{value:"毛蚶"}
        ListElement{value:"毛核桃"}
        ListElement{value:"玛琪琳"}
        ListElement{value:"麻雀蛋"}
        ListElement{value:"马肉"}
        ListElement{value:"马乳"}
        ListElement{value:"马苏里拉芝士"}
        ListElement{value:"马蹄黄梨"}
        ListElement{value:"马心"}
        ListElement{value:"马牙大豆"}
        ListElement{value:"麻油"}
        ListElement{value:"马郁兰"}
        ListElement{value:"糜（糜子）"}
        ListElement{value:"梅干菜"}
        ListElement{value:"玫瑰花"}
        ListElement{value:"玫瑰蕉"}
        ListElement{value:"玫瑰香葡萄"}
        ListElement{value:"美国大杏仁"}
        ListElement{value:"梅花"}
        ListElement{value:"美人椒"}
        ListElement{value:"梅肉酱"}
        ListElement{value:"梅子"}
        ListElement{value:"绵白糖"}
        ListElement{value:"面包"}
        ListElement{value:"面包果"}
        ListElement{value:"面豉"}
        ListElement{value:"面条"}
        ListElement{value:"面条菜"}
        ListElement{value:"面线"}
        ListElement{value:"鮸鱼"}
        ListElement{value:"棉籽油"}
        ListElement{value:"米醋"}
        ListElement{value:"迷迭香"}
        ListElement{value:"迷迭香"}
        ListElement{value:"米豆腐"}
        ListElement{value:"米饭"}
        ListElement{value:"米粉"}
        ListElement{value:"猕猴桃"}
        ListElement{value:"蜜桔"}
        ListElement{value:"明太鱼"}
        ListElement{value:"明虾"}
        ListElement{value:"明月梨"}
        ListElement{value:"蜜蛇瓜"}
        ListElement{value:"米苔目"}
        ListElement{value:"米线"}
        ListElement{value:"米形面"}
        ListElement{value:"米鱼"}
        ListElement{value:"密云小枣"}
        ListElement{value:"抹茶粉"}
        ListElement{value:"蘑菇"}
        ListElement{value:"茉莉花"}
        ListElement{value:"磨盘柿"}
        ListElement{value:"墨西哥辣椒"}
        ListElement{value:"墨鱼"}
        ListElement{value:"墨鱼蛋"}
        ListElement{value:"魔芋"}
        ListElement{value:"魔芋丝"}
        ListElement{value:"木豆"}
        ListElement{value:"木耳"}
        ListElement{value:"木耳菜"}
        ListElement{value:"木榧"}
        ListElement{value:"木瓜"}
        ListElement{value:"木姜子"}
        ListElement{value:"牡蛎"}
        ListElement{value:"木梨"}
        ListElement{value:"木莲"}
        ListElement{value:"木薯"}
        ListElement{value:"木香"}
        ListElement{value:"苜蓿"}
        ListElement{value:"苜蓿芽"}
        ListElement{value:"木鱼干"}
        ListElement{value:"木鱼花"}
        ListElement{value:"木鱼精"}
        ListElement{value:"奶白菜"}
        ListElement{value:"奶粉"}
        ListElement{value:"奶酪"}
        ListElement{value:"奶柿子"}
        ListElement{value:"奶油"}
        ListElement{value:"奶油生菜"}
        ListElement{value:"南板蓝叶"}
        ListElement{value:"南豆腐"}
        ListElement{value:"南瓜"}
        ListElement{value:"南瓜粉"}
        ListElement{value:"南瓜藤"}
        ListElement{value:"南瓜子"}
        ListElement{value:"南极磷虾"}
        ListElement{value:"南美螺"}
        ListElement{value:"南美虾"}
        ListElement{value:"南沙参"}
        ListElement{value:"南芎"}
        ListElement{value:"内酯豆腐"}
        ListElement{value:"嫩豆腐"}
        ListElement{value:"年糕"}
        ListElement{value:"粘米粉"}
        ListElement{value:"鲶鱼"}
        ListElement{value:"黏玉米"}
        ListElement{value:"鸟贝"}
        ListElement{value:"尼罗红鱼"}
        ListElement{value:"柠檬"}
        ListElement{value:"柠檬草"}
        ListElement{value:"柠檬片"}
        ListElement{value:"泥鳅"}
        ListElement{value:"牛百叶"}
        ListElement{value:"牛百叶"}
        ListElement{value:"牛蒡叶"}
        ListElement{value:"牛鞭"}
        ListElement{value:"牛初乳"}
        ListElement{value:"牛大肠"}
        ListElement{value:"牛肚"}
        ListElement{value:"牛肺"}
        ListElement{value:"牛肝"}
        ListElement{value:"牛肝菌"}
        ListElement{value:"牛骨"}
        ListElement{value:"牛骨髓"}
        ListElement{value:"牛黄"}
        ListElement{value:"牛腱子"}
        ListElement{value:"牛腱子肉"}
        ListElement{value:"牛筋"}
        ListElement{value:"牛肋骨"}
        ListElement{value:"牛里脊"}
        ListElement{value:"牛奶"}
        ListElement{value:"牛腩"}
        ListElement{value:"牛脑"}
        ListElement{value:"牛排"}
        ListElement{value:"牛蒡"}
        ListElement{value:"牛肉"}
        ListElement{value:"牛肉酱"}
        ListElement{value:"牛上脑"}
        ListElement{value:"牛舌"}
        ListElement{value:"牛肾"}
        ListElement{value:"牛髓"}
        ListElement{value:"牛蹄"}
        ListElement{value:"牛蹄筋"}
        ListElement{value:"牛头皮"}
        ListElement{value:"牛腿肉"}
        ListElement{value:"牛蛙"}
        ListElement{value:"牛外脊"}
        ListElement{value:"牛尾"}
        ListElement{value:"牛尾笋"}
        ListElement{value:"牛五花肉"}
        ListElement{value:"牛膝"}
        ListElement{value:"牛小排"}
        ListElement{value:"牛膝盖骨"}
        ListElement{value:"牛心"}
        ListElement{value:"牛血"}
        ListElement{value:"牛眼睛菌"}
        ListElement{value:"牛油"}
        ListElement{value:"牛油果"}
        ListElement{value:"牛杂"}
        ListElement{value:"牛仔骨"}
        ListElement{value:"牛至"}
        ListElement{value:"牛油果"}
        ListElement{value:"糯米"}
        ListElement{value:"糯米粉"}
        ListElement{value:"女贞子"}
        ListElement{value:"藕"}
        ListElement{value:"藕带"}
        ListElement{value:"藕粉"}
        ListElement{value:"排骨"}
        ListElement{value:"爬景天"}
        ListElement{value:"胖头鱼"}
        ListElement{value:"螃蟹"}
        ListElement{value:"泡打粉"}
        ListElement{value:"培根"}
        ListElement{value:"胚芽米"}
        ListElement{value:"蓬莱米"}
        ListElement{value:"喷瓜"}
        ListElement{value:"瓢儿白"}
        ListElement{value:"皮蛋"}
        ListElement{value:"苤蓝"}
        ListElement{value:"平菇"}
        ListElement{value:"苹果"}
        ListElement{value:"苹果酱"}
        ListElement{value:"苹果梨"}
        ListElement{value:"平鱼"}
        ListElement{value:"枇杷"}
        ListElement{value:"琵琶腿"}
        ListElement{value:"皮皮虾"}
        ListElement{value:"破布子"}
        ListElement{value:"婆罗门参"}
        ListElement{value:"蒲菜"}
        ListElement{value:"普洱"}
        ListElement{value:"蒲公草"}
        ListElement{value:"蒲公英"}
        ListElement{value:"蒲瓜"}
        ListElement{value:"葡萄籽油"}
        ListElement{value:"葡萄"}
        ListElement{value:"葡萄干"}
        ListElement{value:"葡萄柚"}
        ListElement{value:"掐不齐"}
        ListElement{value:"千岛酱"}
        ListElement{value:"腔骨"}
        ListElement{value:"芡实"}
        ListElement{value:"芡实米"}
        ListElement{value:"前臀尖"}
        ListElement{value:"千页豆腐"}
        ListElement{value:"千张"}
        ListElement{value:"巧克力"}
        ListElement{value:"巧克力豆"}
        ListElement{value:"巧克力酱"}
        ListElement{value:"巧克力酱"}
        ListElement{value:"荞麦"}
        ListElement{value:"荞麦米"}
        ListElement{value:"荞麦面"}
        ListElement{value:"荞麦面粉"}
        ListElement{value:"荞头"}
        ListElement{value:"茄冬叶"}
        ListElement{value:"茄瓜"}
        ListElement{value:"茄子"}
        ListElement{value:"芹菜"}
        ListElement{value:"芹菜叶"}
        ListElement{value:"青菜"}
        ListElement{value:"青豆"}
        ListElement{value:"庆丰桃"}
        ListElement{value:"青甘鱼"}
        ListElement{value:"青花椒"}
        ListElement{value:"青江菜"}
        ListElement{value:"青椒"}
        ListElement{value:"青金针花"}
        ListElement{value:"青稞"}
        ListElement{value:"青口贝"}
        ListElement{value:"青蓼"}
        ListElement{value:"青龙虾"}
        ListElement{value:"青萝卜"}
        ListElement{value:"青芒果"}
        ListElement{value:"青梅"}
        ListElement{value:"清明菜"}
        ListElement{value:"青木瓜"}
        ListElement{value:"青苹果"}
        ListElement{value:"青蒜"}
        ListElement{value:"青头菌"}
        ListElement{value:"青虾"}
        ListElement{value:"青葙子"}
        ListElement{value:"青蟹"}
        ListElement{value:"青鱼"}
        ListElement{value:"青鱼肝"}
        ListElement{value:"青竹"}
        ListElement{value:"琼脂"}
        ListElement{value:"起司"}
        ListElement{value:"秋刀鱼"}
        ListElement{value:"秋蛤蜊"}
        ListElement{value:"秋黄瓜"}
        ListElement{value:"球茎茴香"}
        ListElement{value:"球茎茴香"}
        ListElement{value:"秋葵"}
        ListElement{value:"秋里蒙苹果"}
        ListElement{value:"球生菜"}
        ListElement{value:"七叶胆"}
        ListElement{value:"旗鱼"}
        ListElement{value:"鲭鱼"}
        ListElement{value:"全蛋液"}
        ListElement{value:"全麦面粉"}
        ListElement{value:"全脂牛奶"}
        ListElement{value:"裙边"}
        ListElement{value:"裙带菜"}
        ListElement{value:"人参"}
        ListElement{value:"人参果"}
        ListElement{value:"人心果"}
        ListElement{value:"日本豆腐"}
        ListElement{value:"日本南瓜"}
        ListElement{value:"肉豆蔻"}
        ListElement{value:"肉桂"}
        ListElement{value:"肉桂粉"}
        ListElement{value:"肉魽鱼"}
        ListElement{value:"肉鸡"}
        ListElement{value:"肉末"}
        ListElement{value:"肉松"}
        ListElement{value:"肉蟹"}
        ListElement{value:"乳鸽"}
        ListElement{value:"乳酪"}
        ListElement{value:"软丝"}
        ListElement{value:"软丝藻"}
        ListElement{value:"三道鳞"}
        ListElement{value:"桑葚"}
        ListElement{value:"桑叶"}
        ListElement{value:"三黄鸡"}
        ListElement{value:"三文鱼"}
        ListElement{value:"三文鱼头"}
        ListElement{value:"散叶生菜"}
        ListElement{value:"三叶香"}
        ListElement{value:"色拉油"}
        ListElement{value:"沙丁鱼"}
        ListElement{value:"沙葛"}
        ListElement{value:"沙果"}
        ListElement{value:"沙棘"}
        ListElement{value:"沙尖鱼"}
        ListElement{value:"沙拉酱"}
        ListElement{value:"沙梨"}
        ListElement{value:"扇贝"}
        ListElement{value:"山菜"}
        ListElement{value:"山茶油"}
        ListElement{value:"上海青"}
        ListElement{value:"山核桃"}
        ListElement{value:"珊瑚草"}
        ListElement{value:"珊瑚菇"}
        ListElement{value:"山鸡"}
        ListElement{value:"山椒粉"}
        ListElement{value:"山葵"}
        ListElement{value:"山兰米"}
        ListElement{value:"山莓"}
        ListElement{value:"山苏"}
        ListElement{value:"山药"}
        ListElement{value:"山药豆"}
        ListElement{value:"鳝鱼"}
        ListElement{value:"山楂"}
        ListElement{value:"山楂干"}
        ListElement{value:"山楂酱"}
        ListElement{value:"山竹"}
        ListElement{value:"沙窝萝卜"}
        ListElement{value:"鲨鱼"}
        ListElement{value:"鲨鱼骨"}
        ListElement{value:"沙钻鱼"}
        ListElement{value:"蛇果"}
        ListElement{value:"蛇莓"}
        ListElement{value:"生菜"}
        ListElement{value:"生抽"}
        ListElement{value:"生粉"}
        ListElement{value:"生瓜"}
        ListElement{value:"生蚝"}
        ListElement{value:"生姜"}
        ListElement{value:"圣女果"}
        ListElement{value:"神秘果"}
        ListElement{value:"蔘须"}
        ListElement{value:"蛇肉"}
        ListElement{value:"蛇鲻"}
        ListElement{value:"石斑鱼"}
        ListElement{value:"石耳"}
        ListElement{value:"石花菜"}
        ListElement{value:"石花菜"}
        ListElement{value:"释迦"}
        ListElement{value:"石榴"}
        ListElement{value:"石螺"}
        ListElement{value:"虱目鱼"}
        ListElement{value:"狮头鱼"}
        ListElement{value:"石蟹"}
        ListElement{value:"食用大黄"}
        ListElement{value:"食用色素"}
        ListElement{value:"鲥鱼"}
        ListElement{value:"柿子"}
        ListElement{value:"柿子椒"}
        ListElement{value:"寿司米"}
        ListElement{value:"首乌"}
        ListElement{value:"双孢菇"}
        ListElement{value:"双孢蘑菇"}
        ListElement{value:"树番茄"}
        ListElement{value:"水果藕"}
        ListElement{value:"水葫芦"}
        ListElement{value:"水晶糖"}
        ListElement{value:"水晶鱼"}
        ListElement{value:"水萝卜"}
        ListElement{value:"水麦芽"}
        ListElement{value:"水蜜桃"}
        ListElement{value:"蒲桃"}
        ListElement{value:"水芹菜"}
        ListElement{value:"水田芹"}
        ListElement{value:"水鸭"}
        ListElement{value:"树莓"}
        ListElement{value:"鼠尾草"}
        ListElement{value:"丝瓜"}
        ListElement{value:"丝瓜尖"}
        ListElement{value:"四季豆"}
        ListElement{value:"四棱豆"}
        ListElement{value:"丝苗米"}
        ListElement{value:"四破鱼"}
        ListElement{value:"松花蛋"}
        ListElement{value:"松蘑"}
        ListElement{value:"松针茶"}
        ListElement{value:"松子"}
        ListElement{value:"手指胡萝卜"}
        ListElement{value:"蒜黄"}
        ListElement{value:"蒜苗"}
        ListElement{value:"酸模"}
        ListElement{value:"酸奶"}
        ListElement{value:"蒜蓉酱"}
        ListElement{value:"蒜薹"}
        ListElement{value:"酸枣"}
        ListElement{value:"酸枣仁"}
        ListElement{value:"苏打粉"}
        ListElement{value:"粟粉"}
        ListElement{value:"水果苤蓝"}
        ListElement{value:"素鸡"}
        ListElement{value:"粟米"}
        ListElement{value:"笋"}
        ListElement{value:"笋尖"}
        ListElement{value:"梭鱼"}
        ListElement{value:"梭子蟹"}
        ListElement{value:"速溶酵母"}
        ListElement{value:"苏子叶"}
        ListElement{value:"塔菜"}
        ListElement{value:"苔菜"}
        ListElement{value:"泰国香米"}
        ListElement{value:"太阳鱼"}
        ListElement{value:"鲐鱼"}
        ListElement{value:"太子参"}
        ListElement{value:"鳎目鱼"}
        ListElement{value:"糖粉"}
        ListElement{value:"糖浆"}
        ListElement{value:"塘鲺"}
        ListElement{value:"糖霜"}
        ListElement{value:"桃"}
        ListElement{value:"桃胶"}
        ListElement{value:"桃仁"}
        ListElement{value:"塔塔粉"}
        ListElement{value:"甜菜"}
        ListElement{value:"甜菜根"}
        ListElement{value:"甜菜叶"}
        ListElement{value:"甜豆"}
        ListElement{value:"甜瓜"}
        ListElement{value:"田鸡"}
        ListElement{value:"田鸡腿"}
        ListElement{value:"田螺"}
        ListElement{value:"天麻"}
        ListElement{value:"甜面酱"}
        ListElement{value:"甜玉米"}
        ListElement{value:"调和油"}
        ListElement{value:"鲦鱼"}
        ListElement{value:"铁观音"}
        ListElement{value:"铁棍山药"}
        ListElement{value:"鯷鱼"}
        ListElement{value:"提子"}
        ListElement{value:"通草"}
        ListElement{value:"茼蒿"}
        ListElement{value:"通心粉"}
        ListElement{value:"土豆"}
        ListElement{value:"土番鸭"}
        ListElement{value:"土鸡"}
        ListElement{value:"脱脂奶粉"}
        ListElement{value:"兔肉"}
        ListElement{value:"土三七"}
        ListElement{value:"土虱鱼"}
        ListElement{value:"吐司"}
        ListElement{value:"兔头"}
        ListElement{value:"歪头菜"}
        ListElement{value:"豌豆"}
        ListElement{value:"豌豆尖"}
        ListElement{value:"豌豆尖"}
        ListElement{value:"豌豆苗"}
        ListElement{value:"旺仔QQ糖"}
        ListElement{value:"娃娃菜"}
        ListElement{value:"味精"}
        ListElement{value:"鲔鱼"}
        ListElement{value:"文昌鸡"}
        ListElement{value:"文蛤"}
        ListElement{value:"吻仔鱼"}
        ListElement{value:"窝瓜"}
        ListElement{value:"倭锦苹果"}
        ListElement{value:"莴苣"}
        ListElement{value:"莴苣叶"}
        ListElement{value:"蜗牛"}
        ListElement{value:"莴笋"}
        ListElement{value:"莴笋叶"}
        ListElement{value:"乌菜"}
        ListElement{value:"五彩椒"}
        ListElement{value:"午餐肉"}
        ListElement{value:"武昌鱼"}
        ListElement{value:"乌醋"}
        ListElement{value:"舞菇"}
        ListElement{value:"吴郭鱼"}
        ListElement{value:"无花果"}
        ListElement{value:"五花肉"}
        ListElement{value:"乌鸡"}
        ListElement{value:"乌江鱼"}
        ListElement{value:"乌鸡蛋"}
        ListElement{value:"芜菁"}
        ListElement{value:"乌龙茶"}
        ListElement{value:"乌龙面"}
        ListElement{value:"乌塌菜"}
        ListElement{value:"乌塌菜"}
        ListElement{value:"乌头鱼"}
        ListElement{value:"五香粉"}
        ListElement{value:"乌鱼子"}
        ListElement{value:"乌仔鱼"}
        ListElement{value:"乌贼"}
        ListElement{value:"虾"}
        ListElement{value:"虾潺"}
        ListElement{value:"虾虎"}
        ListElement{value:"虾酱"}
        ListElement{value:"虾米"}
        ListElement{value:"鲜鲍"}
        ListElement{value:"鲜贝"}
        ListElement{value:"苋菜"}
        ListElement{value:"仙草"}
        ListElement{value:"咸鹅蛋"}
        ListElement{value:"象拔蚌"}
        ListElement{value:"香菜"}
        ListElement{value:"香草"}
        ListElement{value:"香草粉"}
        ListElement{value:"香草精"}
        ListElement{value:"香肠"}
        ListElement{value:"香椽"}
        ListElement{value:"香椿"}
        ListElement{value:"香葱"}
        ListElement{value:"香榧"}
        ListElement{value:"香蜂草"}
        ListElement{value:"香干"}
        ListElement{value:"香菇"}
        ListElement{value:"香瓜"}
        ListElement{value:"香菇酱"}
        ListElement{value:"香海螺"}
        ListElement{value:"襄荷"}
        ListElement{value:"香蕉"}
        ListElement{value:"香蕉西葫芦"}
        ListElement{value:"香螺"}
        ListElement{value:"香米"}
        ListElement{value:"橡皮鱼"}
        ListElement{value:"香蒲"}
        ListElement{value:"香芹"}
        ListElement{value:"橡实"}
        ListElement{value:"香叶"}
        ListElement{value:"香油"}
        ListElement{value:"香芋"}
        ListElement{value:"鲜姜"}
        ListElement{value:"线椒"}
        ListElement{value:"咸鸡蛋"}
        ListElement{value:"籼米"}
        ListElement{value:"鲜奶油"}
        ListElement{value:"线茄"}
        ListElement{value:"仙人掌"}
        ListElement{value:"仙人掌果"}
        ListElement{value:"咸肉"}
        ListElement{value:"香鱼"}
        ListElement{value:"咸鸭蛋"}
        ListElement{value:"蚬子肉"}
        ListElement{value:"小白菜"}
        ListElement{value:"小扁豆"}
        ListElement{value:"小草菇"}
        ListElement{value:"小葱"}
        ListElement{value:"小冬瓜"}
        ListElement{value:"小豆"}
        ListElement{value:"小豆蔻"}
        ListElement{value:"小河虾"}
        ListElement{value:"小黄瓜"}
        ListElement{value:"小胡桃"}
        ListElement{value:"小里脊肉"}
        ListElement{value:"小龙虾"}
        ListElement{value:"小麦"}
        ListElement{value:"小麦淀粉"}
        ListElement{value:"小麦粉"}
        ListElement{value:"小米"}
        ListElement{value:"小米蕉"}
        ListElement{value:"小米面"}
        ListElement{value:"小水萝卜"}
        ListElement{value:"小苏打"}
        ListElement{value:"小虾"}
        ListElement{value:"小西瓜"}
        ListElement{value:"小西红柿"}
        ListElement{value:"小叶茼蒿"}
        ListElement{value:"小圆豆"}
        ListElement{value:"小芋头"}
        ListElement{value:"虾皮"}
        ListElement{value:"虾仁"}
        ListElement{value:"虾肉"}
        ListElement{value:"虾籽"}
        ListElement{value:"薤白"}
        ListElement{value:"蟹棒"}
        ListElement{value:"蟹柳"}
        ListElement{value:"血糯米"}
        ListElement{value:"蟹肉"}
        ListElement{value:"蟹味菇"}
        ListElement{value:"蟹子"}
        ListElement{value:"西番莲"}
        ListElement{value:"西贡蕉"}
        ListElement{value:"西瓜"}
        ListElement{value:"西瓜子"}
        ListElement{value:"西红柿"}
        ListElement{value:"西葫芦"}
        ListElement{value:"西兰花"}
        ListElement{value:"西梅"}
        ListElement{value:"西米"}
        ListElement{value:"杏"}
        ListElement{value:"杏鲍菇"}
        ListElement{value:"杏仁"}
        ListElement{value:"杏仁粉"}
        ListElement{value:"杏仁油"}
        ListElement{value:"心里美"}
        ListElement{value:"心里美萝卜"}
        ListElement{value:"熊掌"}
        ListElement{value:"西芹"}
        ListElement{value:"细砂糖"}
        ListElement{value:"西生菜"}
        ListElement{value:"西施舌"}
        ListElement{value:"秀珍菇"}
        ListElement{value:"袖珍菇"}
        ListElement{value:"西洋菜"}
        ListElement{value:"西洋梨"}
        ListElement{value:"血"}
        ListElement{value:"雪斑鱼"}
        ListElement{value:"雪菜"}
        ListElement{value:"血橙"}
        ListElement{value:"雪蛤"}
        ListElement{value:"血红菇"}
        ListElement{value:"雪花梨"}
        ListElement{value:"雪莲"}
        ListElement{value:"雪里红"}
        ListElement{value:"雪里蕻"}
        ListElement{value:"雪利酒"}
        ListElement{value:"鳕鱼"}
        ListElement{value:"熏干"}
        ListElement{value:"熏肉"}
        ListElement{value:"薰衣草"}
        ListElement{value:"鲟鱼"}
        ListElement{value:"旭松纳豆"}
        ListElement{value:"鸭脖"}
        ListElement{value:"芽菜"}
        ListElement{value:"鸭肠"}
        ListElement{value:"鸭翅"}
        ListElement{value:"鸭蛋"}
        ListElement{value:"鸭肝"}
        ListElement{value:"鸭广梨"}
        ListElement{value:"鸭架"}
        ListElement{value:"鸭梨"}
        ListElement{value:"亚麻仁"}
        ListElement{value:"亚麻籽油"}
        ListElement{value:"洋葱"}
        ListElement{value:"羊大肠"}
        ListElement{value:"羊肚"}
        ListElement{value:"羊肚菌"}
        ListElement{value:"羊肺"}
        ListElement{value:"羊肝"}
        ListElement{value:"洋甘菊"}
        ListElement{value:"羊骨"}
        ListElement{value:"羊后腿肉"}
        ListElement{value:"洋姜"}
        ListElement{value:"羊肩排"}
        ListElement{value:"羊里脊"}
        ListElement{value:"杨梅"}
        ListElement{value:"羊奶"}
        ListElement{value:"羊腩"}
        ListElement{value:"羊脑"}
        ListElement{value:"羊排"}
        ListElement{value:"羊前腿肉"}
        ListElement{value:"羊栖菜"}
        ListElement{value:"羊肉"}
        ListElement{value:"羊舌"}
        ListElement{value:"羊髓"}
        ListElement{value:"杨桃"}
        ListElement{value:"羊蹄"}
        ListElement{value:"羊蹄筋"}
        ListElement{value:"羊头"}
        ListElement{value:"羊头肉"}
        ListElement{value:"羊腿肉"}
        ListElement{value:"羊臀"}
        ListElement{value:"羊尾笋"}
        ListElement{value:"羊蝎子"}
        ListElement{value:"羊心"}
        ListElement{value:"养心菜"}
        ListElement{value:"羊血"}
        ListElement{value:"羊眼"}
        ListElement{value:"羊腰子"}
        ListElement{value:"羊腰子"}
        ListElement{value:"羊油"}
        ListElement{value:"燕麦"}
        ListElement{value:"燕麦片"}
        ListElement{value:"岩米"}
        ListElement{value:"腰果"}
        ListElement{value:"瑶柱"}
        ListElement{value:"鸦片鱼"}
        ListElement{value:"鸭肉"}
        ListElement{value:"鸭舌"}
        ListElement{value:"鸭舌头"}
        ListElement{value:"鸭头"}
        ListElement{value:"鸭腿"}
        ListElement{value:"燕窝"}
        ListElement{value:"鸭血"}
        ListElement{value:"鸭心"}
        ListElement{value:"鸭胸"}
        ListElement{value:"鸭胰"}
        ListElement{value:"鸭油"}
        ListElement{value:"鸭掌"}
        ListElement{value:"鸭胗"}
        ListElement{value:"鸭跖草"}
        ListElement{value:"鸭肫"}
        ListElement{value:"鸭子"}
        ListElement{value:"野葱"}
        ListElement{value:"野韭菜"}
        ListElement{value:"野菊"}
        ListElement{value:"夜开花"}
        ListElement{value:"野米"}
        ListElement{value:"野荞"}
        ListElement{value:"野蒜"}
        ListElement{value:"叶菾菜"}
        ListElement{value:"野兔"}
        ListElement{value:"野味"}
        ListElement{value:"野鸭"}
        ListElement{value:"椰枣"}
        ListElement{value:"椰汁"}
        ListElement{value:"野猪肉"}
        ListElement{value:"椰子"}
        ListElement{value:"椰子粉"}
        ListElement{value:"椰子肉"}
        ListElement{value:"椰子油"}
        ListElement{value:"贻贝"}
        ListElement{value:"意大利面"}
        ListElement{value:"意粉酱"}
        ListElement{value:"薏米"}
        ListElement{value:"意面"}
        ListElement{value:"意面酱"}
        ListElement{value:"益母草"}
        ListElement{value:"印度飞饼"}
        ListElement{value:"印度苹果"}
        ListElement{value:"银耳"}
        ListElement{value:"樱花虾"}
        ListElement{value:"樱桃"}
        ListElement{value:"樱桃萝卜"}
        ListElement{value:"鹰嘴豆"}
        ListElement{value:"阴米"}
        ListElement{value:"银鳕鱼"}
        ListElement{value:"银鱼"}
        ListElement{value:"鳙鱼"}
        ListElement{value:"油菜"}
        ListElement{value:"油菜花"}
        ListElement{value:"油菜薹"}
        ListElement{value:"油茶籽油"}
        ListElement{value:"油豆腐"}
        ListElement{value:"油豆角"}
        ListElement{value:"油豆皮"}
        ListElement{value:"有机菜花"}
        ListElement{value:"油麦菜"}
        ListElement{value:"莜麦面"}
        ListElement{value:"油面筋"}
        ListElement{value:"油皮"}
        ListElement{value:"油条"}
        ListElement{value:"鱿鱼"}
        ListElement{value:"鱿鱼板"}
        ListElement{value:"鱿鱼圈"}
        ListElement{value:"鱿鱼头"}
        ListElement{value:"鱿鱼须"}
        ListElement{value:"柚子"}
        ListElement{value:"圆白菜"}
        ListElement{value:"元蘑"}
        ListElement{value:"鱼鳔"}
        ListElement{value:"鱼翅"}
        ListElement{value:"鱼唇"}
        ListElement{value:"鱼豆腐"}
        ListElement{value:"越瓜"}
        ListElement{value:"越光米"}
        ListElement{value:"月桂叶"}
        ListElement{value:"鱼干"}
        ListElement{value:"余柑子"}
        ListElement{value:"榆黄菇"}
        ListElement{value:"鱼胶粉"}
        ListElement{value:"郁金"}
        ListElement{value:"郁金香粉"}
        ListElement{value:"鱼露"}
        ListElement{value:"鱼卵"}
        ListElement{value:"玉米"}
        ListElement{value:"玉米淀粉"}
        ListElement{value:"玉米面"}
        ListElement{value:"玉米片"}
        ListElement{value:"玉米糁"}
        ListElement{value:"玉米油"}
        ListElement{value:"芸豆"}
        ListElement{value:"鱼泡"}
        ListElement{value:"鱼皮"}
        ListElement{value:"鱼片"}
        ListElement{value:"榆钱"}
        ListElement{value:"鱼松"}
        ListElement{value:"芋头"}
        ListElement{value:"鱼丸"}
        ListElement{value:"鱼尾"}
        ListElement{value:"鱼下巴"}
        ListElement{value:"鱼腥草"}
        ListElement{value:"鱼油"}
        ListElement{value:"鱼头"}
        ListElement{value:"鱼杂"}
        ListElement{value:"鱼籽"}
        ListElement{value:"鱼子酱"}
        ListElement{value:"枣"}
        ListElement{value:"皂角米"}
        ListElement{value:"早桔"}
        ListElement{value:"杂色蛤蜊"}
        ListElement{value:"榨菜"}
        ListElement{value:"章鱼"}
        ListElement{value:"章鱼脚"}
        ListElement{value:"折耳根"}
        ListElement{value:"整鸡"}
        ListElement{value:"榛蘑"}
        ListElement{value:"真蛸"}
        ListElement{value:"针鱼"}
        ListElement{value:"珍珠"}
        ListElement{value:"珍珠菇"}
        ListElement{value:"珍珠花菜"}
        ListElement{value:"珍珠梅"}
        ListElement{value:"珍珠石斑"}
        ListElement{value:"珍珠糖"}
        ListElement{value:"榛子"}
        ListElement{value:"蜇皮"}
        ListElement{value:"蔗糖"}
        ListElement{value:"芝麻"}
        ListElement{value:"芝麻菜"}
        ListElement{value:"芝麻酱"}
        ListElement{value:"芝麻酱"}
        ListElement{value:"芝麻蕉"}
        ListElement{value:"芝麻油"}
        ListElement{value:"芝士"}
        ListElement{value:"芝士粉"}
        ListElement{value:"植物奶油"}
        ListElement{value:"植物油"}
        ListElement{value:"栀子花"}
        ListElement{value:"中国鲎"}
        ListElement{value:"中筋面粉"}
        ListElement{value:"砖茶"}
        ListElement{value:"猪大肠"}
        ListElement{value:"猪大骨"}
        ListElement{value:"猪大排"}
        ListElement{value:"猪肚"}
        ListElement{value:"猪耳"}
        ListElement{value:"猪耳朵"}
        ListElement{value:"猪肺"}
        ListElement{value:"猪肥肠"}
        ListElement{value:"猪肝"}
        ListElement{value:"祝光苹果"}
        ListElement{value:"猪骨头"}
        ListElement{value:"猪后腿肉"}
        ListElement{value:"猪腱"}
        ListElement{value:"猪脚"}
        ListElement{value:"猪颊肉"}
        ListElement{value:"猪胛心肉"}
        ListElement{value:"竹荚鱼"}
        ListElement{value:"猪颈肉"}
        ListElement{value:"猪里脊"}
        ListElement{value:"猪龙骨"}
        ListElement{value:"猪脑"}
        ListElement{value:"猪排"}
        ListElement{value:"猪肉"}
        ListElement{value:"猪皮"}
        ListElement{value:"猪舌"}
        ListElement{value:"竹笙"}
        ListElement{value:"竹笋"}
        ListElement{value:"竹荪"}
        ListElement{value:"竹炭粉"}
        ListElement{value:"猪蹄"}
        ListElement{value:"猪天梯"}
        ListElement{value:"猪蹄筋"}
        ListElement{value:"猪头肉"}
        ListElement{value:"猪腿"}
        ListElement{value:"猪尾巴"}
        ListElement{value:"猪五花腩"}
        ListElement{value:"猪小肠"}
        ListElement{value:"猪小排"}
        ListElement{value:"猪心"}
        ListElement{value:"猪血"}
        ListElement{value:"猪腰"}
        ListElement{value:"猪胰"}
        ListElement{value:"猪油"}
        ListElement{value:"猪肘"}
        ListElement{value:"猪肘子"}
        ListElement{value:"猪嘴边肉"}
        ListElement{value:"紫包菜"}
        ListElement{value:"紫背天葵"}
        ListElement{value:"紫菜"}
        ListElement{value:"紫菜花"}
        ListElement{value:"紫菜头"}
        ListElement{value:"紫长茄"}
        ListElement{value:"紫萼香茶菜"}
        ListElement{value:"紫甘蓝"}
        ListElement{value:"紫橄榄菜"}
        ListElement{value:"紫甘薯"}
        ListElement{value:"仔鸡"}
        ListElement{value:"紫尖椒"}
        ListElement{value:"紫米"}
        ListElement{value:"子排"}
        ListElement{value:"紫苤蓝"}
        ListElement{value:"紫钱"}
        ListElement{value:"紫茄子"}
        ListElement{value:"紫薯"}
        ListElement{value:"紫苏"}
        ListElement{value:"紫苏"}
        ListElement{value:"紫苏子"}
        ListElement{value:"紫洋葱"}
        ListElement{value:"紫椰菜"}
        ListElement{value:"紫叶生菜"}
        ListElement{value:"紫叶生菜"}
        ListElement{value:"紫叶油菜"}
        ListElement{value:"鲻鱼"}
        ListElement{value:"紫圆茄"}
        ListElement{value:"棕榈油"}
    }


}
