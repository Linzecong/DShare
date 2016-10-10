import QtQuick 2.5
import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import ReportSystem 1.0
import JavaMethod 1.0
import QtGraphicalEffects 1.0
import QtCharts 2.0

Rectangle {
    id:mainwindow
    anchors.fill: parent
    property string str_userid;//记录这个页面的人的id

    property string nickname

    function getalldiet(userid,mnickname){
        str_userid=userid
        nickname=mnickname
        reportsystem.getalldiet(userid)
        forceActiveFocus()//用于响应返回键
    }
    MouseArea{
        anchors.fill: parent
    }

    ReportSystem{
        id:reportsystem
        onStatueChanged: {
            if(Statue==="getalldietsDBError")
                myjava.toastMsg("网络出错..请重试");

            if(Statue==="getalldietsSucceed"){
                myjava.toastMsg("获取成功！")
                reportsystem.als_Top5()
            }
            if(Statue==="als_Top5DONE"){
                var num0=parseInt(als_Top5_getCount().split("@")[0])
                var num1=parseInt(als_Top5_getCount().split("@")[1])
                var num2=parseInt(als_Top5_getCount().split("@")[2])
                var num3=parseInt(als_Top5_getCount().split("@")[3])
                var num4=parseInt(als_Top5_getCount().split("@")[4])

                barset.values=[num0,num1,num2,num3,num4]


                bcax.categories=als_Top5_getName().split("@")

                yAxis.max=num0
            }

        }
    }

    Keys.enabled: true
    Keys.onBackPressed: {
        mainwindow.parent.visible=false
        mainwindow.parent.parent.forceActiveFocus();
    }


    //顶部栏
    Rectangle{
        id:head;
        width:parent.width;
        height: parent.height/16*1.5;
        color:"#32dc96"
        anchors.top: parent.top;
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: -2
            radius: 8
            color: "black"

        }

        Label{
            text:" ＜";
            id:backbutton
            height: parent.height
            width:height
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font{

                pixelSize: head.height/1.5

            }
            color: "white";
            MouseArea{
                anchors.fill: parent
                id:headma
                onClicked: {
                    mainwindow.parent.visible=false
                    mainwindow.parent.parent.forceActiveFocus();
                }
            }
        }
        Label{
            id:headname
            text:"我的报告"
            anchors.centerIn: parent
            font{
                family: "微软雅黑"
                pixelSize: head.height/2.5
            }
            color: "white";

        }
    }


    ChartView {
        title: "食用次数Top5"
        anchors.top: head.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom:parent.bottom
        id:chart

        animationOptions:ChartView.AllAnimations

        legend.visible:false

        BarCategoryAxis {
            id:bcax
        }

        BarSeries {
                id: mySeries
                useOpenGL:true
                axisX: bcax
                axisY: ValueAxis {
                    id: yAxis
                    labelFormat: "%d"
                    min: 0
                    max: 10
                }

                BarSet {
                    id:barset
                    label: "次数"
                    values: [0, 0, 0, 0, 0]
                }
        }
    }


}




