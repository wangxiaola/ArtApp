//
//  HLoadingHeader.m
//  Fruit
//
//  Created by HeLiulin on 15/8/12.
//  Copyright (c) 2015年 XICHUNZHAO. All rights reserved.
//

#import "HLoadingHeader.h"

@implementation HLoadingHeader

- (void) prepare
{
    [super prepare];

    self.lastUpdatedTimeLabel.hidden=YES;
    self.stateLabel.textColor=[UIColor colorWithHexString:@"999999"];
}

@end
