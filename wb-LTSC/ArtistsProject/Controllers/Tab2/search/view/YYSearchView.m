//
//  YYSearchView.m
//  YYSearchView
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 Jack YY. All rights reserved.
//

#import "YYSearchView.h"

@implementation YYSearchView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.YYBgView.backgroundColor = [UIColor whiteColor];
    self.YYSearch.leftView = [self leftView];
    self.YYSearch.leftViewMode = UITextFieldViewModeAlways;
    self.YYSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[UITextField appearance] setTintColor:[UIColor blackColor]];
//    [self.YYSearch becomeFirstResponder];
}

+(instancetype)creatView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"YYSearchView" owner:nil options:nil]lastObject];
}

-(UIView *)leftView
{
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 8, 24, 24)];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(8, 4, 16, 16);
    [button setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchTile) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:button];
    return leftView;
}
-(void)searchTile
{
    [self.YYSearch resignFirstResponder];
    self.YYGetTitle(self.YYSearch.text);
}

- (IBAction)YYCancel:(UIButton *)sender
{
    //[self.YYSearch resignFirstResponder];
    //self.YYGetCancel();
    [self.YYSearch resignFirstResponder];
    self.YYGetCancel(self.YYSearch.text);
}

@end
