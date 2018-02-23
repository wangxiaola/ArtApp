
#import "NSString+Additions.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (KKAdditional)

- (BOOL)isWhitespace {
  NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  for (NSInteger i = 0; i < self.length; ++i) {
    unichar c = [self characterAtIndex:i];
    if (![whitespace characterIsMember:c]) {
      return NO;
    }
  }
  return YES;
}


/**
 * Determines if the string is empty or contains only whitespace.
 */
- (BOOL)isEmpty
{
    
    if ([self isEqualToString:@""]) {
        return YES;
    }else if ([self isEqualToString:@" "])
    {
        return YES;
    }else
    {
        return NO;
    }
}



- (BOOL)isEmptyOrWhitespace {
  return !self.length || 
         ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length;
}


- (BOOL)containsString:(NSString*)string {
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options {
    if (string == nil) {
        return YES;
    }
    
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

/*
 * We did not write the method below
 * It's all over Google and we're unable to find the original author
 * Please contact info@enormego.com with the original author and we'll
 * Update this comment to reflect credit
 */
- (NSString*)md5
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}



- (NSString*)sha1 {
	const char* string = [self UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];   // 20
	CC_SHA1(string, (CC_LONG)strlen(string), result);
	NSString* hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
					  result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], 
					  result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
					  result[16], result[17], result[18], result[19]];
	
	return [hash lowercaseString];
}

- (NSData*)sha1_data {
	const char* string = [self UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];   // 20
	CC_SHA1(string, (CC_LONG)strlen(string), result);
	NSData *data = [NSData dataWithBytes:result length:20];
	return data;
}

- (NSString *)checkLengthWithString:(NSString *)_str{
    if (self.length>0) {
        return _str;
    }else{
        return @"";
    }
}
/**
 *  用于计算显示多行文字(兼容7及以下)
 *
 *  @param font          字体
 *  @param size          size
 *  @param lineBreakMode linbreakmode
 *
 *  @return CGSize 返回
 */
-(CGSize)sizeWithFontCustom:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(int)lineBreakMode
{
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    CGSize tempSize;
  
    CGRect frame = [self boundingRectWithSize:size
                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributesDictionary context:nil];
        tempSize = frame.size;
    return CGSizeMake(round(tempSize.width+0.5), round(tempSize.height+0.5));
}


-(CGSize)sizeWithFontCustom:(UIFont *)font constrainedToSize:(CGSize)size
{
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect frame = [self boundingRectWithSize:size
                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                   attributes:attributesDictionary context:nil];
    return CGSizeMake(round(frame.size.width+0.5), round(frame.size.height+0.5));
}

+ (NSString *)GUIDString
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return (__bridge NSString *)string;
}

/**
 *  字符串筛选,去掉不需要的特殊字符串
 *  //maxfong友情辅助
 *  使用方法:replaceOccurrencesOfString:@"1(2*3" withString:@"" options:2 replaceArray:[NSArray arrayWithObjects:@"(",@"*", nil]
    输出:123
 *
 *  @param target        原字符串
 *  @param replacement   需要替换的字符串
 *  @param options       默认传2:NSLiteralSearch,区分大小写
 *  @param _replaceArray 需要排除的Array
 *
 *  @return 筛选后的字符串
 */
+ (NSString *)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options replaceArray:(NSArray *)_replaceArray
{
    NSMutableString *tempStr = [NSMutableString stringWithString:target];
    NSArray *replaceArray = [NSArray arrayWithArray:_replaceArray];
    for(int i = 0; i < [replaceArray count]; i++){
        NSRange range = [target rangeOfString:[replaceArray objectAtIndex:i]];
        if(range.location != NSNotFound){
            [tempStr replaceOccurrencesOfString:[replaceArray objectAtIndex:i]
                                     withString:replacement
                                        options:options
                                          range:NSMakeRange(0, [tempStr length])];
        }
    }
    return tempStr;
}

- (NSString *)stringOfDoubleString
{
    NSArray *array = [self componentsSeparatedByString:@"."];
    if ([array count] >= 2)
    {
        if ([self hasPrefix:@"0"])
        {
            NSRange range = NSMakeRange(0, 1);
            return [[self stringByReplacingCharactersInRange:range withString:@""] stringOfDoubleString];
        }
        
        if ([array.firstObject isEqualToString:@""])
        {
           
        }
        
        if ([self hasSuffix:@"0"])
        {
            NSRange range = NSMakeRange(self.length - 1, 1);
            return [[self stringByReplacingCharactersInRange:range withString:@""] stringOfDoubleString];
        }
        else if ([self hasSuffix:@"."])
        {
            return [self stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
    }
    return self;
}

//NSURL解析地址里面各参数值
+ (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd])
    {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

//取得本地化字符串
+ (NSString*)getLocalizedString:(NSString*)key, ...{
    NSString *format = NSLocalizedString(key, nil);
    va_list args;
    va_start(args,key);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return str;
}

//富文本设置（颜色 和 字体大小）
-(NSMutableAttributedString *)setAttributeWithColor:(UIColor *)color font:(UIFont *)font
{
    if (self.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
     NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:self];
    [attribute addAttribute:NSForegroundColorAttributeName value:color range: NSMakeRange(0, self.length)];
    [attribute addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    
    return attribute;
}
@end
