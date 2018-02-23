//
//  MSBPersonCommentController.h
//  meishubao
//
//  Created by T on 17/1/6.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "BaseViewController.h"
#import "MSBArtistDetailModel.h"
@interface MSBPersonCommentController : BaseViewController
@property (nonatomic, copy) NSString *artistId;
@property (nonatomic,strong) MSBArtistDetailModel * artistDetailModel;
@property(nonatomic,strong) NSArray *hotComments;
@end
