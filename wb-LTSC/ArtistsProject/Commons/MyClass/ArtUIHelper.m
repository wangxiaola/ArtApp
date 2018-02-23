//
//  ArtUIHelper.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/1.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtUIHelper.h"
#import "UIImageView+WebCache.h"


@implementation NSMutableAttributedString (Graphic)
-(void)appendIconVideo{
    NSTextAttachment *text = [[NSTextAttachment alloc] init];
    text.image = [UIImage imageNamed:@"icon_video"];
    text.bounds = CGRectMake(0, 0, 20, 3);
    [self appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
    [self appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204)}]];
}
@end

@implementation UIImageView (BackImage)
-(void)sd_setImageWithUrlStr:(NSString*)urlStr{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
}
-(void)sd_setImageWithUrlStr:(NSString *)urlStr tempTmage:(NSString *)imgUrl{
    [self sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:imgUrl]];
}
@end

@implementation NSString (YTXAdd)

+ (NSString *)stripNullWithString:(NSString *)string {
    if ([string isKindOfClass:[NSString class]]) {
        return string;
    } else if ([string isKindOfClass:[NSNumber class]]) {
        NSNumber *sNumber = (NSNumber *)string;
        return sNumber.stringValue;
    }
    return @"";
}

- (NSString *)stringWithFormat:(NSString *)Format {
    NSTimeInterval timeInterval = [self unsignedLongLongValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date stringWithFormat:Format timeZone:[NSTimeZone localTimeZone] locale:[NSLocale currentLocale]];
}

@end

@implementation ArtUIHelper
static ArtUIHelper *_instancer;

+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instancer = [[ArtUIHelper alloc] init];
    });
    return _instancer;
}

+(UITextField *)textFieldWithFrame:(CGRect)frame place:(NSString*)place{
    UITextField*  phoneField = [[UITextField alloc] initWithFrame:frame];
    phoneField.placeholder = place;
    phoneField.returnKeyType = UIReturnKeyDone;
    phoneField.clearButtonMode=UITextFieldViewModeAlways;
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    phoneField.backgroundColor=[UIColor whiteColor];
    return phoneField;
}
//横线
+(UIImageView *)lineWithFrame:(CGRect)frame view:(UIView *)view{
    UIImageView* line=[[UIImageView alloc]initWithFrame:frame];
    line.backgroundColor=RGB(196, 196, 196);
    [view addSubview:line];
    return line;
}
+ (UIButton*)buttonWithFrame:(CGRect)frame Target:(id)target action:(SEL)action normalImage:(NSString *)nImage selectedImage:(NSString *)sImage{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:nImage]  forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:sImage]  forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIButton*)buttonWithFrame:(CGRect)frame Target:(id)target action:(SEL)action btnTitle:(NSString *)btnTitle{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:RGB(27,27, 27) forState:UIControlStateNormal];
    button.frame = frame;
    //button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button setTitle:btnTitle forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UILabel*)labelWithFrame:(CGRect)frame font:(CGFloat)font   Alignment:(NSTextAlignment)Alignment view:(UIView*)view{
    UILabel* label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = Alignment;
    label.font = ART_FONT(font);
    [view addSubview:label];
    return label;
}
//传入字符串、字体大小 返回高度
+(CGFloat)getTextViewHeightWithStr:(NSString*)textStr textView:(UITextView*)textView  width:(CGFloat)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:textStr];
    textView.attributedText = attrStr;
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [textStr boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}


//传入字符串、字体大小 返回高度
+(CGFloat)getLabelHeightWithStr:(NSString*)textStr font:(UIFont*)font height:(CGFloat)height width:(CGFloat)width{
    CGRect frame = [textStr boundingRectWithSize:CGSizeMake(width,height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil];
    CGFloat resultHeight = frame.size.height;
    return resultHeight;
}
//传入字符串、字体大小 返回宽度
+(CGFloat)getLabelWidthWithStr:(NSString*)textStr font:(UIFont*)font{
    CGSize size = [textStr sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    CGFloat w = size.width;
    return w;
}
//传入一个label返回一个这个label宽度并带下划线
+(CGFloat)getLineWidthWithLabel:(UILabel*)label color:(UIColor*)color{
    
    CGSize size = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil]];
    NSUInteger length = [label.text length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleThick)range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:0] range:NSMakeRange(0, 0)];
    [label setAttributedText:attri];
    CGFloat w = size.width;
    return w;
}
+(BOOL)ischaracterString:(id)responseObject{
    if ([responseObject isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}
+(NSString*)returnTimeStrWithMin:(NSString*)minStr Max:(NSString*)maxStr{
    NSMutableString* timeStr = [[NSMutableString alloc]init];
    if (minStr.length>4) {
        [timeStr appendString:[minStr substringToIndex:4]];
    }
    if (maxStr.length>4){
        if (minStr.length>4) {
         [timeStr appendFormat:@"-%@",[maxStr substringToIndex:4]];
        }else{
        [timeStr appendString:[maxStr substringToIndex:4]];
        }
    }
    return timeStr;
}
+(NSString*)returnWidth:(NSString*)widthStr Height:(NSString*)heightStr Long:(NSString*)longStr{
    NSMutableArray* sizeArr = [[NSMutableArray alloc]init];
   
    if (heightStr.length>0&&![heightStr isEqualToString:@"(null)"]&&![heightStr isEqualToString:@"0"]){
         [sizeArr addObject:heightStr];
    }
    
    if (widthStr.length>0&&![widthStr isEqualToString:@"(null)"]&&![widthStr isEqualToString:@"0"]){
        [sizeArr addObject:widthStr];
    }
    
    if (longStr.length>0&&![longStr isEqualToString:@"(null)"]&&![longStr isEqualToString:@"0"]){
        [sizeArr addObject:longStr];
    }
    if (sizeArr.count>0) {
    return  [NSString stringWithFormat:@"%@cm",[sizeArr componentsJoinedByString:@"x"]];
    }

    return @"";
}
#pragma - mark - 提示
-(BOOL)alertSuccessWith:(NSString *)content obj:(id)obj{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSString* resStr = [NSString stringWithFormat:@"%@",obj[@"res"]];
        NSString* msgStr = [NSString stringWithFormat:@"%@",obj[@"msg"]];
        if ([resStr isEqualToString:@"1"]){
            [ArtUIHelper addHUDInView:KEY_WINDOW text:[NSString stringWithFormat:@"%@成功",content] hideAfterDelay:1.0];
            return YES;
        }else{
            [ArtUIHelper addHUDInView:KEY_WINDOW text:msgStr hideAfterDelay:1.0];
            return NO;
        }
    }
    return NO;
}
+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text hideAfterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [self addHUDInView:view text:text];
    [self hideHUD:hud afterDelay:delay animated:YES];
    return hud;
}
+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text
{
    return [self addHUDInView:view text:text fontSize:16.f alpha:1.f];
}
+ (void)hideHUD:(MBProgressHUD *)progress afterDelay:(NSTimeInterval)delay animated:(BOOL)animated
{
    [progress hideAnimated:animated afterDelay:delay];
}
+ (MBProgressHUD *)addHUDInView:(UIView *)view text:(NSString *)text fontSize:(CGFloat)fontSize alpha:(CGFloat)alpha
{
    [self hideAllHUDsForView:view animated:NO];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];//隐藏键盘如果有键盘
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:view];
    progress.removeFromSuperViewOnHide = YES;
    [progress setAlpha:alpha];
    if (text != nil) {
        progress.mode = MBProgressHUDModeText;
        progress.detailsLabel.text = text;
        progress.label.font = [UIFont boldSystemFontOfSize:fontSize];
    }
    
    [view addSubview:progress];
    [view bringSubviewToFront:progress];
    [progress showAnimated:YES];
    return progress;
}
+ (void)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}

#pragma mark - 生成当前时间字符串
+(NSString*)GetCurrentTimeString{
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}
#pragma mark - 生成文件路径
+ (NSString*)GetPathByFileName:(NSString *)_fileName ofType:(NSString *)_type{
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];;
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:_fileName]
                                stringByAppendingPathExtension:_type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}

#pragma mark - 获取音频文件信息
+(NSString *)getVoiceFileInfoByPath:(NSString *)aFilePath convertTime:(NSTimeInterval)aConTime{
    #pragma mark - 获取文件大小
    NSInteger size =0;
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:aFilePath]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:aFilePath error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            size =  [theFileSize intValue]/1024;
        else
            size  = -1/1024;
    }
    else{
        size = -1/1024;
    }
    
    
    NSString *info = [NSString stringWithFormat:@"文件名:%@\n文件大小:%ldkb\n",aFilePath.lastPathComponent,size];
    
    NSRange range = [aFilePath rangeOfString:@"wav"];
    if (range.length > 0) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:aFilePath] error:nil];
        info = [info stringByAppendingFormat:@"文件时长:%f\n",play.duration];
    }
    
    if (aConTime > 0)
        info = [info stringByAppendingFormat:@"转换时间:%f",aConTime];
    return info;
}


//json字符串转为数组
+(NSArray*)stringToJSON:(NSString*)jsonStr
{
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
            }
            else if ([tmp isKindOfClass:[NSString class]]
                     || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
            }
            else {
                return nil;
            }
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

@end
