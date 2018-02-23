//
//  HelpCenterVC.m
//  Car
//
//  Created by Heliulin on 15/9/16.
//  Copyright (c) 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "H5VC.h"

@interface H5VC ()

@end

@implementation H5VC
@synthesize navTitle,url;
- (void)viewDidLoad {
    
    [super viewDidLoad];    
    UIWebView *webView =[[UIWebView alloc] init];
    
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=navTitle;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
