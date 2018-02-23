//
//  ZanHeadCell.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ZanHeadCell.h"

@implementation ZanHeadCell

-(void)addContentViews{
    //    //自定义head线条
        UIImageView *line=[[UIImageView alloc]init];
        line.backgroundColor=BACK_CELL_COLOR;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(10);
            make.top.equalTo(self.contentView.mas_top).offset(0);
        }];
    
    _shangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shangBtn.backgroundColor = RGB(227, 78, 79);
    _shangBtn.layer.cornerRadius = 5;
    _shangBtn.titleLabel.font = ART_FONT(ARTFONT_OF);
    [_shangBtn addTarget:self action:@selector(shangBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_shangBtn setTitle:@"赞赏" forState:UIControlStateNormal];
    [_shangBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [self.contentView addSubview:_shangBtn];
    [_shangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(75, 30));
    }];
    
    _peopleNums = [[UILabel alloc]init];
    _peopleNums.textAlignment = NSTextAlignmentCenter;
    _peopleNums.textColor = kColor3;
    _peopleNums.font = ART_FONT(ARTFONT_OZ);
    [self.contentView addSubview:_peopleNums];
    [_peopleNums mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(_shangBtn.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(200, 13));
    }];
    
}
-(void)setArtTableViewCellDicValue:(NSInteger)num{
   _peopleNums.text = [NSString stringWithFormat:@"共%ld人打赏 ",num];
}
-(void)shangBtnClick{
    if (self.shangSendClick) {
        self.shangSendClick();
    }
}
@end
