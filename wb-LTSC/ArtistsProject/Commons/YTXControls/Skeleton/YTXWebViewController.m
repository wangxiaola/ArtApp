//
//  YTXWebViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2017/1/6.
//  Copyright © 2017年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXWebViewController.h"

@interface YTXWebViewController ()
@property (strong, nonatomic) UIWebView *webView;
@end
@implementation YTXWebViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden=YES;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, -49, 0);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.tabBarController.tabBar.hidden=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = kTitleColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _naviTitle;
    self.navigationItem.titleView = titleLabel;
    _webView = [[UIWebView alloc] init];
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

@end
