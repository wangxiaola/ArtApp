//
//  YTXOrderConfirmViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderConfirmViewController.h"
#import "YTXOrderConfirmTableViewCell.h"
#import "YTXAddressListViewController.h"
#import "YTXGoodsModel.h"
#import "PayNewVC.h"

@interface YTXOrderConfirmViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) YTXOrderConfirmViewModel * viewModel;
@property (nonatomic, assign) NSInteger buyCount;

@end

@implementation YTXOrderConfirmViewController

- (void)viewDidLoad {
    self.title = @"确认订单";
    [super viewDidLoad];
    [self.tableView reloadData];
    _buyCount = 1;
    self.viewModel = [YTXOrderConfirmViewModel modelWithGoodsModel:_goodsModel addressModel:[Global sharedInstance].addressModel];
    self.view.backgroundColor = ColorHex(@"f6f6f6");
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
//    [(HNavigationBar*)self.navigationController.navigationBar setNavigationBarWithColor:[UIColor colorWithHexString:@"#C4B173"]];
}

#pragma mark - Private Methods

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTXOrderConfirmTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXOrderConfirmTableViewCell];
    __weak typeof(self)weakSelf = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectAddressActionBlock = ^{
        YTXAddressListViewController * vc = [[YTXAddressListViewController alloc]init];
        vc.didSelectAddress = ^(YTXAddressViewModel * viewModel){
            //修改地址
            weakSelf.viewModel = [YTXOrderConfirmViewModel modelWithGoodsModel:weakSelf.goodsModel addressModel:viewModel.model];
            [weakSelf.tableView reloadData];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    cell.confirmOrderActionBlock = ^{
        __weak typeof(self)weakSelf = self;
        [weakSelf addGoodsOrder];
    };
    cell.buyCountChangeAction = ^(NSInteger buyCount){
        weakSelf.buyCount = buyCount;
    };
    cell.model = self.viewModel;
    return cell;
}

#pragma mark - FetchData
//下单
- (void)addGoodsOrder {
    if (![self isLogin]) {
        return;
    }if (![[Global sharedInstance]addressModel]) {
        [self showErrorHUDWithTitle:@"请设置收货信息" SubTitle:nil Complete:nil];
        return;
    }
    [self showLoadingHUDWithTitle:@"正在下单" SubTitle:nil];

    NSDictionary * dict = @{
                            @"uid" : [Global sharedInstance].userID,
                            @"goods_id" : self.goodsModel.gid,
                            @"goods_name" : self.goodsModel.topictitle,
                            @"count" : [NSString stringWithFormat:@"%d",(int)_buyCount],
                            @"allcoin" : [NSString stringWithFormat:@"%.2f",_buyCount * self.goodsModel.sellprice.floatValue],
                            @"yunfei" : self.goodsModel.yunfei,
                            @"consignee" : self.viewModel.name,
                            @"phone" : self.viewModel.phone,
                            @"addr" : self.viewModel.address,
                            @"addtime" : [NSDate date],
                            @"status" : @"0",
                            @"type" : @"2",
                            @"maiuid" : self.goodsModel.user.uid,
                            @"photo" : self.viewModel.imageURL.absoluteString
                            };
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpPostRequestWithActionName:@"addgoodsorder" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([[responseObject objectForKey:@"res"] boolValue]) {
                PayNewVC * vc = [[PayNewVC alloc]init];
                vc.tjdd = @"tijiaodingdan";//提交订单页面进入
                vc.uID = [NSString stripNullWithString:[responseObject objectForKey:@"id"]];
                vc.money = [NSString stringWithFormat:@"%.2f",_buyCount * self.goodsModel.sellprice.floatValue + [self.goodsModel.yunfei integerValue]];
                vc.state = @"4";
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            [self showErrorHUDWithTitle:@"服务器异常，请重试!" SubTitle:nil Complete:nil];
        }
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self.hudLoading hide:YES];
    }];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.rowHeight = kScreenH - 64;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [_tableView registerNib:[UINib nibWithNibName:kYTXOrderConfirmTableViewCell bundle:nil] forCellReuseIdentifier:kYTXOrderConfirmTableViewCell];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
