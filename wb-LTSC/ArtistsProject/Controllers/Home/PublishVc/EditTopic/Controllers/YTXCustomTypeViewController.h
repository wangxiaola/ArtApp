//
//  YTXCustomTypeViewController.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/19.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "HViewController.h"

typedef NS_ENUM(NSUInteger, CUSTOM_TYPE) {
    CUSTOM_TYPE_WORKS_CLASS,
    CUSTOM_TYPE_CAMERA_CLASS,
    CUSTOM_TYPE_OTHERS_CLASS,//年表
    CUSTOM_TYPE_AGE,
    CUSTOM_TYPE_SIZE,
    CUSTOM_TYPE_COMMENT//评论文字
};

@interface YTXCustomTypeViewController : HViewController

@property (nonatomic, assign) CUSTOM_TYPE customType;

@property (nonatomic, copy) NSString *longstr;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *width;

@property (nonatomic, copy) void(^didSelectedString)(NSString *typeString, CUSTOM_TYPE customType);
@property (nonatomic, copy) void(^didGetFormatString)(NSString *longstr, NSString *height, NSString *width);

@end
