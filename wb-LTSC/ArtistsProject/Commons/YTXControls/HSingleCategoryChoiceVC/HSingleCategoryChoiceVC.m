//
//  HSingleCategoryChoiceVC
//  logistics
//
//  Created by HeLiulin on 15/11/26.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import "HSingleCategoryChoiceVC.h"

@interface HSingleCategoryChoiceVC () {
    HGridView* viewGrid;
}

@end

@implementation HSingleCategoryChoiceVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat height = 0;
    int numberOfRow = (int)(self.items.count / self.numberOfColumns);
    if (self.items.count % self.numberOfColumns > 0) {
        numberOfRow++;
    }
    if (numberOfRow > 7) {
        height = 326;
    }
    else {
        height = numberOfRow * 40 + 46;
        height = height >= 200 ? height : 200;
    }
    [self.view setFrame:CGRectMake(0, 0, kScreenW, height)];
    self.navItem.title=self.navTitle;
    viewGrid = [HGridView new];
    [self.viewContent addSubview:viewGrid];
    [viewGrid mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.viewContent);
        make.top.and.bottom.equalTo(self.viewContent);
        make.width.mas_equalTo(kScreenW);
    }];
    viewGrid.allowMultiSelect = self.allowMultiChoice;
    __weak __typeof(self)weakSelf = self;
    [viewGrid setItems:self.items
                   andColumnNum:self.numberOfColumns>0?self.numberOfColumns:4
                  andCellHeigth:40
        andDidSelectedCellBlock:^(HKeyValuePair* item) {
            if (self.finishSelectedBlock && !self.allowMultiChoice) {
                weakSelf.finishSelectedBlock(@[item]);
                [weakSelf dismiss];
            }
        }];
    viewGrid.selectedValues=self.selectedValues;
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.viewContent.subviews.lastObject);
    }];

    UIBarButtonItem* btn1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    UIBarButtonItem* btn2 = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    //设置导航栏左右按钮字体和颜色
    [btn1 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
    [btn2 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
    if (!self.disabledClear){
        self.navItem.leftBarButtonItems = @[ btn1, btn2 ];
    }
    if (self.allowMultiChoice){
        UIBarButtonItem* btn3 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
        [btn3 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
        self.navItem.rightBarButtonItem = btn3;
    }
}
/**
 *  清除当前所选
 */
- (void)clear
{
    if (self.clickedClearButtonBlock) {
        self.clickedClearButtonBlock();
    }
    [self dismiss];
}
/**
 *  确定
 */
- (void)ok
{
    if (self.finishSelectedBlock) {
        self.finishSelectedBlock(viewGrid.selectedItems);
        [self dismiss];
    }
}

@end
