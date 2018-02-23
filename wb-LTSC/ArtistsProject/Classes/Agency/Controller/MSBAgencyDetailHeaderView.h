//
//  MSBAgencyDetailHeaderView.h
//  meishubao
//
//  Created by T on 16/12/26.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeaderViewDidBtnClick)();
typedef void(^HeaderViewSearchBlock)();

@interface MSBAgencyDetailHeaderView : UIView
@property (nonatomic, copy) HeaderViewDidBtnClick btnClickBlock;
@property (nonatomic, copy) HeaderViewSearchBlock searchBlock;
- (void)setImages:(NSArray *)images message:(NSString *)message;
@end
