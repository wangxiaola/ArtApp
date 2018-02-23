//
//  IntroImageCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroImageCell.h"
#import "IntroImageCollectionCell.h"

@interface IntroImageCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView* collectionView;

@property(nonatomic,strong)NSMutableArray* imageArr;
@end

@implementation IntroImageCell
-(void)addContentViews{
    
    _imageArr = [[NSMutableArray alloc]init];
    //创建网格布局对象
    UICollectionViewFlowLayout* lay = [[UICollectionViewFlowLayout alloc]init];
    lay.itemSize = CGSizeMake(T_WIDTH(75), T_WIDTH(75));//cell大小
    lay.sectionInset = UIEdgeInsetsMake(T_WIDTH(12), 5, 0, 5);
    lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
    lay.minimumLineSpacing = 5;//行间距
    lay.minimumInteritemSpacing = 5;//网格间距

    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height) collectionViewLayout:lay];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[IntroImageCollectionCell class] forCellWithReuseIdentifier:@"IntroImageCollectionCell"];
    [self.contentView addSubview:self.collectionView];
}

-(void)setArtTableViewCellArrValue:(NSArray *)arr{
    [_imageArr removeAllObjects];
    [_imageArr addObjectsFromArray:arr];
    [self.collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArr.count>0?_imageArr.count:0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //调用自定义Cell
    IntroImageCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"IntroImageCollectionCell" forIndexPath:indexPath];
    NSString* imgUrl = _imageArr[indexPath.row][@"photo"];
    [cell setArtCollectionViewCellStrValue:imgUrl andTag:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IntroImageCollectionCell *cell = (IntroImageCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.selectImgCilck) {
        self.selectImgCilck(_imageArr,cell.iconView);
    }
}
@end
