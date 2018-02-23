//
//  MSBArticleCommentController.h
//  meishubao
//
//  Created by T on 16/11/23.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseViewController.h"
#import "MSBArticleDetailModel.h"

@interface MSBArticleCommentController : BaseViewController
// 文章id
@property (nonatomic, copy) NSString *tid;
@property(nonatomic,strong) MSBArticleDetailModel *detailModel;
@property(nonatomic,strong) NSArray *hotComments;
@end
