//
//  NODataView.h
//  JobElectronic
//  Created by gengyuanyuan on 15/8/7.
//  Copyright © 2015年 PanghuKeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHNODataView : UIView
+ (instancetype)showHUDAddedTo:(UIView *)view :(void(^)(id responseObject))block;
@end
