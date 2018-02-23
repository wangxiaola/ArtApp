//
//  ArtExpClassVC.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//



#import "ArtExpClassVC.h"

@interface ArtExpClassModel : NSObject

// 判断是否勾选
@property (nonatomic, assign) BOOL isSelect;
// 名称
@property (nonatomic, copy) NSString *name;
// id
@property (nonatomic, copy) NSString *czlbid;
@end
@implementation ArtExpClassModel

// 不同key值传值
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"czlbid" : @"id"};
}
@end

@interface ArtExpClassCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
// botview
@property (nonatomic, strong) UIView *botview;
// 按钮
@property (nonatomic, strong) UIButton *button;
// model
@property (nonatomic, strong) ArtExpClassModel *model;

@end

@implementation ArtExpClassCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 标题
        self.titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kFont(14);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .widthIs(100)
        .heightIs(25)
        .centerYEqualToView(self.contentView);
        // 按钮
        self.button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [self.contentView addSubview:_button];
        _button.sd_layout
        .rightSpaceToView(self.contentView, 15)
        .widthIs(30).heightEqualToWidth()
        .centerYEqualToView(self.contentView);
        // 底部视图
        
        _botview = [[UIView alloc] init];
        [self.contentView addSubview:_botview];
        _botview.sd_layout.rightEqualToView(self.contentView).leftEqualToView(self.contentView).bottomSpaceToView(self.contentView, 1)
        .heightIs(1);
        _botview.backgroundColor = BACK_VIEW_COLOR;
    }
    return self;
}

- (void)setModel:(ArtExpClassModel *)model
{
    _model = model;
    self.titleLabel.text = model.name;
    if (model.isSelect == YES) {
        [self.button setImage:ImageNamed(@"add_select") forState:(UIControlStateNormal)];
    }else{
        [self.button setImage:ImageNamed(@"add_unselect") forState:(UIControlStateNormal)];
    }
}

@end

@interface ArtExpClassVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray; // 数据数组
    NSMutableArray *selectClass; //选择种类
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ArtExpClassVC

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ArtExpClassCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"专家类型";
    self.view.backgroundColor = BACK_VIEW_COLOR;
    [self.view addSubview:self.tableView];
    UIBarButtonItem * RightBarButton=[[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btnSave)];
    self.navigationItem.rightBarButtonItem=RightBarButton;
    dataArray = [NSMutableArray array];
    selectClass = [NSMutableArray array];
    [self loadCategoryList];
}
- (void)loadCategoryList
{
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0"};
    kPrintLog(dict)
    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getczlb" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        [self.hudLoading hideAnimated:YES];
        dataArray = [ArtExpClassModel mj_objectArrayWithKeyValuesArray:responseObject];
        kPrintLog(dataArray);
        [self.tableView reloadData];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error){
        [self.hudLoading hideAnimated:YES];
    }];
}
- (void)btnSave
{
    NSMutableArray *nameArr = [NSMutableArray array];
    NSMutableArray *idArr = [NSMutableArray array];
    for (ArtExpClassModel *model in selectClass) {
        [nameArr addObject:model.name];
        [idArr addObject:model.czlbid];
    }
    NSString *nameStr = [nameArr componentsJoinedByString:@","];
    NSString *idStr = [idArr componentsJoinedByString:@","];
    kPrintLog(nameStr);
    kPrintLog(idStr);
    if(_saveBtnCilck){
        _saveBtnCilck(nameStr,idStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArtExpClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.button addTarget:self action:@selector(selectBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}

- (void)selectBtn:(UIButton *)button
{
    ArtExpClassCell *cell = (ArtExpClassCell *)button.superview.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    kPrintLog(indexPath)
    ArtExpClassModel *model = dataArray[indexPath.row];
    model.isSelect = !model.isSelect;
    if (cell.model.isSelect) {
        [cell.button setImage:ImageNamed(@"add_select") forState:(UIControlStateNormal)];
        [selectClass addObject:dataArray[indexPath.row]];
    }else{
        [cell.button setImage:ImageNamed(@"add_unselect") forState:(UIControlStateNormal)];
        [selectClass removeObject:dataArray[indexPath.row]];
    }
    kPrintLog(selectClass);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
