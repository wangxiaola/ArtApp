//
//  WebviewCell.m
//  ShesheDa
//
//  Created by chen on 16/8/3.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "WebviewCell.h"

@implementation WebviewCell {
    //    UIWebView *webView;
    HLabel* lblTitle;
}

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
    //    webView =[[UIWebView alloc] init];
    //    [self addSubview:webView];
    //    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self);
    //        make.top.equalTo(self).offset(10);
    //        make.left.equalTo(self).offset(50);
    //        make.width.mas_equalTo(140*3/2);
    //    }];

    lblTitle = [[HLabel alloc] init];
    lblTitle.text = @"@网页链接";
    lblTitle.font = kFont(15);
    lblTitle.textColor = kTitleColor;
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
    }];

    UIButton* btnRecord = [[UIButton alloc] init];
    [btnRecord setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    [btnRecord setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnRecord.titleLabel.font = kFont(15); //[[Global sharedInstance]fontWithSize:15];
    [btnRecord addTarget:self action:@selector(btnRecord_Click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnRecord];
    [btnRecord mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(KKWidth(570));
        make.height.width.width.mas_equalTo(20);
    }];
}
- (void)btnRecord_Click
{
    if (self.btndelBlock) {
        self.btndelBlock();
    }
}
- (void)setUrl:(NSString*)Url
{
    //    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:Url]];
    //    [webView loadRequest:request];
}

@end
