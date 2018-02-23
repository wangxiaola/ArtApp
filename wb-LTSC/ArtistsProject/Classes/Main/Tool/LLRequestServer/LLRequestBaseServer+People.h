//
//  LLRequestBaseServer+People.h
//  meishubao
//
//  Created by LWR on 2016/12/6.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer.h"

@interface LLRequestBaseServer (People)

/*!
 @brief 2.1.人物首页 get
 @param artist_level 1,2,3,4分别是 大师 大家 名家 新锐
 @param is_all 传0 返回30条 传1返回全部
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestPeopleArticleWithArtist_level:(NSString *)artist_level
                                     is_all:(NSInteger)is_all
                                    success:(LLRequestSuccessBlock)success
                                    failure:(LLRequestFailedBlock)failure
                                      error:(LLRequestErrorBlock)error;

/*!
 @brief 2.2.人物详情 get
 @param artist_id 文章id
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestPeopleDetailWithArtist_id:(NSString *)artist_id
                                    success:(LLRequestSuccessBlock)success
                                    failure:(LLRequestFailedBlock)failure
                                      error:(LLRequestErrorBlock)error;


/*!
 @brief 2.3.人物搜索 get
 @param keyword 搜索关键字
 @param offset 偏移id
 @param pagesize 显示条数
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestPeopleSearchWithKeyword:(NSString *)keyword
                                    offset:(NSString *)offset
                                    pagesize:(NSInteger)pagesize
                                    success:(LLRequestSuccessBlock)success
                                    failure:(LLRequestFailedBlock)failure
                                      error:(LLRequestErrorBlock)error;

/*!
 @brief 2.4. 人物作品接口
 @param artistId 人物id
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestArtistWorksWithArtistId:(NSString *)artistId
                                offset:(NSString *)offset
                              pagesize:(NSInteger)pagesize isAll:(NSString *)is_all
                               success:(LLRequestSuccessBlock)success
                               failure:(LLRequestFailedBlock)failure
                                 error:(LLRequestErrorBlock)error;

/*!
 @brief 2.5. 人物文章接口
 @param artistId 人物id
 @param articleType information/composition资讯/学术著作
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestArtistArticleWithArtistId:(NSString *)artistId
                             articleType:(NSString *)articleType
                                  offset:(NSString *)offset
                                pagesize:(NSInteger)pagesize
                                 success:(LLRequestSuccessBlock)success
                                 failure:(LLRequestFailedBlock)failure
                                   error:(LLRequestErrorBlock)error;
@end