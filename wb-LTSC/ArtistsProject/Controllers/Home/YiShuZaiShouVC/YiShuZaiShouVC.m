//
//  YiShuZaiShouVC.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/30.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "YiShuZaiShouVC.h"
#import "ShopSearchListCell.h"
#import "CangyouQuanDetailModel.h"
#import "ShoppingCollectionReusableView.h"
//#import "YiShuZaiShouCell.h"
@interface YiShuZaiShouCell : UICollectionViewCell

//image
@property (nonatomic, strong) UIImageView *imageV;
@end

@implementation YiShuZaiShouCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageV = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageV];
        _imageV.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 10).heightIs(kScreenW/3);
    }
    return self;
}
@end

@interface YiShuZaiShouVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UserInfoModel *userModel;
    NSArray *array;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray <CangyouQuanDetailModel *>*collectionArrayM;
@property(nonatomic,strong)NSMutableDictionary* introDic;
// 衍生品
@property (nonatomic, strong) NSMutableArray<CangyouQuanDetailModel *> *yanshengping;
// 作品
@property (nonatomic, strong) NSMutableArray <CangyouQuanDetailModel *> *zuoping;
@end

@implementation YiShuZaiShouVC

- (NSMutableArray *)collectionArrayM{
    if (!_collectionArrayM) {
        _collectionArrayM = [NSMutableArray array];
    }
    return _collectionArrayM;
}
- (NSMutableArray *)yanshengping
{
    if (!_yanshengping) {
        _yanshengping = [NSMutableArray array];
    }
    return _yanshengping;
}
- (NSMutableArray *)zuoping
{
    if (!_zuoping) {
        _zuoping = [[NSMutableArray alloc] init];
    }
    return _zuoping;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH ) / 2;
        flowLayout.itemSize = CGSizeMake(width, width + 45);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[YiShuZaiShouCell class] forCellWithReuseIdentifier:@"cell1"];
        [_collectionView registerClass:[ShopSearchListCell class] forCellWithReuseIdentifier:@"cell2"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
#pragma mark collectionViewDelegate
#pragma mark - 头部视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.zuoping.count == 0) {
            return CGSizeZero;
        }else{
            return  CGSizeMake(kScreenW,40);
        }
    }else if (section == 2) {
        if (self.yanshengping.count == 0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(kScreenW,40);
        }
    }else{
        return CGSizeZero;
    }
}
#pragma mark - 头部视图内容
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return nil;
    }else if (indexPath.section == 1 && self.zuoping.count == 0) {
        return nil;
    }else if (indexPath.section == 2&&self.yanshengping.count == 0){
        return nil;
    }else{
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        [header addSubview:view];
        view.backgroundColor = BACK_VIEW_COLOR;
        UILabel *titleLBL = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 30)];
        titleLBL.textAlignment = NSTextAlignmentLeft;
        [view addSubview:titleLBL];
        UILabel *botLBL = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 165, 5, 150, 30)];
        if (indexPath.section == 1) {
            titleLBL.text = @"在售艺术作品";
            botLBL.text = [NSString stringWithFormat:@"现存%ld件",(unsigned long)self.zuoping.count];
        }else{
            titleLBL.text = @"在售艺术衍生品";
            botLBL.text = [NSString stringWithFormat:@"现存%ld件",(unsigned long)self.yanshengping.count];
        }
        botLBL.textAlignment = NSTextAlignmentRight;
        [view addSubview:botLBL];
        return header;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenW - 30, kScreenW/3+20);
    }
    return CGSizeMake(kScreenW/2, kScreenW/2 + 45);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
//        if (array.count > 0) {
//            return 1;
//        }
        return 1;
    }else if (section == 1){
        return self.zuoping.count;
    }
    return self.yanshengping.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        YiShuZaiShouCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
//        NSArray *picArray = _introDic[@"grjj"][@"photo"];
        NSDictionary *dic = nil;
        if (array.count > 0) {
            dic = array[0];
        }
        [cell.imageV sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!3b1",dic[@"photo"]] tempTmage:@"icon_Default_Product.png"];
        return cell;
    }
    ShopSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
    CangyouQuanDetailModel *model = nil;
    if (indexPath.section == 1) {
        model = self.zuoping[indexPath.row];
    }else{
        model = self.yanshengping[indexPath.row];
    }
    NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        NSString* imgUrl = arrayYuanlai[0];
        [cell.imageView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",imgUrl] tempTmage:@"icon_Default_Product.png"];
    }
    cell.titleLabel.text = model.topictitle;
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    cell.price.text = [NSString stringWithFormat:@"¥%.2f",[model.sellprice floatValue]/100];
    if (indexPath.row%2 == 0) {
        cell.rightView2.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        cell.leftbotView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        cell.rightView2.hidden = NO;
        cell.leftbotView.hidden = NO;
        cell.rightbotView.hidden = YES;
    }else{
        cell.rightbotView.backgroundColor = [UIColor hexChangeFloat:@"ebebeb"];
        cell.rightView2.hidden = YES;
        cell.leftbotView.hidden = YES;
        cell.rightbotView.hidden = NO;
    }
    if (indexPath.row == 0) {
        cell.rightView.hidden = NO;
        cell.rightView2.hidden = YES;
    }else{
        cell.rightView.hidden = YES;
        cell.rightView2.hidden = NO;
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 ) {
        HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
        detailVC.topicid = self.zuoping[indexPath.row].id;
        detailVC.topictype = @"4";
        [self.obj.navigationController pushViewController:detailVC animated:YES];
    }
    if (indexPath.section == 2 ) {
        HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
        detailVC.topicid = self.yanshengping[indexPath.row].id;
        detailVC.topictype = @"4";
        [self.obj.navigationController pushViewController:detailVC animated:YES];
    }
   
}

- (void)createView {
    [super createView];
    _introDic = [[NSMutableDictionary alloc] init];
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        // 增加数据
        [self.collectionView.mj_header  beginRefreshing];
        //网络请求
        [self refreshData];
        [self.collectionView.mj_header   endRefreshing];
    }];
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer  beginRefreshing];
        [self loadMoreData];
        [self.collectionView.mj_footer  endRefreshing];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark - 加载数据

- (void)loadMoreData{
    self.pageIndex++;
    [self loadData];
}
- (void)refreshData{
    self.pageIndex = 1;
    [self loadData];
}

- (void)reloadData{
    NSDictionary * dict = @{@"uid":self.artId?self.artId:[[Global sharedInstance] getBundleID],
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0"
                            };
//    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:@"jianjieindex" andPramater:dict succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        //个人简介
        weakSelf.model=[UserInfoModel mj_objectWithKeyValues:responseObject[@"grjj"]];
        [_introDic addEntriesFromDictionary:responseObject];
        [weakSelf.hudLoading hideAnimated:YES];
        array = [NSArray mj_objectArrayWithKeyValuesArray:responseObject[@"grjj"][@"photo"]];
        [weakSelf.collectionView reloadData];
//        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    } failed:^(id responseObject){
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
    }];
}
- (void)loadData{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    NSDictionary *dict = @{ @"postuid":self.artId?:@"0",
                            @"zhiding":@"0",
                            @"getpeople" : @"1" ,
                            @"topictype" : @"4",
                            @"page" : @(self.pageIndex),
                            @"num" : @"10",
                            @"cuid" : [Global sharedInstance].userID?:@"0"                            };
    NSLog(@"%@",dict);
    kWeakSelf;
    [ArtRequest GetRequestWithActionName:@"topiclist" andPramater:dict succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [weakSelf.hudLoading hideAnimated:YES];
        [weakSelf reloadData];
        //近况
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (weakSelf.pageIndex==1) {
                [weakSelf.collectionArrayM removeAllObjects];
            }
            [weakSelf.yanshengping removeAllObjects];
            [weakSelf.zuoping removeAllObjects];
            [weakSelf.collectionArrayM addObjectsFromArray:[CangyouQuanDetailModel mj_objectArrayWithKeyValuesArray:responseObject]];
            for (CangyouQuanDetailModel *model in self.collectionArrayM) {
                if ([model.gtypename containsString:@"艺术作品"]) {
                    [_zuoping addObject:model];
                }
                if ([model.gtypename containsString:@"艺术洐生品art"])
                    [_yanshengping addObject:model];
            }
        }else{
            if(weakSelf.pageIndex==1){//没有相关数据
                [weakSelf.collectionArrayM removeAllObjects];
                [weakSelf.yanshengping removeAllObjects];
            }else{//没有更多数据
                
            }
        }
        kPrintLog(weakSelf.collectionArrayM);
        kPrintLog(weakSelf.yanshengping);
        [weakSelf.collectionView reloadData];
        [weakSelf hideHUD];
        
    } failed:^(id responseObject) {
        [weakSelf.hudLoading hideAnimated:YES];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
