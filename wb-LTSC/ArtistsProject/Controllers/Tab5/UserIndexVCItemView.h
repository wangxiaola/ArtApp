//
//  UserIndexVCItemView.h
//  ShesheDa
//
//  Created by 赵 熙春 on 16/4/7.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//


@interface UserIndexVCItemView : HView

//图片
@property (nonatomic, strong) NSString *imgIcon;

//标题
@property (nonatomic, strong) NSString *title;

//箭头
@property (nonatomic, strong) NSString *imgArrow;

//点击时回调
@property (nonatomic, copy) void (^didTapBlock)();

//底部横线的起始位置
@property (nonatomic, readwrite) CGFloat bottomLineWidth;

@end
