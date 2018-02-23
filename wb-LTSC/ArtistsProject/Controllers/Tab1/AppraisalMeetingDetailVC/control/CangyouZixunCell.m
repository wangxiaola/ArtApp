//
//  CangyouZixunCell.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouZixunCell.h"

@implementation CangyouZixunCell {
    UIImageView* imgTitle;
    HLabel* lblTitle;
    HLabel* lblSubmit;
    HLabel *lblHuifu, *lblHuifu1;
}
//@synthesize img
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView
{
    imgTitle = [[UIImageView alloc] init];
    imgTitle.layer.masksToBounds = YES;
    imgTitle.layer.cornerRadius = 30;
    [self addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        //        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.width.height.mas_equalTo(KKWidth(70));
        make.top.mas_equalTo(KKWidth(10));
    }];

    lblTitle = [[HLabel alloc] init];
    lblTitle.textColor = kTitleColor;
    lblTitle.font = kFont(15);
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(imgTitle.mas_centerY).offset(-3);
        make.left.equalTo(imgTitle.mas_right).offset(10);
        make.right.equalTo(self).offset(-50);
    }];

    lblSubmit = [[HLabel alloc] init];
    lblSubmit.textColor = kSubTitleColor;
    lblSubmit.numberOfLines = 0;
    lblSubmit.font = kFont(13);
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(imgTitle.mas_centerY).offset(3);
        make.left.equalTo(imgTitle.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];

    lblHuifu1 = [[HLabel alloc] init];
    lblHuifu1.textColor = kSubTitleColor;
    lblHuifu1.textEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    lblHuifu1.backgroundColor = ColorHex(@"f2f2f2");
    lblHuifu1.numberOfLines = 0;
    lblHuifu1.font = kFont(14);
    [self addSubview:lblHuifu1];
    [lblHuifu1 mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(imgTitle.mas_bottom).offset(5);
        make.left.equalTo(imgTitle.mas_right).offset(10);
        make.right.equalTo(self).offset(-20);
        make.height.mas_equalTo(30);
    }];

    lblHuifu = [[HLabel alloc] init];
    lblHuifu.textColor = kSubTitleColor;
    lblHuifu.textEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    lblHuifu.backgroundColor = ColorHex(@"f2f2f2");
    lblHuifu.numberOfLines = 0;
    lblHuifu.verticalTextAlignment = HLabelVerticalTextAlignmentTop;
    lblHuifu.font = kFont(13);
    [self addSubview:lblHuifu];
    [lblHuifu mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(lblHuifu1.mas_bottom).offset(-2);
        make.left.equalTo(imgTitle.mas_right).offset(10);
        make.right.equalTo(self).offset(-20);
    }];
}

- (void)setModel:(ExpertAppointmentZhubandanweiDataModel*)model
{
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1",model.zx.avatar]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    lblTitle.text = model.zx.uname;
    lblSubmit.text = model.zx.content; //[NSString stringWithFormat:@"成功举办%@场活动,共%@人参加",model.totalevent,model.totalmember];

    if (model.hf.uid.length > 0) {
        lblHuifu1.text = [NSString stringWithFormat:@"%@ 回复", model.hf.uname];
        NSLog(@"lblHuifu  width %f   height %f", lblHuifu.width, lblHuifu.height);
        CGSize size = CGSizeMake((DeviceSize.width - KKWidth(70) - 20 - 10 - 15), CGFLOAT_MAX);
        NSDictionary* dic = @{ NSFontAttributeName : kFont(13) };
        CGSize resultSize = [model.hf.content boundingRectWithSize:size
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:dic
                                                           context:nil]
                                .size;
        NSLog(@"resultSize  width %f   height %f", resultSize.width, resultSize.height);
        lblHuifu.text = model.hf.content;
        
    }
}

@end
