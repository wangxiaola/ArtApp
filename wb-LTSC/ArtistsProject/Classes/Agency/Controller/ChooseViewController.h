//
//  ChooseViewController.h
//  meishubao
//
//  Created by LWR on 2016/11/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseViewControllerDelegate <NSObject>

@optional
- (void)dismiss;

@end

@interface ChooseViewController : UIViewController

@property (nonatomic, weak) id<ChooseViewControllerDelegate> delegate;

@property (nonatomic, copy) void(^searchBlock) (NSDictionary *);

@property (nonatomic, strong) NSArray *areaTagArr;

@property (nonatomic, strong) NSArray *kindTagArr;

- (void)reset;

@end
