//
//  NODataView.m
//  JobElectronic
//
//  Created by gengyuanyuan on 15/8/7.
//  Copyright (c) 2015年 PanghuKeji. All rights reserved.
//

#import "PHNODataView.h"
#import "MyButton.h"
//获取屏幕 宽度、高度
#define SELF_WIDTH (self.frame.size.width)
#define SELF_HEIGHT (self.frame.size.height)

@implementation PHNODataView

+ (instancetype)showHUDAddedTo:(UIView *)view :(void(^)(id responseObject))block{
    PHNODataView *hud = [[PHNODataView alloc]initWithFrame:view.frame :^(id responseObject) {
        if (block)
        {
            block(responseObject);
        }
    }];
    [view addSubview:hud];
    return  (hud);
}
- (id)initWithFrame:(CGRect)frame :(void(^)(id responseObject))block{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-60, T_WIDTH(150),120, 60)];
        imgView.image = [UIImage imageNamed:@"NotDataicon"];
        [self addSubview:imgView];
        
        UILabel* alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(SELF_WIDTH/2-110, getViewHeight(imgView)+T_WIDTH(20), 220, 25)];
        alertLabel.text = @"暂无数据";
        alertLabel.font = ART_FONT(ARTFONT_OTH);
        alertLabel.textAlignment = NSTextAlignmentCenter;
        UIColor* labelColor = [UIColor colorWithRed:149/255.0f green:149/255.0f blue:149/255.0f alpha:1.0f];
        alertLabel.textColor = labelColor;
        [self addSubview:alertLabel];
        self.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f];
    }
    return self;
}


@end
