//
//  NoResponse.h
//  JobElectronic
//
//  Created by gengyuanyuan on 15/8/7.
//  Copyright (c) 2015年 PanghuKeji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^networkHandle)(id obj);
@interface PHNoResponse : UIView
@property(nonatomic,copy)void(^btnClick)();
+(instancetype)showHUDAddedTo:(UIView *)view :(void(^)(id responseObject))block;
@end
