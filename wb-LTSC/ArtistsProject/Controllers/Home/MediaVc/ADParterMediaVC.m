//
//  ADParterMediaVC.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/30.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ADParterMediaVC.h"
#import "HHttpRequest.h"
#import "YTXFriendsTableViewCell.h"
#import "YTXFriendsViewModel.h"
#import "MyHomePageDockerVC.h"
#import "GuanzhuDockerVC.h"
#import "YTXTagsViewController.h"
#import "YTXOpenAuthentication.h"
#import "ArtApplyVC.h"
#import "ArtApplyController.h"
static NSString * const kYTXTableViewCell = @"YTXTableViewCell";

@interface ADParterMediaVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    BOOL _isSearch;//是否为搜索
}

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * mArrayData;

@property (nonatomic, strong) NSMutableArray * searchArray;

@property (nonatomic, strong) NSMutableArray * mArrayIndexs;//索引数组

@property (nonatomic, strong) NSMutableDictionary * mDictData;//原始数据字典

@property (nonatomic, strong) UISearchBar * searchBar;

@end

@implementation ADParterMediaVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合作媒体";
    _searchArray = [[NSMutableArray alloc]init];
    [self.view addSubview:self.searchBar];
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [self fetchDataWithKeyWord:@""];
    
    // Do any additional setup after loading the view.
}

#pragma mark - Private Methods

#pragma mark - Fetch Data

- (void)fetchDataWithKeyWord:(NSString *)keyWord {
    NSDictionary * dict = @{
                            @"keyword" : keyWord,
                            @"type":@"2"
                            };
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"yiyoulu" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]&&[responseObject objectForKey:@"res"] == nil) {
            self.mDictData = responseObject;
        } else if(keyWord.length){
            [self showErrorHUDWithTitle:@"查询失败" SubTitle:@"没有查询到相关媒体" Complete:nil];
        } else {
            [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        }
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hideAnimated:YES];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
    [self.searchBar resignFirstResponder];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar.text.length>0) {
        [_searchArray removeAllObjects];
        for (NSArray* rowArr in self.mArrayData){
            for (YTXFriendsViewModel* model in rowArr){
                if ([model.name rangeOfString:searchBar.text].location!=NSNotFound){
                    [_searchArray addObject:model];
                }
            }
        }
        _isSearch = YES;
    }else{
        _isSearch = NO;
        [searchBar resignFirstResponder];
        [self.view endEditing:YES];
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isSearch) {
        return _searchArray.count>0?_searchArray.count:0;
    }
//    if (section == 0) {
//        return 3;
//    }
    return [[self.mArrayData objectOrNilAtIndex:section - 1] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isSearch) {
        return 1;
    }
    return self.mArrayIndexs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isSearch) {
        YTXFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXFriendsTableViewCell];
        cell.model = _searchArray[indexPath.row];
        return cell;
    }
//    if (indexPath.section == 0) {
//        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXTableViewCell];
//        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
//        switch (indexPath.row) {
//            case 0:
//            {
//                cell.textLabel.text = @"申请合作";
//                cell.imageView.image = [UIImage imageNamed:@"icon_join"];
//            }
//                break;
//            case 1:
//            {
//                cell.textLabel.text = @"关注\\粉丝";
//                cell.imageView.image = [UIImage imageNamed:@"icon_focus_follow"];
//            }
//                break;
//            case 2:
//            {
//                cell.textLabel.text = @"标签\\分类";
//                cell.imageView.image = [UIImage imageNamed:@"icon_tags"];
//            }
//                break;
//        }
//        return cell;
//    }
    YTXFriendsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXFriendsTableViewCell];
    cell.model = [[self.mArrayData objectOrNilAtIndex:indexPath.section - 1] objectOrNilAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//            {//申请合作（跳转认证）
//                ArtApplyController *vc = [[ArtApplyController alloc]init];
//                //                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 1:
//            {//关注\粉丝
//                GuanzhuDockerVC * vc = [[GuanzhuDockerVC alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//            case 2:
//            {//标签\分类
//                YTXTagsViewController * vc = [[YTXTagsViewController alloc]init];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//        }
//        return;
//    }
    YTXFriendsViewModel * viewModel = [[self.mArrayData objectOrNilAtIndex:indexPath.section - 1] objectOrNilAtIndex:indexPath.row];
    MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
    vc.navTitle= viewModel.name;
    vc.artId=viewModel.uid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    }
    return [self.mArrayIndexs objectAtIndex:section];
}

//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.mArrayIndexs;
}

////点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch])
    {
        [tableView setContentOffset:CGPointZero animated:NO];//tabview移至顶部
        return NSNotFound;
    }
    else
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index]; // -1 添加了搜索标识
    }
}

#pragma mark - Setter

- (void)setMDictData:(NSMutableDictionary *)mDictData {
    _mDictData = mDictData.mutableCopy;
    [self.mArrayData removeAllObjects];
    self.mArrayIndexs = [[[_mDictData allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
    for (NSString * key in self.mArrayIndexs) {
        NSMutableArray * mArray = [[NSMutableArray alloc]init];
        for (NSDictionary * dict in [_mDictData objectForKey:key]) {
            YTXUser * model = [YTXUser modelWithDictionary:dict];
            YTXFriendsViewModel * viewModel = [YTXFriendsViewModel modelWithFriendsModel:model];
            [mArray addObject:viewModel];
        }
        [self.mArrayData addObject:mArray];
    }
    //插入搜索
    [self.mArrayIndexs insertObject:UITableViewIndexSearch atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Getter

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 44)];
        _searchBar.backgroundImage = [UIImage imageNamed:@"navi"];//
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15, 44, kScreenW-30, kScreenH - 64-44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.rowHeight = 55.0f;
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView registerNib:[UINib nibWithNibName:kYTXFriendsTableViewCell bundle:nil] forCellReuseIdentifier:kYTXFriendsTableViewCell];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kYTXTableViewCell];
        self.tableView.sectionIndexColor = [UIColor grayColor];
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSMutableArray *)mArrayData {
    if (!_mArrayData) {
        _mArrayData = [[NSMutableArray alloc]init];
    }
    return _mArrayData;
}

- (NSMutableArray *)mArrayIndexs {
    if (!_mArrayIndexs) {
        _mArrayIndexs = [[NSMutableArray alloc]init];
    }
    return _mArrayIndexs;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    
//}

- (NSString *)firstCharactor:(NSString *)aString
{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    return [pinYin substringToIndex:1];
}

@end
