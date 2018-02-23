//
//  DetailSearchVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/4.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "DetailSearchVc.h"
#import "SIAlertView.h"
#import "YYSearchView.h"
#import "DetailSearchCell.h"
#import "HomeListDetailVc.h"
#import "UIScrollView+YTXRefreshControl.h"
#import "HomeListDetailVc.h"
#import "MyHomePageDockerVC.h"


#define HEAD_CELL_HEIGHT (SCREEN_WIDTH/1.5+10)
#define DefineWeakSelf __weak __typeof(self) weakSelf = self

@interface DetailSearchVc ()<UITextFieldDelegate>
{
    YYSearchView * _searchView;
    UITableView *_tableView;
    UIView *  _headerView;
    UILabel * _nullDataLable;
    DetailSearchCell*  _searchCell;
}
@property(nonatomic,strong)NSMutableArray* selectArray;
@end

@implementation DetailSearchVc

-(void)createView{
    [super createView];
    self.tabView.separatorStyle = UITableViewCellStyleDefault;
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [self setupSearchView];
    NSDictionary * dict = @{
                            @"keyword" : _searchWord?_searchWord:@"",
                            @"page":[NSString stringWithFormat:@"%ld",(long)_page],
                            @"num":@"10",
                            @"topictype":self.topictypeStr?self.topictypeStr:@""
//                            @"postuid":[Global sharedInstance].userID
                            };
    [self.dataDic addEntriesFromDictionary:dict];
    _dataArray = [[NSMutableArray alloc]init];
    _selectArray = [[NSMutableArray alloc]init];
    if (self.idSArr.length>0){
        NSArray* arr = [_idSArr componentsSeparatedByString:@","];
        for (NSString* str in arr) {
            if ((str.length>0)&&![str isEqualToString:@","]&&![str isEqualToString:@" "]) {
                [_selectArray addObject:str];
            }
        }
    }
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
    
}
-(void)touchTypeAction:(UIButton*)sender{
    //选择类型
    [_dataArray removeAllObjects];
    
    for (UIView *view in _headerView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton * btn = (UIButton*)view;
            btn.selected = NO;
        }
        sender.selected = YES;
    }
    if (_searchWord.length==0) {
        
        [self showErrorHUDWithTitle:@"请输入你要搜索的关键词" SubTitle:nil Complete:nil];
        return;
    }
}

-(void)setupSearchView
{
    _searchView = [YYSearchView creatView];
    _searchView.frame = CGRectMake(-200, 0, kScreenW, 40);
    [_searchView.cancelBtn setTitle:@"" forState:(UIControlStateNormal)];
    _searchView.YYSearch.delegate = self;
    _searchView.YYSearch.returnKeyType = UIReturnKeySearch;
    DefineWeakSelf;
    [_searchView setYYGetCancel:^(NSString * title)
     {
         
         _searchWord = [NSString stringWithFormat:@"%@",title];
         [weakSelf searchKeyWords:@""];
         [weakSelf.dataArray removeAllObjects];
         if (_searchWord.length==0) {
             
             [weakSelf showErrorHUDWithTitle:@"请输入你要搜索的关键词" SubTitle:nil Complete:nil];
             return;
         }
         
     }];
    
    [_searchView setYYGetTitle:^(NSString * title)
     {
         _searchWord = [NSString stringWithFormat:@"%@",title];
         
         
     }];
    self.navigationItem.titleView = _searchView;
}
-(void)searchKeyWords:(NSString *)searchType
{
    
    if ( [_searchWord isEqualToString:@""] || _searchWord == nil )
    {
        [_tableView endRefreshing];
        [_tableView setFooterRefreshHidden:YES];
        return;
    }
    [_tableView setFooterRefreshHidden:NO];
    
    [self loadSearchDataWithKeyWord:searchType];
}



-(void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}
-(void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}
-(void)loadSearchDataWithKeyWord:(NSString*)keyWord{
    [self.dataDic setObject:_searchWord forKey:@"keyword"];
    [self loadData];
}
-(void)loadData{
    
    NSString* pageStr = [NSString stringWithFormat:@"%ld",self.pageIndex];
    [self.dataDic setObject:pageStr forKey:@"page"];
    __weak typeof(self)weakSelf = self;
    //http://api.artart.cn/api.php?ac= topiclist&topictype=6&postuid=2797&publickey=ZGZvI1mi8Q
    [ArtRequest GetRequestWithActionName:@"topiclist" andPramater:self.dataDic succeeded:^(id responseObject) {
        [weakSelf.hudLoading hideAnimated:YES];
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (weakSelf.pageIndex==1){
                [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in responseObject) {
                
                [weakSelf.dataArray addObject:dic];
                
            }
            
            
            [weakSelf.tabView.mj_header endRefreshing];
            [weakSelf.tabView.mj_footer endRefreshing];
        }else{
            if (weakSelf.pageIndex==1){//没有相关数据
                // [weakSelf showErrorHUDWithTitle:responseObject[@"msg"] SubTitle:nil Complete:nil];
                [_dataArray removeAllObjects];
                [weakSelf.tabView.mj_header endRefreshing];
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
                
            }else{//没有更多数据
                [(MJRefreshAutoStateFooter *)weakSelf.tabView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [weakSelf.tabView reloadData];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 0.5;
    CangyouQuanDetailModel * model;
    if (self.dataArray.count!=0) {
        model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.dataArray[indexPath.row]]; ;
        cellHeight = _searchCell.getHeight;
    }
    return cellHeight>0?cellHeight:0.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count>0?_dataArray.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CangyouQuanDetailModel * model;
    if (self.dataArray.count!=0) {
        model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.dataArray[indexPath.row]]; ;
    }
    DetailSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSearchCell"];
    if (cell==nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailSearchCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(0, 0, 30, 30);
    [selectButton setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"已勾选"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.tag = indexPath.row;
    for (NSString *idStr in _selectArray) {
        if ([idStr isEqualToString:model.id]) {
            selectButton.selected = YES;
            break;
        }
    }
    cell.accessoryView = selectButton;
    cell.model = model;
    __weak typeof(cell)weakCell = cell;
    _searchCell = weakCell;
    return cell;
}
- (void)selectAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.dataArray[sender.tag]];
    if (sender.selected){
        [_selectArray addObject:model.id];
    }else{
        for (NSString *idStr in _selectArray){
            if ([idStr isEqualToString:model.id]) {
                [_selectArray removeObject:idStr];
                break;
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CangyouQuanDetailModel * model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
    detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchWord = [NSString stringWithFormat:@"%@",textField.text];
    [_dataArray removeAllObjects];
    [self loadSearchDataWithKeyWord:@""];
    [textField resignFirstResponder];
    return YES;
}
-(void)rightBar_Click{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
       //1.设置请求参数
    NSString* idS = @" ";
    if(_selectArray.count>0) {
        idS = [NSString stringWithFormat:@"%@",[_selectArray componentsJoinedByString:@","]];
        
    }
    NSDictionary* dict = @{
                           @"ids":idS,
                           @"id" : self.topicId?self.topicId:@"",
                           @"type":self.typeStr
                           };
    
    
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [self showLoadingHUDWithTitle:@"正在关联..." SubTitle:nil];
    [request httpPostRequestWithActionName:@"addguanlian" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [self.hudLoading hideAnimated:YES];
                     if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"关联" obj:responseObject]) {
                         if (self.guanLianSuccess) {
                             self.guanLianSuccess();
                         }
                         [self.navigationController popViewControllerAnimated:YES];
                     }else{
                         NSString* msg = responseObject[@"msg"];
                         if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                             
                         }
                     }
                 }andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                     if (self.guanLianSuccess) {
                         self.guanLianSuccess();
                     }
                     [self.navigationController popViewControllerAnimated:YES];
                     [self.hudLoading hideAnimated:YES];
                 }];
}

-(void)leftBarItem_Click{
 [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘
    [self.navigationController popViewControllerAnimated:YES];
}

@end
