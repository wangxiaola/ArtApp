//
//  MSBYZHCommentController.h
//  meishubao
//
//  Created by T on 17/1/6.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "BaseViewController.h"
#import "MSBArticleDetailModel.h"
#import "MSBVideoDetaiModel.h"
@interface MSBYZHCommentController : BaseViewController
// 视频id
@property (nonatomic, copy) NSString *video_id;
@property(nonatomic,strong) NSArray *hotComments;
@property(nonatomic,strong) MSBVideoDetaiModel *detailModel;
@end
