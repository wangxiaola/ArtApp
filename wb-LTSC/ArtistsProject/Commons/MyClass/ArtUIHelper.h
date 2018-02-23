//
//  ArtUIHelper.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/1.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UIImageView (BackImage)
-(void)sd_setImageWithUrlStr:(NSString*)urlStr;
-(void)sd_setImageWithUrlStr:(NSString*)urlStr tempTmage:(NSString*)imgUrl;
@end

@interface NSMutableAttributedString (Graphic)
- (void)appendIconVideo;
@end

@interface NSString (YTXAdd)
/**
 过滤NSNull
 
 @return 过滤NSNull后的字符串
 */
+ (NSString *)stripNullWithString:(NSString *)string;
- (NSString *)stringWithFormat:(NSString *)Format;
@end

@interface ArtUIHelper : NSObject
+(instancetype)sharedInstance;
+(UITextField *)textFieldWithFrame:(CGRect)frame place:(NSString*)place;
+(UIImageView*)lineWithFrame:(CGRect)frame view:(UIView*)view;//横线
+ (UIButton*)buttonWithFrame:(CGRect)frame Target:(id)target action:(SEL)action normalImage:(NSString *)nImage selectedImage:(NSString *)sImage;
+ (UIButton*)buttonWithFrame:(CGRect)frame Target:(id)target action:(SEL)action btnTitle:(NSString *)btnTitle;

+(UILabel*)labelWithFrame:(CGRect)frame font:(CGFloat)font   Alignment:(NSTextAlignment)Alignment view:(UIView*)view;
//传入字符串、字体大小 返回高度
+(CGFloat)getTextViewHeightWithStr:(NSString*)textStr textView:(UITextView*)textView  width:(CGFloat)width;
//传入字符串、字体大小 返回高度
+(CGFloat)getLabelHeightWithStr:(NSString*)textStr font:(UIFont*)font height:(CGFloat)height width:(CGFloat)width;
//传入字符串、字体大小 返回宽度
+(CGFloat)getLabelWidthWithStr:(NSString*)textStr font:(UIFont*)font;
//传入一个label返回一个这个label宽度并带下划线
+(CGFloat)getLineWidthWithLabel:(UILabel*)label color:(UIColor*)color;
+(BOOL)ischaracterString:(id)responseObject;
+(NSString*)returnWidth:(NSString*)widthStr Height:(NSString*)heightStr Long:(NSString*)longStr;
+(NSString*)returnTimeStrWithMin:(NSString*)minStr Max:(NSString*)maxStr;
-(BOOL)alertSuccessWith:(NSString *)content obj:(id)obj;//提示请求成功
+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;


+(NSString*)GetCurrentTimeString;
+ (NSString*)GetPathByFileName:(NSString *)_fileName ofType:(NSString *)_type;
+(NSString *)getVoiceFileInfoByPath:(NSString *)aFilePath convertTime:(NSTimeInterval)aConTime;

+(NSArray*)stringToJSON:(NSString*)jsonStr;
@end
