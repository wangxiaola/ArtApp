//
//  MSBArticleCommentController.m
//  meishubao
//
//  Created by T on 16/11/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBArticleCommentController.h"
#import "MSBPersonCenterController.h"

#import "GeneralConfigure.h"
#import "JSBridge.h"
#import "UIWebView+TS_JavaScriptContext.h"

#import "MSBArticleCommentModel.h"
#import "MSBCommentBottom.h"
#import "MSBCommentView.h"
#import "MSBShareCommentView.h"
#import "MSBLoadingView.h"
#import "MSBReplyCommentMore.h"
#import "MSBReplyComment.h"

@interface MSBArticleCommentController ()<UIWebViewDelegate,TSWebViewDelegate, JSBridgeDelegate>
@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) JSBridge *bridge;

@end

@implementation MSBArticleCommentController{
    BOOL  _isJsbridgeInit;
    BOOL _isDataRequestInit;
    NSMutableArray *_datas;
    id _data;
    //NSString * _offSet;//回复加载更多的页数
    //NSString * _commentOffSet;//评论加载更多的页数
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLogoTitle];
    // _commitWebView
    [self _commitWebView];
    
    // _commitBottom
    [self _commitBottom];
    
    // requestData
    [self requestData];
    
    [self webLoadView:self.view];
}

- (void)dealloc{
    
    NDLog(@"MSBArticleCommentController dealloc");
    
    if (self.webView) {
        [self.webView removeFromSuperview];
        self.webView.delegate = nil;
        self.webView = nil;
    }
    
    if (self.bridge) {
        self.bridge.delegate = nil;
        self.bridge = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// _commitWebView
- (void)_commitWebView{
    self.bridge = [[JSBridge alloc] init];
    [self.bridge setDelegate:self];
    self.webView = [UIWebView new];
    [self.webView setDelegate:self];
    [self.webView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49.f)];
    [self.view addSubview:self.webView];
    self.bridge.webview = self.webView;
    self.webView.scalesPageToFit = YES;
    //self.webView.scrollView.bounces = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setOpaque:NO];
    
    NSString *basePath = [NSString stringWithFormat:@"%@/html",  [[NSBundle mainBundle] bundlePath]];
    NSURL *baseURL = [NSURL fileURLWithPath:basePath isDirectory:YES];
    NSString *htmlString = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/comment_article.html", basePath] encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}

// _commitBottom
- (void)_commitBottom{
    MSBCommentBottom *commentBottom = [MSBCommentBottom new];
    [commentBottom setFrame:CGRectMake(0, SCREEN_HEIGHT - kBottomHeight, SCREEN_WIDTH, 49.f)];
    [self.view addSubview:commentBottom];
     __block __weak typeof(self) weakSelf = self;
    commentBottom.commentBlock = ^(){
        [weakSelf commentClick];
    };
}

- (void)requestData{
    
     __weak __block typeof(self)  weakSelf = self;
    
    [[LLRequestServer shareInstance] requestArticleDetailCommentsWithPostId:_tid artist_id:nil video_id:nil
                                                                       type:1 offset:@"0" pagesize:10 success:^(LLResponse *response, id data) {
        if (data!=nil && [data isKindOfClass:[NSDictionary class]]) {
            _isDataRequestInit = YES;
          NSArray *arr =  [MSBArticleCommentModel mj_objectArrayWithKeyValuesArray:data[@"items"]];
            //_commentOffSet = data[@"offset"];
            _datas = [NSMutableArray arrayWithArray:arr];
            _data = data;
            
            [weakSelf initConfigDataComment:_datas data:data];
        }
    } failure:^(LLResponse *response) {
        //没有数据 或者数据为空
        _isDataRequestInit = YES;
        _datas = [NSMutableArray arrayWithArray:@[]];
        _data = @{@"total":@"",@"offset":@"",@"pagesize":@"",@"items":@[]};
        
        [weakSelf initConfigDataComment:_datas data:_data];
    } error:^(NSError *error) {
        _isDataRequestInit = YES;
        _datas = [NSMutableArray arrayWithArray:@[]];
        _data = @{@"total":@"",@"offset":@"",@"pagesize":@"",@"items":@[]};
        
        [weakSelf initConfigDataComment:_datas data:_data];
    }];
}

- (void)commentClick{
//    if (![MSBAccount userLogin]) {
//        LoginViewController *loginVC = [LoginViewController new];
//        [self.navigationController pushViewController:loginVC animated:YES];
//        return;
//    }

    if ([MSBJumpLoginVC showLoginAlert:self]) {
        return;
    }
    
    __weak __block typeof(self) weakSelf = self;
    [MSBCommentView commentshowSuccess:^(NSString *commentText) {
        
        if (commentText.length == 0) {
            [weakSelf hudTip:@"请输入内容"];
            return ;
        }
        
        [weakSelf hudLoding];
        [[LLRequestBaseServer shareInstance] requestArticleDetailPublishCommentPostId:_tid artist_id:nil video_id:nil type:1 commentId:nil mainCommentId:nil toUid:nil commentContent:commentText success:^(LLResponse *response, id data) {
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                NSDictionary * reply_comments = @{@"hasmore":@0,@"reply_comments_num":@0,@"items":@[]};
                MSBReplyComment * comment = [MSBReplyComment mj_objectWithKeyValues:data];
                NSMutableDictionary * resultDic = [NSMutableDictionary dictionaryWithDictionary:[comment mj_keyValues]];
                [resultDic setObject:reply_comments forKey:@"reply_comments"];
                [resultDic setObject:@0 forKey:@"praise"];
                [weakSelf.bridge nativeCallH5Handler:@"page" handlerName:@"writeComment" data:[NSString dictionaryToJson:resultDic]];
                [weakSelf showSuccess:@"评论成功"];
            }
        } failure:^(LLResponse *response) {

            [weakSelf showError:@"评论失败"];
        } error:^(NSError *error) {

            [weakSelf showError:@"评论失败"];
        }];
    }];
}


#pragma mark - jsbridge
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    ctx[@"__jsbridge"] = self.bridge;
}

// onJsBridgeInit
- (void)onJsBridgeInit{
    _isJsbridgeInit = YES;
    [self initConfigDataComment:_datas data:_data];
}

- (void)initConfigDataComment:(NSArray *)comment data:(id)data{
    if (!(_isJsbridgeInit && _isDataRequestInit)) return;
    //if (comment.count <=0 || comment == nil) return;
    
    NSNumber *is_praise = nil;
    NSNumber *praise = nil;
    NSArray *post_keywords = nil;
    if (self.detailModel == nil) {
        is_praise = @(0);
        praise = @(0);
        post_keywords = @[];
    }else{
        is_praise = @(self.detailModel.is_praise);
        praise = @(self.detailModel.praise);
        post_keywords = self.detailModel.post_keywords.count>0?self.detailModel.post_keywords:@[];
    }
    
    NSDictionary* comments = @{
                                 @"total":data[@"total"],
                                 @"offset":data[@"offset"],
                                 @"pagesize":data[@"pagesize"],
                                 @"items":comment.count>0?[MSBArticleCommentModel mj_keyValuesArrayWithObjectArray:comment]:@[]
                                 };
    
    NSDictionary *articleDic = @{
//                                     @"is_praise":@(self.detailModel.is_praise),
//                                     @"praise":@(self.detailModel.praise),
                                     @"post_title":[NSString notNilString:self.detailModel.post_title],
                                     @"comment_num":[NSString notNilString:self.detailModel.comment_num],
//                                     @"post_keywords":self.detailModel.post_keywords.count>0?self.detailModel.post_keywords:@[],
                                     
                                     @"is_praise":is_praise,
                                     @"praise":praise,
                                      @"post_keywords":post_keywords,
                                 };
    
    NSDictionary *hotComments = @{
                                  @"items":self.hotComments.count>0?[MSBArticleCommentModel mj_keyValuesArrayWithObjectArray:self.hotComments]:@[]
                                  };
    
    NSDictionary *initPara = @{
                               @"themeVersion":self.dk_manager.themeVersion,
                               @"articleDetail":articleDic,
                               @"hotComments":hotComments,
                               @"comments":comments
                               };
    //NSLog(@"初始评论：%@",[NSString dictionaryToJson:hotComments]);
    [self.bridge nativeCallJsInitConfig:[NSString dictionaryToJson:initPara]];
}

// onWebPageReady
- (void)onWebPageReady{
    __weak __block typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf endLoading];
    });
    // 点击用户头像
    [self.bridge registerHandler:@"page" handlerName:@"readUserinfo" callback:^(id data) {
        NDLog(@"readUserinfo --comment---%@  %@", data, [NSThread currentThread]);
        NSString * anonymity = data[@"anonymity"];
        if (anonymity.integerValue == 1) {
            //如果匿名
            [weakSelf hudTip:@"该用户已匿名"];
            return;
        }else{
            MSBPersonCenterController *vc = [MSBPersonCenterController new];
            vc.uid = data[@"uid"];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    // 评论点赞
    [self.bridge registerHandlerForResult:self module:@"page" handlerName:@"upvoteComment" callbackResult:^(id data, callBackBlock responseCallback) {
        //NSLog(@"----upvoteComment %@", data);
        NSString * commentId = data[@"comment_id"];
        BOOL isPraise = [data[@"is_praise"] integerValue];
        if ([MSBAccount userLogin]) {
            BOOL isPraise = [[NSString stringWithFormat:@"%@", data[@"is_praise"]] integerValue];
            [weakSelf hudLoding];
            [[LLRequestServer shareInstance] requestArticleDetailCommentPraisePostId:nil commentId:commentId videoId:nil artistId:nil orgId:nil parise:!isPraise type:2 success:^(LLResponse *response, id data) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                //NSLog(@"%d",isPraise);
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }
                responseCallback(result);
            } failure:^(LLResponse *response) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }
                responseCallback(result);
            } error:^(NSError *error) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }
                responseCallback(result);
            }];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }
                responseCallback(result);
            });
        }
    }];
    
    // 点赞文章
    [self.bridge registerHandlerForResult:self module:@"page" handlerName:@"upvoteArticle" callbackResult:^(id data, callBackBlock responseCallback) {
        //NSLog(@"----upvoteArticle %@", data);
        BOOL isPraise = [data[@"is_praise"] integerValue];
        
        if ([MSBAccount userLogin]) {
            BOOL isPraise = [[NSString stringWithFormat:@"%@", data[@"is_praise"]] integerValue];
            [weakSelf hudLoding];
            [[LLRequestServer shareInstance] requestArticleDetailCommentPraisePostId:weakSelf.tid commentId:nil videoId:nil artistId:nil orgId:nil parise:!isPraise type:1 success:^(LLResponse *response, id data) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }
                responseCallback(result);
            } failure:^(LLResponse *response) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }
                responseCallback(result);
            } error:^(NSError *error) {
                [weakSelf hiddenHudLoding];
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }
                responseCallback(result);
            }];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *result;
                if (isPraise) {
                    result = [NSString dictionaryToJson:@{@"is_praise":@NO}];
                }else{
                    result = [NSString dictionaryToJson:@{@"is_praise":@YES}];
                }
                responseCallback(result);
            });
        }
    }];
    
    // 查看所有回复
    [self.bridge registerHandlerForResult:self module:@"page" handlerName:@"commentAllReply" callbackResult:^(id data, callBackBlock responseCallback) {
        NDLog(@"----commentAllReply %@", data);
        NSString * commentId = data[@"comment_id"];
        
        [[LLRequestServer shareInstance] requestReplyCommentMoreWithMainCommentId:commentId offSet:@"5" pageSize:0 success:^(LLResponse *response, id data) {
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                MSBReplyCommentMore * replyMore = [MSBReplyCommentMore mj_objectWithKeyValues:data];
                //_offSet = replyMore.offset;
                NSDictionary * backData = @{@"hasmore":@(replyMore.hasmore),@"reply_comments":[MSBReplyComment mj_keyValuesArrayWithObjectArray:replyMore.reply_comments]};
                NSString * result = [NSString dictionaryToJson:backData];
                //NSLog(@"========result:%@",result);
                responseCallback(result);
            }
        } failure:^(LLResponse *response) {
            NDLog(@"错误：%@",response.msg);
        } error:^(NSError *error) {
            
        }];
    }];
    
    //回复
    [self.bridge registerHandlerForResult:self module:@"page" handlerName:@"writeReply" callbackResult:^(id data, callBackBlock responseCallback) {
        NDLog(@"----writeReply %@", data);
        
        if ([MSBJumpLoginVC showLoginAlert:weakSelf]) {
            return;
        }
        
        NSString * toUid = data[@"to_uid"];
        NSString * commentId = data[@"comment_id"];
        NSString * mainCommentId = data[@"main_comment_id"];
        NSString * content = data[@"content"];
        
        MSBShareCommentView * commentView = [MSBShareCommentView shareInstance];
        commentView.articleDetialVC = weakSelf;
        commentView.msb_copyContent = content;
        commentView.comment_id      = commentId;
        [commentView show];
        
        //举报操作
        [commentView reportComment:^(NSString *comment_id){
            
            [weakSelf hudLoding];
            [[LLRequestServer shareInstance] requestReportComment:comment_id.integerValue Success:^(LLResponse *response, id data) {
                

                [weakSelf showSuccess:response.msg];
            } failure:^(LLResponse *response) {

                [weakSelf showError:response.msg];
            } error:^(NSError *error) {

                [weakSelf showError:@"网络出错"];
            }];
        }];
        
        [commentView replyComment:^(NSString *context) {
            if (context.length == 0) {
                [weakSelf hudTip:@"请输入内容"];
                return ;
            }
            
            [weakSelf hudLoding];
            [[LLRequestBaseServer shareInstance] requestArticleDetailPublishCommentPostId:weakSelf.tid artist_id:nil video_id:nil type:1 commentId:commentId mainCommentId:mainCommentId toUid:toUid commentContent:context success:^(LLResponse *response, id data) {

                [weakSelf showSuccess:@"评论成功"];
                if (data && [data isKindOfClass:[NSDictionary class]]) {
                    MSBReplyComment * comment = [MSBReplyComment mj_objectWithKeyValues:data];
                    NSString * result = [comment mj_JSONString];
                    //NSLog(@"回复：%@",result);
                    responseCallback(result);
                }
            } failure:^(LLResponse *response) {

                [weakSelf showError:@"评论失败"];
            } error:^(NSError *error) {

                [weakSelf showError:@"网络出错"];
            }];
        }];
    }];
    
    //加载更多
    [self.bridge registerHandlerForResult:self module:@"page" handlerName:@"loadMoreComment" callbackResult:^(id data, callBackBlock responseCallback) {
        NDLog(@"=========loadMoreComment:%@",data);
        NSString * page = data[@"offset"];
        NSString * pagesize = data[@"pagesize"];
        [[LLRequestServer shareInstance] requestArticleDetailCommentsWithPostId:weakSelf.tid artist_id:nil video_id:nil type:1 offset:page pagesize:[pagesize integerValue] success:^(LLResponse *response, id data) {
            if (data!=nil && [data isKindOfClass:[NSDictionary class]]) {
                NSArray *arr =  [MSBArticleCommentModel mj_objectArrayWithKeyValuesArray:data[@"items"]];
                
                NSDictionary * dic =    @{@"total":data[@"total"],@"offset":data[@"offset"],@"pagesize":data[@"pagesize"],@"items":[MSBReplyComment mj_keyValuesArrayWithObjectArray:arr]};
                NSString * result = [NSString dictionaryToJson:dic];
                //NDLog(@"返给js的数据 ==== %@",result);
                responseCallback(result);
            }
        } failure:^(LLResponse *response) {
            NSString * result = [NSString dictionaryToJson:@{@"total":_data[@"total"],@"offset":@(page.integerValue+1),@"pagesize":pagesize,@"items":@[]}];
            responseCallback(result);
            //[weakSelf endLoading];
        } error:^(NSError *error) {
            //[weakSelf endLoading];
            NSString * result = [NSString dictionaryToJson:@{@"total":_data[@"total"],@"offset":@(page.integerValue+1),@"pagesize":pagesize,@"items":@[]}];
            responseCallback(result);
        }];
    }];
}

- (void)setTid:(NSString *)tid{
    _tid = tid;
}

- (void)setDetailModel:(MSBArticleDetailModel *)detailModel{
    _detailModel = detailModel;
}

- (void)setHotComments:(NSArray *)hotComments{
    _hotComments = hotComments;
}
@end
