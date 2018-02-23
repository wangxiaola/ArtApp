//
//  MediaSecondCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/31.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MediaSecondCell.h"
#define Second_Cell_height T_WIDTH(87)


@interface MediaSecondCell ()
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)UIImageView* titImgView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)CustomLabel * subLabel;
@property(nonatomic,strong)CustomLabel * seeLabel;
@property(nonatomic,strong)CustomLabel * kindLabel;
@property(nonatomic,strong)CustomLabel* timeLabel;
@end

@implementation MediaSecondCell

-(void)addContentViews{
    _baseImage = [[UIImageView alloc]init];
    [self.contentView addSubview:_baseImage];
    [_baseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.height.mas_equalTo(0);
    }];
    
    for (int i=0; i<3; i++) {
        UIImageView* img = [[UIImageView alloc]init];
        img.tag = 100+i;
        [_baseImage addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.bottom.equalTo(_baseImage);
            make.left.equalTo(_baseImage);
            make.width.mas_equalTo(0);
        }];
    }
    
    _titImgView = [[UIImageView alloc]init];
    [self.contentView addSubview:_titImgView];
    [_titImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(_baseImage.mas_bottom).offset(0);
        make.bottom.equalTo(self.contentView);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = ART_FONT(ARTFONT_OE);
    [_titImgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titImgView);
        make.top.equalTo(_titImgView.mas_top).offset(T_WIDTH(15));
        make.height.mas_equalTo(T_WIDTH(20));
    }];
    
    _subLabel = [[CustomLabel alloc]init];
    _subLabel.numberOfLines = 0;
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.font = ART_FONT(ARTFONT_OTH);
    [_titImgView addSubview:_subLabel];
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titImgView);
        make.top.equalTo(_titleLabel.mas_bottom).offset(T_WIDTH(15));
        make.height.mas_equalTo(T_WIDTH(0));
    }];
    _seeLabel = [[CustomLabel alloc]init];
    _seeLabel.textAlignment = NSTextAlignmentLeft;
    _seeLabel.font = ART_FONT(ARTFONT_OT);
    [_titImgView addSubview:_seeLabel];
    [_seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_titImgView);
        make.bottom.equalTo(_titImgView.mas_bottom).offset(T_WIDTH(-7));
        make.height.mas_equalTo(T_WIDTH(20));
    }];

    UIImageView *line1=[[UIImageView alloc]init];
    line1.backgroundColor=kLineColor;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
    }];
//    _kindLabel = [[CustomLabel alloc]init];
//    _kindLabel.textAlignment = NSTextAlignmentLeft;
//    _kindLabel.font = ART_FONT(ARTFONT_OT);
//    [_titImgView addSubview:_kindLabel];
//    [_kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_seeLabel.mas_right).offset(0);
//        make.top.equalTo(_subLabel.mas_bottom).offset(T_WIDTH(7));
//        make.width.mas_equalTo(T_WIDTH(120));
//        make.height.mas_equalTo(T_WIDTH(20));
//    }];
//
//    _timeLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(getViewWidth(_kindLabel), getViewHeight(_subLabel)+T_WIDTH(7), T_WIDTH(80),T_WIDTH(20))];
//    _timeLabel.textAlignment = NSTextAlignmentLeft;
//    _timeLabel.font = ART_FONT(ARTFONT_OT);
//    [_titImgView addSubview:_timeLabel];
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_kindLabel.mas_right).offset(0);
//        make.top.equalTo(_subLabel.mas_bottom).offset(T_WIDTH(7));
//        make.width.mas_equalTo(T_WIDTH(80));
//        make.height.mas_equalTo(T_WIDTH(20));
//    }];
}

- (CGFloat)setMediaCellDicValue:(NSDictionary *)dic{
    CGFloat cellHeight = T_WIDTH(25)+45;
    _titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"topictitle"]];
   
    NSMutableArray* subArr = [[NSMutableArray alloc]init];
    NSString* seeStr = [NSString stringWithFormat:@"查看%@",dic[@"clicknum"]];
    if (seeStr.length>0) {
        [subArr addObject:seeStr];
    }

    id obj = dic[@"source"];
    NSString* kindStr = @"";
    if ([obj isKindOfClass:[NSDictionary class]]) {
        kindStr  = [NSString stringWithFormat:@"%@",dic[@"source"][@"username"]];
    }else{
    kindStr  = [NSString stringWithFormat:@"%@",dic[@"source"]];
    }
    
    if (kindStr.length>0) {
        [subArr addObject:kindStr];
    }
    
    NSString* timeStr = [NSString stringWithFormat:@"%@",dic[@"age"]];
    if (seeStr.length>0) {
        [subArr addObject:timeStr];
    }
    NSString* result=@"";
    if (subArr.count>0) {
        result = [subArr componentsJoinedByString:@"   "];
    }
    _seeLabel.text = result;
    
    UIImageView* img1 = [_baseImage viewWithTag:100];
    img1.hidden = YES;
    UIImageView* img2 = [_baseImage viewWithTag:101];
    img2.hidden = YES;
    UIImageView* img3 = [_baseImage viewWithTag:102];
    img3.hidden = YES;
    //containsObject
    //containsObject
   
    if([[dic allKeys] containsObject:@"photoscbk"]){
        NSArray* imgArr = dic[@"photoscbk"];
        kPrintLog(imgArr);
        if (imgArr.count>0) {
            cellHeight+=T_WIDTH(15);
        if (imgArr.count<3){
            [_baseImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo((SCREEN_WIDTH-30)/2);
                make.top.equalTo(self.contentView.mas_top).offset(15);
            }];
            cellHeight+=(SCREEN_WIDTH-30)/2;
            
            UIImageView* img = [_baseImage viewWithTag:100];
            img.hidden = NO;
            [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!2b1",imgArr[0][@"photo"]] tempTmage:@"icon_Default_Product"];
            [img mas_remakeConstraints:^(MASConstraintMaker *make){
                make.top.bottom.equalTo(_baseImage);
                make.left.equalTo(_baseImage.mas_left).offset(T_WIDTH(15));
                make.right.equalTo(_baseImage.mas_right).offset(T_WIDTH(-15));
            }];
        }else{
            [_baseImage mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo((SCREEN_WIDTH-T_WIDTH(44))/3);
                make.top.equalTo(self.contentView.mas_top).offset(15);
            }];
            cellHeight+=(SCREEN_WIDTH-T_WIDTH(44))/3;
            
            CGFloat width = (SCREEN_WIDTH-T_WIDTH(44))/3;
            UIImageView* img1 = [_baseImage viewWithTag:100];
            img1.hidden = NO;
            [img1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[0][@"photo"]] tempTmage:@"icon_Default_Product"];
            [img1 mas_remakeConstraints:^(MASConstraintMaker *make){
                make.top.bottom.equalTo(_baseImage);
                make.left.equalTo(_baseImage.mas_left).offset(T_WIDTH(15));
                make.width.mas_equalTo(width);
            }];
            
            
            UIImageView* img2 = [_baseImage viewWithTag:101];
            img2.hidden = NO;
            [img2 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[1][@"photo"]] tempTmage:@"icon_Default_Product"];
            [img2 mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.top.bottom.equalTo(_baseImage);
                make.left.equalTo(_baseImage.mas_left).offset(T_WIDTH(15)+(T_WIDTH(7)+width));
                make.width.mas_equalTo(width);
            }];
            
            UIImageView* img3 = [_baseImage viewWithTag:102];
            img3.hidden = NO;
            [img3 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgArr[2][@"photo"]] tempTmage:@"icon_Default_Product"];
            [img3 mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.top.bottom.equalTo(_baseImage);
                make.left.equalTo(_baseImage.mas_left).offset(T_WIDTH(15)+(T_WIDTH(7)+width)*2);
                make.width.mas_equalTo(width);
            }];
        }
      }

    }else{
        [_baseImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.top.equalTo(self.contentView.mas_top).offset(0);
        }];
    }
    
    return cellHeight;
}

@end
