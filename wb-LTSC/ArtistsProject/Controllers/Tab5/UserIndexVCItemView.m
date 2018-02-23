//
//  UserIndexVCItemView.m
//  ShesheDa
//
//  Created by 赵 熙春 on 16/4/7.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "UserIndexVCItemView.h"

@implementation UserIndexVCItemView{
    
    //图标
    UIImageView *imgPic;
    //标题
    HLabel *lblTitle;
    //箭头
    UIImageView *imageArrow;
}

- (id)init{

    if([super init]){
        [self createView];
    }
    return self;
}

//初始化控件
- (void) createView{
    
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    
    //图标
    imgPic = [UIImageView new];
    [self addSubview:imgPic];
    [imgPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    //标题
    lblTitle = [HLabel new];
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgPic.mas_right).offset(12);
        make.centerY.equalTo(self);
    }];
    lblTitle.font = [[Global sharedInstance]fontWithSize:15];
    lblTitle.textColor = [UIColor colorWithHexString:@"333333"];
    
    //箭头
    imageArrow = [UIImageView new];
    [self addSubview:imageArrow];
    [imageArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    //设置点击事件
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapSelf = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf_Click)];
    [self addGestureRecognizer:tapSelf];
    
}

#pragma mark -点击事件
- (void) tapSelf_Click{
    
    if (self.didTapBlock) {
        self.didTapBlock();
    }
}

//设置setter方法
- (void)setImgIcon:(NSString *)imgIcon{
    
    _imgIcon = imgIcon;
    imgPic.image = [UIImage imageNamed:imgIcon];
}

- (void)setTitle:(NSString *)title{
    
    _title = title;
    lblTitle.text = title;
}

- (void)setImgArrow:(NSString *)imgArrow{
    
    _imgArrow = imgArrow;
    imageArrow.image = [UIImage imageNamed:imgArrow];
}


- (void)setBottomLineWidth:(CGFloat)bottomLineWidth{
    _bottomLineWidth = bottomLineWidth;
    HLine *line = [[HLine alloc]init];
    line.lineColor = kLineColor;
    line.lineStyle = UILineStyleHorizon;
    line.lineWidth = 1;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self).offset(bottomLineWidth);
    }];
}



@end
