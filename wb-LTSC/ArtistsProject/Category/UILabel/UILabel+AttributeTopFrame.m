//
//  UILabel+AttributeTopFrame.m
//  YunLianMeiGou
//
//  Created by 牛中磊 on 2017/6/8.
//  Copyright © 2017年 namei. All rights reserved.
//

#import "UILabel+AttributeTopFrame.h"

@implementation UILabel (AttributeTopFrame)


-(void)getInfoText:(NSString *)ktext withFont:(UIFont *)kfont withtosize:(CGRect)krect withBackGroundColor:(UIColor *)kbackgroundColor
{
    self.numberOfLines =0;
    UIFont * tfont =kfont;
    self.font = tfont;
    self.lineBreakMode =NSLineBreakByTruncatingTail ;
    self.text =ktext;
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    CGSize size =CGSizeMake(krect.size.width,10000);
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    //ios7方法，获取文本需要的size，限制宽度
    CGSize  actualsize =[ktext boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
    self.frame=CGRectMake(krect.origin.x,krect.origin.y,actualsize.width, actualsize.height);
    self.backgroundColor=kbackgroundColor;
}







@end
