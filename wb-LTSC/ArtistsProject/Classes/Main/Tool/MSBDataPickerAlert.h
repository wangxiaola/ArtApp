//
//  MSBDataPickerAlert.h
//  meishubao
//
//  Created by T on 16/11/28.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MSBDataPickerAlertBlock)(NSDate *);

@interface MSBDataPickerAlert : UIView
@property (readonly, nonatomic, getter=isShow) BOOL isShow;
- (void)showWithTitle:(NSString *)title
              content:(NSString *)content
                   ok:(MSBDataPickerAlertBlock)ok
               cancel:(MSBDataPickerAlertBlock)cancel;
@end
