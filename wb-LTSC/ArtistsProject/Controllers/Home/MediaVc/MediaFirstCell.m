//
//  IntroImageCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MediaFirstCell.h"
#import "MediasFirstCollectionCell.h"

@interface MediaFirstCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSMutableArray* imageArr;
@end

@implementation MediaFirstCell
-(void)addContentViews{
    
    _imageArr = [[NSMutableArray alloc]init];
    //创建网格布局对象
    UICollectionViewFlowLayout* lay = [[UICollectionViewFlowLayout alloc]init];
    lay.itemSize = CGSizeMake(T_WIDTH(60), T_WIDTH(90));//cell大小
    lay.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    lay.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
    lay.minimumLineSpacing = 15;//行间距
    
    self.collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height-T_WIDTH(10)) collectionViewLayout:lay];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.backgroundColor=[UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[MediasFirstCollectionCell class] forCellWithReuseIdentifier:@"MediasFirstCollectionCell"];
    [self.contentView addSubview:self.collectionView];
    
    //自定义线条
    UIImageView *line1=[[UIImageView alloc]init];
    line1.backgroundColor=BACK_VIEW_COLOR;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(T_WIDTH(10));
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
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
    MediasFirstCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MediasFirstCollectionCell" forIndexPath:indexPath];
    id obj = _imageArr[indexPath.row];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        [cell setArtCollectionViewCellValue:_imageArr[indexPath.row]];
    }
    
    return cell;
    
}
@end
