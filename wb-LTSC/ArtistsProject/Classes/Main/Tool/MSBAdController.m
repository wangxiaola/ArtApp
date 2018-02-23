//
//  MSBAdController.m
//  meishubao
//
//  Created by T on 16/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAdController.h"
#import "MSBAdSchedule.h"
#import "MSBAdView.h"
#import "MSBAdModel.h"

@interface MSBAdController ()
@property(nonatomic,strong) MSBAdView *adView;
@end

@implementation MSBAdController{
    BOOL _isShow;
}

- (MSBAdView *)adView {
    
    if (_adView == nil) {
        
        _adView = [[MSBAdView alloc] init];
        [_adView setBackgroundColor:[UIColor whiteColor]];
    }
    
    return _adView;
}


- (void)play{
    __weak __block typeof(self) weakSelf = self;
    MSBAdModel *ad = [MSBAdSchedule currentAdSchedule];
//    if (!(_isShow || ad == nil || ad.adBinaryData == nil)) {
    
        NSEnumerator *fontToBackWindows = [[UIApplication sharedApplication] windows].reverseObjectEnumerator;
        
        for (UIWindow *window in fontToBackWindows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                
                _isShow = YES;
                weakSelf.adView.frame = [UIScreen mainScreen].bounds;
                weakSelf.adView.alpha = 1.f;
                [window addSubview:weakSelf.adView];
                
                [self.adView start:nil duration:10 complete:^{
                    
                    [UIView animateWithDuration:.5f animations:^{
                        
                        weakSelf.adView.alpha = 0.f;
                    } completion:^(BOOL finished) {
                        
                        _isShow = NO;
                        [weakSelf.adView removeFromSuperview];
                        weakSelf.adView = nil;
                    }];
                }];
                break;
            }
        }
//    }
}



- (void)start{
    @try {
        [self play];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
@end
