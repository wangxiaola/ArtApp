#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (KKAdditional)

/**
 * Determines if the string contains only whitespace.
 */ 
- (BOOL)isWhitespace;

/**
 * Determines if the string is empty or contains only whitespace.
 */ 
- (BOOL)isEmptyOrWhitespace;


/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)isEmpty;

/*
 * Checks to see if the string contains the given string, case insenstive
 */
- (BOOL)containsString:(NSString*)string;

/*
 * Checks to see if the string contains the given string while allowing you to define the compare options
 */
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;

/*
 * Returns the MD5 value of the string
 */
- (NSString*)md5;

/*
 * return the sha1 digest of the string
 */
- (NSString*)sha1;

/*
 * return the sha1 digest of the data
 */
- (NSData*)sha1_data;

- (NSString *)checkLengthWithString:(NSString *)_str;

- (CGSize)sizeWithFontCustom:(UIFont *)font
           constrainedToSize:(CGSize)size
               lineBreakMode:(int)lineBreakMode;


-(CGSize)sizeWithFontCustom:(UIFont *)font
          constrainedToSize:(CGSize)size;

+ (NSString *)GUIDString;

+ (NSString *)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options replaceArray:(NSArray *)_replaceArray;

- (NSString *)stringOfDoubleString;
+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding;

//取得本地化字符串
+ (NSString*)getLocalizedString:(NSString*)key, ...;

//富文本设置（颜色 和 字体大小）
-(NSMutableAttributedString *)setAttributeWithColor:(UIColor *)color font:(UIFont *)font;
@end
