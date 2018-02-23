//
//  xczbDetailCell.m
//  ShesheDa
//
//  Created by chen on 16/8/5.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "xczbDetailCell.h"

@implementation xczbDetailCell{
    HLabel *lblTitle;
    UIView *viewContent;
}

//@synthesize img
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
        
        
    }
    return self;
}
-(void)createView{
    lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=kTitleColor;
    lblTitle.font=kFont(15);
    lblTitle.numberOfLines=0;
    [self addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    
    UIScrollView * scrollView=[[UIScrollView alloc] init];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerX.equalTo(self);
        make.top.equalTo(lblTitle.mas_bottom).offset(10);
        make.height.mas_equalTo(80);
    }];
    scrollView.alwaysBounceHorizontal=YES;
    scrollView.scrollEnabled=YES;
    scrollView.showsHorizontalScrollIndicator=NO;
    
    viewContent=[[UIView alloc] init];
    [scrollView addSubview:viewContent];
    [viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.height.equalTo(scrollView);
        
    }];
}

-(void)setModel:(xczbModel *)model{
    _model=model;
    lblTitle.text=model.message;
    for (UIView *view in viewContent.subviews) {
        [view removeFromSuperview];
    }
    
    NSArray *arrayPhoto=[model.photos componentsSeparatedByString:@","];
    if (arrayPhoto.count<1) {
        return ;
    }
    
    UIImageView *imgLast=nil;
    for (NSString *strPhoto in arrayPhoto) {
        UIImageView *imgPhoto=[[UIImageView alloc]init];
        [imgPhoto sd_setImageWithURL:[NSURL URLWithString:strPhoto] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewContent addSubview:imgPhoto];
        [imgPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewContent).offset(10);
            make.width.height.mas_equalTo(60);
            if (imgLast) {
                make.left.equalTo(imgLast.mas_right).offset(10);
            }else{
                 make.left.equalTo(viewContent).offset(10);
            }
        }];
        imgLast=imgPhoto;
    }
    [viewContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgLast).offset(10);
    }];
}

@end
