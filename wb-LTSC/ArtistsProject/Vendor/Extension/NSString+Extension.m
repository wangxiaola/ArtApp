//
//  AppDelegate.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//
#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

- (NSString*) moneyFormat
{

    NSMutableString *strNew=[[NSMutableString alloc] initWithString:self];
    NSArray *arrNumber=[self componentsSeparatedByString:@"."];
    if (arrNumber.count>1){
        strNew=[[NSMutableString alloc] initWithString:arrNumber[0]];
    }
    NSInteger count=strNew.length/3;
    if (strNew.length%3==0){
        count-=1;
    }
    for (int i=0; i<count; i++) {
        [strNew insertString:@"," atIndex:strNew.length-i-(i+1)*3];
    }
    if ([self componentsSeparatedByString:@"."].count>1){
        return [strNew stringByAppendingString:[NSString stringWithFormat:@".%@",arrNumber[1]]];
    }else{
        return strNew;
    }
}

-(BOOL)isBlankString{
    
    if (self == nil) {
        return YES;
    }
    
    if (self == NULL) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize andMaxWidth:(CGFloat)maxWidth andMaxHeight:(CGFloat)maxHeight
{
    NSDictionary *attribute=@{NSFontAttributeName:ART_FONT(fontSize)};
    CGRect titleSize=[self boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:attribute context:nil];
    return titleSize.size;
}
@end
