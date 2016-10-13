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
        myjava.toastMsg("获取中...请耐心等待...")
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

                reportsystem.als_Top5(foodcountchart.currentPage)
                reportsystem.als_Time(foodtimechart.currentPage)
                reportsystem.als_Type(foodtypechart.currentPage,foodtimechart.currentPage)

            }



            if(Statue==="als_Top5DONE"){


                var num0=parseInt(als_Top5_getCount().split("@")[0])
                var num1=parseInt(als_Top5_getCount().split("@")[1])
                var num2=parseInt(als_Top5_getCount().split("@")[2])
                var num3=parseInt(als_Top5_getCount().split("@")[3])
                var num4=parseInt(als_Top5_getCount().split("@")[4])

                foodcountchartbarset.values=[num0,num1,num2,num3,num4]

                foodcountchartbcax.categories=als_Top5_getName().split("@")
                foodcountchartyAxis.max=num0*1.1



                als_Top5_getName().split("@")


            }

            if(Statue==="als_TimeError"){
                myjava.toastMsg("食材不足三种……无法生成最近数据")
                foodtimechartfir.clear()
                foodtimechartsec.clear()
                foodtimechartthr.clear()
                foodtimechartfir.name=""
                foodtimechartsec.name=""
                foodtimechartthr.name=""
            }

            if(Statue==="als_TimeDONE"){
                foodtimechartfir.clear()
                foodtimechartsec.clear()
                foodtimechartthr.clear()

                var a=0;
                var max=0;
                for(var i=0;i<=9;i++){
                    foodtimechartfir.append(i,a=parseInt(als_Time_getCount().split("|||")[0].split("@")[i]))
                    max=max<a?a:max
                    foodtimechartsec.append(i,a=parseInt(als_Time_getCount().split("|||")[1].split("@")[i]))
                    max=max<a?a:max
                    foodtimechartthr.append(i,a=parseInt(als_Time_getCount().split("|||")[2].split("@")[i]))
                    max=max<a?a:max
                }
                foodtimechartyAxis.max=max*1.2

                foodtimechartbcax.categories=als_Time_getName().split("@")

                foodtimechartfir.name=als_Time_getFoodName().split("@")[0]
                foodtimechartsec.name=als_Time_getFoodName().split("@")[1]
                foodtimechartthr.name=als_Time_getFoodName().split("@")[2]
            }

            if(Statue==="als_TypeDONE"){
                var num=als_Type_getCount().split("@")
                if(foodtypechart.currentPage===1){
                    pie1.color="#FF6103"
                    pie1.label="热性"
                    pie1.value=num[0]
                    pie2.color="#ED9121"
                    pie2.label="温性"
                    pie2.value=num[1]
                    pie3.color="#F5DEB3"
                    pie3.label="平性"
                    pie3.value=num[2]
                    pie4.color="#FFD700"
                    pie4.label="凉性"
                    pie4.value=num[3]
                    pie5.color="#FFE384"
                    pie5.label="寒性"
                    pie5.value=num[4]
                }
                if(foodtypechart.currentPage===2){
                    pie1.color="#E3A869"
                    pie1.label="谷薯类"
                    pie1.value=num[0]
                    pie2.color="#00C957"
                    pie2.label="蔬果类"
                    pie2.value=num[1]
                    pie3.color="#FF7F50"
                    pie3.label="动物类"
                    pie3.value=num[2]
                    pie4.color="#FFDEAD"
                    pie4.label="豆制类"
                    pie4.value=num[3]
                    pie5.color="#A066D3"
                    pie5.label="纯能类"
                    pie5.value=num[4]
                }
                if(foodtypechart.currentPage===3){
                    pie1.color="#00C957"
                    pie1.label="果蔬制品"
                    pie1.value=num[0]
                    pie2.color="#FF7F50"
                    pie2.label="肉禽制品"
                    pie2.value=num[1]
                    pie3.color="#87CEEB"
                    pie3.label="水产制品"
                    pie3.value=num[2]
                    pie4.color="#FFDEAD"
                    pie4.label="乳制品"
                    pie4.value=num[3]
                    pie5.color="#E3CF57"
                    pie5.label="粮食制品"
                    pie5.value=num[4]
                }

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
        color:"#02ae4a"
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


    Flickable{
        id:view
        clip:true
        anchors.top: head.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom:parent.bottom

        contentHeight: foodcountchart.height+foodtimechart.height+foodtypechart.height


        ChartView {
            title: "总食用次数Top5"
            titleFont{
                family: "微软雅黑"
                pixelSize: head.height/4
            }
            property int currentPage: 0
            onCurrentPageChanged: {
                switch(currentPage){
                case 0:
                    title="总食用次数Top5"
                    break;
                case 1:
                    title="早餐食用次数Top5"
                    break;
                case 2:
                    title="午餐食用次数Top5"
                    break;
                case 3:
                    title="晚餐食用次数Top5"
                    break;
                case 4:
                    title="零食食用次数Top5"
                    break;
                case 5:
                    title="甜品食用次数Top5"
                    break;
                case 6:
                    title="其他食用次数Top5"
                    break;
                default:
                    title="总食用次数Top5"
                    break;
                }
            }

            height: mainwindow.height/2
            width: parent.width
            id:foodcountchart
            animationOptions:ChartView.SeriesAnimations

            BarSeries {
                id: mySeries
                useOpenGL:true
                axisX: BarCategoryAxis {
                    id:foodcountchartbcax
                    labelsFont{
                        family: "微软雅黑"
                        pixelSize: head.height/5
                        bold:true
                    }
                }
                axisY: ValueAxis {
                    id: foodcountchartyAxis
                    labelFormat: "%d"
                    min: 0
                    max: 10
                }
                BarSet {
                    id:foodcountchartbarset
                    label: "次数"
                    values: [0, 0, 0, 0, 0]
                }
            }

            Rectangle{
                id:foodcountchartleft
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: head.height/3
                height: head.height/3
                width: parent.width/7
                color:"yellow"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        foodcountchart.currentPage--
                        if(foodcountchart.currentPage==-1)
                            foodcountchart.currentPage=6;
                        reportsystem.als_Top5(foodcountchart.currentPage)
                    }
                }
            }

            Rectangle{
                id:foodcountchartright
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: head.height/3
                height: head.height/3
                width: parent.width/7
                color:"yellow"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        foodcountchart.currentPage++
                        if(foodcountchart.currentPage==7)
                            foodcountchart.currentPage=0;
                        reportsystem.als_Top5(foodcountchart.currentPage)
                    }
                }
            }


        }

        ChartView {
            title: "最近10天食用次数前三"
            titleFont{
                family: "微软雅黑"
                pixelSize: head.height/4
            }
            anchors.top: foodcountchart.bottom

            height: mainwindow.height/2
            width: parent.width

            animationOptions:ChartView.SeriesAnimations
            legend.visible:true
            id:foodtimechart

            property int currentPage: 0
            onCurrentPageChanged: {
                switch(currentPage){
                case 0:
                    title="最近10天食用次数前三"
                    break;
                case 1:
                    title="最近30天食用次数前三"
                    break;
                case 2:
                    title="最近60天食用次数前三"
                    break;
                case 3:
                    title="最近90天食用次数前三"
                    break;
                case 4:
                    title="最近半年食用次数前三"
                    break;
                case 5:
                    title="最近一年食用次数前三"
                    break;
                default:
                    title="最近10天食用次数前三"
                    break;
                }

                var temp;
                switch(foodtimechart.currentPage){
                case 0:
                    temp="最近10天"
                    break;
                case 1:
                    temp="最近30天"
                    break;
                case 2:
                    temp="最近60天"
                    break;
                case 3:
                    temp="最近90天"
                    break;
                case 4:
                    temp="最近半年"
                    break;
                case 5:
                    temp="最近一年"
                    break;
                default:
                    temp="最近10天"
                    break;
                }

                switch(foodtypechart.currentPage){
                case 1:
                    foodtypechart.title=temp+"性状分布"
                    break;
                case 2:
                    foodtypechart.title=temp+"营养分布"
                    break;
                case 3:
                    foodtypechart.title=temp+"原料分布"
                    break;
                default:
                    foodtypechart.title=temp+"性状分布"
                    break;
                }


            }

            BarCategoryAxis {
                id:foodtimechartbcax
                labelsFont{
                    family: "微软雅黑"
                    pixelSize: head.height/7
                    bold:true
                }
            }
            ValueAxis {
                id: foodtimechartyAxis
                labelFormat: "%d"
                min: -0.9
                max: 10
            }

            SplineSeries {
                name: ""
                id:foodtimechartfir
                axisX:foodtimechartbcax
                axisY: foodtimechartyAxis
            }
            SplineSeries {
                name: ""
                id:foodtimechartsec
                axisX:foodtimechartbcax
                axisY: foodtimechartyAxis
            }
            SplineSeries {
                name: ""
                id:foodtimechartthr
                axisX:foodtimechartbcax
                axisY: foodtimechartyAxis
            }

            Rectangle{
                id:foodtimechartleft
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: head.height/3
                height: head.height/3
                width: parent.width/7
                color:"yellow"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        foodtimechart.currentPage--
                        if(foodtimechart.currentPage==-1)
                            foodtimechart.currentPage=5;

                        reportsystem.als_Time(foodtimechart.currentPage)
                        reportsystem.als_Type(foodtypechart.currentPage,foodtimechart.currentPage)
                    }
                }
            }

            Rectangle{
                id:foodtimechartright
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: head.height/3
                height: head.height/3
                width: parent.width/7
                color:"yellow"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        foodtimechart.currentPage++
                        if(foodtimechart.currentPage==6)
                            foodtimechart.currentPage=0;
                        reportsystem.als_Time(foodtimechart.currentPage)
                        reportsystem.als_Type(foodtypechart.currentPage,foodtimechart.currentPage)
                    }
                }
            }
        }

        ChartView {
            id: foodtypechart

            title: "食物性状分布"
            titleFont{
                family: "微软雅黑"
                pixelSize: head.height/4
            }

            legend.alignment: Qt.AlignBottom
            legend.visible:true
            legend.font{
                family: "微软雅黑"
                pixelSize: head.height/5
            }


            antialiasing: true

            anchors.top: foodtimechart.bottom

            height: mainwindow.height/2
            width: parent.width
            animationOptions:ChartView.SeriesAnimations


            property int currentPage: 1
            onCurrentPageChanged: {
                var temp;
                switch(foodtimechart.currentPage){
                case 0:
                    temp="最近10天"
                    break;
                case 1:
                    temp="最近30天"
                    break;
                case 2:
                    temp="最近60天"
                    break;
                case 3:
                    temp="最近90天"
                    break;
                case 4:
                    temp="最近半年"
                    break;
                case 5:
                    temp="最近一年"
                    break;
                default:
                    temp="最近10天"
                    break;
                }

                switch(currentPage){
                case 1:
                    title=temp+"性状分布"
                    break;
                case 2:
                    title=temp+"营养分布"
                    break;
                case 3:
                    title=temp+"原料分布"
                    break;
                default:
                    title=temp+"性状分布"
                    break;
                }

            }

            PieSeries {
                id: pieSeries


                PieSlice {id:pie1; color:"#FF6103"; label: "热性"; value: 1; labelVisible:true}
                PieSlice {id:pie2; color:"#ED9121"; label: "温性"; value: 2; labelVisible:true}
                PieSlice {id:pie3; color:"#F5DEB3"; label: "平性"; value: 3; labelVisible:true}
                PieSlice {id:pie4; color:"#FFD700"; label: "凉性"; value: 4; labelVisible:true}
                PieSlice {id:pie5; color:"#FFE384"; label: "寒性"; value: 5; labelVisible:true}
            }

            Rectangle{
                id:foodtypechartleft
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: head.height/3
                height: head.height/3
                width: parent.width/7
                color:"yellow"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        foodtypechart.currentPage--
                        if(foodtypechart.currentPage==0)
                            foodtypechart.currentPage=3;
                        reportsystem.als_Type(foodtypechart.currentPage,foodtimechart.currentPage)
                    }
                }
            }

            Rectangle{
                id:foodtypechartright
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: head.height/3
                height: head.height/3
                width: parent.width/7
                color:"yellow"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        foodtypechart.currentPage++
                        if(foodtypechart.currentPage==4)
                            foodtypechart.currentPage=1;
                        reportsystem.als_Type(foodtypechart.currentPage,foodtimechart.currentPage)
                    }
                }
            }


        }

    }
}
