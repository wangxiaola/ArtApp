//
//  PaintDetailController.h
//  meishubao
//
//  Created by benbun－mac on 17/1/22.
//  Copyright © 2017年 benbun. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MSBWebBaseController.h"

typedef NS_ENUM(NSUInteger, WebTitleType){
    WebTitleTypeHuaYuan = 0,
    WebTitleTypeNormal = 1
};

@interface PaintDetailController : MSBWebBaseController
@property (nonatomic, assign) WebTitleType titleType;
@end
