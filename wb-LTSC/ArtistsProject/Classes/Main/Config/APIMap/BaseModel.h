//
//  BaseModel.h
//  meishubao
//
//  Created by LWR on 2016/11/16.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@end


@interface NSObject(PrintSQL)

+ (NSString *)getCreateTableSQL;

@end
