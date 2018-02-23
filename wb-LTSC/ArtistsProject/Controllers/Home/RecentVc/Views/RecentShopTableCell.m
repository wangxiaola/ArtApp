//
//  RecentShopTableCell.m
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/7.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "RecentShopTableCell.h"
#import "RecentShopCollectionCell.h"
@implementation RecentShopTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc ] init];
    layout.minimumLineSpacing      = 0;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset =  UIEdgeInsetsMake(10,15,0, 15);
    [self.collectionView setCollectionViewLayout:layout];
    [self.collectionView reloadData];

}


- (void)setShopList:(NSArray *)shopList
{
    [self.collectionView reloadData];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/2 - 20,210);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
    return self.shopList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RecentShopCollectionCell *sendGiftCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecentShopCollectionCell" forIndexPath:indexPath];
    return sendGiftCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,0);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(getRecentShopCellIndex:)]) {
        [self.delegate getRecentShopCellIndex:indexPath.row];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
@end

