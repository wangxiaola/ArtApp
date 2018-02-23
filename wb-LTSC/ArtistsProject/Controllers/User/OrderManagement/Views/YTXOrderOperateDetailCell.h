//
//  YTXOrderOperateDetailCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXOrderViewModel.h"
extern NSString * const kYTXOrderOperateDetailCell;

@interface YTXOrderOperateDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel * stateLabel1;
@property (nonatomic, strong) UILabel * stateLabel2;
@property (nonatomic, strong) UILabel * contentLabel1;
@property (nonatomic, strong) UILabel * contentLabel2;
@property (nonatomic, strong) UIView  *botView;
@property (nonatomic, copy) NSString * text;

+ (NSInteger)getCellNumberWithModel:(YTXOrderViewModel *)model;  // 获得cell的个数
+ (CGFloat)getCellHeightWithText:(NSString *)text;// cell的高度

@end
