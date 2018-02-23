//
//  ArtSelectCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtSelectCell.h"

@interface ArtSelectCell ()
@property(nonatomic,strong)UILabel* titlabel;
@end

@implementation ArtSelectCell
-(void)addContentViews{
    _titlabel= [[UILabel alloc]init];
    _titlabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_titlabel];
    [_titlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(120), 20));
    }];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"已勾选"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-35);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(20), 20));
    }];
}
-(void)btnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        if (self.addSelectBlock) {
            self.addSelectBlock(self.tag);
        }
    }else{
        if (self.deleteSelectBlock) {
            self.deleteSelectBlock(self.tag);
        }
    }
}
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    _titlabel.text = dic[@"name"];
}
-(void)setSelectCellDic:(NSDictionary*)dic{
    _titlabel.text = dic[@"value"];
}
@end
