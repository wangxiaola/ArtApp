//
//  YTXScrollViewController.m
//  ShesheDa
//
//  Created by 徐建波 on 2016/11/16.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXScrollViewController.h"

@interface YTXScrollViewController ()

@end

@implementation YTXScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadScrollView];
}
- (void)loadScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _scrollView.contentSize = CGSizeMake(kScreenW, kScreenH - 64);
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    NSNotificationCenter *notiC = [NSNotificationCenter defaultCenter];
    [notiC addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [_scrollView addGestureRecognizer:tap];
    _scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
}


-(void)keyboardWasShown:(NSNotification *)notifi
{
    NSDictionary *dic = [notifi userInfo];
    CGSize keyBSize = [dic[UIKeyboardFrameEndUserInfoKey]CGRectValue].size;
    
    _scrollView.frame = CGRectMake(0, 0, kScreenW,kScreenH - keyBSize.height - 64);
}

-(void)keyboardWillBeHidden:(NSNotification *)notifi
{
    _scrollView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
}

-(void)click
{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
