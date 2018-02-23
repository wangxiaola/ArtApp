//
//  LLRequestBaseServer+User.m
//  meishubao
//
//  Created by T on 16/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "LLRequestBaseServer+User.h"
#import "GeneralConfigure.h"
#import "NSString+ToString.h"
#import "ApiMap.h"
#import "NSString+Device.h"

@implementation LLRequestBaseServer (User)

/*!
 @brief 1.1.用户中心页面接口 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestUserInfoSuccess:(LLRequestSuccessBlock)success
                      failure:(LLRequestFailedBlock)failure
                        error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"token":[self getToken]
                                 };
    [self getWithUrl:[ApiMap url:@"USER_CENTER"]  parameters:parameters success:success failure:failure error:error];

}

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
                         error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"account":[NSString notNilString:account],
                                 @"password":[NSString notNilString:password]
                                 };
     [self getWithUrl:[ApiMap url:@"USER_LOGIN"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.3.用户退出登录 get
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestLoginOutSuccess:(LLRequestSuccessBlock)success
                      failure:(LLRequestFailedBlock)failure
                        error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"token":[self getToken],
                                 @"reg_id":[NSString notNilString:[[NSUserDefaults standardUserDefaults] objectForKey:JPUSH_REGISTRATIONID]]
                                 };
    [self getWithUrl:[ApiMap url:@"USER_LOGINOUT"]  parameters:parameters success:success failure:failure error:error];
}

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
                            error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"mobile":[NSString notNilString:account],
                                 @"password":[NSString notNilString:password],
                                 @"code":[NSString notNilString:code],
                                 @"token" :[NSString notNilString:codeToken]
                                 };
    [self getWithUrl:[ApiMap url:@"USER_REGISTER"]  parameters:parameters success:success failure:failure error:error];
}

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
                            error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"type":[NSString notNilString:type],
                                 @"mobile":[NSString notNilString:mobile],
                                 };
    [self getWithUrl:[ApiMap url:@"USER_CAPTCHA"]  parameters:parameters success:success failure:failure error:error];
}
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
                                          error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"verify_code_token":[NSString notNilString:codeToken],
                                 @"password":[NSString notNilString:password],
                                 @"code":[NSString notNilString:code],
                                 @"token":[self getToken]
                                 };
    [self postWithUrl:[ApiMap url:@"USER_RESETPASSWORD"] parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.7.更改个人信息 post
 @param field  name
 @param fieldValue  密码
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
-(void)requestUserModifyInfoField:(NSString *)field
                       fieldValue:(NSString *)fieldValue
                          success:(LLRequestSuccessBlock)success
                          failure:(LLRequestFailedBlock)failure
                            error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"field_value":[NSString notNilString:fieldValue],
                                 @"field":[NSString notNilString:field],
                                 @"token":[self getToken]
                                 };
    [self postWithUrl:[ApiMap url:@"USER_MODIFY_INFO"] parameters:parameters success:success failure:failure error:error];
}

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
                                    error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"token":[NSString notNilString:token],
                                 @"uid":[NSString notNilString:uid],
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize)
                                 };
    [self getWithUrl:[ApiMap url:@"USER_COMMENT_LIST"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 1.9. 我的收藏列表
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
                                       error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"token":[self getToken],
                                 @"uid":[NSString notNilString:uid],
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize),
                                 @"type":[NSString notNilString:collectType]
                                 };
    [self getWithUrl:[ApiMap url:@"USER_COLLECT_LIST"]  parameters:parameters success:success failure:failure error:error];
}

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
                                error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"filename":[NSString notNilString:filename],
                                 @"token":[self getToken]
                                 };
    [self getWithUrl:[ApiMap url:@"USER_UPLOAD_TOKEN"]  parameters:parameters success:success failure:failure error:error];
}

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
                                 error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"thirdparty_uid":[NSString notNilString:uid],
                                 @"type":@(type),
                                 @"avatar":[NSString notNilString:avatar],
                                 @"nickname":[NSString notNilString:nickname],
                                 };
    [self postWithUrl:[ApiMap url:@"OAUTH_LOGIN"]  parameters:parameters success:success failure:failure error:error];
}

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
                                     error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"token":[self getToken],
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize),
                                 @"tab":@(type)
                                 };
    [self getWithUrl:[ApiMap url:@"USER_ATTENTION_LIST"]  parameters:parameters success:success failure:failure error:error];

}


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
                                 error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"token":[self getToken],
                                 @"uid":[NSString notNilString:uid],
                                 @"org_id":[NSString notNilString:org_id],
                                 @"type":@(type),
                                 @"attention_status":@(attention_status)
                                 };
    [self postWithUrl:[ApiMap url:@"PAY_ATTENTION"]  parameters:parameters success:success failure:failure error:error];
}

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
                              error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"token":[self getToken],
                                 @"uid":[NSString notNilString:uid]
                                 };
    [self getWithUrl:[ApiMap url:@"GET_OTHER_USER_INFO"]  parameters:parameters success:success failure:failure error:error];

}

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
                               error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"type":@(type),
                                 @"token":[self getToken],
                                 @"post_id":[NSString notNilString:post_id],
                                 @"video_id":[NSString notNilString:video_id],
                                 @"pic_url":[NSString notNilString:pic_url]
                                 };
    [self postWithUrl:[ApiMap url:@"DELETE_COLLECT"]  parameters:parameters success:success failure:failure error:error];
}

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
                                          error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"verify_code_token":[NSString notNilString:verify_code_token],
                                 @"mobile":[NSString notNilString:mobile],
                                 @"password":[NSString notNilString:password],
                                 @"code":[NSString notNilString:code]
                                 };
    [self postWithUrl:[ApiMap url:@"RETRIEVEPASS"]  parameters:parameters success:success failure:failure error:error];
}

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
                                         error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"type":[NSString notNilString:collectType],
                                 @"offset":[NSString isNull:offset] ? @"0" : offset,
                                 @"pagesize":@(pagesize),
                                 @"token":[self getToken]
                                 };
    [self getWithUrl:[ApiMap url:@"MY_COLLECT_LIST"]  parameters:parameters success:success failure:failure error:error];

}

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
                         error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"post_type" : @(post_type),
                                 @"pagesize"  : @(pagesize),
                                 @"term_id"   : [NSString notNilString:term_id]
                                 };
    [self postWithUrl:[ApiMap url:@"GET_POST_ID_LIST"]  parameters:parameters success:success failure:failure error:error];
}

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
                          error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"reg_id":[NSString notNilString:regId],
                                 @"token":[self getToken],
                                 @"device_type":[NSString getCurrentDeviceName]
                                 };
    [self getWithUrl:[ApiMap url:@"GET_POST_ID_LIST"] parameters:parameters success:success failure:failure error:error];
}

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
                                error:(LLRequestErrorBlock)error{
    NSDictionary *parameters = @{
                                 @"desc":[NSString notNilString:desc],
                                 @"contact_info":[NSString notNilString:contact_info],
                                 @"name":[NSString notNilString:name],
                                 @"token":[self getToken]
                                 };
    [self postWithUrl:[ApiMap url:@"SUBMIT_FEEDBACK"]  parameters:parameters success:success failure:failure error:error];
}

/*!
 @brief 6.3. 常见问题
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestCommonQuestionSuccess:(LLRequestSuccessBlock)success
                             failure:(LLRequestFailedBlock)failure
                               error:(LLRequestErrorBlock)error {
    
    [self getWithUrl:[ApiMap url:@"FAQ"]  parameters:@{} success:success failure:failure error:error];
}

/*!
 @brief 6.4. 开场首页广告
 @param success 结果状态 = 0, 回调
 @param failure 结果状态 != 0, 回调
 @param error 接口请求异常
 */
- (void)requestOpenShowAdSuccess:(LLRequestSuccessBlock)success
                         failure:(LLRequestFailedBlock)failure
                           error:(LLRequestErrorBlock)error {
    
   [self getWithUrl:[ApiMap url:@"OPEN_SHOW_AD"]  parameters:@{} success:success failure:failure error:error];
}

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
                       error:(LLRequestErrorBlock)error {

    [self postWithUrl:[ApiMap url:@"REPORT_COMMENT"] parameters:@{@"comment_id" : @(comment_id)} success:success failure:failure error:error];
}

@end
