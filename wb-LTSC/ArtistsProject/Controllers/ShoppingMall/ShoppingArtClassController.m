//
//  ShoppingArtClassController.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/9.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ShoppingArtClassController.h"
#import "GoodsCategoryTableViewCell.h"
#import "ShoppingMallCollectionViewCell.h"
#import "GoodsCategoryModel.h"
#import <masonry.h>
#import "SearchGoodsViewController.h"
#import "YTXHomeSearchVC.h"
#import "MemSearchView.h"
#import "PublishShopController.h"
#import "PublishDongtaiVC.h"
#import "ShoppingCollectionReusableView.h"
#define LEFTVIEWWIDTH 90
#define MINIMUNSPACE 15
static NSString *IDENTIFER = @"cell";


@interface ShoppingArtClassController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MemSearchDelegate>
{
    MemSearchView  *_search;
    UIView *botView;
    NSString *imageUrl;
    NSMutableArray *allArray;
}
@property (nonatomic, strong)UITableView *leftTableView;
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *collectionDataM;
@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)UICollectionView *collectionView;


@end

@implementation ShoppingArtClassController

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - LEFTVIEWWIDTH - 4 * MINIMUNSPACE) / 3;
        flowLayout.itemSize = CGSizeMake(width, width * 1.5);
        flowLayout.minimumInteritemSpacing = MINIMUNSPACE;
        flowLayout.minimumLineSpacing = MINIMUNSPACE;
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        // 如果未设置背景颜色是黑色设置背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        // 设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ShoppingMallCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
        [_collectionView registerClass:[ShoppingCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        [self.view addSubview:_collectionView];
        _collectionView.frame = CGRectMake(LEFTVIEWWIDTH, _search.endY + 10, kScreenW - LEFTVIEWWIDTH, kScreenH - 64-44);
//        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_search.mas_bottom);
//            make.right.mas_equalTo(self.view);
//            make.bottom.mas_equalTo(self.view).offset(-44);
//            make.left.mas_offset(LEFTVIEWWIDTH);
//        }];
    }
    return _collectionView;
}

-(UITableView *)leftTableView{
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_leftTableView];
        [_leftTableView registerNib:[UINib nibWithNibName:@"GoodsCategoryTableViewCell" bundle:nil] forCellReuseIdentifier:IDENTIFER];
        _leftTableView.frame = CGRectMake(0, _search.endY + 10, LEFTVIEWWIDTH, kScreenH - 64-44);
//        [_leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.mas_equalTo(_search.mas_bottom);
//            make.bottom.mas_equalTo(self.view).offset(-44);
//            make.width.mas_equalTo(LEFTVIEWWIDTH);
//        }];
    }
    return _leftTableView;
}

-(NSMutableArray *)collectionDataM{
    if (!_collectionDataM) {
        _collectionDataM = [NSMutableArray array];
    }
    return _collectionDataM;
}

-(NSMutableArray *)tableViewDataM{
    if (!_tableViewDataM) {
        _tableViewDataM = [NSMutableArray array];
    }
    return _tableViewDataM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //菜单选择器
    if (iOS7Later) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    UIView* userview = [[UIView alloc]initWithFrame:CGRectMake(0,20,160, 44)];
    self.navigationItem.titleView = userview;
    //艺术家名称
    UILabel *_nameLabel = [[UILabel alloc]init];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = [NSString stringWithFormat:@"%@",_navTitle];
    CGSize tempSize = [_nameLabel sizeThatFits:CGSizeMake(160, 44)];
    _nameLabel.frame = CGRectMake(30, 7,tempSize.width, 30);
    _nameLabel.centerX = userview.centerX;
    [userview addSubview:_nameLabel];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(66, 20, kScreenW-78, 44)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = _navTitle;
//    self.navigationItem.titleView = label;
    _search = [[MemSearchView alloc] initWithFrame:CGRectMake(10,0, kScreenWidth - 55, 35)];
    _search.delegate = self;
    kWeakSelf;
    _search.YYGetTitle = ^(NSString *Title) {
        kPrintLog(Title);
        SearchGoodsViewController *searchVC = [[SearchGoodsViewController alloc]init];
        searchVC.gtype = Title;
        searchVC.searchText = Title;
        searchVC.huiyuan = @"2";// 0不过滤，1为会员，2为非会员
        searchVC.goodsCategorys = weakSelf.tableViewDataM;
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    };
    _search.YYGetCancel = ^(NSString *Title) {
        kPrintLog(Title);
    };
    [self.view addSubview:_search];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW-35, 7.5, 20, 20)];
    [rightButton addTarget:self action:@selector(rightPublicAction) forControlEvents:UIControlEventTouchUpInside];
    //    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    self.selectedIndex = 0;
    [self.leftTableView reloadData];
    //选中第一个cell
    if (self.tableViewDataM.count) {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        if (self.tableViewDataM[0].child) {
            [self.collectionDataM addObjectsFromArray: self.tableViewDataM[0].child];
            imageUrl = self.tableViewDataM[0].imgurl;
            [self.collectionView reloadData];
        }
    }
//    [self updataDate];
}
- (void)rightPublicAction{
    if ([Global sharedInstance].isgroup.integerValue != 1) {
        [ArtUIHelper addHUDInView:self.view text:@"暂无权限" hideAfterDelay:1.0];
        return;
    }
    PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
    vc.topictype = @"4";// 商品类型
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

// 搜索视图消息代理方法
- (void)menSearchNewMessage:(UIButton *)button
{
    [self.view endEditing:YES];
    [button setTitle:@"" forState:(UIControlStateNormal)];
}

//请求数据
-(void)updataDate{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [ArtRequest GetRequestWithActionName:@"goodstype" andPramater:nil succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [self hideHUD];
        allArray = [NSMutableArray array];
        [allArray addObjectsFromArray:[GoodsCategoryModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
        for (GoodsCategoryModel *model in allArray) {
            if (![model.title isEqualToString:@"会员区"]) {
                [self.tableViewDataM addObject:model];
            }
        }
        //         [self.tableViewDataM addObjectsFromArray:[GoodsCategoryModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
        [self.leftTableView reloadData];
        //选中第一个cell
        if (self.tableViewDataM.count) {
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            if (self.tableViewDataM[0].child) {
                [self.collectionDataM addObjectsFromArray: self.tableViewDataM[0].child];
                imageUrl = self.tableViewDataM[0].imgurl;
                [self.collectionView reloadData];
            }
        }
        
    } failed:^(id responseObject) {
        
        [self hideHUD];
    }];
}

#pragma mark - tableview delegate ,dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataM.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFER];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    NSString *string = self.tableViewDataM[indexPath.row].title;
    string = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\n"];
    cell.titleLabel.text = string;
    if (indexPath.row == 0) {
        cell.topView.hidden = YES;
    }else{
        cell.topView.hidden = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (cell.selected) {
        cell.backgroundColor = [UIColor whiteColor];
        [self.collectionView reloadData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsCategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = indexPath.row;
    if (indexPath.row == 0) {
        cell.topView.hidden = YES;
    }else{
        cell.topView.hidden = NO;
    }
    if (self.tableViewDataM[indexPath.row].child) {
        cell.rightView.hidden = YES;
        imageUrl = self.tableViewDataM[indexPath.row].imgurl;
        [self.collectionDataM removeAllObjects];
        [self.collectionDataM addObjectsFromArray: self.tableViewDataM[indexPath.row].child];
    }else{
        [self.collectionDataM removeAllObjects];
        SearchGoodsViewController *searchVC = [[SearchGoodsViewController alloc]init];
        searchVC.gtype = self.tableViewDataM[indexPath.row].goods_id;
        searchVC.searchText = self.tableViewDataM[indexPath.row].cname;
        searchVC.huiyuan = @"2";
        searchVC.goodsCategorys = self.tableViewDataM;
        [self.navigationController pushViewController:searchVC animated:YES];
    }
    [self.collectionView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GoodsCategoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - collectionDelegate  collectionDataSource
// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
#pragma mark - 头部视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = CGSizeMake(200,100);
    return size;
}
#pragma mark - 头部视图内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ShoppingCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        [header.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        return header;
    }
    return nil;
}


// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionDataM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    ShoppingMallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    // 取出图片名称
    NSString *url = self.collectionDataM[indexPath.row].imgurl;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    // 取出文字
    cell.titleLabel.text = self.collectionDataM[indexPath.row].title;
    //    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

// 点击图片的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchGoodsViewController *searchVC = [[SearchGoodsViewController alloc]init];
    searchVC.gtype = self.collectionDataM[indexPath.row].goods_id;
    searchVC.searchText = self.collectionDataM[indexPath.row].title;
    searchVC.huiyuan = @"2";
    searchVC.goodsCategorys = self.tableViewDataM;
    [self.navigationController pushViewController:searchVC animated:YES];
    NSLog(@"我点击了%ld图片！！！",indexPath.item + 1);
}

@end
