//
//  MyButton.h
//  refresh
//
//  Created by 中嘉信诺 on 15/8/2.
//  Copyright (c) 2015年 中嘉信诺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishBlock)(id response);
@interface MyButton : UIButton

@property(nonatomic,strong)FinishBlock block;

-(instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag title:(NSString*)title img:(NSString*)img font:(CGFloat)Float :(void(^)(id responseObject))block;

@end
