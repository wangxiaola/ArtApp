//
//  LLRequestBaseServer+Agency.m
//  meishubao
//
//  Created by LWR on 2016/12/8.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer+Agency.h"
#import "NSString+ToString.h"
#import "ApiMap.h"

@implementation LLRequestBaseServer (Agency)

/*!
 @brief 3.1.机构列表接口 get
 @param type 1,国内 , 2国外 3六个机构
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestEightAgencyHeaderWithType:(NSString *)type
                                success:(LLRequestSuccessBlock)success
                                failure:(LLRequestFailedBlock)failure
                                  error:(LLRequestErrorBlock)error {
    NSDictionary *parameters = @{
                                 @"type":[NSString notNilString:type]
                                 };
    [self getWithUrl:[ApiMap url:@"GET_ORG_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 3.2.搜索机构接口 get
 @param keyword 搜索关键字
 @param offset 偏移id
 @param pagesize 显示条数
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestAgencySearchWithKeyword:(NSString *)keyword
                               offset:(NSString *)offset
                                 type:(NSString *)type
                             pagesize:(NSInteger)pagesize
                              success:(LLRequestSuccessBlock)success
                              failure:(LLRequestFailedBlock)failure
                                error:(LLRequestErrorBlock)error {
    NSDictionary *parameters = @{
                                 @"keyword":[NSString notNilString:keyword],
                                 @"offset":[NSString notNilString:offset],
                                 @"type":[NSString notNilString:type],
                                 @"pagesize":@(pagesize)
                                 };
    [self getWithUrl:[ApiMap url:@"SEARCH_ORG_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 3.4. 艺术机构详情接口
 @param orgId 机构id
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestAgencyDetailWithOrgId:(NSString *)orgId
                             success:(LLRequestSuccessBlock)success
                             failure:(LLRequestFailedBlock)failure
                               error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"org_id":[NSString notNilString:orgId]
                                 };
    [self getWithUrl:[ApiMap url:@"GET_ORG_DETAIL"]  parameters:parameters success:success failure:failure error:error];

}

/*!
 @brief 3.5.更多机构列表接口 get
 @param type 1,国内 , 2国外
 @param offset 偏移id
 @param pagesize 显示条数
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestMoreAgencyWith:(NSString *)type
                      offset:(NSString *)offset
                    pagesize:(NSInteger)pagesize
                     success:(LLRequestSuccessBlock)success
                     failure:(LLRequestFailedBlock)failure
                       error:(LLRequestErrorBlock)error {
    NSDictionary *parameters = @{
                                 @"type":[NSString notNilString:type],
                                 @"offset":[NSString notNilString:offset],
                                 @"pagesize":@(pagesize)
                                 };
    [self getWithUrl:[ApiMap url:@"GET_MORE_ORG_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 3.9.一部八院链接接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestOrgUrlSuccess:(LLRequestSuccessBlock)success
                    failure:(LLRequestFailedBlock)failure
                      error:(LLRequestErrorBlock)error
{
   [self getWithUrl:[ApiMap url:@"ORG_URL"]  parameters:nil success:success failure:failure error:error];
}

/**
 3.10.机构筛选接口 get
 
 @param update_time  1/2/3 	一月内/三月内/一年
 @param manager_time 1/2/3/4 	1-3/3-5/5-10/10以上
 @param art_cate     油画,版画 	艺术分类
 @param zone         内蒙古 	外国国家名 或者 中国地区名
 @param nation       1/2 	1中国 2外国
 @param offset       0 	偏移id 9个机构一个数组 这个是数组的个数
 @param pagesize     显示条数
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestAgencyFilterWithUpdate_time:(NSInteger)update_time
                             manager_time:(NSInteger)manager_time
                                 art_cate:(NSString *)art_cate
                                     zone:(NSString *)zone
                                   nation:(NSInteger)nation
                                   offset:(NSInteger)offset
                                 pagesize:(NSInteger)pagesize
                                  success:(LLRequestSuccessBlock)success
                                  failure:(LLRequestFailedBlock)failure
                                    error:(LLRequestErrorBlock)error {

    NSDictionary *parameters = @{
                                 @"update_time" : update_time == 0 ? [NSNull null] : @(update_time),
                                 @"manager_time" : manager_time == 0 ? [NSNull null] : @(manager_time),
                                 @"art_cate" : [NSString notNilString:art_cate],
                                 @"zone" : [NSString notNilString:zone],
                                 @"nation" : nation == 0 ? [NSNull null] : @(nation),
                                 @"offset" : @(offset),
                                 @"pagesize" : @(pagesize),
                                 };
    [self getWithUrl:[ApiMap url:@"ORG_SEARCH"]  parameters:parameters success:success failure:failure error:error];
}


@end
