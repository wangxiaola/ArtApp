//
//  YTXGoodsModel.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTXUser.h"

@interface YTXGoodsModel : NSObject<YYModel>
//id: "1230763",
//dateline: "1476602183",
//topictype: 4,
//catatype: "0",
//topictitle: "撒啊啊",
//message: "什么什么世纪大酒店黑道皇后HD很多很多弧度接电话不代表大会是记得记得觉得还是是就是就是三年三班记得记得接电话 到家#时尚生活#哈觉得接电话大把大把觉得基督教#打火机紧急集合电话度诶我i我iu人人喊打吧nnd你电话速死饿呵呵个好吧#都不是事使劲儿今晚i",
//status: 4,
//age: "",
//price: "",
//video: "",
//likenum: 0,
//commentnum: 0,
//postuid: "9",
//replyuid: "0",
//isdel: "0",
//attach_list: "",
//pingyu: "",
//audio: "",
//clicknum: "16",
//addtop: "0",
//source: "",
//ispay: "1",
//authtime: "0",
//gtype: "015019",
//yunfei: "0",
//kucun: "1",
//shopgoodscata: "0",
//sellprice: "12200",
//sellstatus: "0",
//reltopic: "0",
//width: "",
//height: "",
//long: "",
//address: "",
//starttime: "",
//endtime: "",
//arttype: "0",
//city: "",
//caizhi: "",
//albumid: "0",
//people: "",
//award: "",
//gtypename: "",
//planner: "",
//user: {
//uid: "9",
//username: "张大湿",
//auth: "4",
//audio: "[{"url":"http://sdapp.guwanw.com/2016/08/20/1471698168.mp3","duration":7}]",
//tag: "床榻,竹雕"
//},
//alt: "http://jianbao.guwanw.com/index.php?app=Activity&mod=Recent&act=index&id=1230763",
//isLiked: false,
//isfollow: false,
//photoscbk: [
//{
//photo: "http://sdapp.guwanw.com/2016/1016/07/157cc592557.jpg",
//cbk: 0.5625,
//wbh: 0.5625
//},
//{
//photo: "http://sdapp.guwanw.com/2016/1016/07/157cc592559.jpg",
//cbk: 0.5625,
//wbh: 0.5625
//},
//{
//photo: "http://sdapp.guwanw.com/2016/1016/07/157cc592553.jpg",
//cbk: 0.5625,
//wbh: 0.5625
//},
//{
//photo: "http://sdapp.guwanw.com/2016/1016/07/157cc59255b.jpg",
//cbk: 0.5625,
//wbh: 0.5625
//},
//{
//photo: "http://sdapp.guwanw.com/2016/1016/07/157cc59255a.jpg",
//cbk: 0.5625,
//wbh: 0.5625
//},
//{
//photo: "http://sdapp.guwanw.com/2016/1016/07/157cc59255d.jpg",
//cbk: 0.5625,
//wbh: 0.5625
//}
//            ],
//likeuser: [ ],
//comments: [ ]
@property (nonatomic, copy) NSString * gid;
@property (nonatomic, copy) NSString * dateline;
@property (nonatomic, copy) NSString * topictype;
@property (nonatomic, copy) NSString * catatype;
@property (nonatomic, copy) NSString * topictitle;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * age;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * photos;
@property (nonatomic, copy) NSString * video;
@property (nonatomic, copy) NSString * likenum;
@property (nonatomic, copy) NSString * commentnum;
@property (nonatomic, copy) NSString * postuid;
@property (nonatomic, copy) NSString * replyuid;
@property (nonatomic, copy) NSString * isdel;
@property (nonatomic, copy) NSString * attach_list;
@property (nonatomic, copy) NSString * pingyu;
@property (nonatomic, copy) NSString * audio;
@property (nonatomic, copy) NSString * clicknum;
@property (nonatomic, copy) NSString * addtop;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * ispay;
@property (nonatomic, copy) NSString * authtime;
@property (nonatomic, copy) NSString * gtype;
@property (nonatomic, copy) NSString * yunfei;
@property (nonatomic, copy) NSString * kucun;
@property (nonatomic, copy) NSString * shopgoodscata;
@property (nonatomic, copy) NSString * sellprice;
@property (nonatomic, copy) NSString * sellstatus;
@property (nonatomic, copy) NSString * reltopic;
@property (nonatomic, copy) NSString * width;
@property (nonatomic, copy) NSString * height;
@property (nonatomic, copy) NSString * goodslong;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * starttime;
@property (nonatomic, copy) NSString * endtime;
@property (nonatomic, copy) NSString * arttype;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * caizhi;
@property (nonatomic, copy) NSString * albumid;
@property (nonatomic, copy) NSString * people;
@property (nonatomic, copy) NSString * award;
@property (nonatomic, copy) NSString * gtypename;
@property (nonatomic, copy) NSString * planner;
@property (nonatomic, strong) YTXUser * user;
@property (nonatomic, copy) NSString * alt;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isfollow;
@property (nonatomic, strong) NSArray * photoscbk;
@property (nonatomic, strong) NSArray * likeuser;
@property (nonatomic, strong) NSArray * comments;

@end

@interface YTXPhoto : NSObject

@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString * cbk;
@property (nonatomic, copy) NSString * wbh;

@end
