//
//  LLRequestBaseServer+User.h
//  meishubao
//
//  Created by T on 16/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer.h"

@interface LLRequestBaseServer (User)

/*!
 @brief 1.1.用户中心页面接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestUserInfoSuccess:(LLRequestSuccessBlock)success
                                 failure:(LLRequestFailedBlock)failure
                                   error:(LLRequestErrorBlock)error;

/*!
 @brief 1.2.用户登陆接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestLoginWithAccount:(NSString *)account
                         password:(NSString *)password
                        success:(LLRequestSuccessBlock)success
                      failure:(LLRequestFailedBlock)failure
                        error:(LLRequestErrorBlock)error;

/*!
 @brief 1.3.用户退出登录 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestLoginOutSuccess:(LLRequestSuccessBlock)success
                      failure:(LLRequestFailedBlock)failure
                        error:(LLRequestErrorBlock)error;

/*!
 @brief 1.4.用户注册接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestRegisterWithAccount:(NSString *)account
                    code:(NSString *)code
                    codeToken:(NSString *)codeToken
                    password:(NSString *)password
                    success:(LLRequestSuccessBlock)success
                      failure:(LLRequestFailedBlock)failure
                        error:(LLRequestErrorBlock)error;
/*!
 @brief 1.5.获取验证码接口 get
 @param type  signup 注册(需要mobile) resetpassword 重置密码(需要token) retrievepassword 找回密码(需要mobile)
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestUserCaptchaWithType:(NSString *)type
                      mobile:(NSString *)mobile
                       success:(LLRequestSuccessBlock)success
                       failure:(LLRequestFailedBlock)failure
                         error:(LLRequestErrorBlock)error;
/*!
 @brief 1.6.修改密码 post
 @param codeToken  调用获取登陆和注册的接口返回的token
  @param password  密码
  @param code  验证码
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestUserRepasswordWithVerifyCodeToken:(NSString *)codeToken
                           password:(NSString *)password
                           code:(NSString *)code
                          success:(LLRequestSuccessBlock)success
                          failure:(LLRequestFailedBlock)failure
                            error:(LLRequestErrorBlock)error;

/*!
 @brief 1.7.更改个人信息 post
 @param field  nickname昵称 birthday生日 sex性别 device设备名称 niming是否匿名
 @param fieldValue  密码
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestUserModifyInfoField:(NSString *)field
                                       fieldValue:(NSString *)fieldValue
                                        success:(LLRequestSuccessBlock)success
                                        failure:(LLRequestFailedBlock)failure
                                          error:(LLRequestErrorBlock)error;

/*!
 @brief 1.8.用户跟帖列表 get
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestUserFollowPosterWithOffset:(NSString *)offset
                          pagesize:(NSInteger)pagesize
                            token:(NSString *)token
                            uid:(NSString *)uid
                           success:(LLRequestSuccessBlock)success
                           failure:(LLRequestFailedBlock)failure
                             error:(LLRequestErrorBlock)error;
/*!
 @brief 1.9. 他人收藏列表
 @param collectType 文章1 视频2 图片3
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestUserStoreItemsWithCollectType:(NSString *)collectType
                                         uid:(NSString *)uid
                                offset:(NSString *)offset
                                 pagesize:(NSInteger)pagesize
                                  success:(LLRequestSuccessBlock)success
                                  failure:(LLRequestFailedBlock)failure
                                    error:(LLRequestErrorBlock)error;


/*!
 @brief 1.10. 获得上传token信息
 @param filename 图片名称
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestPhotoTokenWithFilename:(NSString *)filename
                                     success:(LLRequestSuccessBlock)success
                                     failure:(LLRequestFailedBlock)failure
                                       error:(LLRequestErrorBlock)error;

/*!
 @brief 1.11. 用户第三方登陆接口
 @param uid 图片名称
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestThirdOauthLoginWithtUid:(NSString *)uid
                                  type:(NSInteger)type
                                avatar:(NSString *)avatar
                              nickname:(NSString *)nickname
                              success:(LLRequestSuccessBlock)success
                              failure:(LLRequestFailedBlock)failure
                                error:(LLRequestErrorBlock)error;

/*!
 @brief 1.12. 关注列表接口
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestUserAttentionListWithOffset:(NSString *)offset
                          pagesize:(NSInteger)pagesize
                          type:(NSInteger)type
                           success:(LLRequestSuccessBlock)success
                           failure:(LLRequestFailedBlock)failure
                             error:(LLRequestErrorBlock)error;


/*!
 @brief 1.13. 关注他人接口
 @param uid 	被点人uid
 @param attention_status 关注状态
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestUserPayAttentionWithUid:(NSString *)uid
                                org_id:(NSString *)org_id
                                  type:(NSInteger)type
                                  attention_status:(NSInteger)attention_status
                                   success:(LLRequestSuccessBlock)success
                                   failure:(LLRequestFailedBlock)failure
                                     error:(LLRequestErrorBlock)error;

/*!
 @brief 1.14. 其他用户详情接口
 @param uid 	人uid
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestOtherUserInfoWithUid:(NSString *)uid
                               success:(LLRequestSuccessBlock)success
                               failure:(LLRequestFailedBlock)failure
                                 error:(LLRequestErrorBlock)error;

/*!
 @brief 1.15. 删除自己收藏
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestDeletedCollectionWithType:(NSInteger)type
                             post_id:(NSString *)post_id
                            video_id:(NSString *)video_id
                             pic_url:(NSString *)pic_url
                            success:(LLRequestSuccessBlock)success
                            failure:(LLRequestFailedBlock)failure
                              error:(LLRequestErrorBlock)error;

/*!
 @brief 1.16.忘记密码 post
 @param verify_code_token  调用获取登陆和注册的接口返回的token
 @param mobile  手机号
 @param password  密码
  @param code  验证码
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestUserRetrievepassWithVerifyCodeToken:(NSString *)verify_code_token
                                       mobile:(NSString *)mobile
                                        password:(NSString *)password
                                           code:(NSString *)code
                                        success:(LLRequestSuccessBlock)success
                                        failure:(LLRequestFailedBlock)failure
                                          error:(LLRequestErrorBlock)error;

/*!
 @brief 1.17. 我的收藏列表
 @param collectType 文章1 视频2 图片3
 @param offset 页数
 @param pagesize 分页数量，按每页多少条进行分页
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestUserMyStoreItemsWithCollectType:(NSString *)collectType
                                        offset:(NSString *)offset
                                      pagesize:(NSInteger)pagesize
                                       success:(LLRequestSuccessBlock)success
                                       failure:(LLRequestFailedBlock)failure
                                         error:(LLRequestErrorBlock)error;

/**
 4.16. 当前分类下的文章id
 
 @param post_type 1是普通文章类型
 @param term_id   分类标签
 @param pagesize 数量
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestOfflineCategory:(NSInteger)post_type
                       term_id:(NSString *)term_id
                      pagesize:(NSInteger)pagesize
                       success:(LLRequestSuccessBlock)success
                       failure:(LLRequestFailedBlock)failure
                         error:(LLRequestErrorBlock)error;

/*!
 @brief 6.1. 更新极光推送id接口
 @param regId 激光id
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestJPUSHIDWithRegId:(NSString *)regId
                              success:(LLRequestSuccessBlock)success
                              failure:(LLRequestFailedBlock)failure
                                error:(LLRequestErrorBlock)error;

/*!
 @brief 6.2. 提交反馈信息
 @param desc 问题描述
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestSubmitFeedbackWithDesc:(NSString *)desc
                         contact_info:(NSString *)contact_info
                                 name:(NSString *)name
                        success:(LLRequestSuccessBlock)success
                        failure:(LLRequestFailedBlock)failure
                          error:(LLRequestErrorBlock)error;
/*!
 @brief 6.3. 常见问题
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestCommonQuestionSuccess:(LLRequestSuccessBlock)success
                              failure:(LLRequestFailedBlock)failure
                                error:(LLRequestErrorBlock)error;
/*!
 @brief 6.4. 开场首页广告
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestOpenShowAdSuccess:(LLRequestSuccessBlock)success
                             failure:(LLRequestFailedBlock)failure
                               error:(LLRequestErrorBlock)error;

/*!
 @brief 6.6. 举报评论
 @param comment_id 评论用户id
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestReportComment:(NSInteger)comment_id
                         Success:(LLRequestSuccessBlock)success
                         failure:(LLRequestFailedBlock)failure
                           error:(LLRequestErrorBlock)error;

@end
