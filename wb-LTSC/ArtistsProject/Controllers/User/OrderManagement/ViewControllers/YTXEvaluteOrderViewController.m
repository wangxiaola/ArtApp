//
//  YTXEvaluteOrderViewController.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "YTXEvaluteOrderViewController.h"
#import "JGTextView.h"
#import "YTXHuiPingOrderModel.h"
#import "YTXOrderModel.h"
#import "YTXOrderViewModel.h"
@interface YTXEvaluteOrderViewController ()
{
    HLabel *zhuipingLBL;
    JGTextView *zhuipingText;
    HButton *commitBtn;
}
@property (nonatomic, strong) YTXOrderViewModel * viewModel;
@end

@implementation YTXEvaluteOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_orderType isEqualToString:@"2"]) {
        self.navigationItem.title = @"追评";
    }else{
        self.navigationItem.title = @"回评";
    }
    [self getOrderCommenID];
    self.scrollView.backgroundColor = [UIColor whiteColor];
}
- (void)getOrderCommenID
{
    NSDictionary * dict = @{
                            @"id" : _orderID,
                            @"page":@1,
                            @"num":@10,
                            @"uid" : [Global sharedInstance].userID,
                            @"type":@1,
                            };
    [ArtRequest GetRequestWithActionName:@"getordercomment" andPramater:dict succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        YTXOrderModel * model = [YTXOrderModel modelWithDictionary:[responseObject firstObject]];
        model.type = _orderType;// 买入和卖出的类型判断
        _viewModel = [YTXOrderViewModel modelWithOrderModel:model];
        _replyid = _viewModel.huiping;
    } failed:^(id responseObject) {
        kPrintLog(responseObject);
    }];
}
- (void) createView:(UIView *)contentView
{
    // 追评
    HView *jianliBottom=[HView new];
    jianliBottom.backgroundColor=kWhiteColor;
//    jianliBottom.borderColor=kLineColor;
//    jianliBottom.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:jianliBottom];
    [jianliBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(0);
        make.height.mas_equalTo(200);
    }];
    zhuipingLBL = [[HLabel alloc] init];
    if ([_orderType isEqualToString:@"2"]) {
        zhuipingLBL.text = [NSString stringWithFormat:@"追评:"];
    }else{
        zhuipingLBL.text = [NSString stringWithFormat:@"回评:"];
    }
    zhuipingLBL.textAlignment = NSTextAlignmentLeft;
    zhuipingLBL.font = kFont(16);
    [jianliBottom addSubview:zhuipingLBL];
    [zhuipingLBL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jianliBottom).offset(20);
        make.left.equalTo(jianliBottom).offset(10);
        make.width.mas_equalTo(kScreenW-20);
        make.height.mas_equalTo(25);
    }];
    zhuipingText = [[JGTextView alloc] init];
    zhuipingText.font = kFont(14);
    zhuipingText.backgroundColor = BACK_VIEW_COLOR;
    [jianliBottom addSubview:zhuipingText];
    [zhuipingText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zhuipingLBL).offset(30);
        make.left.equalTo(jianliBottom).offset(10);
        make.width.mas_equalTo(kScreenW-20);
        make.bottom.equalTo(jianliBottom).offset(-10);
    }];
    // 提交追评
    commitBtn = [HButton buttonWithType:(UIButtonTypeSystem)];
    [contentView addSubview:commitBtn];
    [commitBtn hyb_addCornerRadius:5];
    [commitBtn setTintColor:[UIColor whiteColor]];
    [commitBtn addTarget:self action:@selector(commitAutoInfo) forControlEvents:(UIControlEventTouchUpInside)];
    if ([_orderType isEqualToString:@"2"]) {
        [commitBtn setTitle:@"提交追评" forState:(UIControlStateNormal)];
    }else{
        [commitBtn setTitle:@"提交回评" forState:(UIControlStateNormal)];
    }
    commitBtn.frame = CGRectMake(25, kScreenH - 80-64, kScreenW - 50, 50);
    commitBtn.backgroundColor = [UIColor blackColor];
}

- (void)commitAutoInfo
{
    if (_orderID.length == 0) {
        [self showErrorHUDWithTitle:@"订单号异常请重试!" SubTitle:nil Complete:nil];
        return;
    }
    if (zhuipingText.text.length == 0) {
        if ([_orderType isEqualToString:@"2"]) {
            [self showErrorHUDWithTitle:@"请输入追加的评价!" SubTitle:nil Complete:nil];
        }else{
            [self showErrorHUDWithTitle:@"请输入回复的评价!" SubTitle:nil Complete:nil];
        }
        return;
    }
    NSDictionary * dict = @{
                            @"id" : [NSString stringWithFormat:@"%@", _orderID]?:@"0",
                            @"message" : zhuipingText.text,
                            @"uid" : [Global sharedInstance].userID,
                            @"replyid":_replyid?:@"0",
                            };
    kPrintLog(dict);
    [ArtRequest PostRequestWithActionName:@"postordercomment" andPramater:dict succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"res"] boolValue]) {
                if ([_orderType isEqualToString:@"2"]) {
                    [self showOkHUDWithTitle:@"追加评价成功" SubTitle:nil Complete:nil];
                }else{
                    [self showOkHUDWithTitle:@"回复评价成功" SubTitle:nil Complete:nil];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            } else {
                [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
            }
        } else {
            if ([_orderType isEqualToString:@"2"]) {
                [self showErrorHUDWithTitle:@"追加评价失败" SubTitle:nil Complete:nil];
            }else{
                [self showErrorHUDWithTitle:@"回复评价失败" SubTitle:nil Complete:nil];
            }
        }

    } failed:^(id responseObject) {
        kPrintLog(responseObject);
        if ([_orderType isEqualToString:@"2"]) {
            [self showErrorHUDWithTitle:@"追加评价失败" SubTitle:nil Complete:nil];
        }else{
            [self showErrorHUDWithTitle:@"回复评价失败" SubTitle:nil Complete:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
