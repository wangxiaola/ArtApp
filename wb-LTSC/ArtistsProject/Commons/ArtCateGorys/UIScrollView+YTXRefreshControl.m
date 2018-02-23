//
//  UIScrollView+YTXRefreshControl.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/9.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "UIScrollView+YTXRefreshControl.h"
#import <MJRefresh.h>

@implementation UIScrollView (YTXRefreshControl)

- (void)beginHeaderRefresh
{
    [self.mj_header beginRefreshing];
}

- (void)beginFooterRefresh
{
    [self.mj_footer beginRefreshing];
}

- (void)headerRefreshingWithBlock:(void(^)())refreshBlock {
    __weak typeof(self)weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.mj_footer.isRefreshing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.mj_header endRefreshing];
            });
            return ;
        } else if (strongSelf.mj_footer.state == MJRefreshStateNoMoreData) {
            [strongSelf.mj_footer resetNoMoreData];
        }
        refreshBlock();
    }];
    self.mj_header.backgroundColor = [UIColor clearColor];
}

- (void)footerRefreshingWithBlock:(void(^)())refreshBlock {
    __weak typeof(self)weakSelf = self;
    self.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.mj_header.isRefreshing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf.mj_footer endRefreshing];
            });
            return ;
        }
        refreshBlock();
    }];
    self.mj_footer.backgroundColor = [UIColor clearColor];
}

- (void)setTitle:(NSString *)title forState:(YTXRefreshState)state {
    MJRefreshAutoStateFooter *footer = (MJRefreshAutoStateFooter *)self.mj_footer;
    [footer setTitle:title forState:(MJRefreshState)state];
}

- (void)endRefreshing
{
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

- (void)endRefreshingWithNoMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)setHeaderRefreshHidden:(BOOL)hidden {
    self.mj_header.hidden = hidden;
}

- (void)setFooterRefreshHidden:(BOOL)hidden {
    self.mj_footer.hidden = hidden;
}


@end
