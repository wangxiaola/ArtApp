//
//  YTXOrderListViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/14.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderListViewController.h"
#import "UIScrollView+YTXRefreshControl.h"
#import "YTXOrderViewModel.h"
#import "YTXOrderListTableViewCell.h"
#import "YTXOrderDetailViewController.h"
#import "PayNewVC.h"
#import "YTXReceivedViewController.h"
#import "YTXCancelOrderViewController.h"
#import "YTXDeliverGoodsViewController.h"
#import "YTXEvaluteOrderViewController.h"
@interface YTXOrderListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * mArrayOrder;

@end

@implementation YTXOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _mArrayOrder = @[].mutableCopy;
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
//    [self fetchOrderList];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchOrderList];
}


#pragma mark - Fetch Data

- (void)fetchOrderList {
    if (![self isLogin]) {
        return;
    }
    NSDictionary * dict = @{
                            @"uid" : [Global sharedInstance].userID,
                            @"type" : _orderType,
                            @"page" : @(_page),
                            @"num" : @"10"
                            };
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"getgoodsorder" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self reloadData];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            if (_page == 1) {
                [_mArrayOrder removeAllObjects];
            }
            if ([(NSArray *)responseObject count] < 5) {
                [self.tableView endRefreshingWithNoMoreData];
            }
            kPrintLog(responseObject)
            for (NSDictionary * dict in responseObject) {
                YTXOrderModel * model = [YTXOrderModel modelWithDictionary:dict];
                model.type = _orderType;
                YTXOrderViewModel * viewModel = [YTXOrderViewModel modelWithOrderModel:model];
                [_mArrayOrder addObject:viewModel];
            }
        }
        [self reloadData];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self reloadData];
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
    }];
}

- (void)reloadData {
    [self.tableView reloadData];
    [self.tableView endRefreshing];
    [self.hudLoading hide:YES];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _mArrayOrder.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTXOrderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXOrderListTableViewCell];
    YTXOrderViewModel * model = [_mArrayOrder objectOrNilAtIndex:indexPath.row];
    cell.model = model;
    __weak typeof(self)weakSelf = self;;
    cell.btnActionBlock = ^(NSString * btnTitle) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if ([btnTitle isEqualToString:@"去支付"]) {
            PayNewVC * vc = [[PayNewVC alloc]init];
            vc.uID = model.orderID;
            vc.state = @"4";// 商品支付
            vc.money = [NSString stringWithFormat:@"%.2f",[model.price floatValue] + [model.yunfei floatValue]];
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"追评"]) {
            YTXEvaluteOrderViewController *vc= [[YTXEvaluteOrderViewController alloc] init];
            vc.orderID = model.orderID;
            vc.orderType = @"2";// 买家
//            vc.replyid = model.replyuid;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"申请售后"]) {
            
        } else if([btnTitle isEqualToString:@"确认收货"]) {
            YTXReceivedViewController * vc = [[YTXReceivedViewController alloc]init];
            vc.orderID = model.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"取消订单"]) {
            YTXCancelOrderViewController * vc = [[YTXCancelOrderViewController alloc]init];
            vc.orderID = model.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"待支付"]) {
            
        } else if([btnTitle isEqualToString:@"待收货"]) {
            YTXDeliverGoodsViewController * vc = [[YTXDeliverGoodsViewController alloc]init];
            vc.orderID = model.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"处理售后"]) {
            
        } else if([btnTitle isEqualToString:@"回评"]) {
            YTXEvaluteOrderViewController *vc= [[YTXEvaluteOrderViewController alloc] init];
            vc.orderID = model.orderID;
            vc.orderType = @"1";// 卖家
//            vc.replyid = model.replyuid;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"发货"]) {
            YTXDeliverGoodsViewController * vc = [[YTXDeliverGoodsViewController alloc]init];
            vc.orderID = model.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YTXOrderViewModel * model = [_mArrayOrder objectOrNilAtIndex:indexPath.row];
    YTXOrderDetailViewController * vc = [[YTXOrderDetailViewController alloc]init];
    vc.orderID = model.orderID;
    vc.orderType = _orderType; // 买入和卖出的类型判断
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [self fetchOrderList];
}

#pragma mark - Getter

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        __weak typeof(self)weakSelf = self;
        [_tableView headerRefreshingWithBlock:^{
            weakSelf.page = 1;
            [self fetchOrderList];
        }];
        _tableView.rowHeight = 150;
        [_tableView footerRefreshingWithBlock:^{
            weakSelf.page++;
            [self fetchOrderList];
        }];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [_tableView registerNib:[UINib nibWithNibName:kYTXOrderListTableViewCell bundle:nil] forCellReuseIdentifier:kYTXOrderListTableViewCell];
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
