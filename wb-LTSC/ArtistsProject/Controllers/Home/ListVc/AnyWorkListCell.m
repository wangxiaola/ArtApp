//
//  AnyWorkListCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "AnyWorkListCell.h"

@interface AnyWorkListCell ()

@end
@implementation AnyWorkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _titLabel.textAlignment = NSTextAlignmentLeft;
    _chkDefault = [[sendBtn alloc] init];
    _chkDefault.titleFrame = CGRectMake(0, 5, 30, 20);
    _chkDefault.imgFrame = CGRectMake(40, 10, 10, 10);
    _chkDefault.titleLabel.textAlignment = NSTextAlignmentRight;
    [_chkDefault setTitle:@"详情" forState:UIControlStateNormal];
    [_chkDefault.titleLabel setFont:ART_FONT(ARTFONT_OT)];
    [_chkDefault setTitleColor:kColor6 forState:UIControlStateNormal];
    [_chkDefault setImage:[UIImage imageNamed:@"icon_UserIndexVC_rightArrow"] forState:UIControlStateNormal];
   
    [_chkDefault addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_chkDefault];
    [_chkDefault mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_backImg.mas_bottom).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)detailClick{
    NSDictionary* dic = [_model.mj_keyValues copy];
    if (self.detailBtnCilck){
        self.detailBtnCilck(dic);
    }
}
-(void)setAnyWorkListDic:(NSDictionary *)dic{
    
    _model = [CangyouQuanDetailModel mj_objectWithKeyValues:dic];
    NSMutableArray* titleArr = [[NSMutableArray alloc]init];
    NSString* tit = [NSString stringWithFormat:@"%@",dic[@"topictitle"]];
    if (tit.length>0) {
        [titleArr addObject:tit];
    }

    NSString* timeStr = [NSString stringWithFormat:@"%@",dic[@"age"]];
    if (timeStr.length>0) {
        [titleArr addObject:[NSString stringWithFormat:@"%@年",timeStr]];
    }
    
    NSString* widht = [NSString stringWithFormat:@"%@",dic[@"width"]];
    NSString* height = [NSString stringWithFormat:@"%@",dic[@"height"]];
    NSString* longStr = [NSString stringWithFormat:@"%@",dic[@"long"]];
    NSString* sum = [ArtUIHelper returnWidth:widht Height:height Long:longStr];
    if (sum.length>0) {
        [titleArr addObject:sum];
    }
    
    NSString* titleStr = @"";
    if (titleArr.count>0) {
        titleStr = [titleArr componentsJoinedByString:@" "];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",titleStr]];
    if (![dic[@"video"] isEqualToString:@""]){//视频图标
        NSTextAttachment *text = [[NSTextAttachment alloc] init];
        text.image = [UIImage imageNamed:@"icon_video"];
        text.bounds = CGRectMake(0,-3, _titLabel.font.pointSize, _titLabel.font.pointSize);
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204),NSFontAttributeName:_titLabel.font}]];
    }
    
    _titLabel.attributedText  = attributedString;
    
    if (_model.photoscbk.count>0){
        photoscbkModel* photoModel = _model.photoscbk[0];
        
    [_backImg sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!3b2",photoModel.photo] tempTmage:@"icon_Default_Product"];
    }
   
}
@end
