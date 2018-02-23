//
//  RecentShopTableCell.h
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/7.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "BaseTableCell.h"

@protocol  RecentShopTableCellDelegate <NSObject>

- (void)getRecentShopCellIndex:(NSInteger)index;
@end
@interface RecentShopTableCell : BaseTableCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *shopList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) id <RecentShopTableCellDelegate> delegate;

@end
