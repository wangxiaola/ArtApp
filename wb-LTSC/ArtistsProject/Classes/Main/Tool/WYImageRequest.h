//
//  WYImageRequest.h
//  adquan
//
//  Created by sks on 16/7/13.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^complection)(id data);
typedef void(^failer)(NSError *error);
static NSString *const MSBCanCelWYImageRequest = @"MSBCanCelWYImageRequest";
//(void (^)(NSError *error))failer      (void (^)(id data))complection
@interface WYImageRequest : NSObject
+ (void)requestWithURL:(NSString *)url
               isCache:(BOOL)isCache
           complection:complection
                failer:failer;
@end



@interface WYRequest : NSObject

- (void)requestWithURL:(NSString *)url
               isCache:(BOOL)isCache
           complection:complection
                failer:failer;

@end
