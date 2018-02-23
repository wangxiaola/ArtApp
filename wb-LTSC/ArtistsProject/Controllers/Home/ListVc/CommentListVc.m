//
//  TextsListVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/31.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "CommentListVc.h"
#import "CommentListCell.h"


@interface CommentListVc ()<UITextFieldDelegate>
{
    UITextField* _commentField;
    BOOL isReply;
    NSString* strReply;//回复评论时传回复的评论id
}
@property(nonatomic,strong)NSMutableArray* lisrArr;
@end

@implementation CommentListVc
-(void)createView{
    [super createView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, -44, 0));
    }];
    UIImageView* footView = [[UIImageView alloc]init ];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = BACK_VIEW_COLOR;
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_offset(44);
        make.bottom.mas_offset(0);
    }];
    
    _commentField = [[UITextField alloc]init];
    _commentField.backgroundColor = RGB(230, 230, 230);
    _commentField.delegate = self;
    _commentField.clearsOnBeginEditing = YES;
    _commentField.clearButtonMode = UITextFieldViewModeAlways;
    _commentField.font = ART_FONT(ARTFONT_OTH);
    _commentField.textColor = RGB(150, 150, 150);
    _commentField.placeholder = @"我也说两句...";
    [footView addSubview:_commentField];
    [_commentField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.and.bottom.equalTo(footView);
        make.bottom.mas_equalTo(footView.mas_bottom).offset(-10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH-90);
    }];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blackColor];
    btn.titleLabel.font = ART_FONT(ARTFONT_OF);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"评论" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView);
        make.bottom.mas_equalTo(footView.mas_bottom).offset(-10);
        make.left.mas_equalTo(_commentField.mas_right);
        make.right.mas_equalTo(-15);
    }];

    _lisrArr = [[NSMutableArray alloc]init];
    NSDictionary * dict = @{
                            @"num":@"10",
                            @"id":self.topictypeStr?self.topictypeStr:@"0",
                            @"timenum":self.timenumStr?self.timenumStr:@"0"
                            };
    [self.dataDic addEntriesFromDictionary:dict];
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
}
-(void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}
-(void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}
-(void)loadData{
    NSString* pageStr = [NSString stringWithFormat:@"%ld",self.pageIndex];
    [self.dataDic setObject:pageStr forKey:@"page"];
    
    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:@"topiccommentlist" andPramater:self.dataDic succeeded:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
        //近况
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (weakSelf.pageIndex==1){
                [_lisrArr removeAllObjects];
            }
            [_lisrArr addObjectsFromArray:responseObject];
            [self.tabView.mj_header endRefreshing];
            [self.tabView.mj_footer endRefreshing];
            
        }else{
            if (weakSelf.pageIndex==1){//没有相关数据
                //[weakSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_lisrArr removeAllObjects];
                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];

            }else{//没有更多数据
                 [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [self.tabView reloadData];
        
    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [strongSelf.tabView.mj_header endRefreshing];
        [strongSelf.tabView.mj_footer endRefreshing];

        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _lisrArr.count>0?_lisrArr.count:0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentListCell"];
    if (cell==nil) {
        cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.sendBtnClick = ^(NSDictionary* dic){
        [_commentField becomeFirstResponder];
        isReply = YES;
        NSDictionary* dicComment = dic;
        _commentField.text = [NSString stringWithFormat:@"回复 @%@: ", dicComment[@"author"][@"username"]];
        strReply = [NSString stringWithFormat:@"%@",dic[@"author"][@"uid"]];
    };
    [cell setCommentListCell:_lisrArr[indexPath.row]];
    return cell;
}
//评论
-(void)commentBtnClick{
    if (![self isNavLogin]) {
        return;
    }
    [self hideKeyBoard];
    if (_commentField.text.length < 1||[_commentField.text isEqualToString:@"我也说两句..."]) {
        [self showErrorHUDWithTitle:@"请输入评论内容" SubTitle:nil Complete:nil];
        return;
    }
    
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"id" : self.topictypeStr,
                            @"type" : @"2",
                            @"replyid" : strReply ?: @"0",
                            @"message" : _commentField.text };
    
    [self showLoadingHUDWithTitle:@"正在发送评论" SubTitle:nil];
    __weak typeof(self)wself = self;
    [ArtRequest PostRequestWithActionName:@"topiccomment" andPramater:dict succeeded:^(id responseObject){
        [wself.hudLoading hideAnimated:YES];
        [wself loadData];
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"评论" obj:responseObject]) {
            //评论成功
        }else{
            NSString* msg = responseObject[@"msg"];
            
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [self logonAgain];
            }
        }
        
    } failed:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
    }];
    
}

@end
