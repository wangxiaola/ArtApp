//
//  YTXOrderDetailViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/15.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOrderDetailViewController.h"
#import "UIScrollView+YTXRefreshControl.h"
#import "YTXOrderViewModel.h"
#import "YTXOrderListTableViewCell.h"
#import "YTXOrderModel.h"
#import "PayNewVC.h"
#import "YTXReceivedViewController.h"
#import "YTXCancelOrderViewController.h"
#import "YTXDeliverGoodsViewController.h"
#import "YTXEvaluteOrderViewController.h"
#import "YTXOrderOperateDetailCell.h"
@interface YTXOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) YTXOrderViewModel * viewModel;

@end

@implementation YTXOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchDetailOrder];
}
- (void)fetchDetailOrder {
    NSDictionary * dict = @{
                            @"orderid" : _orderID
                            };
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"ordercontent" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            YTXOrderModel * model = [YTXOrderModel modelWithDictionary:responseObject];
            model.type = _orderType;// 买入和卖出的类型判断
            _viewModel = [YTXOrderViewModel modelWithOrderModel:model];
        }
        [self.tableView reloadData];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return [YTXOrderOperateDetailCell getCellNumberWithModel:_viewModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    YTXOrderListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXOrderListTableViewCell forIndexPath:indexPath];
    cell.model = _viewModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __weak typeof(self)weakSelf = self;;
    cell.btnActionBlock = ^(NSString * btnTitle) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if ([btnTitle isEqualToString:@"去支付"]) {
            PayNewVC *vc = [[PayNewVC alloc]init];
            vc.uID = strongSelf.viewModel.orderID;
            vc.money = strongSelf.viewModel.price;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"追评"]) {
            YTXEvaluteOrderViewController *vc= [[YTXEvaluteOrderViewController alloc] init];
            vc.orderID = _viewModel.orderID;
            vc.orderType = @"2";// 买家
            vc.replyid = _viewModel.huiping;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"申请售后"]) {
            
        } else if([btnTitle isEqualToString:@"确认收货"]) {
            YTXReceivedViewController * vc = [[YTXReceivedViewController alloc]init];
            vc.orderID = strongSelf.viewModel.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"取消订单"]) {
            YTXCancelOrderViewController * vc = [[YTXCancelOrderViewController alloc]init];
            vc.orderID = strongSelf.viewModel.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"待支付"]) {
            
        } else if([btnTitle isEqualToString:@"待收货"]) {
            YTXDeliverGoodsViewController * vc = [[YTXDeliverGoodsViewController alloc]init];
            vc.orderID = strongSelf.viewModel.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"处理售后"]) {
            
        }else if([btnTitle isEqualToString:@"回评"]) {
            YTXEvaluteOrderViewController *vc= [[YTXEvaluteOrderViewController alloc] init];
            vc.orderID = _viewModel.orderID;
            vc.orderType = @"1";// 卖家
            vc.replyid = _viewModel.huiping;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        } else if([btnTitle isEqualToString:@"发货"]) {
            YTXDeliverGoodsViewController * vc = [[YTXDeliverGoodsViewController alloc]init];
            vc.orderID = strongSelf.viewModel.orderID;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
    }else{
        YTXOrderOperateDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [YTXOrderListTableViewCell getCellHeightWithModel:_viewModel];
    }else{
        if (indexPath.row == 0) {
            if (_viewModel.payTime.doubleValue > 0) {
                return [YTXOrderOperateDetailCell getCellHeightWithText:[NSString stringWithFormat:@"支付金额:%.2f",[_viewModel.price floatValue]/100]];
            }else{
                return [YTXOrderOperateDetailCell getCellHeightWithText:[NSString stringWithFormat:@"取消原因:%@",_viewModel.reason]];
            }
        }else if (indexPath.row == 1) {
            return [YTXOrderOperateDetailCell getCellHeightWithText:[NSString stringWithFormat:@"快递:%@\n单号:%@",_viewModel.expname,_viewModel.expnum]];
        }else if (indexPath.row == 2) {
            return [YTXOrderOperateDetailCell getCellHeightWithText:_viewModel.reason];
        }else if (indexPath.row == 0) {
            if (_viewModel.payTime > 0) {
                return [YTXOrderOperateDetailCell getCellHeightWithText:_viewModel.price];
            }else{
                return [YTXOrderOperateDetailCell getCellHeightWithText:_viewModel.reason];
            }
        }else if (indexPath.row == 0) {
            if (_viewModel.payTime > 0) {
                return [YTXOrderOperateDetailCell getCellHeightWithText:_viewModel.price];
            }else{
                return [YTXOrderOperateDetailCell getCellHeightWithText:_viewModel.reason];
            }
        }else if (indexPath.row == 0) {
            if (_viewModel.payTime > 0) {
                return [YTXOrderOperateDetailCell getCellHeightWithText:_viewModel.price];
            }else{
                return [YTXOrderOperateDetailCell getCellHeightWithText:_viewModel.reason];
            }
        }else{
            return 10;
        }
    }
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
        _tableView.rowHeight = kScreenH - 64;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [_tableView registerNib:[UINib nibWithNibName:kYTXOrderListTableViewCell bundle:nil] forCellReuseIdentifier:kYTXOrderListTableViewCell];
        [_tableView registerClass:[YTXOrderOperateDetailCell class] forCellReuseIdentifier:@"cell"];
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
