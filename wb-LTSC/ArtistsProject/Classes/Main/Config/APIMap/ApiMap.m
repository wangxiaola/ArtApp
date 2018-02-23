//
//  ApiMap.m
//  evtmaster
//
//  Created by sks on 16/5/10.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "ApiMap.h"
#import "SchemaVersionModel.h"
#import "ApiMapConfigModel.h"
#import "GeneralConfigure.h"
#import "LKDBHelper.h"

@implementation ApiMap
+ (void)initConfig {
    // TODO 比较当前使用的和配置文件中的data version
    NSArray *apimapSchema = [SchemaVersionModel searchWithWhere:@"tableName = \"apimap_config\"" orderBy:nil offset:0 count:0];
    NSDictionary *apiConfig = [ApiMap readLocalFile:API_CONFIG_LOCAL_FILE];
    if ([apimapSchema count] > 0) {

        SchemaVersionModel *currentApi = [apimapSchema objectAtIndex:0];
        NSInteger currentLocalFileVer = [(NSNumber *) apiConfig[@"meta"][@"dataVer"] longValue];
        // 比较dataVer在数据库中和本地文件的版本
        if (currentLocalFileVer > currentApi.dataVer) {
            [ApiMap setApiMapUserDefaults:apiConfig[@"payload"]];
            currentApi.dataVer = currentLocalFileVer;
            [currentApi saveToDB];
        }
    } else {
//        BBLog(@"api map db not inited");
        // 初始化
        [ApiMap setApiMapUserDefaults:apiConfig[@"payload"]];
        SchemaVersionModel *apiMapSchema = [[SchemaVersionModel alloc] init];
        apiMapSchema.tableName = @"apimap_config";
        apiMapSchema.schemaVer = [apiConfig[@"meta"][@"schemaVer"] intValue];
        apiMapSchema.dataVer = [apiConfig[@"meta"][@"dataVer"] intValue];
        [apiMapSchema saveToDB];
    }
}

+ (NSDictionary *)readLocalFile:(NSString *) path {
    NSString *filePath = [NSString stringWithFormat:@"%@%@", @"apimap/", path];
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:fullPath];
    NSDictionary *apiConfig =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    return apiConfig;
}

// 加载本地的config文件
+ (void)loadLocalConfig:(NSString*) path {
    NSDictionary *apiConfig = [ApiMap readLocalFile:path];
//    BBLog(@"load path %@", path);
    [ApiMap setApiMapUserDefaults:apiConfig[@"payload"]];
}


+ (void)setApiMapUserDefaults:(NSDictionary *)apiConfig {
    LKDBHelper *globalDbHelper = [BaseModel getUsingLKDBHelper];
    
    [globalDbHelper executeForTransaction:^BOOL(LKDBHelper *helper) {
         // 清空表数据
        [LKDBHelper clearTableData:[ApiMapConfigModel class]];
        for (NSString *key in apiConfig) {
            ApiMapConfigModel *urlConfigRow = [[ApiMapConfigModel alloc] init];
            urlConfigRow.url = apiConfig[key][@"url"];
            urlConfigRow.desc = apiConfig[key][@"desc"];
            urlConfigRow.key = key;
            [urlConfigRow saveToDB];
        }
        return YES;
    }];
}

// 获取一个url配置
+ (NSString *)url: (NSString *)key {
    if (key == nil || [key isEqualToString:@""]) {
        return @"";
    }
    NSArray *searchResults = [ApiMapConfigModel searchWithWhere:@{@"key": key} orderBy:nil offset:0 count:1];
    if ([searchResults count] > 0) {
        ApiMapConfigModel *config = [searchResults objectAtIndex:0];
        return config.url;
    } else {
        return @"";
    }
}
@end
