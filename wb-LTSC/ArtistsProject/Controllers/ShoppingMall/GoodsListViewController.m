//
//  GoodsListViewController.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsListCollectionViewCell.h"
#import "GoodsCategoryModel.h"
#define MINIMUNSPACE 15

@interface GoodsListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *collectionDataM;


@end

@implementation GoodsListViewController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - 3 * MINIMUNSPACE) / 2;
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
        [_collectionView registerClass:[GoodsListCollectionViewCell class] forCellWithReuseIdentifier:@"GoodsListCollectionViewCell"];
        
        [self.view addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    return _collectionView;
}

-(NSMutableArray *)collectionDataM{
    if (!_collectionDataM) {
        _collectionDataM = [NSMutableArray array];
    }
    return _collectionDataM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.collectionDataM.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    GoodsListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsListCollectionViewCell" forIndexPath:indexPath];
    
    // 取出图片名称
    NSString *url = self.collectionDataM[indexPath.row].imgurl;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    // 取出文字
    cell.titleLabel.text = self.collectionDataM[indexPath.row].title;
    cell.backgroundColor = [UIColor lightGrayColor];
    
    
    return cell;
}

// 点击图片的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"我点击了%ld图片！！！",indexPath.item + 1);
    
}


@end
