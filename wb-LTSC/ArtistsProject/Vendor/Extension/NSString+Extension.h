//
//
//  AppDelegate.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) moneyFormat;
-(BOOL)isBlankString;
- (CGSize) sizeWithFontSize:(CGFloat)fontSize andMaxWidth:(CGFloat)maxWidth andMaxHeight:(CGFloat)maxHeight;
@end
