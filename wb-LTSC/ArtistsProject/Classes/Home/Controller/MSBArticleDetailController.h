//
//  MSBArticleDetailController.h
//  meishubao
//
//  Created by T on 16/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class MSBArticleDetailModel,ArticleModel;

@interface MSBArticleDetailController : BaseViewController
// 文章id
@property (nonatomic, copy) NSString *tid;

@property (nonatomic, strong) MSBArticleDetailModel *articleModel;
@property (nonatomic,strong) ArticleModel * article;

@end
