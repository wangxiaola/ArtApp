//
//  ZanListCell.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/4/22.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ZanListCell.h"

@implementation ZanListCell
-(void)addContentViews{
    //自定义线条
    UIImageView *line=[[UIImageView alloc]init];
    line.backgroundColor=Art_LineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.contentView.mas_top).offset(0);
    }];
    
    _iconView = [[UIImageView alloc] init];
    _iconView.layer.cornerRadius = 15;
    _iconView.layer.masksToBounds = YES;
    UITapGestureRecognizer* commentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentTap:)];
    _iconView.userInteractionEnabled = YES;
    [_iconView addGestureRecognizer:commentTap];
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.mas_offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = kColor3;
    _nameLabel.font = ART_FONT(ARTFONT_OZ);
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    _dateLabel = [[UILabel alloc]init];
    _dateLabel.textColor = kColor3;
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.font = ART_FONT(ARTFONT_OZ);
    [self.contentView addSubview:_dateLabel];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];

}
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    _model = [UserInfoUserModel mj_objectWithKeyValues:dic[@"user"]];
    
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",_model.avatar] tempTmage:@"temp_Default_headProtrait"];
    
    NSString* nameStr = _model.username;
    NSString* money  = [NSString stringWithFormat:@"¥:%.2f元",[dic[@"coin"] floatValue]/100];
    NSString* resultStr = [NSString stringWithFormat:@"%@ 赞赏 %@",nameStr,money];
    
    
    //富文本
    NSMutableAttributedString* attri = [[NSMutableAttributedString alloc]initWithString:resultStr];
    
    [attri addAttribute:NSForegroundColorAttributeName value:kColor6 range:NSMakeRange(0,nameStr.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OT] range:NSMakeRange(0,nameStr.length)];
    
    [attri addAttribute:NSForegroundColorAttributeName value:kColor3 range:NSMakeRange(nameStr.length+1,3)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OT] range:NSMakeRange(nameStr.length+1,3)];
    
    [attri addAttribute:NSForegroundColorAttributeName value:kColor6 range:NSMakeRange(nameStr.length+3,resultStr.length-(nameStr.length+3))];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OT] range:NSMakeRange(nameStr.length+3,resultStr.length-(nameStr.length+3))];
    
    _nameLabel.attributedText = attri;
    CGSize maximumLabelSize = CGSizeMake(100, 13);
    CGSize expectSize = [_nameLabel sizeThatFits:maximumLabelSize];
    
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(expectSize.width, 20));
    }];

    _dateLabel.text = dic[@"timeFormat"];
}
-(void)commentTap:(UITapGestureRecognizer*)tap{
    
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = _model.username;
    vc.artId = _model.uid;
    [self.containingViewController.navigationController pushViewController:vc animated:YES];
}
@end
