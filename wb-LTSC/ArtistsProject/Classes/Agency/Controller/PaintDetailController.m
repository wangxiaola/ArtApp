//
//  PaintDetailController.m
//  meishubao
//
//  Created by benbun－mac on 17/1/22.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "PaintDetailController.h"
#import "GeneralConfigure.h"
#import "MSBShareContentView.h"
#import "MSBWebBaseController.h"
#import "MSBPersonCenterController.h"

@interface PaintDetailController ()

@end

@implementation PaintDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.titleType && self.titleType == WebTitleTypeHuaYuan) {
        self.title = @"中国国家画院";
    }
}

#pragma mark - Private Method
/**
 * page _commit
 */
- (void)_commitRightItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"detailpage_item_more"] style:UIBarButtonItemStyleDone target:self action:@selector(shareItemClick)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)shareItemClick {
    
    MSBShareContentView * shareContentView = [[MSBShareContentView alloc] init];
    [shareContentView setArticleDetialVC:self];
    [shareContentView show];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = request.URL;
//    NSString *scheme = [url scheme];
//    NSString *host = [url host];
//    NSString *path = [url path];
    
    //    NSString *key = [NSString stringWithFormat:@"%@://%@%@", scheme, host,path];
        //NSLog(@"scheme== %@,host=== %@,path===%@ ", scheme, host,path);//stringByRemovingPercentEncoding
    
    //    NSString *urlEncode = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlEncode = [[url absoluteString] stringByRemovingPercentEncoding];
    NDLog(@"url === %@---%@", url.absoluteString,urlEncode);
    NSRange range = [urlEncode rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        NSString *propertys = [urlEncode substringFromIndex:(NSInteger)(range.location+1)];
        NSLog(@"propertys === %@", propertys);
        
        NSArray *subArray = [propertys componentsSeparatedByString:@"&"];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int j = 0 ; j < subArray.count; j++){
            //在通过=拆分键和值
            NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
            //给字典加入元素
            [tempDic setObject:dicArray[1] forKey:dicArray[0]];
        }
        NDLog(@"打印参数列表生成的字典：%@", tempDic);
        
        if ([[tempDic valueForKey:@"bb:open_native"] isEqualToString:@"artist/profile"]) {
            
            NSString *jsonStr = [tempDic valueForKey:@"bb:applink_data"];
            
            NSDictionary *param = [NSString dictionaryWithJsonString:jsonStr];
            
            MSBPersonDetailController *vc = [MSBPersonDetailController new];
            vc.artistId =[NSString stringWithFormat:@"%@",param[@"artist_id"]];
            [self.navigationController pushViewController:vc animated:YES];
            //NSLog(@"-----%@", param);
            return NO;
        }
        //anniversary30/gallery
//        if ([[tempDic valueForKey:@"bb:open_native"] isEqualToString:@"anniversary30/gallery"]) {
//            NSString *jsonStr = [tempDic valueForKey:@"bb:applink_data"];
//            NSDictionary *param = [NSString dictionaryWithJsonString:jsonStr];
//            TopViewController *vc = [TopViewController new];
//            vc.tid =[NSString stringWithFormat:@"%@",param[@"post_id"]];
//            vc.wantsNavigationBarVisible = NO;
//            [self.navigationController pushViewController:vc animated:YES];
//            return NO;
//        }

        if ([[tempDic valueForKey:@"bb:open_web"] integerValue] == 1) {
            MSBWebBaseController *vc = [MSBWebBaseController new];
            vc.webUrl = url.absoluteString;
            vc.post_id = tempDic[@"post_id"];
            [self.navigationController pushViewController:vc animated:YES];
            return NO;
        }
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
  // [self webLoadView:self.view];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //self.title =  [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (self.titleType == WebTitleTypeNormal||!self.titleType) {
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    [self endLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
