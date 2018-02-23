//
//  MemVeriCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/26.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationModel.h"
@interface MemVeriCell : UITableViewCell

// 标题
@property (nonatomic, strong) UILabel *title;
// 内容
@property (nonatomic, strong) UILabel *content;

// 模型
@property (nonatomic, strong) AuthenticationModel *model;
@end


