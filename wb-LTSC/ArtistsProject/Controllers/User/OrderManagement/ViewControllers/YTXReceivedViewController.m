//
//  YTXReceivedViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/16.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXReceivedViewController.h"

@interface YTXReceivedViewController ()

@property (nonatomic, strong) UIButton * confirmBtn;

@property (nonatomic, strong) UILabel * label;

@property (nonatomic, strong) UIButton * selectedBtn;

@property (nonatomic, strong) UITextView * textView;

@end

@implementation YTXReceivedViewController

- (void)viewDidLoad {
//    @"icon_Default_selected"  @"icon_Default_unSelected"
    self.title = @"确认收货";
    [super viewDidLoad];
    [self createViews];
    // Do any additional setup after loading the view.
}

- (void)createViews {
    //确认按钮
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setImage:[UIImage imageNamed:@"icon_Default_unSelected"] forState:UIControlStateNormal];
    [_confirmBtn setImage:[UIImage imageNamed:@"icon_Default_selected"] forState:UIControlStateSelected];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _confirmBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_confirmBtn setTitle:@"已确认收到货品，并且验证已验收合格" forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _confirmBtn.selected = NO;
    _confirmBtn.contentMode = UIViewContentModeLeft;
    [self.scrollView addSubview:_confirmBtn];
    _confirmBtn.frame = CGRectMake(20, 20, kScreenW - 40, 30);
    //线条
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, _confirmBtn.bottom + 20, kScreenW - 20, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.scrollView addSubview:lineView];
    //评价label
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, lineView.bottom + 30, kScreenW - 40, 21)];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"满意度评价";
    label.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:label];
    CGFloat btnWidth = 50;
    CGFloat space = (kScreenW - 5 * btnWidth) / 6.0;
    for (int i = 0; i < 5; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.selected = NO;
        btn.tag = i + 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];

        [btn setImage:[UIImage imageNamed:@"icon_Default_unSelected"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_Default_selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(space + i * (space + btnWidth), label.bottom + 20, btnWidth, 30);
        [btn setTitle:[NSString stringWithFormat:@"%d分",i + 1] forState:UIControlStateNormal];
        [self.scrollView addSubview:btn];
    }
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, label.bottom + 80, kScreenW - 20, 150)];
    [self.scrollView addSubview:_textView];
    
    _textView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.frame = CGRectMake(20, _textView.bottom + 20, kScreenW - 40, 44);
    [commitBtn setBackgroundColor:[UIColor blackColor]];
    [self.scrollView addSubview:commitBtn];
    commitBtn.layer.cornerRadius = 5;
    [commitBtn setTitle:@"确认并评价" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commitBtnAction {
    if (_orderID.length == 0) {
        [self showErrorHUDWithTitle:@"订单号异常请重试!" SubTitle:nil Complete:nil];
        return;
    }
    if (!_confirmBtn.selected) {
        [self showErrorHUDWithTitle:@"请选中确认收货" SubTitle:nil Complete:nil];
        return;
    }
    if (!_selectedBtn) {
        [self showErrorHUDWithTitle:@"请选择评分!" SubTitle:nil Complete:nil];
        return;
    }
    if (_textView.text.length == 0) {
        [self showErrorHUDWithTitle:@"请输入评价!" SubTitle:nil Complete:nil];
        return;
    }
    NSDictionary * dict = @{
                            @"orderid" : _orderID,
                            @"comment" : _textView.text,
                            @"uid" : [Global sharedInstance].userID,
                            @"score" : @(_selectedBtn.tag)
                            };
    kPrintLog(dict);
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpPostRequestWithActionName:@"recgoods" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self showErrorHUDWithTitle:@"确认收货失败" SubTitle:nil Complete:nil];

    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"res"] boolValue]) {
                [self showOkHUDWithTitle:@"确认收货成功" SubTitle:nil Complete:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
            }
        } else {
            [self showErrorHUDWithTitle:@"确认收货失败" SubTitle:nil Complete:nil];

        }
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"确认收货失败" SubTitle:nil Complete:nil];
    }];
}

- (void)confirmBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (void)btnSelect:(UIButton *)sender {
    if ([_selectedBtn isEqual:sender]) {
        return;
    }
    _selectedBtn.selected = NO;
    _selectedBtn = sender;
    _selectedBtn.selected = YES;
    
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
