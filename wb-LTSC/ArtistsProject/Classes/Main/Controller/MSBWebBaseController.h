//
//  MSBWebBaseController.h
//  meishubao
//
//  Created by benbun－mac on 17/2/10.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "BaseViewController.h"

@interface MSBWebBaseController : BaseViewController<UIWebViewDelegate>
@property (nonatomic,strong,readonly) UIWebView * webView;

@property (nonatomic, copy) NSString * webUrl;
@property (nonatomic, assign) BOOL isWeb;
@property (nonatomic, copy) NSString *post_id; // 文章id

@end
