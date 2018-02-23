//
//  MSBCollectPhotoCell.h
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBInfoStoreItem.h"
@interface MSBCollectPhotoCell : UICollectionViewCell
@property(nonatomic,strong) UIImageView *photoImageView;
- (void)setPhoto:(NSString *)photo;
@end
