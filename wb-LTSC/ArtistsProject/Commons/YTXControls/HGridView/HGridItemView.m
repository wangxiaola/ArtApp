//
//  HGridItem.m
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/4.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HGridItemView.h"

@interface HGridItemView (){
    HLabel *titleLabel;
    UIImageView *imgvBG;
}

@end

@implementation HGridItemView

- (id)init
{
    self = [super init];
    if (self) {
        
        titleLabel=[HLabel new];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(3, 3, 3, 3));
        }];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines=2;
        titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
        titleLabel.textColor=ColorHex(@"666666");
        
        imgvBG=[UIImageView new];
        [self addSubview:imgvBG];
        [imgvBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}
- (void) setItem:(HKeyValuePair *)item
{
    _item=item;
    titleLabel.text=item.displayText;
}
- (void) setSelected:(BOOL)selected
{
    _selected=selected;
    if (selected){
        UIImage *imgBG=[UIImage imageNamed:@"icon_GridItem_selected"];
        UIEdgeInsets edge=UIEdgeInsetsMake(0, 1, 0, 38);
        imgBG= [imgBG resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        [imgvBG setImage:imgBG];
        titleLabel.textColor=ColorHex(@"c88400");
    }else{
        titleLabel.textColor=ColorHex(@"666666");
        [imgvBG setImage:nil];
    }
}
- (void) setTitleColor:(UIColor *)titleColor
{
    _titleColor=titleColor;
    titleLabel.textColor=titleColor;
}
- (void) setItemTitleAlignment:(NSTextAlignment)itemTitleAlignment
{
    _itemTitleAlignment=itemTitleAlignment;
    titleLabel.textAlignment=itemTitleAlignment;
    if (itemTitleAlignment==NSTextAlignmentLeft){
        titleLabel.textEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    }else if (itemTitleAlignment==NSTextAlignmentRight){
        titleLabel.textEdgeInsets=UIEdgeInsetsMake(0, 0, 0, 10);
    }else{
        titleLabel.textEdgeInsets=UIEdgeInsetsZero;
    }
}
@end