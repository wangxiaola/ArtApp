//
//  CangyouQuanDetailVC.h
//  ShesheDa
//
//  Created by MengTuoChina on 16/7/23.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HPageViewController.h"

@interface CangyouQuanDetailVC : HPageViewController

//1为我的关注 2为藏有动态 3为我的动态 4
@property(strong,nonatomic)NSString *state;
@property(strong,nonatomic)NSString *userID;
@property(nonatomic)BOOL isHidePush;
//为1时隐藏nav
@property(strong,nonatomic)NSString *isHideNav;
@property(nonatomic,copy)NSString* isYiSuJiaJinKuang;
@property (strong,nonatomic)NSString *pagestr;
@end
