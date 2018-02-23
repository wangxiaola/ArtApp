//
//  TitleView_Choose.h
//  ShesheDa
//
//  Created by chen on 16/8/2.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HView.h"

@interface TitleView_Choose : HView
{
    float  itmeWideth;
}
@property(strong,nonatomic)NSArray *arrayTitle;

@property (nonatomic, copy) void(^selectBtnCilck)(NSInteger );

@property(assign,nonatomic)NSInteger iClick;

@end
