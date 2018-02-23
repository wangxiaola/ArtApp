//
//  MSBFollowPosterCell.h
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSBUserFollowPoster.h"

typedef void(^FollowPosterPraiseBlock)(UIButton *);
typedef void(^FollowPosterArticleClick)();
@interface MSBFollowPosterCell : UITableViewCell

@property (nonatomic, copy) FollowPosterPraiseBlock praiseBlock;
@property (nonatomic, copy) FollowPosterArticleClick articleBlock;


- (void)setModel:(MSBUserFollowPoster *)item;

+ (CGFloat)rowHeight:(MSBUserFollowPoster *)item
           cellWidth:(CGFloat)cellWidth;

@end
