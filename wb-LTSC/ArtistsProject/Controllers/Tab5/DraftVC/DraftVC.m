//
//  DraftVC.m
//  ShesheDa
//
//  Created by chen on 16/7/17.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "DraftVC.h"
#import "DraftCell.h"
//#import "OnlineIdentificationVC.h"

@interface DraftVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    UITableView *tableview;
    NSMutableArray *arrayTab;
}

@end

@implementation DraftVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"草稿";
    //创建tableview
    tableview=[[UITableView alloc]init];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.tableFooterView=[UIView new];
    [self.view addSubview:tableview];
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self upDataTab];
}

-(void)upDataTab{
    arrayTab=[[[TMCache sharedCache] objectForKey:@"caogao"] mutableCopy];
    if (arrayTab.count<1) {
        tableview.emptyDataSetDelegate=self;
        tableview.emptyDataSetSource=self;
    }
    [tableview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayTab.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    OnlineIdentificationVC *vc=[[OnlineIdentificationVC alloc]init];
//    NSDictionary *dicIndex=arrayTab[indexPath.row];
//    vc.dicNow=dicIndex;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier=@"MyCouponCell";
    DraftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[DraftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.dic=arrayTab[indexPath.row];
    return cell;
}

//设置编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [tableview setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        NSDictionary *dicClick=arrayTab[indexPath.row];
        NSLog(@"%@",dicClick);
        [[Global sharedInstance] delCaoGao:[dicClick objectForKey:@"id"]];
        [self upDataTab];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

/**
 *  补全分割线方法
 */
- (void)viewDidLayoutSubviews
{
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPat
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

#pragma mark - DZNEmptyDataSetSource Methods

//- (UIImage*) buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
//{
//    return [UIImage imageNamed:@"icon_Default_Refresh"];
//}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"bg_noData"];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}
@end
