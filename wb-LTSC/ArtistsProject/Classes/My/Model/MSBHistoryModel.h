//
//  MSBHistoryModel.h
//  meishubao
//
//  Created by T on 16/12/21.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseModel.h"

@interface MSBHistoryModel : BaseModel
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *title;
@end
