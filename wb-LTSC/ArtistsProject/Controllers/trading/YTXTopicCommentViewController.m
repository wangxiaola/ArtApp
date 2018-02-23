//
//  YTXTopicCommentViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/10.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXTopicCommentViewController.h"
#import "YTXTopicCommentViewCell.h"
#import "UIScrollView+YTXRefreshControl.h"
#import "CangyouQuanDetailModel.h"
#import "YTXCommentInputView.h"
#import "MyHomePageDockerVC.h"
#import "YTXTopicInputTextViewCell.h"

@interface YTXTopicCommentViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *commentsArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) YTXCommentInputView *commentInputView;

@end

@implementation YTXTopicCommentViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _commentsArray = [[NSMutableArray alloc] init];
    
    _page = 1;
    
    [self fetchComments];
}


#pragma mark - TableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicComment = _commentsArray[indexPath.row];
    CangyouQuanCommentsModel* modelComment = [CangyouQuanCommentsModel mj_objectWithKeyValues:dicComment];

    YTXTopicCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTXTopicCommentViewCell" forIndexPath:indexPath];
    cell.commentsModel = modelComment;
    cell.userIconTaped = ^(CangyouQuanCommentsModel *model) {
        MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
        vc.navTitle = model.user.username;
        vc.artId = model.user.uid;
        [self.navigationController pushViewController:vc animated:YES];
    };
    cell.userReplyTaped = ^(CangyouQuanCommentsModel *model) {
        [self.commentInputView becomeWithUserName:model.user.username replyId:model.replyid];
    };
    cell.deleteActionBlock = ^(CangyouQuanCommentsModel *model) {
        
        [self hideKeyBoard];
        
        [self showLoadingHUDWithTitle:@"正在删除评论" SubTitle:nil];
        NSDictionary* dict = @{ @"cid" : model.cid };
        HHttpRequest* request = [[HHttpRequest alloc] init];
        [request httpPostRequestWithActionName:@"deltopiccomment" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
            [self.hudLoading hide:YES];
            ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
            [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        }
                     andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                         [self.hudLoading hide:YES];
                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                             NSString *msg = [responseObject objectForKey:@"msg"];
                             if (msg.length > 0) {
                                 [self showOkHUDWithTitle:msg SubTitle:@"" Complete:nil];
                             }
                         }
                         YTXTopicInputTextViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:13]];
                         [cell clearText];
                         _page = 1;
                         [self fetchComments];
                         kPrintLog(responseObject);
                     }
                      andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                          NSLog(@"%@",error);
                          [self.hudLoading hide:YES];
                      }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicComment = _commentsArray[indexPath.row];
    CangyouQuanCommentsModel* modelComment = [CangyouQuanCommentsModel objectWithKeyValues:dicComment];
    return [YTXTopicCommentViewCell cellHeightWithCommentsModel:modelComment];
}


#pragma mark - load

- (void)fetchComments
{
    if (_topicId == nil) {
        [self showErrorHUDWithTitle:@"id不能为空" SubTitle:@"" Complete:nil];
        return;
    }
    
    NSDictionary* dict = @{ @"id" : _topicId,
                            @"page" : @(_page),
                            @"num" : @"10" };
    @weakify(self);
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"topiccommentlist" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        @strongify(self);
        [self.hudLoading hide:YES];
        [self.tableView endRefreshing];
        ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
        @strongify(self);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (self.page == 1) {
                [self.commentsArray removeAllObjects];
                self.commentsArray = [responseObject mutableCopy];
            } else {
                [self.commentsArray addObjectsFromArray:responseObject];
                if ([(NSArray*)responseObject count] < 1) {
                    [self.tableView endRefreshingWithNoMoreData];
                }
            }
        }
        [self.hudLoading hide:YES];
        [self.tableView endRefreshing];
        [self.tableView reloadData];
    } andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
        @strongify(self);
        [self.hudLoading hide:YES];
        [self.tableView endRefreshing];
    }];
}

#pragma mark - TableView

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:[YTXTopicCommentViewCell class] forCellReuseIdentifier:@"YTXTopicCommentViewCell"];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.left.and.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.commentInputView.mas_top);
        }];
        
        __weak typeof(self)weakSelf = self;
        [_tableView headerRefreshingWithBlock:^{
            weakSelf.page = 1;
            [weakSelf fetchComments];
        }];
        [_tableView footerRefreshingWithBlock:^{
            weakSelf.page++;
            [weakSelf fetchComments];
        }];
    }
    return _tableView;
}

- (YTXCommentInputView *)commentInputView
{
    if (!_commentInputView) {
        _commentInputView = [[YTXCommentInputView alloc] init];
        [self.view addSubview:_commentInputView];
        
        __weak typeof(self)weakSelf = self;
        _commentInputView.sendActionBlock = ^(NSString *comment, NSString *replyId) {
            [weakSelf sendComment:comment strReply:replyId];
        };

        [_commentInputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
    }
    return _commentInputView;
}


- (void)sendComment:(NSString *)comment strReply:(NSString *)strReply
{
    if (![self isNavLogin]) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    
    [self hideKeyBoard];
    if (comment.length < 1) {
        [self showErrorHUDWithTitle:@"请输入评论内容" SubTitle:nil Complete:nil];
        return;
    }
    
    [self showLoadingHUDWithTitle:@"正在发送评论" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                            @"id" : self.topicId,
                            @"type" : @"2",
                            @"replyid" : strReply ?: @"0",
                            @"message" : comment };
    //    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"topiccomment" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [self.hudLoading hide:YES];
        ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [weakSelf.hudLoading hide:YES];
                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                         NSString *msg = [responseObject objectForKey:@"msg"];
                         if (msg.length > 0) {
                             [weakSelf showOkHUDWithTitle:msg SubTitle:@"" Complete:nil];
                         }
                     }
                     [weakSelf.commentInputView clearText];
                     [weakSelf.tableView beginHeaderRefresh];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      NSLog(@"%@",error);
                      [weakSelf.hudLoading hide:YES];
                  }];
}

@end
