//
//  MSBFollowRecommendController.h
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    MSBFollowTypeRecommend = 1,
    MSBFollowTypeAll = 2,
    MSBFollowTypeNew = 3
}MSBFollowType;

@interface MSBFollowRecommendController : BaseViewController
@property (nonatomic, assign) MSBFollowType  followType;
@end
