//
//  MSBAdView.h
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSBAdView : UIView
- (void)start:(NSData *)binaryData duration:(NSInteger)duration complete:(void (^)())complete;
@end
