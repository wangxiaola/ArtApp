//
//  HCheckBox.h
//  Hospital
//
//  Created by 安信 on 15/5/22.
//  Copyright (c) 2015年 上海翔汇网络技术有限公司. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface HCheckBox : UIButton {
    
    BOOL _checked;
    id _userInfo;
}

@property(nonatomic, assign)BOOL checked;
@property(nonatomic, retain)id userInfo;
@property(nonatomic, copy) void(^didCheckStatusChangedBlock)(BOOL checked);
@end