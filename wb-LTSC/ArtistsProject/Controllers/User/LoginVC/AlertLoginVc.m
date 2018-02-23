//
//  AlertLoginVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "AlertLoginVc.h"
#import "LogonVc.h"

@interface AlertLoginVc ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (strong, nonatomic) IBOutlet UIButton *startLoginBtn;

@end

@implementation AlertLoginVc
-(void)createView{
    [super createView];
    _top.constant = T_WIDTH(100);
    _startLoginBtn.layer.borderWidth = 1;
    [_startLoginBtn setTitleColor:RGB(170, 170, 170) forState:UIControlStateNormal];
    _startLoginBtn.layer.borderColor = [RGB(170, 170, 170) CGColor];
    _startLoginBtn.layer.cornerRadius = 3;
}
- (IBAction)startLoginClick:(UIButton *)sender {
    LogonVc* login = [[LogonVc alloc] initWithNibName:@"LogonVc" bundle:nil];
    login.navTitle = @"用户验证";
    login.state = @"push";
    login.whichControl = self.whichControl;
    [self.navigationController pushViewController:login animated:YES];
    
}
-(void)leftBarItem_Click{
    if ([self.whichControl isEqualToString:@"tabBar"]){
        [self JumpToControlIndex:0 TransitionType:UISSAnimationFromBottom whichContol:nil];
    }else{
        NSArray* arr = self.navigationController.viewControllers;
        for (UIViewController* vc in arr) {
            if ([vc isKindOfClass:NSClassFromString(self.whichControl)]) {
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
}
@end
