//
//  HLoadingHeader.m
//  Fruit
//
//  Created by HeLiulin on 15/8/12.
//  Copyright (c) 2015年 XICHUNZHAO. All rights reserved.
//

#import "HLoadingFooter.h"

@implementation HLoadingFooter

- (void) prepare
{
    [super prepare];
    self.stateLabel.textColor=[UIColor colorWithHexString:@"999999"];
}
- (void) beginRefreshing
{
    self.stateLabel.hidden=NO;
    [super beginRefreshing];
}
- (void) endRefreshingWithNoMoreData
{
    self.stateLabel.hidden=NO;
    [super endRefreshingWithNoMoreData];
}
- (void) resetNoMoreData
{
    self.stateLabel.hidden=YES;
    [super resetNoMoreData];
}

@end
