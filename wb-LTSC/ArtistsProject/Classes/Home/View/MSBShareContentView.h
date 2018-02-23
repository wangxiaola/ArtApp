//
//  MSBShareContentView.h
//  meishubao
//
//  Created by T on 16/11/17.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBArticleDetailController.h"

static const CGFloat kMSBShareContentViewH = 280.f;
typedef NS_ENUM(NSUInteger, MSBShareType) {
    MSBShareTypeQQ = 1,
    MSBShareTypeWeixin,
    MSBShareTypeWeiQ,
    MSBShareTypeWeibo,
    MSBShareTypeSystem,
    MSBShareTypeMsg,
    MSBShareTypeMail,
    MSBShareTypeCopy
};

@interface MSBShareContentView : UIView
+ (instancetype)shareInstance;
@property (nonatomic, weak) BaseViewController  *articleDetialVC;
@property (nonatomic, copy) NSString            *post_type; // 1文章 2视频 3人物
@property (nonatomic, copy) NSString            *post_id;   // 文章id
- (void)show;
- (void)dismiss;
- (void)shareTitle:(NSString *)title  desc:(NSString *)desc url:(NSString *)url img:(UIImage *)img;
@end
