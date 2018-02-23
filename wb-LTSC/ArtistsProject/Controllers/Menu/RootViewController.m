//
//  RootViewController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

-(void)createView{
    [super createView];
    //设置导航栏标题字体和颜色
    NSDictionary* dictTitle = @{ NSFontAttributeName : [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName : kTitleColor };
    self.navigationController.navigationBar.titleTextAttributes = dictTitle;

    //设置导航栏返回按钮样式
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0, 0, 14, 60);
    [customButton addTarget:self action:@selector(leftBarItem_Click) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"icon_navigationbar_back"] forState:UIControlStateNormal];
    customButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem* leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    if (self.navTitle) {
        self.navigationItem.title = self.navTitle;
    }
}
-(void)leftBarItem_Click{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
