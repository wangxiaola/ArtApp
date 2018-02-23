//
//  MSBPersonCenterArticleCell.h
//  meishubao
//
//  Created by T on 16/12/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSBInfoStoreItem.h"

typedef void(^ArticlePraiseBlock)(UIButton *);
typedef void(^ArticleCommentBlock)(UIButton *);
typedef void(^ArticleShareBlock)(UIImage *shareImage);

@interface MSBPersonCenterArticleCell : UITableViewCell
- (void)setModel:(MSBInfoStoreItem *)item;

@property (nonatomic, copy) ArticlePraiseBlock praiseBlock;
@property (nonatomic, copy) ArticleCommentBlock commentBlock;
@property (nonatomic, copy) ArticleShareBlock shareBlock;
@end
