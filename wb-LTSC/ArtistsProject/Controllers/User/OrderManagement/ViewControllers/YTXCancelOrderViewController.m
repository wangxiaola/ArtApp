//
//  YTXCancelOrderViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/16.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXCancelOrderViewController.h"

@interface YTXCancelOrderViewController ()

@property (nonatomic, strong) UIButton * confirmBtn;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) UITextView * textView;

@end

@implementation YTXCancelOrderViewController

- (void)viewDidLoad {
    //    @"icon_Default_selected"  @"icon_Default_unSelected"
    self.title = @"取消订单";
    [super viewDidLoad];
    [self createViews];
    // Do any additional setup after loading the view.
}

- (void)createViews {
    //确认按钮
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setImage:[UIImage imageNamed:@"icon_Default_unSelected"] forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"icon_Default_selected"] forState:UIControlStateSelected];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmBtn setTitle:@"双方已协商一致" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _confirmBtn.selected = NO;
    _confirmBtn.contentMode = UIViewContentModeLeft;
    [self.scrollView addSubview:_confirmBtn];
    _confirmBtn.frame = CGRectMake(0, 20, 150, 30);
    //线条
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, _confirmBtn.bottom + 20, kScreenW - 20, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    //评价label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 30, kScreenW - 40, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"取消订单原因:";
    label.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:label];

    _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, label.bottom + 30, kScreenW - 40, 150)];
    [self.scrollView addSubview:_textView];
    
    _textView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, _textView.bottom + 20, kScreenW - 40, 44);
    [commitBtn setBackgroundColor:[UIColor blackColor]];
    [self.scrollView addSubview:commitBtn];
    commitBtn.layer.cornerRadius = 5;
    [commitBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commitBtnAction {
    if (_orderID.length == 0) {
        [self showErrorHUDWithTitle:@"订单号异常请重试!" SubTitle:nil Complete:nil];
        return;
    }
    if (_textView.text.length == 0) {
        [self showErrorHUDWithTitle:@"请输入取消原因!" SubTitle:nil Complete:nil];
        return;
    }
    if (!_confirmBtn.selected) {
        [self showErrorHUDWithTitle:@"请选中确认已经协商！" SubTitle:nil Complete:nil];
        return;
    }

    NSDictionary * dict = @{
                            @"orderid" : [NSString stringWithFormat:@"%@",_orderID],
                            @"reason" : _textView.text,
                            @"uid" : [Global sharedInstance].userID,
                            };
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpPostRequestWithActionName:@"cancelgoodsorder" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject);
        [self showErrorHUDWithTitle:@"取消订单失败" SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"res"] boolValue]) {
                [self showOkHUDWithTitle:@"取消订单成功" SubTitle:nil Complete:nil];
                [self.navigationController popViewControllerAnimated:YES];// 返回订单列表页面
            } else {
                [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
            }
        } else {
            [self showErrorHUDWithTitle:@"取消订单失败" SubTitle:nil Complete:nil];
            
        }
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        kPrintLog(error);
        [self showErrorHUDWithTitle:@"取消订单失败" SubTitle:nil Complete:nil];
    }];
}

- (void)confirmBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
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
