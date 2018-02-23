//
//  MSBPickerAlertView.h
//  meishubao
//
//  Created by T on 16/11/29.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MSBPickerAlertViewBlock)(NSInteger);
@interface MSBPickerAlertView : UIView
@property (readonly, nonatomic, getter=isShow) BOOL isShow;
- (void)showWithTitle:(NSString *)title
              content:(NSArray *)content
                index:(NSInteger)index
                   ok:(MSBPickerAlertViewBlock)ok
               cancel:(MSBPickerAlertViewBlock)cancel;

@end
