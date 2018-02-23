//
//  NoResponse.m
//  JobElectronic
//
//  Created by gengyuanyuan on 15/8/7.
//  Copyright © 2015年 PanghuKeji. All rights reserved.
//

#import "PHNoResponse.h"
#import "MyButton.h"
//获取屏幕 宽度、高度
#define SELF_WIDTH (self.frame.size.width)
#define SELF_HEIGHT (self.frame.size.height)

@implementation PHNoResponse

+ (instancetype)showHUDAddedTo:(UIView *)view :(void(^)(id responseObject))block
{
    PHNoResponse *hud = [[PHNoResponse alloc]initWithFrame:view.frame :^(id responseObject) {
        if (block) {
            block(responseObject);
        }
    }];
    //[view addSubview:hud];
    return  (hud);
}

- (id)initWithFrame:(CGRect)frame :(void(^)(id responseObject))block{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2- T_WIDTH(50), T_WIDTH(120), T_WIDTH(100), T_WIDTH(70))];
        imgView.image = [UIImage imageNamed:@"NotRequesticon"];
        [self addSubview:imgView];
        
        UILabel* alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(SELF_WIDTH/2-T_WIDTH(130),getViewHeight(imgView)+ T_WIDTH(10),  T_WIDTH(260),  T_WIDTH(20))];
        alertLabel.text = @"暂无网络";
        alertLabel.font = ART_FONT(ARTFONT_OTH);
        alertLabel.textAlignment = NSTextAlignmentCenter;
        UIColor* labelColor = PH_COLOR_BUTTON_BORDER;
        alertLabel.textColor = labelColor;
        [self addSubview:alertLabel];
        self.backgroundColor = [UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
        
//        MyButton* loadBtn = [[MyButton alloc]initWithFrame:CGRectMake(SELF_WIDTH/2- T_WIDTH(50),getViewHeight(alertLabel)+T_WIDTH(50), T_WIDTH(100), T_WIDTH(40)) tag:0 title:@"重新加载" img:nil font:13 :^(id responseObject)
//        {
//            if (block)
//            {
//                block(responseObject);
//            }
//            [self removeFromSuperview];
//        }];
        UIButton* loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loadBtn.frame = CGRectMake(SELF_WIDTH/2- T_WIDTH(50),getViewHeight(alertLabel)+T_WIDTH(50), T_WIDTH(100), T_WIDTH(40));
        UIColor* color =PH_COLOR_TEXT_COMMON;
        [loadBtn setTitleColor:color forState:UIControlStateNormal];
        [loadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        loadBtn.layer.cornerRadius = 5;
        loadBtn.layer.backgroundColor=(__bridge CGColorRef _Nullable)(RGB(196,196,196));
        loadBtn.layer.borderColor=[PH_COLOR_TEXT_COMMON CGColor];
        loadBtn.layer.borderWidth = 1;
        [loadBtn addTarget:self action:@selector(loadBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loadBtn];
        
        if (block) {
            self.btnClick = block;
        }
    }
    return self;
}
-(void)loadBtnClick{
    
    if (self.btnClick){
        self.btnClick();
    }
    [self dismissing];
}
-(void)dismissing
{
    for (UIView* smallView in KEY_WINDOW.subviews)
    {
        if ([smallView isKindOfClass:[self class]])
        {
            [smallView removeFromSuperview];
        }
    }
}
@end
