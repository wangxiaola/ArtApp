//
//  MSBFollowItem.h
//  meishubao
//
//  Created by T on 16/12/20.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSBFollowModel.h"
@interface MSBFollowItem : NSObject
@property (nonatomic, assign) NSInteger type;
@property(nonatomic,strong) MSBFollowModel *payload;
@end
