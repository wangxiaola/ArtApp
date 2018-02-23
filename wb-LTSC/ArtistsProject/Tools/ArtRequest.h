//
//  ArtRequest.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtRequest : NSObject

+(void)GetRequestWithActionName:(NSString*)actionName
                    andPramater:(NSDictionary*)pramaters
                      succeeded:(void (^)(id responseObject))successBlock
                         failed:(void (^)(id responseObject))failedBlock;

+(void)PostRequestWithActionName:(NSString*)actionName
                     andPramater:(NSDictionary*)pramaters
                       succeeded:(void (^)(id responseObject))successBlock
                          failed:(void (^)(id responseObject))failedBlock;
@end
