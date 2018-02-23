//
//  MSBInfoItem.h
//  meishubao
//
//  Created by T on 16/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
/*static NSString *const KEY_TITLE = @"title";
 static NSString *const KEY_VALUE = @"value";
 static NSString *const KEY_TAP = @"tap";
 static NSString *const KEY_SETTER = @"setter";
 static NSString *const KEY_IDENTIFIER = @"identifier";*/

@interface MSBInfoItem : NSObject
@property (nonatomic, copy) NSString *KEY_TITLE;
@property(nonatomic,strong) id KEY_VALUE;;
@property (nonatomic, copy) NSString *KEY_TAP;
@property (nonatomic, copy) NSString *KEY_IDENTIFIER;

@end
