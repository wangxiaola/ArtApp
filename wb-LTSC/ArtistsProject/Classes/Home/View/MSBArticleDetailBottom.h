//
//  MSBArticleDetailBottom.h
//  meishubao
//
//  Created by T on 16/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^messageBtnClickBlock)();
typedef void(^storeBtnClickBlock)(UIButton *);
typedef void(^shareBtnClickBlock)();
typedef void(^commentClickBlock)();
static const CGFloat kBottomViewHeight = 49.f;

@interface MSBArticleDetailBottom : UIView
@property (nonatomic, copy) messageBtnClickBlock messClick;
@property (nonatomic, copy) storeBtnClickBlock storeClick;
@property (nonatomic, copy) shareBtnClickBlock shareClick;
@property (nonatomic, copy) commentClickBlock commentBlock;
@property (nonatomic, copy) NSString * commentCount;
@property (nonatomic, assign) BOOL is_collect;
@property (nonatomic,assign) BOOL isImageMode;
@property (nonatomic,assign) BOOL isArtist;
@end
