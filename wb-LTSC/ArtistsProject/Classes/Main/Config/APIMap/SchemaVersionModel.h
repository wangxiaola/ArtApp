//
//  SchemaVersionModel.h
//  evtmaster
//
//  Created by sks on 16/5/10.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SchemaVersionModel : BaseModel
@property  NSInteger id;
@property (nonatomic, copy) NSString *tableName;
@property  NSInteger schemaVer;
@property  NSInteger dataVer;
@end
