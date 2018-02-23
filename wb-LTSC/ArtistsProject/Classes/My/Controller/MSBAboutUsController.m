//
//  MSBAboutUsController.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAboutUsController.h"
#import "GeneralConfigure.h"

@interface MSBAboutUsController ()<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webView;

@end

@implementation MSBAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"关于我们";
    self.webView = [UIWebView new];
    [self.webView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.webView];
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.delegate = self;
    
    [self.webView setBackgroundColor:[UIColor clearColor]];
    [self.webView setOpaque:NO];
    
    NSString *basePath = [NSString stringWithFormat:@"%@/html",  [[NSBundle mainBundle] bundlePath]];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *htmlString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/about.html", basePath] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (![self.dk_manager.themeVersion isEqualToString:@"NORMAL"]) {
        [webView stringByEvaluatingJavaScriptFromString:@"nightChange()"];
    }
}


@end
