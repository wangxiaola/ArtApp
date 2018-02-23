//
//  HComboBoxItem.h
//  logistics
//
//  Created by HeLiulin on 15/11/26.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HKeyValuePair(value,displayText) [[HKeyValuePair alloc] initWithValue:value andDisplayText:displayText]
@interface HKeyValuePair : NSObject
///值
@property(nonatomic, strong) NSString *value;
///显示文字
@property(nonatomic, strong) NSString *displayText;
- (id) initWithValue:(NSString*)value andDisplayText:(NSString*)displayText;
@end
