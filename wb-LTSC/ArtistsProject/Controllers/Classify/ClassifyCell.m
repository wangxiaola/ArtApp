//
//  ClassifyCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/30.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ClassifyCell.h"

@interface ClassifyCell ()
@property(nonatomic,strong)UIImageView* iconImg;
@property(nonatomic,strong)UIImageView* subImg;
@property(nonatomic,strong)UILabel* titleLabel;
@end

@implementation ClassifyCell

-(void)addContentViews{
    _iconImg = [[UIImageView alloc]initWithFrame:CGRectMake( 15, self.bounds.size.height/2- T_WIDTH(10), T_WIDTH(20),  T_WIDTH(20))];
    [self.contentView addSubview:_iconImg];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(getViewWidth(_iconImg)+T_WIDTH(15), self.bounds.size.height/2-T_WIDTH(10), T_WIDTH(200), T_WIDTH(20))];
    _titleLabel.font = ART_FONT(ARTFONT_OFI);
    [self.contentView addSubview:_titleLabel];
    
    _subImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-T_WIDTH(45), self.bounds.size.height/2- T_WIDTH(15),  T_WIDTH(30),  T_WIDTH(30))];
    _subImg.hidden = YES;
    [self.contentView addSubview:_subImg];
}
-(void)setClassifyImg:(NSString*)imgUrl title:(NSString*)titStr subImg:(NSString*)subImgUrl{
    [_iconImg setImage:[UIImage imageNamed:imgUrl]];
    _titleLabel.text = titStr;
//    if (subImgUrl.length>0) {
//        _subImg.hidden = NO;
//         [_iconImg setImage:[UIImage imageNamed:subImgUrl]];
//    }
}

@end
