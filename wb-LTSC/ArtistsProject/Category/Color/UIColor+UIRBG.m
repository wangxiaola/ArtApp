//
//  UIColor+UIrgb.m
//  YunLianMeiGou
//
//  Created by namei on 16/3/15.
//  Copyright © 2016年 namei.com. All rights reserved.
//

#import "UIColor+UIRBG.h"
#import "UIColor+RGBA.h"

@implementation UIColor (UIrgb)


+ (UIColor *)rgbColorForm:(UIColor *)from to:(UIColor *)to value:(float)value
{
    RGBA fromRGBA = RGBAFromUIColor(from);
    RGBA toRGBA = RGBAFromUIColor(to);
    
    float red = fromRGBA.r + (toRGBA.r - fromRGBA.r)*value;
    float green = fromRGBA.g + (toRGBA.g - fromRGBA.g)*value;
    float blue = fromRGBA.b + (toRGBA.b - fromRGBA.b)*value;
    float alpha = fromRGBA.a + (toRGBA.a - fromRGBA.a)*value;
    
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

    
}

+ (UIColor *)rgbfrom:(NSString *)from to:(NSString *)to value:(float)value
{
    if (from.length < 7)
    {
        return nil;
    }
    NSString* redf = [from substringWithRange: NSMakeRange(1, 2)];
    NSString* greenf = [from substringWithRange: NSMakeRange(3, 2)];
    NSString* bluef = [from substringWithRange: NSMakeRange(5, 2)];
    int red_if, green_if, blue_if;
    sscanf([redf cStringUsingEncoding:NSASCIIStringEncoding], "%x", &red_if);
    sscanf([greenf cStringUsingEncoding:NSASCIIStringEncoding], "%x", &green_if);
    sscanf([bluef cStringUsingEncoding:NSASCIIStringEncoding], "%x", &blue_if);

    
    NSString* redt = [to substringWithRange: NSMakeRange(1, 2)];
    NSString* greent = [to substringWithRange: NSMakeRange(3, 2)];
    NSString* bluet = [to substringWithRange: NSMakeRange(5, 2)];
    int red_it, green_it, blue_it;
    sscanf([redt cStringUsingEncoding:NSASCIIStringEncoding], "%x", &red_it);
    sscanf([greent cStringUsingEncoding:NSASCIIStringEncoding], "%x", &green_it);
    sscanf([bluet cStringUsingEncoding:NSASCIIStringEncoding], "%x", &blue_it);
    
    
    
    return [UIColor colorWithRed:(red_if+(red_if - red_if)*value)/255.0 green:(green_if+(green_it - green_if)*value)/255.0 blue:(blue_if+(blue_it - blue_if)*value)/255.0 alpha:1];
;
}

+ (UIColor *)rgb:(NSString *)rgb alpha:(float)alpha
{
    return [self mgColorWithRGB:rgb alpha:alpha];
}

+(UIColor *)mgColorWithRGB:(NSString *)rgb alpha:(float)alpha
{
    if (rgb.length < 7)
    {
        return nil;
    }    
    NSString* red = [rgb substringWithRange: NSMakeRange(1, 2)];
    NSString* green = [rgb substringWithRange: NSMakeRange(3, 2)];
    NSString* blue = [rgb substringWithRange: NSMakeRange(5, 2)];
    int red_i, green_i, blue_i;
    sscanf([red cStringUsingEncoding:NSASCIIStringEncoding], "%x", &red_i);
    sscanf([green cStringUsingEncoding:NSASCIIStringEncoding], "%x", &green_i);
    sscanf([blue cStringUsingEncoding:NSASCIIStringEncoding], "%x", &blue_i);
    return [UIColor colorWithRed:red_i/255.0 green:green_i/255.0 blue:blue_i/255.0 alpha:alpha];
}

@end
