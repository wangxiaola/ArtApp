//
//  WxpayModel.m
//  Fruit
//
//  Created by HeLiulin on 15/9/28.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "WxpayInfoModel.h"

@implementation WxpayInfoModel
- (id) newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSString class]){
        if (oldValue==nil) return @"";
    }
    return oldValue;
}
@end
