//
//  LLRequestBaseServer.h
//  evtmaster
//
//  Created by T on 16/6/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RequestPhotoTokenType) {
    RequestPhotoTokenTypeInfo,
    RequestPhotoTokenTypeActive
};

@interface LLRequestUpload : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *image;

+ (instancetype)initWithName:(NSString *)name
                       image:(UIImage *)image;

@end

@interface LLResponse : NSObject

@property (strong, nonatomic) id data;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *trace;
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) id response;

@end

/*! 请求状态码为0，成功 */
typedef void(^LLRequestSuccessBlock)(LLResponse *response, id data);
/*! 请求状态码非0，失败 */
typedef void(^LLRequestFailedBlock)(LLResponse *response);
/*! 请求异常 */
typedef void(^LLRequestErrorBlock)(NSError *error);

@interface LLRequestBaseServer : NSObject

- (void)getWithUrl:(NSString *)url
        parameters:(NSDictionary *)parameters
           success:(LLRequestSuccessBlock)success
           failure:(LLRequestFailedBlock)failure
             error:(LLRequestErrorBlock)error;

- (void)postWithUrl:(NSString *)url
         parameters:(NSDictionary *)parameters
            success:(LLRequestSuccessBlock)success
            failure:(LLRequestFailedBlock)failure
              error:(LLRequestErrorBlock)error;

/*! 附件仅限图片 */
- (void)postUploadWithUrl:(NSString *)url
           associatedName:(NSString *)associatedName
               parameters:(NSDictionary *)parameters
              uploadDatas:(NSArray<LLRequestUpload *> *)uploadDatas
                  success:(LLRequestSuccessBlock)success
                  failure:(LLRequestFailedBlock)failure
                    error:(LLRequestErrorBlock)errorr;

- (NSString *)getToken;
+ (instancetype)shareInstance;
@end