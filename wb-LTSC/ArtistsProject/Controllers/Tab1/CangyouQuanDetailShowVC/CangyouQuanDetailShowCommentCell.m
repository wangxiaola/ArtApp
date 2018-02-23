//
//  CangyouQuanDetailShowCommentCell.m
//  ShesheDa
//
//  Created by chen on 16/7/27.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouQuanDetailShowCommentCell.h"
#import "MyHomePageDockerVC.h"

@implementation CangyouQuanDetailShowCommentCell {
    UIImageView* imgTitle;
    HLabel* lblTitle;
    HLabel *lblSubmit, *lblTime;
    HView* viewRed;
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
    imgTitle.layer.cornerRadius = KKWidth(30);
    [self addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(KKWidth(11));
        make.left.equalTo(self).offset(KKWidth(25));
        make.width.height.mas_equalTo(KKWidth(60));
    }];
    imgTitle.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitle_Click)];
    [imgTitle addGestureRecognizer:tapTitle];

    lblTitle = [[HLabel alloc] init];
    lblTitle.textColor = kTitleColor;
    lblTitle.font = kFont(13);
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(imgTitle).offset(0);
        make.left.equalTo(imgTitle.mas_right).offset(KKWidth(22));
    }];

    lblSubmit = [[HLabel alloc] init];
    lblSubmit.textColor = kSubTitleColor;
    lblSubmit.font = kFont(13);
    lblSubmit.numberOfLines = 0;
    [self addSubview:lblSubmit];
    [lblSubmit mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(lblTitle.mas_bottom);
        make.left.equalTo(imgTitle.mas_right).offset(KKWidth(22));
        make.right.equalTo(self).offset(-KKWidth(103));
    }];

    lblTime = [[HLabel alloc] init];
    lblTime.textColor = kSubTitleColor;
    lblTime.font = kFont(10);

    [self addSubview:lblTime];
    [lblTime mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(imgTitle).offset(0);
        make.left.equalTo(lblTitle.mas_right).offset(10);
    }];

    HLabel* lblTitleOther = [[HLabel alloc] init];
    lblTitleOther.textColor = ColorHex(@"858585");
    lblTitleOther.font = kFont(13);
    lblTitleOther.text = @"回复";
    [self addSubview:lblTitleOther];
    [lblTitleOther mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(KKWidth(11));
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(KKWidth(60));
    }];

    NSLog(@"%@", NSStringFromCGRect(self.frame));
}

- (void)setModel:(CangyouQuanCommentsModel*)model
{
    _model = model;
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
    lblTime.text = [self changeTime:model.dateline];
    lblTitle.text = model.user.username;
    if (model.reply.length > 0) {
        lblSubmit.text = [NSString stringWithFormat:@"回复@ %@:%@", model.reply, model.message];
    }
    else {
        lblSubmit.text = model.message;
    }
}

- (NSString*)changeTime:(NSString*)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM/dd HH:MM:SS"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}

- (void)tapTitle_Click
{
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = _model.user.username;
    vc.artId = _model.user.uid;
    [self.containingViewController.navigationController pushViewController:vc animated:YES];
}

@end
