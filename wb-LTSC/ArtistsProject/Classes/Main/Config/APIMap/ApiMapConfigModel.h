//
//  ApiMapConfigModel.h
//  evtmaster
//
//  Created by sks on 16/5/10.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ApiMapConfigModel : BaseModel
@property  NSInteger id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *url;
@end
