//
//  WorksFirstCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "CirclesCell.h"
#import "HomeListDetailVc.h"

@interface CirclesCell ()
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)UILabel* zanLabel;
@property(nonatomic,strong)NSMutableDictionary* recentCellDic;
@property(nonatomic,strong)NSString* nameStr ;
@end

@implementation CirclesCell

-(void)addContentViews{
    _recentCellDic = [[NSMutableDictionary alloc]init];
    _baseImage = [[UIImageView alloc]init];
    _baseImage.userInteractionEnabled = YES;
    _baseImage.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:_baseImage];
    [_baseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(60);
    }];
    
    _zanLabel = [[UILabel alloc]init];
    _zanLabel.textAlignment = NSTextAlignmentLeft;
    _zanLabel.numberOfLines = 0;
    _zanLabel.textColor = kZANLABELColor;
    _zanLabel.font = ART_FONT(ARTFONT_OT);
    [_baseImage addSubview:_zanLabel];
    [_zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_baseImage.mas_left).offset(6);
        make.right.equalTo(_baseImage.mas_right).offset(-6);
        make.top.equalTo(_baseImage.mas_top).offset(6);
        make.height.mas_equalTo(15);
    }];
    
    for (int i=0; i<3; i++) {
        UILabel* Label = [[UILabel alloc]init];
         UITapGestureRecognizer* commentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentTap:)];
        Label.userInteractionEnabled = YES;
        [Label addGestureRecognizer:commentTap];
        
        Label.tag = 100+i;
        Label.textAlignment = NSTextAlignmentLeft;
        Label.numberOfLines = 0;
        Label.font = ART_FONT(ARTFONT_OT);
        [_baseImage addSubview:Label];
        
        [Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_zanLabel.mas_bottom).offset(8+i*13);
            make.height.mas_equalTo(13);
            make.left.equalTo(_baseImage.mas_left).offset(6);
            make.right.equalTo(_baseImage.mas_right).offset(-6);
        }];
    }
    
    //自定义线条
    UIImageView *line1=[[UIImageView alloc]init];
    line1.backgroundColor=Art_LineColor;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
    }];

}
-(CGFloat)setArtTableViewCellDicValue:(NSDictionary *)dic{
    CGFloat cellHeight=0;
    [_recentCellDic removeAllObjects];
    [_recentCellDic addEntriesFromDictionary:dic];

    NSMutableString* titleStr = [[NSMutableString alloc]init];
    id likeArr = dic[@"likeuser"];
    
    if ([likeArr isKindOfClass:[NSArray class]]){
        NSArray* tempArr = dic[@"likeuser"];
        for (NSDictionary* dic in tempArr){
            NSString* namStr = dic[@"username"];
            if (namStr.length>0) {
                 [titleStr appendFormat:@"%@,",dic[@"username"]];
            }
        }
    }
    if (titleStr.length>0) {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",titleStr]];
        NSTextAttachment *text = [[NSTextAttachment alloc] init];
        text.image = [UIImage imageNamed:@"likeUser"];
        text.bounds = CGRectMake(0,-3, _zanLabel.font.pointSize, _zanLabel.font.pointSize);
    [attributedString insertAttributedString:[NSAttributedString attributedStringWithAttachment:text] atIndex:0];
    _zanLabel.attributedText  = attributedString;
    }else{
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",@" "]];
//        NSTextAttachment *text = [[NSTextAttachment alloc] init];
//        text.image = [UIImage imageNamed:@"likeUser"];
//        text.bounds = CGRectMake(0,-3, _zanLabel.font.pointSize, _zanLabel.font.pointSize);
//        [attributedString insertAttributedString:[NSAttributedString attributedStringWithAttachment:text] atIndex:0];
        _zanLabel.text  = @"";
    }
    
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-30, 13);
    CGSize expectSize = [_zanLabel sizeThatFits:maximumLabelSize];
    
    [_zanLabel mas_updateConstraints:^(MASConstraintMaker *make){
        if (expectSize.height<35) {
            make.height.mas_equalTo(expectSize.height);
        }else{
           make.height.mas_equalTo(35);
        }
    }];
    if (expectSize.height<35){
        if (expectSize.height>0) {
            cellHeight+=expectSize.height+14;
        }
    }else{
       cellHeight+=35+14;
    }
    
    
    //评论
    
    for (int i=0; i<4; i++) {
        UILabel* img = [_baseImage viewWithTag:100+i];
        img.hidden = YES;
    }
    
    id commentArr = dic[@"comments"];
    if ([commentArr isKindOfClass:[NSArray class]]){
        NSArray* tempArr = dic[@"comments"];
            CGFloat titlabelHeight = 0;
            NSInteger  tempNum = tempArr.count;
            if (tempNum>3) {
                tempNum = 3;
            }
        for (int i=0; i<tempNum; i++) {
            UILabel* titleLabel = [_baseImage viewWithTag:100+i];
            titleLabel.hidden = NO;
            
            NSDictionary* dic = tempArr[i];
            NSDictionary* authorDic = [dic objectForKey:@"author"];
            
            BOOL  ishave=[dic containsObjectForKey:@"username"];
            if (ishave) {
                 _nameStr = authorDic[@"username"];
            }else
            {
               _nameStr = @"";
            }
            NSString* message  = dic[@"message"];
            NSString* resultStr = [NSString stringWithFormat:@"%@: %@",_nameStr,message];
           
            //富文本
            NSMutableAttributedString* attri = [[NSMutableAttributedString alloc]initWithString:resultStr];
            [attri addAttribute:NSForegroundColorAttributeName value:kZANLABELColor range:NSMakeRange(0,_nameStr.length+2)];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OT] range:NSMakeRange(0,_nameStr.length+2)];
            
            [attri addAttribute:NSForegroundColorAttributeName value:kColor7 range:NSMakeRange(_nameStr.length+2,message.length)];
            [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OT] range:NSMakeRange(_nameStr.length+2,message.length)];
            
            titleLabel.attributedText = attri;
            CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-30, 13);
            CGSize expectSize = [titleLabel sizeThatFits:maximumLabelSize];
        
            [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_zanLabel.mas_bottom).offset(8+titlabelHeight);
                make.height.mas_equalTo(expectSize.height+6);
            }];
            titlabelHeight+=expectSize.height+6;
        }
            if (tempArr.count>0) {
                 cellHeight+=titlabelHeight+8;
            }
       
    }
    
    [_baseImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(cellHeight);
    }];

    return cellHeight>0?cellHeight+20:2;
}
-(void)commentTap:(UITapGestureRecognizer*)tap{
    NSInteger index = tap.view.tag-100;
    NSArray* tempArr = _recentCellDic[@"comments"];
    NSDictionary* dic = tempArr[index][@"author"];
    
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = dic[@"username"];
    vc.artId = dic[@"uid"];
    [self.containingViewController.navigationController pushViewController:vc animated:YES];
}
@end
