//
//  HComboBoxItem.m
//  logistics
//
//  Created by HeLiulin on 15/11/26.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import "HKeyValuePair.h"

@implementation HKeyValuePair
- (id) initWithValue:(NSString*)value andDisplayText:(NSString*)displayText
{
    self.value=value;
    self.displayText=displayText;
    return self;
}
@end
