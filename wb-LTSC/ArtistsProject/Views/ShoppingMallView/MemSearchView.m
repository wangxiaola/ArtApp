//
//  MemSearchView.m
//  weiguankeji
//
//  Created by 黄兵 on 2017/6/15.
//  Copyright © 2017年 黄兵. All rights reserved.
//

#import "MemSearchView.h"
@interface MemSearchView()<UITextFieldDelegate>
{
    UIButton *cancel;
}

@end
@implementation MemSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 父视图
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleView];
        // 左视图
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleView.ownWidth - 60, frame.size.height)];
        view1.backgroundColor = [UIColor hexChangeFloat:@"f0f3f5"];
        [titleView addSubview:view1];
        [view1 hyb_addCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadius:19];
        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 20, 20)];
        imageV1.image = ImageNamed(@"shopping_search");
        [view1 addSubview:imageV1];
        self.search = [[UITextField alloc] initWithFrame:CGRectMake(imageV1.endX+ 5, 0, view1.width - imageV1.width, frame.size.height)];
        _search.backgroundColor = [UIColor hexChangeFloat:@"f0f3f5"];
        _search.delegate = self;
        _search.placeholder = @"搜索";
        _search.returnKeyType = UIReturnKeySearch;
        _search.textColor = [UIColor hexChangeFloat:@"bdc0c0"];
        _search.font = ART_FONT(14);
        [view1 addSubview:_search];
        // 右视图
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(titleView.ownWidth - 60, 0, 55, frame.size.height)];
        view2.backgroundColor = [UIColor hexChangeFloat:@"f0f3f5"];
        [titleView addSubview:view2];
        [view2 hyb_addCorner:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadius:19];
        cancel = [UIButton buttonWithType:(UIButtonTypeSystem)];
        cancel.frame = CGRectMake(0, 2.5, 50, 30);
        cancel.titleLabel.font = ART_FONT(16);
        [cancel setTintColor:[UIColor hexChangeFloat:@"bdc0c0"]];
        [cancel setTitle:@"" forState:(UIControlStateNormal)];
        [cancel addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [view2 addSubview:cancel];
    }
    return self;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [cancel setTitle:@"取消" forState:(UIControlStateNormal)];
    return YES;
}

- (void)btnAction:(UIButton *)button
{
    [_search resignFirstResponder];
    self.YYGetCancel(_search.text?:@"");
    [self.delegate menSearchNewMessage:button];// 代理
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [cancel setTitle:@"" forState:(UIControlStateNormal)];
    self.YYGetTitle(textField.text);
    return YES;
}

@end
