//
//  NavigationController.m
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        
        UIImage *img= [UIImage imageNamed:@"icon_navigationbar_back"];
        img= [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIButton *navBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 40, 30)];
        
        navBtn.imageEdgeInsets= UIEdgeInsetsMake(0, -30, 0, 0);
        [navBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [navBtn setImage:img forState:UIControlStateNormal];
        
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:navBtn];
        
    }
    
    
    [super pushViewController:viewController animated:animated];
}

- (void)backClick
{
    // 因为self本来就是一个导航控制器，self.navigationController这里是nil的
    [self popViewControllerAnimated:YES];
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
