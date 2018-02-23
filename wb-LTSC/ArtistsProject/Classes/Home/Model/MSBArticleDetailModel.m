//
//  MSBArticleDetailModel.m
//  meishubao
//
//  Created by T on 16/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBArticleDetailModel.h"
#import "NSString+Extension.h"
#import "LKDBHelper.h"
#import "ArticleImageModel.h"
@implementation MSBArticleDetailModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"smeta":[ArticleImageModel class]};
}

- (void)setPost_date:(NSString *)post_date{
    _post_date = post_date;
    if (![_post_date containsString:@"至"]) {
        _post_date = [NSString formatTimeStamp:[post_date doubleValue]];
    }
}

// 必写
+(LKDBHelper *)getUsingLKDBHelper {
    return [BaseModel getUsingLKDBHelper];
}

// 必写表名
+(NSString *)getTableName {
    return @"offline_read";
}

// 必写 主键
+(NSString *)getPrimaryKey {
    return @"post_id";
}

// 保存后是否更新主键id到model中
+(BOOL)autoIncreatPrimaryKey {
    return NO;
}

@end

