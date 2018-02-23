//
//  ArtSelectVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtSelectVc.h"
#import "ArtSelectCell.h"

@interface ArtSelectVc ()
@property(nonatomic,strong)NSMutableArray* kindArr;
@property(nonatomic,strong)NSMutableArray* selectArr;
@end

@implementation ArtSelectVc

-(void)createView{
    [super createView];
    self.tabView.backgroundColor =  BACK_CELL_COLOR;
    self.tabView.tableFooterView = [UIImageView new];
    [self.tabView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _kindArr = [[NSMutableArray alloc]init];
    _selectArr = [[NSMutableArray alloc]init];
    UIButton* btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 2, 60, 40);
   btn.titleLabel.font = [UIFont systemFontOfSize:18],
    [btn setTitleColor:kTitleColor forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar;
}
-(void)loadData{
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":@""};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:self.acStr andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [_kindArr addObjectsFromArray:responseObject];            
            [self.tabView reloadData];
        }
        
    }andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _kindArr.count>0?_kindArr.count:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ArtSelectCell"];
    if (cell==nil) {
        cell = [[ArtSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ArtSelectCell"];
    }
    cell.addSelectBlock = ^(NSInteger index){
        [_selectArr addObject:_kindArr[index]];
    };
    cell.deleteSelectBlock =  ^(NSInteger index){
        [_selectArr removeObject:_kindArr[index]];
    };

    NSDictionary* dic = _kindArr[indexPath.row];
    for (NSDictionary* dic1 in _selectArr) {
        if ([dic isEqual:dic1]) {
            cell.selectBtn.selected = YES;
        }else{
            cell.selectBtn.selected = NO;
        }
    }
    cell.tag = indexPath.row;
    if ([self.acStr isEqualToString:@"getshoptype"]) {
        [cell setSelectCellDic:dic];
    }else{
    [cell  setArtTableViewCellDicValue:dic];
    }
    return cell;
}

-(void)rightBtn{
    
    if (self.selectBlock) {
        self.selectBlock(_selectArr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
