//
//  CustomLabel.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/1.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "CustomLabel.h"

@interface CustomLabel ()
{
    CGRect _tempF;
}
@end
@implementation CustomLabel
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = frame;
        _tempF = frame;
        self.text = @" ";
    }
    return self;
}

-(void)CustomHeightTitle:(NSString *)customTitle point:(CGPoint)point{
    self.text = customTitle;
    CGSize maximumLabelSize = CGSizeMake(_tempF.size.width, _tempF.size.height);
    CGSize expectSize = [self sizeThatFits:maximumLabelSize];
    self.frame =CGRectMake(point.x, point.y, _tempF.size.width, expectSize.height);
}
-(void)CustomWidthTitle:(NSString *)customTitle point:(CGPoint)point{
    self.text = customTitle;
    CGSize maximumLabelSize = CGSizeMake(_tempF.size.width, _tempF.size.height);
    CGSize expectSize = [self sizeThatFits:maximumLabelSize];
    self.frame =CGRectMake(point.x,point.y , expectSize.width, _tempF.size.height);
}
@end
