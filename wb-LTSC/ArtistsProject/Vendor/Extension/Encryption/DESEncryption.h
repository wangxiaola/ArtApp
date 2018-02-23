//
//  DESEncryption.h
//  LiJunEvaluate
//
//  Created by XICHUNZHAO on 15/10/3.
//  Copyright © 2015年 上海翔汇⺴络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESEncryption : NSObject
+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
+(NSString*) encryptUseDES:(NSString*)clearText key:(NSString *)key;
@end
