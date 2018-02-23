
//
//  LogonVc.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RootViewController.h"

@interface LogonVc : RootViewController
@property(nonatomic,copy)NSString* state;
@property(nonatomic,copy)NSString* whichControl;
// vc
@property (nonatomic, strong) UIViewController *pushVC;
@property (weak, nonatomic) IBOutlet UIButton *Weixin;

@end
