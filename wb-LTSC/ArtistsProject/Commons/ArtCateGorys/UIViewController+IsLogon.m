//
//  UIViewController+IsLogon.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/7.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "UIViewController+IsLogon.h"
#import "AlertLoginVc.h"
#import "AppDelegate.h"
#import "LogonVc.h"

@implementation UIViewController (IsLogon)
- (BOOL)isFinishLogin{
    if (![[Global sharedInstance] userID]) {
//        AlertLoginVc* login = [[AlertLoginVc alloc] initWithNibName:@"AlertLoginVc" bundle:nil];
//        login.navTitle = @"用户验证";
//        //        login.state = @"push";
//        login.hidesBottomBarWhenPushed = YES;
//        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
//        [self.navigationController pushViewController:login animated:YES];
        LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
        login.navTitle = @"用户验证";
        login.hidesBottomBarWhenPushed = YES;
        login.whichControl = [NSString stringWithFormat:@"%@",self.class];
        [self.navigationController pushViewController:login animated:YES];
        return NO;
    }
    return YES;
}
-(void)JumpToControlIndex:(NSInteger)index TransitionType:(UISSAnimationType)type whichContol:(NSString *)whichControl{
    [self.navigationController popToRootViewControllerAnimated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AppDelegate* aud = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if (type==UISSAnimationFromLeft) {
            [aud.tab JumpToControlForIndex:index TransitionType:UISSTransitionFromLeft whichControl:whichControl];
        }else if(type==UISSAnimationFromRight){
            [aud.tab JumpToControlForIndex:index TransitionType:UISSTransitionFromRight whichControl:whichControl];
        }else if(type==UISSAnimationFromBottom){
            [aud.tab JumpToControlForIndex:index TransitionType:UISSTransitionFromBottom whichControl:whichControl];
        }else{
            [aud.tab JumpToControlForIndex:index TransitionType:UISSTransitionFromTop whichControl:whichControl];
        }
    });
}

@end
