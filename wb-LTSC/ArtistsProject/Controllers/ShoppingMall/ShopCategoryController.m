//
//  ShopCategoryController.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/17.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ShopCategoryController.h"
#import "ArtApplyCell.h"
#import "GoodsCategoryModel.h"

@interface ShopCategoryController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *titleArray;
}
@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic, strong)NSMutableArray<GoodsCategoryModel *> *goodsCategorys;

@end

@implementation ShopCategoryController
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ArtApplyCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
- (NSMutableArray<GoodsCategoryModel *> *)goodsCategorys
{
    if (!_goodsCategorys) {
        _goodsCategorys = [[NSMutableArray alloc] init];
    }
    return _goodsCategorys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    self.title = @"商品类别";
    titleArray = [NSMutableArray array];
    [self getShopCategoryList];
    [self.view addSubview:self.tableView];
}

- (void)getShopCategoryList
{
    [self showLoadingHUDWithTitle:@"正在加载" SubTitle:nil];
    [ArtRequest GetRequestWithActionName:@"goodstype" andPramater:nil succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [self hideHUD];
        [self.goodsCategorys addObjectsFromArray:[GoodsCategoryModel mj_objectArrayWithKeyValuesArray:(NSArray *)responseObject]];
        [self.tableView reloadData];
    } failed:^(id responseObject) {
        [self hideHUD];
    }];
}
- (void)hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - tableViewDelegate , dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.goodsCategorys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArtApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.goodsCategorys[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.title.text = self.goodsCategorys[indexPath.row].title;
    }else{
        GoodsCategoryModel *model = self.goodsCategorys[indexPath.row];
        if (model.cname) {
            cell.title.text = model.cname;
        }else{
            cell.title.text = model.title;
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtApplyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            //数据处理
    GoodsCategoryModel *model = self.goodsCategorys[indexPath.row];
    [titleArray addObject:model.title];
    if (model.child) {
        NSArray <GoodsCategoryModel *>*childArray = model.child;
        [self.goodsCategorys removeAllObjects];
        [self.goodsCategorys addObjectsFromArray:childArray];
                //处理tableview
        [self.tableView reloadData];
    }else{
        NSString *string = [titleArray componentsJoinedByString:@","];
        if(_saveBtnCilck){
            _saveBtnCilck(string,model.goods_id);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
