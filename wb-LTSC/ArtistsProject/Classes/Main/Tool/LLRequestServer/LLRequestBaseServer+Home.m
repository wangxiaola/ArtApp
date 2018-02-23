//
//  LLRequestServer+Home.m
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer+Home.h"
#import "NSString+ToString.h"
#import "ApiMap.h"
#import "MJExtension.h"

@implementation LLRequestBaseServer (Home)
/*!
 @brief 1.1.首页列表数据
 @param type 文章类型
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestHomeArticleWithType:(NSString *)type
                            offset:(NSString *)offset
                          pagesize:(NSInteger)pagesize
                           success:(LLRequestSuccessBlock)success
                           failure:(LLRequestFailedBlock)failure
                             error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"term_id": [NSString isNull:type] ? @"0" : type,
                                     @"offset":[NSString isNull:offset] ? @"0" : offset,
                                     @"pagesize":@(pagesize)
                                 };
    [self getWithUrl:[ApiMap url:@"POST_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.2.文章详情内容
 @param articleId 文章ID
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestArticleDetailWithArticleId:(NSString *)articleId
                                 success:(LLRequestSuccessBlock)success
                                 failure:(LLRequestFailedBlock)failure
                                   error:(LLRequestErrorBlock)error{
                NSDictionary *parameters = @{
                                             @"post_id":[NSString notNilString:articleId]
                                         };
     [self getWithUrl:[ApiMap url:@"POST_DETAIL"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.3.文章详情热门评论
 @param articleId 文章ID
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestArticleDetailHotCommentWithArticleId:(NSString *)articleId
                                         artist_id:(NSString *)artist_id
                                          video_id:(NSString *)video_id
                                              type:(NSInteger)type
                                           success:(LLRequestSuccessBlock)success
                                           failure:(LLRequestFailedBlock)failure
                                             error:(LLRequestErrorBlock)error{
            NSDictionary *parameters = @{
                                                @"post_id":[NSString notNilString:articleId],
                                                @"artist_id":[NSString notNilString:artist_id],
                                                @"video_id":[NSString notNilString:video_id],
                                                @"type":@(type),
                                                };
     [self getWithUrl:[ApiMap url:@"HOT_COMMENT"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.4.全部评论
 @param postId 文章id
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestArticleDetailCommentsWithPostId:(NSString *)postId
                                     artist_id:(NSString *)artist_id
                                    video_id:(NSString *)video_id
                                          type:(NSInteger)type
                                        offset:(NSString *)offset
                                      pagesize:(NSInteger)pagesize
                                       success:(LLRequestSuccessBlock)success
                                       failure:(LLRequestFailedBlock)failure
                                         error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"post_id":[NSString notNilString:postId],
                                 @"artist_id":[NSString notNilString:artist_id],
                                 @"video_id":[NSString notNilString:video_id],
                                 @"type":@(type),
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize)
                                 };
    [self getWithUrl:[ApiMap url:@"ALL_COMMENT"]  parameters:parameters success:success failure:failure error:error];
}
/*!
 @brief 1.5.文章发表评论/回复评论  post请求
 @param postId 文章id
 @param commentId 评论id
 @param toUid 被回复人的id
 @param commentContent 评论内容
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestArticleDetailPublishCommentPostId:(NSString *)postId
                                       artist_id:(NSString *)artist_id video_id:(NSString *)video_id
                                            type:(NSInteger)type
                                       commentId:(NSString *)commentId
                                        mainCommentId:(NSString *)mainCommentId
                                           toUid:(NSString *)toUid
                                  commentContent:(NSString *)commentContent
                                         success:(LLRequestSuccessBlock)success
                                         failure:(LLRequestFailedBlock)failure
                                           error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"post_id":[NSString notNilString:postId],
                                 @"artist_id":[NSString notNilString:artist_id],
                                 @"video_id":[NSString notNilString:video_id],
                                 @"type":@(type),
                                 @"comment_id":[NSString notNilString:commentId],
                                 @"main_comment_id":[NSString notNilString:mainCommentId],
                                 @"to_uid" : [NSString notNilString:toUid],
                                 @"comment_content":[NSString notNilString:commentContent],
                                 @"token":[self getToken]
                                 };
    [self postWithUrl:[ApiMap url:@"PUBLISH_COMMENT"] parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.6.文章收藏接口  post请求
 @param postId 文章id
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestArticleDetailArticleCollectionPostId:(NSString *)postId
                                            isCollect:(BOOL)isCollect
                                           video_id:(NSString *)video_id
                                            pic_url:(NSString *)pic_url
                                               type:(NSInteger)type
                                            success:(LLRequestSuccessBlock)success
                                            failure:(LLRequestFailedBlock)failure
                                              error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"post_id":[NSString notNilString:postId],
                                 @"pic_url":[NSString notNilString:pic_url],
                                 @"video_id":[NSString notNilString:video_id],
                                 @"type":@(type),
                                 @"is_collect":@(isCollect),
                                 @"token":[self getToken]
                                 };
    [self postWithUrl:[ApiMap url:@"POST_COLLECT"] parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.7.文章评论点赞  post请求
 @param postId 文章id
 @param commentId 评论id
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestArticleDetailCommentPraisePostId:(NSString *)postId
                                      commentId:(NSString *)commentId
                                        videoId:(NSString *)videoId
                                       artistId:(NSString *)artistId
                                          orgId:(NSString *)orgId
                                        parise:(NSInteger)praise
                                           type:(NSInteger)type
                                        success:(LLRequestSuccessBlock)success
                                        failure:(LLRequestFailedBlock)failure
                                          error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"post_id":[NSString notNilString:postId],
                                 @"comment_id":[NSString notNilString:commentId],
                                 @"video_id":[NSString notNilString:videoId],
                                 @"artist_id":[NSString notNilString:artistId],
                                 @"org_id":[NSString notNilString:orgId],
                                 @"type":@(type),
                                 @"praise_status":@(praise),
                                 @"token":[self getToken]
                                 };
    [self postWithUrl:[ApiMap url:@"COMMENT_PRAISE"] parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.8.文章轮播图接口  get请求
 @param termId 文章类型
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestArticleBannerWithTermId:(NSString *)termId
                               success:(LLRequestSuccessBlock)success
                               failure:(LLRequestFailedBlock)failure
                                 error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"term_id": [NSString isNull:termId] ? @"0" : termId
                                 };
    [self getWithUrl:[ApiMap url:@"BANNER"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.9.文章搜索列表
 @param keyword 关键字
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestHomeSearchArticleWithKeyword:(NSString *)keyword
                                     offset:(NSString *)offset
                                   pagesize:(NSInteger)pagesize termId:(NSString *)term_id
                                    success:(LLRequestSuccessBlock)success
                                    failure:(LLRequestFailedBlock)failure
                                      error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"keyword":[NSString notNilString:keyword],
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize),
                                 @"term_id":[NSString notNilString:term_id],
                                 };
    [self getWithUrl:[ApiMap url:@"SEARCH_POST_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.10.文章分类列表
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestHomeArticleCategoryWithSuccess:(LLRequestSuccessBlock)success
                                            failure:(LLRequestFailedBlock)failure
                                              error:(LLRequestErrorBlock)error {
    NSString *token = [self getToken];
    NSDictionary *parameters;
    if ([token isEqualToString:@""] || token == nil) {
        
       parameters  = @{};
    }else {
    
        parameters = @{@"token" : token};
    }
    [self getWithUrl:[ApiMap url:@"POST_TERM_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 4.11.圆桌会列表 
 @param term_id 文章类型
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestHomeRoundTableWith:(NSString *)term_id
                            offset:(NSString *)offset
                          pagesize:(NSInteger)pagesize
                           success:(LLRequestSuccessBlock)success
                           failure:(LLRequestFailedBlock)failure
                             error:(LLRequestErrorBlock)error {
    NSDictionary *parameters = @{
                                 @"term_id": [NSString isNull:term_id] ? @"16" : term_id,
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize)
                                 };
    [self getWithUrl:[ApiMap url:@"GET_ROUND_TABLE"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 4.12.首页近期热点接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestRecentHotSuccess:(LLRequestSuccessBlock)success
                        failure:(LLRequestFailedBlock)failure
                          error:(LLRequestErrorBlock)error {
    [self getWithUrl:[ApiMap url:@"GET_RECENT_HOT"]  parameters:@{} success:success failure:failure error:error];
}

/*!
 @brief 4.13.回复的评论列表点击更多接口 get
 @param main_comment_id 主评论id
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestReplyCommentMoreWithMainCommentId:(NSString *)main_comment_id offSet:(NSString *)offset pageSize:(NSInteger)pagesize success:(LLRequestSuccessBlock)success failure:(LLRequestFailedBlock)failure error:(LLRequestErrorBlock)error
{
    NSDictionary *parameters = @{
                                 @"main_comment_id":[NSString notNilString:main_comment_id],
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize)
                                 };
    [self getWithUrl:[ApiMap url:@"ALL_REPLY_COMMENT"]  parameters:parameters success:success failure:failure error:error];
}


/*!
 @brief 4.14.视频详情接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestVideoDetailWithVideoId:(NSString *)videoId
                              success:(LLRequestSuccessBlock)success
                              failure:(LLRequestFailedBlock)failure
                                error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"video_id":[NSString notNilString:videoId],
                                 @"token":@""
                                 };
    [self getWithUrl:[ApiMap url:@"GET_VIDEO_DETAIL"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 4.15.30周年图集 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestAnniversary30WithPostId:(NSString *)postId
                               success:(LLRequestSuccessBlock)success
                               failure:(LLRequestFailedBlock)failure
                                 error:(LLRequestErrorBlock)error
{
    NSDictionary *parameters = @{
                                 @"post_id":[NSString notNilString:postId]
                                 };
    [self getWithUrl:[ApiMap url:@"GET_ANNIVERSARY30_DETAIL"]  parameters:parameters success:success failure:failure error:error];
}
    
/*!
 @brief 4.17.设置我的个性分类接口 post
 @param term_list 分类数组
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestPersonalityCategory:(NSArray *)term_list
                           success:(LLRequestSuccessBlock)success
                           failure:(LLRequestFailedBlock)failure
                             error:(LLRequestErrorBlock)error {

    NSDictionary *parameters = @{
                                 @"term_list" : term_list.mj_JSONString,
                                 @"token"     : [self getToken]
                                 };
    [self postWithUrl:[ApiMap url:@"SAVE_MY_TERM_LIST"] parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 4.18.最热展览列表接口
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestHotestShowWithOffset:(NSString *)offset
                           pagesize:(NSInteger)pagesize startTime:(NSString *)start_time endTime:(NSString *)end_time
                            success:(LLRequestSuccessBlock)success
                            failure:(LLRequestFailedBlock)failure
                              error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize),
                                 @"start_time":[NSString notNilString:start_time],
                                 @"end_time":[NSString notNilString:end_time]
                                 };
    [self getWithUrl:[ApiMap url:@"ZHANLAN_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 4.19.转发量自增接口
 @param Postid  文章ID
 @param type    1文章 2视频 3人物
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestRepeatIncrementWithPostid:(NSString *)Postid
                                     type:(NSString *)type
                                 success:(LLRequestSuccessBlock)success
                                 failure:(LLRequestFailedBlock)failure
                                   error:(LLRequestErrorBlock)error {

    NSDictionary *parameters = @{
                                 @"object_id" : [NSString notNilString:Postid],
                                 @"type"    : [NSString notNilString:type]
                                 };
    [self postWithUrl:[ApiMap url:@"SHARE_ACTION"] parameters:parameters success:success failure:failure error:error];
}

@end
