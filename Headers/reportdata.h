#ifndef REPORTDATA_H
#define REPORTDATA_H

#include "ReportSystem.h"


void ReportSystem::initMap(){
    XZMap["冰糖"]=1;
    XZMap["菠菜"]=2;
    XZMap["薄荷"]=3;
    XZMap["草莓酱"]=4;
    XZMap["长毛对虾"]=5;
    XZMap["长糯米"]=1;
    XZMap["柴鱼片"]=2;
    XZMap["鲳鱼"]=3;
    XZMap["茶树菇"]=4;
    XZMap["豆浆"]=5;
    XZMap["印度飞饼"]=1;
    XZMap["米饭"]=2;
    XZMap["肌肉"]=3;
    XZMap["白菜"]=4;
    XZMap["野猪肉"]=5;
    XZMap["西兰花"]=1;
    XZMap["叉烧饭"]=2;
    XZMap["辣条"]=3;
    XZMap["白花椰菜"]=4;
    XZMap["土豆"]=5;
    XZMap["猪肉"]=1;
    XZMap["红番茄"]=2;
    XZMap["烤串"]=3;
    XZMap["艾草"]=4;
    XZMap["猪颈肉"]=5;
    XZMap["百香果"]=1;
    XZMap["面包"]=2;
    XZMap["面条"]=3;
    XZMap["绿豆芽"]=4;
    XZMap["青菜"]=5;
    XZMap["海带"]=1;
    XZMap["鹌鹑"]=2;
    XZMap["鹌鹑蛋"]=3;
    XZMap["月饼"]=4;
    XZMap["火锅"]=5;
    XZMap["白面"]=1;
    XZMap["鸡翅"]=2;
    XZMap["霸王蟹"]=3;
    XZMap["北京填鸭"]=4;
    XZMap["红茶"]=5;
    XZMap["肉饼"]=1;
    XZMap["花甲"]=2;
    XZMap["牛肉"]=3;
    XZMap["河粉"]=4;
    XZMap["艾草"]=5;
    XZMap["百合"]=1;
    XZMap["白扁豆"]=2;
    XZMap["烧卖"]=3;
    XZMap["大花蟹"]=4;
    XZMap["紫茄子"]=5;


    YYMap["冰糖"]=5;
    YYMap["菠菜"]=4;
    YYMap["薄荷"]=3;
    YYMap["草莓酱"]=2;
    YYMap["长毛对虾"]=1;
    YYMap["长糯米"]=5;
    YYMap["柴鱼片"]=4;
    YYMap["鲳鱼"]=3;
    YYMap["茶树菇"]=2;
    YYMap["豆浆"]=1;
    YYMap["印度飞饼"]=5;
    YYMap["米饭"]=4;
    YYMap["肌肉"]=3;
    YYMap["白菜"]=2;
    YYMap["野猪肉"]=1;
    YYMap["西兰花"]=5;
    YYMap["叉烧饭"]=4;
    YYMap["辣条"]=3;
    YYMap["白花椰菜"]=2;
    YYMap["土豆"]=1;
    YYMap["猪肉"]=5;
    YYMap["红番茄"]=4;
    YYMap["烤串"]=3;
    YYMap["艾草"]=2;
    YYMap["猪颈肉"]=1;
    YYMap["百香果"]=5;
    YYMap["面包"]=4;
    YYMap["面条"]=3;
    YYMap["绿豆芽"]=2;
    YYMap["青菜"]=1;
    YYMap["海带"]=5;
    YYMap["鹌鹑"]=4;
    YYMap["鹌鹑蛋"]=3;
    YYMap["月饼"]=2;
    YYMap["火锅"]=1;
    YYMap["白面"]=5;
    YYMap["鸡翅"]=4;
    YYMap["霸王蟹"]=3;
    YYMap["北京填鸭"]=2;
    YYMap["红茶"]=1;
    YYMap["肉饼"]=5;
    YYMap["花甲"]=4;
    YYMap["牛肉"]=3;
    YYMap["河粉"]=2;
    YYMap["艾草"]=1;
    YYMap["百合"]=5;
    YYMap["白扁豆"]=4;
    YYMap["烧卖"]=3;
    YYMap["大花蟹"]=2;
    YYMap["紫茄子"]=1;


    YLMap["冰糖"]=1;
    YLMap["菠菜"]=2;
    YLMap["薄荷"]=3;
    YLMap["草莓酱"]=4;
    YLMap["长毛对虾"]=5;
    YLMap["长糯米"]=1;
    YLMap["柴鱼片"]=2;
    YLMap["鲳鱼"]=3;
    YLMap["茶树菇"]=4;
    YLMap["豆浆"]=5;
    YLMap["印度飞饼"]=1;
    YLMap["米饭"]=2;
    YLMap["肌肉"]=3;
    YLMap["白菜"]=4;
    YLMap["野猪肉"]=5;
    YLMap["西兰花"]=1;
    YLMap["叉烧饭"]=2;
    YLMap["辣条"]=3;
    YLMap["白花椰菜"]=4;
    YLMap["土豆"]=5;
    YLMap["猪肉"]=1;
    YLMap["红番茄"]=2;
    YLMap["烤串"]=3;
    YLMap["艾草"]=4;
    YLMap["猪颈肉"]=5;
    YLMap["百香果"]=1;
    YLMap["面包"]=2;
    YLMap["面条"]=3;
    YLMap["绿豆芽"]=4;
    YLMap["青菜"]=5;
    YLMap["海带"]=1;
    YLMap["鹌鹑"]=2;
    YLMap["鹌鹑蛋"]=3;
    YLMap["月饼"]=4;
    YLMap["火锅"]=5;
    YLMap["白面"]=1;
    YLMap["鸡翅"]=2;
    YLMap["霸王蟹"]=3;
    YLMap["北京填鸭"]=4;
    YLMap["红茶"]=5;
    YLMap["肉饼"]=1;
    YLMap["花甲"]=2;
    YLMap["牛肉"]=3;
    YLMap["河粉"]=4;
    YLMap["艾草"]=5;
    YLMap["百合"]=1;
    YLMap["白扁豆"]=2;
    YLMap["烧卖"]=3;
    YLMap["大花蟹"]=4;
    YLMap["紫茄子"]=5;





}












#endif // REPORTDATA_H
