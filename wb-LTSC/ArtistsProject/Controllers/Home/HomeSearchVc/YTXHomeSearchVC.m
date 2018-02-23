//
//  YTXHomeSearchVC.m
//  ShesheDa
//
//  Created by lixianjun on 2017/1/7.
//  Copyright © 2017年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXHomeSearchVC.h"
#import "YYSearchView.h"
#import "YTXSearchDynamicCell.h"
#import "YTXSearchDynamicModel.h"
#import "HomeListDetailVc.h"
#import "UIScrollView+YTXRefreshControl.h"
#import "HomeListDetailVc.h"
#import "MyHomePageDockerVC.h"
#import "MemSearchView.h"
#define DefineWeakSelf __weak __typeof(self) weakSelf = self

@interface YTXHomeSearchVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,MemSearchDelegate>
{
    YYSearchView * _searchView;
    UITableView *_tableView;
    UIView *  _headerView;
    UILabel * _nullDataLable;
    MemSearchView *_search;
}
@end

@implementation YTXHomeSearchVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    _search = [[MemSearchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 45, 40)];
    _search.delegate = self;
    kWeakSelf;
    [_search setYYGetCancel:^(NSString * title)
     {
         _searchWord = [NSString stringWithFormat:@"%@",title];
         [weakSelf searchKeyWords:@""];
         [weakSelf.dataArray removeAllObjects];
         if (_searchWord.length==0) {
             [weakSelf showErrorHUDWithTitle:@"请输入你要搜索的关键词" SubTitle:nil Complete:nil];
             return;
         }
     }];
    
    [_search setYYGetTitle:^(NSString * title){
         _searchWord = [NSString stringWithFormat:@"%@",title];
        [weakSelf searchKeyWords:weakSelf.searchWord];
        [weakSelf.dataArray removeAllObjects];
        if (_searchWord.length==0) {
            [weakSelf showErrorHUDWithTitle:@"请输入你要搜索的关键词" SubTitle:nil Complete:nil];
            return;
        }
     }];
    self.navigationItem.titleView = _search;
//    [self setupSearchView];
    [self setTableView];
 }
// 搜索视图消息代理方法
- (void)menSearchNewMessage:(UIButton *)button
{
    [self.view endEditing:YES];
    [button setTitle:@"" forState:(UIControlStateNormal)];
}

-(void)setupSearchView
{
    _searchView = [YYSearchView creatView];
    _searchView.frame = CGRectMake(-200, 0, kScreenW, 40);
    _searchView.YYSearch.delegate = self;
    _searchView.YYSearch.placeholder = [NSString stringWithFormat:@"搜索%@资料",[Global sharedInstance].getBundleName];

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
- (void)setTableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView registerNib:[UINib nibWithNibName:@"YTXSearchDynamicCell" bundle:nil] forCellReuseIdentifier:@"YTXSearchDynamicCell"];
        
        __weak typeof(self)weakSelf = self;
        _nullDataLable = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH/2.0, kScreenW, 12)];
        _nullDataLable.hidden = NO;
        _nullDataLable.text = @"暂无数据";
        _nullDataLable.font = [UIFont systemFontOfSize:13];
        _nullDataLable.textAlignment = NSTextAlignmentCenter;
        _nullDataLable.textColor = [UIColor grayColor];
        [_tableView addSubview:_nullDataLable];
        [_tableView headerRefreshingWithBlock:^{
            weakSelf.page = 1;
            [_dataArray removeAllObjects];;
            [self searchKeyWords:nil];
        }];
        
        [_tableView footerRefreshingWithBlock:^{
            weakSelf.page++;
            [self searchKeyWords:nil];
            
        }];
        [_tableView setFooterRefreshHidden:YES];
        
        [self.view addSubview:_tableView];
    }
    
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

- (void)loadSearchDataWithKeyWord:(NSString *)searchType
{
    
    
    NSString *   getBundleID= [[Global sharedInstance] getBundleID];
    NSLog(@"2344444===postDic%@",getBundleID);
    NSDictionary * dict = @{
                            @"keyword" : _searchWord,
                            @"type":@"1",
                            @"page":[NSString stringWithFormat:@"%ld",(long)_page],
                            @"num":@"10",
                            @"topictype":@"4"
//                            @"postuid":getBundleID
                            };

    kPrintLog(dict);
    [self showLoadingHUDWithTitle:@"搜索中" SubTitle:nil];
    __weak typeof(self)weakSelf = self;
    
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"search" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        _nullDataLable.hidden = YES;
        
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        kPrintLog(responseObject)
        [strongSelf.hudLoading hideAnimated:YES];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSLog(@"method = jianjieindex  \n response = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
            _nullDataLable.hidden = YES;
            for (NSDictionary *dic in responseObject) {
                
                    //YTXSearchDynamicModel *model = [YTXSearchDynamicModel mj_objectWithKeyValues:dic];
                    [strongSelf.dataArray addObject:dic];
    
                
                
            }
            if (strongSelf.page > 1) {
                [strongSelf.dataArray addObjectsFromArray:strongSelf.dataArray];
            }
            if ([responseObject count] < 5) {
                [_tableView endRefreshingWithNoMoreData];
                
            }
            [self reloadData];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            _nullDataLable.hidden = YES;
            [_tableView endRefreshing];
            if (_dataArray.count  == 0) {
                [_tableView setFooterRefreshHidden:YES];
            }
            else{
                [_tableView endRefreshingWithNoMoreData];
            }
            [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
            [self reloadData];
        }
        [self.hudLoading hideAnimated:YES];
        
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        //        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hideAnimated:YES];
        _nullDataLable.hidden = NO;
        [_tableView endRefreshing];
    }];
}

- (void)reloadData {
    [_tableView reloadData];
    [_tableView endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        YTXSearchDynamicModel *model=[YTXSearchDynamicModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        
        return [self getCellHeight:model];
        
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        YTXSearchDynamicModel * model;
        if (self.dataArray.count!=0) {
            model=[YTXSearchDynamicModel mj_objectWithKeyValues:self.dataArray[indexPath.row]]; ;
        }
    
        YTXSearchDynamicCell * cells = [[[NSBundle mainBundle] loadNibNamed:@"YTXSearchDynamicCell" owner:self options:nil] lastObject];
        cells.selectionStyle=UITableViewCellSelectionStyleNone;
        //}
        
        cells.model=model;
        
        return cells;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  YTXSearchDynamicModel * model=[YTXSearchDynamicModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
    detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
    detailVC.isScrollToBottom = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
    }

- (CGFloat)getCellHeight:(id)model
{
    if ([model isKindOfClass:[YTXSearchDynamicModel class]]) {
        
        YTXSearchDynamicModel *searchModel = model;
        if (searchModel.photoscbk.count > 0) {
            return 136;
        }
        else{
            return 136;
        }
    }
    return 0;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchWord = [NSString stringWithFormat:@"%@",textField.text];
    [_dataArray removeAllObjects];
    [self loadSearchDataWithKeyWord:@""];
    [textField resignFirstResponder];
    return YES;
}

@end
