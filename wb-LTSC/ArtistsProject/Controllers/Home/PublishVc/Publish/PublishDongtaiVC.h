//
//  PublishDongtaiVC.h
//  ShesheDa
//
//  Created by chen on 16/7/21.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HScrollViewController.h"

@interface PublishDongtaiVC : HScrollViewController

//topictype 7 相册
@property (strong,nonatomic)NSString *topictype;

@property (strong, nonatomic) UILabel *selectedTypeLabel;

@property (strong, nonatomic) NSString *selectedType;
@property (nonatomic, strong) NSString *selectTypeId;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *longstr;
@property (strong, nonatomic) NSString *width;
@property (strong, nonatomic) NSString *height;
@property (strong, nonatomic) NSString *format;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *planner;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *award;
@property (strong, nonatomic) NSString *people;
@property (strong, nonatomic) NSArray *atuser;

@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *yunfei;
@property (nonatomic, strong) NSString *kucun;
@property (nonatomic, strong) NSString *huiyuan;
@property (nonatomic, strong) NSString *yishujia;
@property (strong, nonatomic) NSArray<UIImage *> *selectedImageList;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSString *topicid;
@property (strong, nonatomic) NSMutableArray *arrayRecorderSave;

//为1时为鉴定会现场直播
@property (strong,nonatomic)NSString *state;

@property (strong,nonatomic)NSString *messageTop;

@property (assign,nonatomic) BOOL isEdit;

@property (strong,nonatomic) NSArray *videoArray;

@end
