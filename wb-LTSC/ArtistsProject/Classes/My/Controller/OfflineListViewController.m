//
//  OfflineListViewController.m
//  meishubao
//
//  Created by LWR on 2017/3/1.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "OfflineListViewController.h"
#import "MSBArticleDetailController.h"
#import "GeneralConfigure.h"
#import "MSBArticleDetailModel.h"
#import "OfflineReadViewController.h"

@interface OfflineListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *titleArr;

@end

@implementation OfflineListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1, 初始化
    [self setup];
    
    // 2, 获取数据
    [self.titleArr addObjectsFromArray:self.termArr];
    for (ArticleCategoryModel *model in self.termArr) {
        
        NSArray *arr = [MSBArticleDetailModel searchWithWhere:@{@"term_id" : model.term_id} orderBy:nil offset:0 count:0];
        if (arr.count != 0) {
            
            [self.dataSource addObject:arr];
        }else {
        
            [self.titleArr removeObject:model];
        }
    }
    [self.tableView reloadData];
}

- (void)setup {

    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新下载" style:UIBarButtonItemStylePlain target:self action:@selector(reLoad)];
    
    UIImage *image = [UIImage imageNamed:@"navigation_back"];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:image style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem= backButton;
}

- (void)doBack {

    [self.navigationController popToViewController:self.settingVC animated:YES];
}

#pragma mark - 重新加载
- (void)reLoad {

    // 清除表格数据
    [LKDBHelper clearTableData:[MSBArticleDetailModel class]];
    
    NSString *filePath = [kDocumentsPath stringByAppendingString:@"/termArr.data"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        OfflineReadViewController *lineRead = [[OfflineReadViewController alloc] init];
        lineRead.settingVC = self.settingVC;
        [self.navigationController pushViewController:lineRead animated:YES];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource[section] == nil ? 0 : [self.dataSource[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 32.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32.0)];
    headerV.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xE8E8E8, 0x202020);
    if (!section) {
        
        UILabel *downedLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, 32.0)];
        downedLab.text = @"已经为您下载:";
        downedLab.font = [UIFont systemFontOfSize:10.0];
        downedLab.textColor = RGBCOLOR(98, 98, 98);
        [headerV addSubview:downedLab];
    }
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(114, 0, SCREEN_WIDTH - 128, 32.0)];
    ArticleCategoryModel *model = self.titleArr[section];
    titleLab.text = model.name;
    titleLab.font = [UIFont systemFontOfSize:10.0];
    titleLab.textColor = RGBCOLOR(98, 98, 98);
    titleLab.textAlignment = NSTextAlignmentRight;
    [headerV addSubview:titleLab];
    
    return headerV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cell_id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    MSBArticleDetailModel *model = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = model.post_title;
    cell.textLabel.dk_textColorPicker = DKColorSwiftWithRGB(0x000000, 0x989898);
    cell.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xffffff, 0x222222);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MSBArticleDetailController *detailVC = [[MSBArticleDetailController alloc] init];
    MSBArticleDetailModel *model         = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
    detailVC.articleModel                = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)titleArr {

    if (!_titleArr) {
        
        _titleArr = [[NSMutableArray alloc] init];
    }
    return _titleArr;
}

- (UITableView *)tableView {

    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.dk_backgroundColorPicker = DKColorSwiftWithRGB(0xDCDCDC, 0x1c1c1c);
        _tableView.dk_separatorColorPicker  = DKColorSwiftWithRGB(0xe7e7e7, 0x454545);
        
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    return _tableView;
}

@end
