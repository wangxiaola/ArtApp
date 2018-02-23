//
//  HDDropDownMenu.h
//  evtmaster
//
//  Created by sks on 16/8/19.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    HDDropDownMenuTime, // 时间
    HDDropDownMenuYear  // 年代
} HDDropDownMenuType;

@protocol HDDrodownMenuDelegate <NSObject>
@optional
- (void)dropDownMenuDismiss:(NSInteger)type;
@optional
- (void)dropDownMenuBtnClick:(NSInteger)tag andType:(NSInteger)type;

@end

@interface HDDropDownMenu : UIView

// 显示
- (void)showInView:(UIView *)view andFrom:(UIView *)from;

// 移除
- (void)dismiss;

@property (nonatomic, strong) NSArray *titleArr;

// 代理
@property (nonatomic, weak) id<HDDrodownMenuDelegate> delegate;

@property (nonatomic, assign) HDDropDownMenuType type;

@property (nonatomic, assign) CGFloat fromViewW;

@end
