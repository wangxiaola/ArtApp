//
//  MJSelectCell.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJSelectCell : UITableViewCell
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* selectBtn;
-(void)setMjSelectCell:(NSString*)titleStr;
@end
