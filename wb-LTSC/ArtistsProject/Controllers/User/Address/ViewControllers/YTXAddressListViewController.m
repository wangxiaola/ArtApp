//
//  YTXAddressListViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/11/12.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXAddressListViewController.h"
#import "YTXAddAddressViewController.h"
#import "YTXAddressTableViewCell.h"
#import "YTXAddressViewModel.h"

@interface YTXAddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * mArrayAddress;

@property (nonatomic, strong) UIButton * addAddressBtn;

@end

@implementation YTXAddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noDataMode = HNoDataModeDefault;
    
    self.title = @"收货信息";
    [self fetchAddressInfo];
    [self addAddressBtn];
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    _mArrayAddress = @[].mutableCopy;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
//    [(HNavigationBar*)self.navigationController.navigationBar setNavigationBarWithColor:[UIColor colorWithHexString:@"#C4B173"]];
    
    if(self.tableView){
        [self fetchAddressInfo];
    }
}

#pragma mark - Private methods

- (void)addAction {
    YTXAddAddressViewController * vc = [[YTXAddAddressViewController alloc]init];
    vc.isSetDefault = _mArrayAddress.count == 0;//地址为0的时候设置的第一个地址为默认地址
    __weak typeof(self)weakSelf = self;
    vc.didAddSucessBlock = ^(NSArray * addresses){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.mArrayAddress = addresses.mutableCopy;
        [strongSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Fetct Data

- (void)fetchAddressInfo {
    if (![self isLogin]) {
        return;
    }
    NSDictionary * dict = @{
                            @"uid" : [NSString stripNullWithString:[Global sharedInstance].userID]
                            };
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [request httpGetRequestWithActionName:@"getaddress" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        [self reloadData];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [_mArrayAddress removeAllObjects];
            for (NSDictionary * dict in responseObject) {
                YTXAddressModel * model = [YTXAddressModel modelWithDictionary:dict];
                if ([model.defaultStr isEqualToString:@"1"]) {
                    [Global sharedInstance].addressModel = model;
                    YTXAddressViewModel * viewModel = [YTXAddressViewModel modelWithAddressModel:model];
                    [_mArrayAddress insertObject:viewModel atIndex:0];
                } else {
                    YTXAddressViewModel * viewModel = [YTXAddressViewModel modelWithAddressModel:model];
                    [_mArrayAddress addObject:viewModel];
                }
            }
        }
        [self reloadData];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        [self reloadData];
    }];
}

- (void)deleteWithAddressID:(NSString *)addressID atIndex:(NSInteger) row{
    HHttpRequest * request = [[HHttpRequest alloc]init];
    [self showLoadingHUDWithTitle:@"正在删除" SubTitle:nil];
    NSDictionary * dict = @{
                            @"uid" : [NSString stripNullWithString:[Global sharedInstance].userID],
                            @"id" : addressID
                            };
    [request httpPostRequestWithActionName:@"deladdress" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self showErrorHUDWithTitle:@"删除失败" SubTitle:nil Complete:nil];
        [self reloadData];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [_mArrayAddress removeObjectAtIndex:row];
        [self showErrorHUDWithTitle:@"删除成功" SubTitle:nil Complete:nil];
        [self reloadData];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self showErrorHUDWithTitle:@"删除失败" SubTitle:nil Complete:nil];
        [self reloadData];
    }];

}

- (void)reloadData {
    [self.hudLoading hide:YES];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _mArrayAddress.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTXAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kYTXAddressTableViewCell];
    YTXAddressViewModel * model = [_mArrayAddress objectOrNilAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        model.isDefault = YES;
    } else {
        model.isDefault = NO;
    }
    cell.model = model;
    __weak typeof(self)weakSelf = self;
    cell.editBtnAcionBlock = ^{
        YTXAddAddressViewController * vc = [[YTXAddAddressViewController alloc]init];
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTXAddressViewModel * model = [_mArrayAddress objectOrNilAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        model.isDefault = YES;
    } else {
        model.isDefault = NO;
    }
    return [YTXAddressTableViewCell heightForViewModel:model];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    YTXAddressViewModel * model = [_mArrayAddress objectOrNilAtIndex:indexPath.row];

    // 置顶删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self deleteWithAddressID:model.aid atIndex:indexPath.row];
    }];
    return @[deleteRowAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_didSelectAddress) {
        _didSelectAddress([_mArrayAddress objectOrNilAtIndex:indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DZNEmptyDataSetDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [self fetchAddressInfo];
}

#pragma mark - Getter

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource  = self;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
        [_tableView registerNib:[UINib nibWithNibName:kYTXAddressTableViewCell bundle:nil] forCellReuseIdentifier:kYTXAddressTableViewCell];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIButton *)addAddressBtn {
    if (!_addAddressBtn) {
        _addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addAddressBtn setTitle:@"+ 新增地址" forState:UIControlStateNormal];
        [_addAddressBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        _addAddressBtn.layer.cornerRadius = 5.0f;
        [_addAddressBtn setBackgroundColor:[UIColor colorWithHexString:@"D49D66"]];
        [self.view addSubview:_addAddressBtn];
        [_addAddressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.bottom.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(44);
        }];
    }
    return _addAddressBtn;
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
