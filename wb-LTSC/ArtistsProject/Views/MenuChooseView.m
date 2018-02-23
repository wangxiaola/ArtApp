//
//  ArtChooseView.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MenuChooseView.h"

@interface MenuChooseView ()
{
    UIImageView* lineChoose;
    UIButton* _introBtn;
    CGFloat btnWidth;
}
@end

@implementation MenuChooseView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]){
        self.frame = frame;
        self.bounces = NO;
        self.backgroundColor=kWhiteColor;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(void)addBtnAndTitLabel{
    btnWidth = SCREEN_WIDTH/5.5;
    if (self.arrayTitle.count==2){
        btnWidth = SCREEN_WIDTH/2;
    }
    self.contentSize = CGSizeMake(btnWidth*_arrayTitle.count, 0);
    for (int i=0; i<self.arrayTitle.count; i++) {
        UIButton *btnTitle=[[UIButton alloc]init];
        btnTitle.frame = CGRectMake(i*btnWidth-T_WIDTH(8), 0, btnWidth+9, self.frame.size.height);
        [btnTitle setTitle:self.arrayTitle[i] forState:UIControlStateNormal];
        [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnTitle.titleLabel.font=ART_FONT(ARTFONT_OE);
        btnTitle.tag=i;
        [btnTitle addTarget:self action:@selector(btnTitle_Click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnTitle];
        
        UILabel* subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnTitle.bounds.size.height-13, btnWidth+9, 10)];
        subLabel.text = self.subTitleArr[i];
        subLabel.textAlignment = NSTextAlignmentCenter;
        subLabel.font = ART_FONT(ARTFONT_E);
        [btnTitle addSubview:subLabel];
    
        if (i==_arrayTitle.count-1){
            _introBtn = btnTitle;
            lineChoose=[[UIImageView alloc]initWithFrame:CGRectMake(-T_WIDTH(8), self.bounds.size.height-2, btnWidth+9,2)];
            lineChoose.backgroundColor=[UIColor clearColor];
            [self addSubview:lineChoose];
            UIImageView* smallLine = [[UIImageView alloc]initWithFrame:CGRectMake((btnWidth-9)/2-T_WIDTH(8), 0,40 , 2)];
            smallLine.backgroundColor = [UIColor blackColor];
            [lineChoose addSubview:smallLine];
        }
    }
    
   
}

-(void)setArrayTitle:(NSArray *)arrayTitle{
    _arrayTitle=arrayTitle;
}
-(void)setSubTitleArr:(NSArray *)subTitleArr{
    _subTitleArr = subTitleArr;
}
-(void)btnTitle_Click:(UIButton *)btnTitle{
    [UIView animateWithDuration:0.3 animations:^{
        lineChoose.frame = CGRectMake(btnTitle.tag*btnWidth-T_WIDTH(8), self.bounds.size.height-2, btnWidth+9, 2);
    }];
    
    if (btnTitle.tag>=4) {
        [self setContentOffset:CGPointMake((btnWidth+9)/2-T_WIDTH(8)+btnWidth, 0) animated:YES];
    }else if(btnTitle.tag<=2){
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (self.selectBtnCilck){
        self.selectBtnCilck(btnTitle.tag);
    }
}

- (void)setSelectedPageIndex:(int)selectedPageIndex
{
    [UIView animateWithDuration:0.1 animations:^{
        lineChoose.frame = CGRectMake(selectedPageIndex*btnWidth-T_WIDTH(8), self.bounds.size.height-2, btnWidth+9, 2);
    }];
    if (selectedPageIndex>=4) {
        [self setContentOffset:CGPointMake((btnWidth+9)/2-T_WIDTH(8)+btnWidth, 0) animated:YES];
    }else if(selectedPageIndex<=2){
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(void)setIntroBtnTitle:(NSString *)introBtnTitle{
    
    [_introBtn setTitle:introBtnTitle forState:UIControlStateNormal];
}
@end
