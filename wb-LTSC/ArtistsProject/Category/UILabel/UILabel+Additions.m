//
//  UILabel+Additions.m
//  dzmmac
//
//  Created by dzmmac on 13-12-4.
//
//

#import "UILabel+Additions.h"
#import <CoreText/CoreText.h>

@implementation UILabel (ZYJLabel)
- (NSRange)rangeWithText:(NSString *)text
{

    if ([self.text length] <= 0 ||
        [text length] <= 0)
    {
        return NSMakeRange(0, 0);
    }
    else
    {
        NSRange range = [self.text rangeOfString:text];
        return range;
    }
}


- (void)setAttributedText:(NSString*)str withColor:(UIColor *)color fontSize:(NSInteger)fontSize
{
    if (self.text.length>0||self.attributedText.length>0) {
        if (self.text.length>0) {
            self.attributedText= [[NSMutableAttributedString alloc] initWithString:self.text] ;
        }
        NSMutableAttributedString *attStr =  [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText] ;
        if (color && str) {
            [attStr addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:str]];
        }
        if (fontSize>0 && str){
            [attStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.font.fontName size:fontSize] range:[self.text rangeOfString:str]];
        }
        self.attributedText = attStr;
        [self setNeedsDisplay];
    }
}

-(void)setDeleteLine:(NSString *)lineString{
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:lineString];
    
    NSRange range = [lineString rangeOfString:self.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
    [attri addAttribute:NSStrikethroughColorAttributeName value:self.textColor range:range];
    [self setAttributedText:attri];
}

@end
