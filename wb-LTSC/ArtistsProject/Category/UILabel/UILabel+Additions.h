//
//  UILabel+Additions.h
//  dzmmac
//
//  Created by dzmmac on 13-12-4.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (ZYJLabel)
- (NSRange)rangeWithText:(NSString *)text;

- (void)setAttributedText:(NSString*)str withColor:(UIColor *)color fontSize:(NSInteger)fontSize;


-(void)setDeleteLine:(NSString *)lineString;

@end
