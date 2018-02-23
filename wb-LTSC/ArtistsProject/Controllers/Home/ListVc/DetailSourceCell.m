//
//  DetailSourceCell.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/5/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "DetailSourceCell.h"

@interface DetailSourceCell ()
@property(nonatomic,strong)UILabel* sourceLabel;
@property(nonatomic,strong)UILabel* viewLabel;
@end
@implementation DetailSourceCell

-(void)addContentViews{
    
    _sourceLabel = [[UILabel alloc] init];
    _sourceLabel.font = ART_FONT(ARTFONT_OT);
    _sourceLabel.textAlignment = NSTextAlignmentLeft;
    _sourceLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_sourceLabel];
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_offset(15);
        make.height.mas_equalTo(20);
        make.right.mas_offset(-90);
    }];
    
    
    
    _viewLabel = [[UILabel alloc] init];
    _viewLabel.font = ART_FONT(ARTFONT_OT);
    _viewLabel.textAlignment = NSTextAlignmentRight;
    _viewLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_viewLabel];
    [_viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(20);
        make.right.mas_offset(-15);
        make.width.mas_equalTo(0);
    }];
    
    UIImageView *viewImage = [[UIImageView alloc] init];
    viewImage.clipsToBounds = YES;
    viewImage.image = [UIImage imageNamed:@"seeNums"];
    [self.contentView addSubview:viewImage];
    [viewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.equalTo(_viewLabel.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(15, 10));
    }];


}
-(void)setDetailSourceCell:(CangyouQuanDetailModel*)model{
    if (model.sourceText.length > 0) {
        self.sourceLabel.text = model.sourceText;
    }
    _viewLabel.text = [NSString stringWithFormat:@"%@浏览",model.clicknum];
   CGSize size = [_viewLabel sizeThatFits:CGSizeMake(60, 20)];
    [_viewLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
}
@end
