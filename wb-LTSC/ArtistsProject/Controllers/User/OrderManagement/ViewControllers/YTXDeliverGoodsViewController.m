//
//  YTXDeliverGoodsViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/16.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXDeliverGoodsViewController.h"
#import "STextFieldWithTitle.h"
#import "ZJBLStoreShopTypeAlert.h"
#import "JGTextView.h"
@interface SendExpClassModel : NSObject
// 名称
@property (nonatomic, copy) NSString *name;
// id
@property (nonatomic, copy) NSString *kdgsid;
@end
@implementation SendExpClassModel

// 不同key值传值
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"kdgsid" : @"id"};
}
@end
@interface YTXDeliverGoodsViewController ()
{
    STextFieldWithTitle *kdName;// 快递名称
    SendExpClassModel *sendModel;
    JGTextView *kdNum;// 快递单号
}
// 数据数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@end

@implementation YTXDeliverGoodsViewController

- (void)viewDidLoad {
    self.title = @"发货单";
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithHexString:@"f6f6f6"];
    _dataArray = [NSMutableArray array];
    _nameArray = [NSMutableArray array];
    [self createViews];
    [self loadCategoryList];
    // Do any additional setup after loading the view.
}

- (void)loadCategoryList
{
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0"};
    kPrintLog(dict)
    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getexpress" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        [self.hudLoading hideAnimated:YES];
        _dataArray = [SendExpClassModel mj_objectArrayWithKeyValuesArray:responseObject];
        kPrintLog(_dataArray);
        for (SendExpClassModel *model in _dataArray) {
            [_nameArray addObject:model.name];
        }
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error){
        [self.hudLoading hideAnimated:YES];
    }];
}

- (void)createViews {
    
    UILabel * expidLabel = [[UILabel alloc]init];
    expidLabel.text = @"请选择快递名称:";
    expidLabel.textAlignment = NSTextAlignmentLeft;
    expidLabel.font = kFont(14);
    [self.view addSubview:expidLabel];
    [expidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(20);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    //快递公司
    kdName = [[STextFieldWithTitle alloc]init];
    kdName.title= @"";
    [kdName hyb_addCorner:UIRectCornerAllCorners cornerRadius:5];
    kdName.backgroundColor = kColore7e7e7;
    kdName.isBottom= NO;
//    kdName.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtName = kdName;
    kdName.didTapBlock = ^(){
        [ZJBLStoreShopTypeAlert showWithTitle:nil titles:_nameArray selectIndex:^(NSInteger selectIndex) {
            NSLog(@"选择了第%ld个",selectIndex);
            sendModel = _dataArray[selectIndex];
        } selectValue:^(NSString *selectValue) {
            NSLog(@"选择的值为%@",selectValue);
            weaktxtName.title = selectValue;
        } showCloseButton:NO];
    };
    [self.view addSubview:kdName];
    [kdName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(expidLabel);
        make.top.equalTo(expidLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
    
    UILabel * expNumLabel = [[UILabel alloc]init];
    expNumLabel.font = kFont(14);
    expNumLabel.textAlignment = NSTextAlignmentLeft;
    expNumLabel.text = @"请输入快递单号:";
    [self.view addSubview:expNumLabel];
    [expNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(kdName.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(30);
    }];
    kdNum = [[JGTextView alloc] init];
    kdNum.font = kFont(14);
    [kdNum hyb_addCorner:UIRectCornerAllCorners cornerRadius:5];
    kdNum.backgroundColor = kColore7e7e7;
    [self.view addSubview:kdNum];
    [kdNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(expNumLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(100);
    }];
    UIButton * commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:commitBtn];
    commitBtn.layer.cornerRadius = 5;
    [commitBtn setTitle:@"提交发货单" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(44);
        make.top.equalTo(kdNum.mas_bottom).offset(40);
        make.right.equalTo(self.view).offset(-20);
    }];
}

- (void)commitBtnAction {
    if (_orderID.length == 0) {
        [self showErrorHUDWithTitle:@"订单号异常请重试!" SubTitle:nil Complete:nil];
        return;
    }
    if (sendModel.name.length == 0) {
        [self showErrorHUDWithTitle:@"请选择物流名称!" SubTitle:nil Complete:nil];
        return;
    }
    if (kdNum.text.length==0) {
        [self showErrorHUDWithTitle:@"请输入物流单号！" SubTitle:nil Complete:nil];
        return;
    }
    
    NSDictionary * dict = @{
                            @"orderid" : _orderID,
                            @"expid" : sendModel.kdgsid,
                            @"expname" : sendModel.name,
                            @"expnum":kdNum.text,
                            @"uid" : [Global sharedInstance].userID?:@"0"
                            };
    kPrintLog(dict);
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpPostRequestWithActionName:@"sendgoods" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self showErrorHUDWithTitle:@"发货订单上传失败" SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"res"] boolValue]) {
                [self showOkHUDWithTitle:@"发货订单上传成功" SubTitle:nil Complete:nil];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });

            } else {
                [self showErrorHUDWithTitle:[responseObject objectForKey:@"msg"] SubTitle:nil Complete:nil];
            }
        } else {
            [self showErrorHUDWithTitle:@"发货订单上传失败" SubTitle:nil Complete:nil];
            
        }
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"发货订单上传失败" SubTitle:nil Complete:nil];
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
