//
//  MSBLaunchImage.m
//  meishubao
//
//  Created by T on 16/11/18.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBLaunchImage.h"
#import <UIKit/UIKit.h>
#import "GeneralConfigure.h"
@implementation MSBLaunchImage
+ (instancetype)shareInstance{
    static MSBLaunchImage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MSBLaunchImage alloc] init];
    });
    return instance;
}

- (void)show{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIView *launchScreenView = [UIView new];
    launchScreenView.frame = window.bounds;
    [window addSubview:launchScreenView];

    
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame = launchScreenView.bounds;
    launchView.contentMode = UIViewContentModeScaleAspectFill;
    launchView.clipsToBounds = YES;
    
    [launchScreenView addSubview:launchView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:launchView.bounds];
    maskView.backgroundColor = [UIColor whiteColor];
    [launchScreenView insertSubview:maskView belowSubview:launchView];
    
    [UIView animateWithDuration:.15 delay:0.9 options:(7<<16) animations:^{
        launchView.frame = CGRectMake(0, 0, CGRectGetWidth(launchView.bounds), 64);
    } completion:nil];
    [UIView animateWithDuration:1.2 delay:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        maskView.alpha = 0;
        launchView.alpha = 0;
    } completion:^(BOOL finished) {
        [launchScreenView removeFromSuperview];
        
        [self requestOpenAds];
    }];

    
//    [UIView animateWithDuration:2.f
//                          delay:0.0f
//                        options:UIViewAnimationOptionBeginFromCurrentState
//                     animations:^{
//                         launchView.alpha = 0.0f;
//                         launchView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -launchView.frame.size.height, 50);
////                         CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
//                     }
//                     completion:^(BOOL finished) {
//                         [launchView removeFromSuperview];
//                     }];
}

-(void)requestOpenAds
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[LLRequestBaseServer shareInstance] requestOpenShowAdSuccess:^(LLResponse *response, id data) {
            if (data && [data isKindOfClass:[NSArray class]]) {
                NSArray * imageModels = [OpenAdModel mj_objectArrayWithKeyValuesArray:data];
                if (imageModels.count==0) {
                    return ;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    MSBADAlertView * alertView = [MSBADAlertView new];
                    alertView.imageDatas = imageModels;
                    [alertView show];
                });
            }
        } failure:^(LLResponse *response) {
            
        } error:^(NSError *error) {
            
        }];
    });
}


@end
