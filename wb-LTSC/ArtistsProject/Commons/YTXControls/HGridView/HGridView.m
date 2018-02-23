//
//  HGridView.m
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/2.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HGridView.h"
#import "HButton.h"

@interface HGridView (){
    UIScrollView *contentScrollView;
    UIView *viewContent;
}
@property(nonatomic,copy) didSelectedCellBlock block;
@end

@implementation HGridView
- (id) init
{
    if (self=[super init]){
        [self setBackgroundColor:[UIColor whiteColor]];
        contentScrollView=[[UIScrollView alloc] init];
        [self addSubview:contentScrollView];
        [contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        contentScrollView.alwaysBounceVertical = YES;
        contentScrollView.scrollEnabled = YES;
        contentScrollView.showsVerticalScrollIndicator = NO;
        
        viewContent=[[UIView alloc] init];
        [contentScrollView addSubview:viewContent];
        [viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(contentScrollView);
            make.width.equalTo(contentScrollView);
        }];
    }
    return self;
}

- (void)setItems:(NSArray*)items
               andColumnNum:(NSInteger)column
              andCellHeigth:(CGFloat)cellHeight
    andDidSelectedCellBlock:(didSelectedCellBlock)block
{
    self.block=block;
    for (UIView *view in viewContent.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < items.count / column + 1; i++) {
        for (int j = 0; j < column; j++) {
            if (i * column + j >= items.count)
                break;
            HGridItemView* item = [HGridItemView new];
            [viewContent addSubview:item];
            [item mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(viewContent).offset(kScreenW / column * j);
                make.top.equalTo(viewContent).offset(cellHeight * i);
                make.size.mas_equalTo(CGSizeMake(kScreenW / column, cellHeight));
            }];
            if (self.itemTitleAlignment){
                item.itemTitleAlignment=self.itemTitleAlignment;
            }
            [item setItem:items[i * column + j]];
            item.tag = i * column + j;
            BOOL top = 1;
            BOOL right = 1;
            BOOL bottom = 1;
            BOOL left = 0;
            if (j==0){
                left = 1;
            }
            if (i > 0) { //第1行之后不显示上边框线
                top = 0;
            }
            item.borderWidth = HViewBorderWidthMake(top, left, bottom, right);
            item.borderColor = [UIColor colorWithHexString:@"#cbcbcb"];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(item_Click:)];
            [item addGestureRecognizer:tap];
        }
    }
    [viewContent mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(viewContent.subviews.lastObject);
    }];
}
- (void) item_Click:(UITapGestureRecognizer*)sender
{
    HGridItemView *viewItem=(HGridItemView*)sender.view;
    ///是否允许反选
    if (self.allowUnSelect){
        for (HGridItemView *view in viewContent.subviews) {
            if (![view isEqual:viewItem]){
                view.selected=NO;
            }
        }
        viewItem.selected=!viewItem.selected;
        if (self.block){
            self.block(viewItem.item);
        }
        return;
    }
    
    
    if (self.allowMultiSelect){
        viewItem.selected=!viewItem.selected;
    }else{
        for (HGridItemView *view in viewContent.subviews) {
            view.selected=NO;
        }
        viewItem.selected=YES;
    }
    if (self.block){
        self.block(viewItem.item);
    }
}
- (NSArray<HKeyValuePair*>*) selectedItems
{
    NSMutableArray *arrIndex=[[NSMutableArray alloc] initWithCapacity:0];
    for (HGridItemView *viewItem in viewContent.subviews) {
        if (viewItem.selected){
            [arrIndex addObject:viewItem.item];
        }
    }
    return arrIndex;
}
- (NSArray<NSString*>*) selectedValues
{
    NSMutableArray *arrValue=[[NSMutableArray alloc] initWithCapacity:0];
    for (HGridItemView *viewItem in viewContent.subviews) {
        if (viewItem.selected){
            [arrValue addObject:viewItem.item.value];
        }
    }
    return arrValue;
}
- (void) setSelectedValues:(NSMutableArray<NSString *> *)selectedValues
{
    for (NSString *value in selectedValues) {
        for (HGridItemView *viewItem in viewContent.subviews) {
            if ([viewItem.item.value isEqualToString:value]){
                viewItem.selected=YES;
                break;
            }
        }
    }

}
- (void) setTitleColor:(UIColor *)titleColor
{
    _titleColor=titleColor;
    for (int i=0; i<viewContent.subviews.count; i++) {
        UIView *view=viewContent.subviews[i];
        if ([view isKindOfClass:[HGridItemView class]]){
            ((HGridItemView*)view).titleColor=titleColor;
        }
    }
}

- (void) setHideItemsBorder:(BOOL)hideItemsBorder
{
    _hideItemsBorder=hideItemsBorder;
    for (int i=0; i<viewContent.subviews.count; i++) {
        UIView *view=viewContent.subviews[i];
        if ([view isKindOfClass:[HGridItemView class]]){
            ((HGridItemView*)view).borderWidth=HViewBorderWidthMake(0, 0, 0, 0);
        }
    }
}
@end
