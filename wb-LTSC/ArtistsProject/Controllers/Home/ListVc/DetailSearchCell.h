//
//  DetailSearchCell.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/5/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YTXSearchDynamicModel.h"
@interface DetailSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avactorView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@property (strong, nonatomic)CangyouQuanDetailModel *model;
- (CGFloat)getHeight;
@end
