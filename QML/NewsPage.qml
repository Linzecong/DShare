import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import JavaMethod 1.0
import NewsSystem 1.0
import QtGraphicalEffects 1.0
import "qrc:/GlobalVariable.js" as GlobalColor


Rectangle{
    id:mainrect
    anchors.fill: parent
    property double dp:(myjava.getHeight()/16*2)/70

    function abs(a){
        if(a<0)
            return -a
        else
            return a
    }

    property int getcount: 0

    function setcount(type,count,newsid){
         if(type==="点赞"){
             for(var i=0;i<newsmodel.count;i++)
                 if(newsid===newsmodel.get(i).NewsID)
                     newsmodel.get(i).LikeCount=count
         }

         if(type==="评论"){
             for(var i2=0;i2<newsmodel.count;i2++)
                 if(newsid===newsmodel.get(i2).NewsID)
                     newsmodel.get(i2).CommentCount=count
         }

    }

    JavaMethod{
        id:myjava
    }

    property string username
    property string nickname

    function setid(a,b){
        username=a
        nickname=b

        if(getcount==0){
            newssystem.getNews(getcount++)
        }
    }


    FontLoader {
        id: localFont
        source:"qrc:/Resources/msyh.ttf"
    }

    NewsSystem{
        id:newssystem
        onStatueChanged: {
            if(Statue=="getnewsDBError")
                myjava.toastMsg("新闻获取失败")

            if(Statue=="getnewsSucceed"){
                var str=newssystem.getNewsList()
                var singlenews=str.split("{|}")

                for(var i=0;i<singlenews.length-1;i++){
                    var data=singlenews[i].split("|||")
                    newsmodel.append({"NewsID":data[0],"Title":data[1],"CoverPhoto":data[2],"Posttime":data[3],"CommentCount":data[4],"LikeCount":data[5]})
                }
            }


        }
    }


    //显示列表
    ListView{
        id:listview;
        anchors.fill: parent
        clip:true

        Rectangle{
            anchors.fill: parent
            //color:GlobalColor.Background
            color:"white"
            z:-100
        }

        cacheBuffer:contentHeight+2

        Rectangle {
            id: scrollbar
            anchors.right: listview.right
            anchors.rightMargin: 3
            y: listview.visibleArea.yPosition * listview.height
            width: 5
            height: listview.visibleArea.heightRatio * listview.height
            color: "grey"
            radius: 5
            z:2
            visible: listview.dragging||listview.flicking
        }


        header:Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width/3*1.1
            height: getcount==0?dp*70:0
            visible: getcount==0?true:false
            Rectangle{
                width: parent.width/1.2
                height:head.height/2
                color:"white"

                anchors.top: parent.top
                anchors.topMargin: 8*dp
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    text:"加载中"
                    color:"grey"
                    anchors.centerIn: parent
                    font.pointSize: 16
                }
            }
        }
        spacing:-1

        delegate: Item{
            id:newsitem
            width:parent.width+5
            height:68*dp


            Rectangle{
                anchors.fill: parent
                id:delegaterect
         //       anchors.margins: 2*dp

//                layer.enabled: true
//                layer.effect: DropShadow {
//                    transparentBorder: true
//                    radius: 8
//                    color: GlobalColor.Main
//                }

                border.width: 1
                border.color: "grey"

                property string newsID: NewsID

                Image{
                    id:coverimage
                    source:CoverPhoto
                    anchors.top:parent.top
                    anchors.topMargin: 8*dp
                    anchors.left: parent.left
                    anchors.leftMargin: 8*dp
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8*dp

                    width: height*1.3


                    //用于网速慢，头像加载慢时先显示文字
                    BusyIndicator{
                        anchors.centerIn: parent
                        visible: (parent.status==Image.Error||parent.status==Image.Null||parent.status==Image.Loading)?true:false
                        running:(parent.status==Image.Loading)?true:false
                    }
                }

                //title
                Text{
                    id:titlelabel
                    anchors.left: coverimage.right
                    anchors.leftMargin: 8*dp
                    anchors.top: coverimage.top
                    anchors.right: parent.right
                    anchors.rightMargin: 8*dp
                    wrapMode: Text.Wrap
                    text: Title
                    color:"black"
                     lineHeight: 1.2
                    font{
                        family: localFont.name
                        pointSize: 16
                    }
                }

                //发表时间
                Text{
                    id:posttimelabel
                    anchors.left: coverimage.right
                    anchors.leftMargin: 8*dp

                    anchors.bottom: coverimage.bottom
                    text: Posttime
                    color:"grey"
                    font{
                        family: localFont.name
                        pointSize:12
                    }
                    verticalAlignment: Text.AlignBottom
                }


                //文字信息
                Label{
                    id:commentcountlabel

                    anchors.right: parent.right
                    anchors.rightMargin: 8*dp

                    anchors.bottom: coverimage.bottom
                    anchors.bottomMargin: -3

                    text:"✉ "+CommentCount
                    verticalAlignment: Text.AlignBottom
                    color:"grey"
                    font{
                        family: localFont.name
                        //family: "微软雅黑"
                        pointSize:12
                    }

                }


                Label{
                    id:likecountlabel

                    anchors.right: commentcountlabel.left
                    anchors.rightMargin: 8*dp

                    anchors.bottom: coverimage.bottom

                    text:"♡ "+LikeCount
                    verticalAlignment: Text.AlignBottom
                    color:"grey"
                    font{
                        family: localFont.name
                        pointSize:12
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainrect.parent.parent.parent.shownewscontent(delegaterect.newsID,username,nickname,titlelabel.text,posttimelabel.text)
                    }
                }

            }
        }

        model: newsmodel//信息model
        onDragEnded: {
            // 下拉刷新判断逻辑：已经到头了，还下拉一定距离
            if (contentY < originY){
                if(refreshtimer.refreshtime>30){
                    var dy = contentY - originY;
                    if (dy < -70){
                        if(refreshtimer.refreshtime>120){
                      newsmodel.clear()
                      getcount=0
                      newssystem.getNews(getcount++)
                            refreshtimer.refreshtime=0
                        }
                    }
                }
            }
            // 上拉加载判断逻辑：已经到底了，还上拉一定距离
            if (contentHeight>height && contentY-originY > contentHeight-height){
                var dy = (contentY-originY) - (contentHeight-height);
                if (dy > 70){
                     newssystem.getNews(getcount++)
                }
            }
        }


        //防止多次刷新用
        Timer{
            id:refreshtimer;
            interval: 1000;
            repeat: true
            running: true
            property int refreshtime: 120//防止连续刷新
            onTriggered: {
                refreshtime=refreshtimer.refreshtime+1;
            }
        }


        ListModel{
            id:newsmodel

        }


    }
}
