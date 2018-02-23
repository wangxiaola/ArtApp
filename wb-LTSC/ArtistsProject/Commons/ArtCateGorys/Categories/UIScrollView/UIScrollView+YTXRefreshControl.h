//
//  UIScrollView+YTXRefreshControl.h
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, YTXRefreshState) {
    /** 普通闲置状态 */
    YTXRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    YTXRefreshStatePulling,
    /** 正在刷新中的状态 */
    YTXRefreshStateRefreshing,
    /** 即将刷新的状态 */
    YTXRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    YTXRefreshStateNoMoreData
};

@interface UIScrollView (YTXRefreshControl)

- (void)beginHeaderRefresh;

- (void)beginFooterRefresh;

- (void)headerRefreshingWithBlock:(void(^)())refreshBlock;

- (void)footerRefreshingWithBlock:(void(^)())refreshBlock;

- (void)setTitle:(NSString *)title forState:(YTXRefreshState)state;

- (void)endRefreshing;

- (void)endRefreshingWithNoMoreData;

- (void)setHeaderRefreshHidden:(BOOL)hidden;

- (void)setFooterRefreshHidden:(BOOL)hidden;

@end
