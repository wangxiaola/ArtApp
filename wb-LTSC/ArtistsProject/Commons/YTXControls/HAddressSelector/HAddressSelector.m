//
//  HAddressSelector.m
//
//  Created by HeLiulin on 15/10/29.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import "HAddressSelector.h"
#import "HButton.h"
#import "HView.h"
#import "HGridView.h"
#import "UIViewController+KNSemiModal.h"
#import "ListResultModel.h"

@interface HAddressSelector ()<UIScrollViewDelegate>
{
    NSMutableArray *arrIDs;
    NSMutableArray *arrNames;
    NSMutableArray *arrActionViews;
    NSString *sortAreaId;
}
@property (nonatomic, copy) didFinishSelectedBlock finishSelectedBlock;
@property (nonatomic, copy) didClickedCancelButtonBlock clickedCancelButtonBlock;
@property (nonatomic, copy) didClickedClearButtonBlock clickedClearButtonBlock;

@end

@implementation HAddressSelector

- (id) initWithFinishSelectedBlock:(didFinishSelectedBlock)finishSelectedBlock
       andClickedCancelButtonBlock:(didClickedCancelButtonBlock)clickedCancelButtonBlock
        andClickedClearButtonBlock:(didClickedClearButtonBlock)clickedClearButtonBlock;
{
    if (self = [super init]) {
        self.finishSelectedBlock = finishSelectedBlock;
        self.clickedCancelButtonBlock = clickedCancelButtonBlock;
        self.clickedClearButtonBlock = clickedClearButtonBlock;
        self.mustSelectLevel=3;
    }
    return self;
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, kScreenW, 325)];
    self.navItem.title=@"省份";
    HGridView* tempGrid = nil;
    for (int i = 0; i < 3; i++) {
        HGridView* viewGrid = [HGridView new];
        [self.viewContent addSubview:viewGrid];
        [viewGrid mas_makeConstraints:^(MASConstraintMaker* make) {
            if (tempGrid) {
                make.left.equalTo(tempGrid.mas_right);
            }
            else {
                make.left.equalTo(self.viewContent);
            }
            make.top.and.bottom.equalTo(self.viewContent);
            make.width.mas_equalTo(kScreenW);
        }];
        tempGrid = viewGrid;
    }
    [self.viewContent mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.viewContent.subviews.lastObject);
    }];

    arrIDs = [[NSMutableArray alloc] initWithCapacity:3];
    arrNames = [[NSMutableArray alloc] initWithCapacity:3];

    [self showWithLevelNum:3 andCategoryID:@"0" Completion:self.finishSelectedBlock];
    self.scrollView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
//    UIBarButtonItem *btn2=[[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    self.navItem.leftBarButtonItems=@[btn1];

    
    //设置导航栏左右按钮字体和颜色
    [btn1 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
//    [btn2 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
}
//选择省份
- (void) showWithLevelNum:(int)levelNum andCategoryID:(NSString*)categoryID Completion:(didFinishSelectedBlock)didSelectedBlock
{
    [self.scrollView setContentOffset:CGPointMake(kScreenW*(3-levelNum), 0) animated:YES];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"city_jsonnew" ofType:@"txt"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *arr2 = [NSMutableArray new];
    NSMutableArray *items;
    if (levelNum==3) {
        NSArray* keys = [dic allKeys];
        for (NSString* key in keys) {
           NSMutableDictionary *dicList= [dic valueForKey:key];
            NSDictionary *dic=@{key:dicList};
            [arr2 addObject:dic];
        }
        
        items=[[NSMutableArray alloc] initWithCapacity:0];
         for (NSDictionary* dic in arr2) {
             NSArray* keys = [dic allKeys];
             [items addObject:[[HKeyValuePair alloc] initWithValue:keys[0] andDisplayText:dic[keys[0]][@"title"]]];
         }
    }else if (levelNum==2){
        sortAreaId=categoryID;
        NSDictionary *dic1=[dic objectForKey:categoryID][@"areas"];
        NSArray* keys = [dic1 allKeys];
        for (NSString* key in keys) {
            NSMutableDictionary *dicList= [dic1 valueForKey:key];
            NSDictionary *dic=@{key:dicList};
            [arr2 addObject:dic];
        }
         items=[[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary* dic in arr2) {
            NSArray* keys = [dic allKeys];
            [items addObject:[[HKeyValuePair alloc] initWithValue:keys[0] andDisplayText:dic[keys[0]][@"title"]]];
        }
    }else{
        NSDictionary *dic2=[dic objectForKey:sortAreaId][@"areas"];
        NSDictionary *dic1=[dic2 objectForKey:categoryID][@"areas"];
        NSArray* keys = [dic1 allKeys];
        for (NSString* key in keys) {
            NSMutableDictionary *dicList= [dic1 valueForKey:key];
            NSDictionary *dic=@{key:dicList};
            [arr2 addObject:dic];
        }
        items=[[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary* dic in arr2) {
            NSArray* keys = [dic allKeys];
            [items addObject:[[HKeyValuePair alloc] initWithValue:keys[0] andDisplayText:dic[keys[0]][@"title"]]];
        }
    }

         __weak HGridView *viewGrid=(HGridView*)(self.viewContent.subviews[3-levelNum]);
         if (levelNum==1 && self.allowMultiSelectOnLastLevel){
             viewGrid.allowMultiSelect=YES;
         }
    
        if (items.count<1) {
            if (self.finishSelectedBlock){
                self.finishSelectedBlock(arrIDs,arrNames);
                [self dismiss];
                //[self dismissSemiModalView];
            }
            return ;
        }
                         [viewGrid setItems:items
                                        andColumnNum:5
                                       andCellHeigth:40
                             andDidSelectedCellBlock:^(HKeyValuePair* item) {
                                 arrIDs[3-levelNum]=item.value;
                                 arrNames[3-levelNum]=item.displayText;
        
                                 if (levelNum > 1) {
                                     [self showWithLevelNum:levelNum - 1 andCategoryID:item.value Completion:didSelectedBlock];
                                 }else{
                                     if (viewGrid.allowMultiSelect){
                                         arrIDs[3-levelNum]=[viewGrid.selectedItems componentsJoinedByString:@","];
                                         if (viewGrid.selectedItems.count>1){//选择多项
                                             arrNames[3-levelNum]=[NSString stringWithFormat:@"%@等%lu项",item.displayText,(unsigned long)viewGrid.selectedItems.count];
                                         }else{//选择一项
                                             arrNames[3-levelNum]=item.displayText;
                                         }
                                     }else{
                                         if (self.finishSelectedBlock){
                                             self.finishSelectedBlock(arrIDs,arrNames);
                                                [self dismiss];
                                             //[self dismissSemiModalView];
                                         }
                                     }
                                 }
                             }];
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / kScreenW;
    if (page>=self.mustSelectLevel){
        UIBarButtonItem *btn3=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ok)];
        [btn3 setTitleTextAttributes:self.dicBarItemAttr forState:UIControlStateNormal];
        self.navItem.rightBarButtonItems=@[btn3];
    }else{
        self.navItem.rightBarButtonItems=@[];
    }
    switch (page) {
        case 0:
        {
            self.navItem.title=@"省份";
            UIBarButtonItem *btn1=self.navItem.leftBarButtonItems[0];
            btn1.title=@"取消";
            [btn1 setAction:@selector(dismiss)];

            break;
        }
        case 1:
        {
            self.navItem.title=@"城市";
            UIBarButtonItem *btn1=self.navItem.leftBarButtonItems[0];
            btn1.title=@"返回";
            [btn1 setAction:@selector(pop)];
            break;
        }
        case 2:
        {
            self.navItem.title=@"区县";
        }

        default:
            break;
    }
}
/**
 *  返回
 */
- (void) pop
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x-kScreenW, 0) animated:YES];
}
/**
 *  清除当前所选
 */
//- (void) clear
//{
//    if (self.clickedClearButtonBlock){
//        self.clickedClearButtonBlock();
//    }
//    [self dismiss];
//}
/**
 *  确定
 */
- (void) ok
{
    if (self.finishSelectedBlock){
        self.finishSelectedBlock(arrIDs,arrNames);
        [self dismiss];
    }
}
@end
