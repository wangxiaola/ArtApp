//
//  HotShowDatePicker.h
//  meishubao
//
//  Created by 胡亚刚 on 2017/4/19.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnSelectedDate)(NSString *dateStr);
@interface HotShowDatePicker : UIView
-(instancetype)init;
-(void)showDatePicker:(NSDate *)seleDate position:(CGPoint)position;
@property (nonatomic,copy) returnSelectedDate block;
-(void)returnSelectedDateWithBlock:(returnSelectedDate)block;
@end
