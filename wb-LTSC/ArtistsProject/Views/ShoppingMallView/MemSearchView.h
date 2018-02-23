//
//  MemSearchView.h
//  weiguankeji
//
//  Created by 黄兵 on 2017/6/15.
//  Copyright © 2017年 黄兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MemSearchDelegate <NSObject>

// 搜索视图消息通知
- (void)menSearchNewMessage:(UIButton *)button;

@end
@interface MemSearchView : UIView

@property (strong,nonatomic)void (^YYGetTitle)(NSString * Title);
@property (strong,nonatomic)void (^YYGetCancel)(NSString * Title);
@property ( strong, nonatomic) UIView *YYBgView;
@property (strong, nonatomic)  UITextField *search;
// 代理
@property (nonatomic, assign) id<MemSearchDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;


@end
