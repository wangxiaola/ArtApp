//
//  LLRequestServer+Home.h
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer.h"

@interface LLRequestBaseServer (Home)
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
                                  error:(LLRequestErrorBlock)error;
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
                            error:(LLRequestErrorBlock)error;

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
                            error:(LLRequestErrorBlock)error;

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
                             error:(LLRequestErrorBlock)error;
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
                                         error:(LLRequestErrorBlock)error;

/*!
 @brief 1.6.文章收藏接口  post请求
 @param postId 文章id
 @param isCollect  1 收藏、 0取消收藏
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
                                         error:(LLRequestErrorBlock)error;

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
                                           error:(LLRequestErrorBlock)error;

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
                                          error:(LLRequestErrorBlock)error;

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
                             error:(LLRequestErrorBlock)error;

/*!
 @brief 1.10.文章分类列表
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestHomeArticleCategoryWithSuccess:(LLRequestSuccessBlock)success
                                            failure:(LLRequestFailedBlock)failure
                                              error:(LLRequestErrorBlock)error;

/*!
 @brief 4.11.圆桌会列表 get
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
                             error:(LLRequestErrorBlock)error;

/*!
 @brief 4.12.首页近期热点接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestRecentHotSuccess:(LLRequestSuccessBlock)success
                          failure:(LLRequestFailedBlock)failure
                            error:(LLRequestErrorBlock)error;

/*!
 @brief 4.13.回复的评论列表点击更多接口 get
 @param main_comment_id 主评论id
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestReplyCommentMoreWithMainCommentId:(NSString *)main_comment_id offSet:(NSString *)offset pageSize:(NSInteger)pagesize success:(LLRequestSuccessBlock)success failure:(LLRequestFailedBlock)failure error:(LLRequestErrorBlock)error;

/*!
 @brief 4.14.视频详情接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestVideoDetailWithVideoId:(NSString *)videoId
                        success:(LLRequestSuccessBlock)success
                        failure:(LLRequestFailedBlock)failure
                          error:(LLRequestErrorBlock)error;

/*!
 @brief 4.15.30周年图集 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestAnniversary30WithPostId:(NSString *)postId
                              success:(LLRequestSuccessBlock)success
                              failure:(LLRequestFailedBlock)failure
                                error:(LLRequestErrorBlock)error;
    
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
                                 error:(LLRequestErrorBlock)error;
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
                             error:(LLRequestErrorBlock)error;

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
                                   error:(LLRequestErrorBlock)error;
@end
