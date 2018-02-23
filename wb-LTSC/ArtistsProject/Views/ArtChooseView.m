//
//  ArtChooseView.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtChooseView.h"

@interface ArtChooseView ()
{
    UIImageView* lineChoose;
    UIButton* _introBtn;
}
@end
@implementation ArtChooseView

-(id)init{
    if (self=[super init]) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.backgroundColor=kWhiteColor;
    
    //arrayTitleBtn=[[NSMutableArray alloc]init];
    UIImageView* lineBottom=[[UIImageView alloc]init];
    lineBottom.backgroundColor = [UIColor orangeColor];
    [self addSubview:lineBottom];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(2);
    }];
}
-(void)setArrayTitle:(NSArray *)arrayTitle{
    _arrayTitle=arrayTitle;
    for (int i=0; i<arrayTitle.count; i++) {
        UIButton *btnTitle=[[UIButton alloc]init];
        [btnTitle setTitle:arrayTitle[i] forState:UIControlStateNormal];
        [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnTitle.titleLabel.font=ART_FONT(ARTFONT_OE);
        btnTitle.tag=i;
        [btnTitle addTarget:self action:@selector(btnTitle_Click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTitle];
        [btnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(self.bounds.size.width/6);
            make.left.equalTo(self).offset(i*self.bounds.size.width/6);
        }];
        
        UILabel* subLabel = [[UILabel alloc]init];
        subLabel.text = self.subTitleArr[i];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.font = ART_FONT(ARTFONT_E);
        [btnTitle addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btnTitle.mas_bottom).offset(-2);
            make.centerX.equalTo(btnTitle);
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width/6,10));
        }];
        
       // [arrayTitleBtn addObject:btnTitle];
        if (i==0) {
            _introBtn = btnTitle;
            
            lineChoose=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width/6,2)];
            lineChoose.backgroundColor=[UIColor clearColor];
            [self addSubview:lineChoose];
            UIImageView* smallLine = [[UIImageView alloc]init];
            smallLine.backgroundColor = [UIColor blackColor];
            [lineChoose addSubview:smallLine];
            [smallLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(lineChoose).with.insets(UIEdgeInsetsMake(0, T_WIDTH(8), 0, T_WIDTH(8)));
            }];
        }
    }
}
-(void)btnTitle_Click:(UIButton *)btnTitle{
    [UIView animateWithDuration:0.3 animations:^{
        lineChoose.frame = CGRectMake(btnTitle.tag*self.bounds.size.width/6, self.bounds.size.height-2, self.bounds.size.width/6, 2);
    }];
   
    
    if (self.selectBtnCilck){
        self.selectBtnCilck(btnTitle.tag);
    }
}
- (void)setSelectedPageIndex:(int)selectedPageIndex
{
    [UIView animateWithDuration:0.1 animations:^{
        lineChoose.frame = CGRectMake(selectedPageIndex*self.bounds.size.width/6, self.bounds.size.height-2, self.bounds.size.width/6, 2);
    }];
}
-(void)setIntroBtnTitle:(NSString *)introBtnTitle{

[_introBtn setTitle:introBtnTitle forState:UIControlStateNormal];
}
@end
