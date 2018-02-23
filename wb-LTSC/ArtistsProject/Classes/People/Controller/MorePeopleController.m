//
//  MorePeopleController.m
//  meishubao
//
//  Created by LWR on 2017/4/24.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "MorePeopleController.h"
#import "GeneralConfigure.h"
#import "MorePeopleModel.h"
#import "NSString+PinYin.h"
#import "MorePeopleCell.h"
#import "ItemHeaderView.h"
#import "MSBPersonDetailController.h"

@interface MorePeopleController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray   *dataSource;

@end

@implementation MorePeopleController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 设置标题
    [self setLogoTitle];
    // 初始化
    [self setup];
    // 加载数据
    [self loadData];
}

- (void)setup {

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing      = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3.0, 74.25);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:layout];
    [_collectionView registerClass:[MorePeopleCell class] forCellWithReuseIdentifier:@"MorePeopleCell"];
    _collectionView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222);
    _collectionView.dataSource = self;
    _collectionView.delegate   = self;
    [self.view addSubview:_collectionView];

    [_collectionView registerClass:[ItemHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
}

- (void)loadData {

    [self hudLoding];
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestServer shareInstance] requestPeopleArticleWithArtist_level:self.artist_uid is_all:1 success:^(LLResponse *response, id data) {
        
        [weakSelf hiddenHudLoding];
        if (data != nil && [data isKindOfClass:[NSArray class]]) {
            
            NSArray *arr = [MorePeopleModel mj_objectArrayWithKeyValuesArray:data];
            if (arr.count > 0) {
                
                [weakSelf.dataSource addObjectsFromArray:[arr arrayWithPinYinFirstLetterFormat]];
                [weakSelf createLetterLab];
                [weakSelf.collectionView reloadData];
            }
        }
        
    } failure:^(LLResponse *response) {
        
        [weakSelf hudTip:response.msg];
    } error:^(NSError *error) {
        
        [weakSelf hudTip:@"请求出错"];
    }];
}

#pragma mark - 创建标签
-(void) createLetterLab {

    NSInteger count   = self.dataSource.count;
    CGFloat eachLabH  = 20.0;
    CGFloat eachLabW  = 28.0;
    
    CGFloat firstLabY = (SCREEN_HEIGHT - 64 - (count * eachLabH)) / 2.0;
    for (int i = 0; i < count; i++) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - eachLabW - 2, 64 + firstLabY + i * eachLabH, eachLabW, eachLabH)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor       = [UIColor colorWithHex:0x989898];
        lab.textAlignment   = NSTextAlignmentRight;
        lab.font = [UIFont systemFontOfSize:10.0];
        lab.text = self.dataSource[i][@"firstLetter"];
        lab.tag  = i;
        lab.userInteractionEnabled = YES;
        [self.view addSubview:lab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letterLabTap:)];
        [lab addGestureRecognizer:tap];
    }
}

- (void)letterLabTap:(id)sender {

    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UILabel *lab = (UILabel *)tap.view;
    
    NSIndexPath* cellIndexPath = [NSIndexPath indexPathForItem:0 inSection: lab.tag];
    UICollectionViewLayoutAttributes* attr = [self.collectionView.collectionViewLayout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:cellIndexPath];
    UIEdgeInsets insets = self.collectionView.scrollIndicatorInsets;
    
    CGRect rect = attr.frame;
    rect.size   = self.collectionView.frame.size;
    rect.size.height -= insets.top + insets.bottom;
    CGFloat offset    = (rect.origin.y + rect.size.height) - self.collectionView.contentSize.height;
    if ( offset > 0.0 ) rect = CGRectOffset(rect, 0, -offset);
    
    [self.collectionView scrollRectToVisible:rect animated:NO];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    }else {
    
        NSDictionary *dict = self.dataSource[section];
        NSMutableArray *array = dict[@"content"];
        return [array count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MorePeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MorePeopleCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataSource[indexPath.section];
    NSMutableArray *array = dict[@"content"];
    cell.model = array[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        ItemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        headerView.sectionTitle.text = self.dataSource[indexPath.section][@"firstLetter"];
        reusableview = headerView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary    *dict    = self.dataSource[indexPath.section];
    NSMutableArray  *array   = dict[@"content"];
    MorePeopleModel *model   = array[indexPath.row];
    MSBPersonDetailController *personDetailVC = [[MSBPersonDetailController alloc] init];
    personDetailVC.artistId  = [NSString stringWithFormat:@"%ld", model.artist_id];
    [self.navigationController pushViewController:personDetailVC animated:YES];
}

#pragma mark - getter
- (NSMutableArray *)dataSource {

    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)dealloc {

    if (self.collectionView.delegate != nil) {
        
        self.collectionView.delegate = nil;
    }
    
    if (self.collectionView.dataSource != nil) {
        
        self.collectionView.dataSource = nil;
    }
}

@end
