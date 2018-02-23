//
//  SearchViewController.m
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "SearchViewController.h"
#import "YYSearchView.h"
#import "YTXSearchDynamicCell.h"
#import "YTXSearchDynamicModel.h"
#import "YTXSearchUserCell.h"
#import "YTXSearchUserModel.h"
#import "YTXSearchActivityCell.h"
#import "YTXSearchActivityModel.h"

#import "UIScrollView+YTXRefreshControl.h"
#import "HomeListDetailVc.h"
#import "MyHomePageDockerVC.h"
#import "AppraisalMeetingDetailVC.h"
#define DefineWeakSelf __weak __typeof(self) weakSelf = self


@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    YYSearchView * _searchView;
    UITableView *_tableView;
    UIView *  _headerView;
    UILabel * _nullDataLable;
}
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    _page = 1;
    _searchType=@"1";
    
    [self setupSearchView];
    [self setTableView];
    [self setupHeaderView];

}

-(void)setupSearchView
{
    _searchView = [YYSearchView creatView];
    _searchView.frame = CGRectMake(-200, 0, kScreenW, 40);
    _searchView.YYSearch.delegate = self;
    _searchView.YYSearch.returnKeyType = UIReturnKeySearch;
    DefineWeakSelf;
    [_searchView setYYGetCancel:^(NSString * title)
     {
        
         _searchWord = [NSString stringWithFormat:@"%@",title];
         [weakSelf searchKeyWords:weakSelf.searchType];
          [weakSelf.dataArray removeAllObjects];
         if (_searchWord.length==0) {
             [weakSelf showErrorHUDWithTitle:@"请输入你要搜索的关键词" SubTitle:nil Complete:nil];
             return;
         }
         
     }];

    [_searchView setYYGetTitle:^(NSString * title)
     {
         _searchWord = [NSString stringWithFormat:@"%@",title];
         [weakSelf searchKeyWords:weakSelf.searchType];
         
         
         
         
     }];
    self.navigationItem.titleView = _searchView;
}

#pragma mark --头部View
-(void)setupHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    NSArray * searchArray =@[@"近况/作品",@"用户/艺术家",@"展览/活动"];
    
    for (int i = 0; i < searchArray.count; i++) {
        UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0+kScreenW/3.0*i, 0, kScreenW/3.0, 44)];
        [searchBtn setTitle:searchArray[i] forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [searchBtn setTitleColor:ColorHex(@"c09256") forState:UIControlStateSelected];
        [searchBtn addTarget:self action:@selector(touchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:searchBtn];
        if (i==0) {
            searchBtn.selected =YES;
            searchBtn.tag = 1;
        }
        if (i==1) {
            searchBtn.selected =NO;
            searchBtn.tag = 3;
        }
        if (i==2) {
            searchBtn.selected =NO;
            searchBtn.tag = 2;
        }
    }
    
       
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, kScreenW, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_headerView addSubview:line];
    
    [_tableView setTableHeaderView:_headerView];
}

-(void)touchTypeAction:(UIButton*)sender{
   //选择类型
    NSUInteger tag = sender.tag;
     _searchType = [@(tag) stringValue];
    [_dataArray removeAllObjects];
    [self searchKeyWords:_searchType];
    
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
        [_tableView registerNib:[UINib nibWithNibName:@"YTXSearchUserCell" bundle:nil] forCellReuseIdentifier:@"YTXSearchUserCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"YTXSearchActivityCell" bundle:nil] forCellReuseIdentifier:@"YTXSearchActivityCell"];


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
            [self searchKeyWords:_searchType];
        }];
        
        [_tableView footerRefreshingWithBlock:^{
            weakSelf.page++;
            [self searchKeyWords:_searchType];

        }];
        [_tableView setFooterRefreshHidden:YES];

        [self.view addSubview:_tableView];
    }

}

-(void)searchKeyWords:(NSString *)searchType
{
  
    if ([searchType isEqualToString:@""] || searchType == nil || [_searchWord isEqualToString:@""] || _searchWord == nil )
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
    //@"uid":[Global sharedInstance].userID,
    NSDictionary * dict = @{
                            @"keyword" : _searchWord,
                            @"type":searchType,
                            @"page":[NSString stringWithFormat:@"%ld",(long)_page],
                            @"num":@"10"
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
        
        [strongSelf.hudLoading hideAnimated:YES];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
             NSLog(@"method = jianjieindex  \n response = %@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
            _nullDataLable.hidden = YES;
            for (NSDictionary *dic in responseObject) {
                
                if ([_searchType isEqualToString:@"1"]) {
                    //YTXSearchDynamicModel *model = [YTXSearchDynamicModel mj_objectWithKeyValues:dic];
                    [strongSelf.dataArray addObject:dic];
                    NSLog(@"count%lu",(unsigned long)strongSelf.dataArray.count);
                    
                }else if ([_searchType isEqualToString:@"3"]){
                    //YTXSearchUserModel *model = [YTXSearchUserModel mj_objectWithKeyValues:dic];
                    [strongSelf.dataArray addObject:dic];
                }else{
                    //YTXSearchActivityModel *model = [YTXSearchActivityModel mj_objectWithKeyValues:dic];
                    [strongSelf.dataArray addObject:dic];

                }
                
            }
            if (strongSelf.page > 1) {
                [strongSelf.dataArray addObjectsFromArray:strongSelf.dataArray];
            }
            if ([responseObject count] < 5) {
                [_tableView endRefreshingWithNoMoreData];
            }
            
            [self reloadData];
        }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
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
    if ([_searchType isEqualToString:@"1"]) {
        YTXSearchDynamicModel *model=[YTXSearchDynamicModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
       
        return [self getCellHeight:model];
        
        }else if ([_searchType isEqualToString:@"3"]){
        return 58;
    }
    else{
        YTXSearchActivityModel *model=[YTXSearchActivityModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        return [self getCellHeight:model];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if ([_searchType isEqualToString:@"1"]) {
        YTXSearchDynamicModel * model;
        if (self.dataArray.count!=0) {
            model=[YTXSearchDynamicModel mj_objectWithKeyValues:self.dataArray[indexPath.row]]; ;
        }
        
        //重用
       // YTXSearchDynamicCell * cell=(YTXSearchDynamicCell*)[tableView cellForRowAtIndexPath:indexPath];
        //YTXSearchDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTXSearchDynamicCell"];
        //if (!cell){
           // YTXSearchDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTXSearchDynamicCell"];
        YTXSearchDynamicCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"YTXSearchDynamicCell" owner:self options:nil] lastObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //}
        
        cell.model=model;
        
        return cell;
    }else if ([_searchType isEqualToString:@"3"]){
        YTXSearchUserModel *model ;
        if (self.dataArray.count!=0) {
          model=[YTXSearchUserModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        }
        
        YTXSearchUserCell * cell=(YTXSearchUserCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"YTXSearchUserCell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        cell.model=model;
        
        return cell;

    }else{
        YTXSearchActivityModel *model;
        if (self.dataArray.count!=0) {
            model=[YTXSearchActivityModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        }
        YTXSearchActivityCell * cell=(YTXSearchActivityCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (!cell){
            cell = [tableView dequeueReusableCellWithIdentifier:@"YTXSearchActivityCell"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        cell.model=model;
        
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_searchType isEqualToString:@"1"]) {
            YTXSearchDynamicModel * model=[YTXSearchDynamicModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        
        HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
        detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
        detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
        detailVC.hidesBottomBarWhenPushed = YES;
        detailVC.isScrollToBottom = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if ([_searchType isEqualToString:@"3"]){
       
            YTXSearchUserModel *model=[YTXSearchUserModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];

        MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
        vc.artId = model.uid;
        vc.navTitle = model.username;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
            YTXSearchActivityModel *model=[YTXSearchActivityModel mj_objectWithKeyValues:self.dataArray[indexPath.row]];
        AppraisalMeetingDetailVC *vc=[[AppraisalMeetingDetailVC alloc]init];
        vc.cid=model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)getCellHeight:(id)model
{
    if ([model isKindOfClass:[YTXSearchDynamicModel class]]) {
        
        YTXSearchDynamicModel *searchModel = model;
        if (searchModel.photoscbk.count > 0) {
            return 136;
        }
        else{
            return 85;
        }
    }
    else if([model isKindOfClass:[YTXSearchActivityModel class]]) {
        
        YTXSearchActivityModel *searchModel = model;
        if (searchModel.photoscbk.count > 0) {
            return 132;
        }
        else{
            return 130;
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
    [self searchKeyWords:_searchType];
     [_dataArray removeAllObjects];
    [textField resignFirstResponder];
    return YES;
}

@end
