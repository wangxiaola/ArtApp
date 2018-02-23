//
//  YTXOpenAuthentication.m
//  ShesheDa
//
//  Created by 贾卯 on 2016/12/21.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXOpenAuthentication.h"
#import "H5VC.h"
#import "AuthenticationModel.h"
@interface YTXOpenAuthentication ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *array;
}

@property (nonatomic, strong) UITableView * tableView;

@end

@implementation YTXOpenAuthentication

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请合作";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource  = self;
    _tableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];
//    [self loadData];
}

-(void)loadData{
    
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getUserAuth" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        
        AuthenticationModel* model=[AuthenticationModel mj_objectWithKeyValues:responseObject];

        array = [model.type componentsSeparatedByString:@","];
        
        [self.tableView reloadData];
    
        
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setFont:[UIFont systemFontOfSize:16.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.0]];
        
    }
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"艺术家功能";
        if ([array containsObject:@"2"]) {
            cell.detailTextLabel.text = @"已开通";
        }else{
            cell.detailTextLabel.text = @"未开通";
        }
        
    }
    else if (indexPath.section == 1) {
        
        cell.textLabel.text = @"鉴定功能";
        if ([array containsObject:@"1"]) {
            cell.detailTextLabel.text = @"已开通";
        }else{
            cell.detailTextLabel.text = @"未开通";
        }
        
        
    }
    else{
        
        cell.textLabel.text = @"销售功能";
        if ([array containsObject:@"4"]) {
            cell.detailTextLabel.text = @"已开通";
        }else{
            cell.detailTextLabel.text = @"未开通";
        }
        
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {


    }else if (indexPath.section == 1){

    }else{

    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = section;
    [btn setTitle:@"查看介绍" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [btn addTarget:self action:@selector(pushIntroduction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setFrame:CGRectMake(10, 5, 60, 20)];
    [view addSubview:btn];
    return view;
}

- (void)pushIntroduction:(UIButton*)send
{
    switch (send.tag) {
        case 0:
        {
            H5VC* h5 = [[H5VC alloc] init];
            h5.navTitle = @"艺术家功能";
            h5.url = @"http://www.artart.cn/huodong/app/artist.html";
            [self.navigationController pushViewController:h5 animated:YES];

        }
            break;
        case 1:
        {
            H5VC* h5 = [[H5VC alloc] init];
            h5.navTitle = @"鉴定功能";
            h5.url = @"http://www.artart.cn/huodong/app/jianding.html";
            [self.navigationController pushViewController:h5 animated:YES];
            
        }
            break;
        case 2:
        {
            H5VC* h5 = [[H5VC alloc] init];
            h5.navTitle = @"销售功能";
            h5.url = @"http://www.artart.cn/huodong/app/sale.html";
            [self.navigationController pushViewController:h5 animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

@end
