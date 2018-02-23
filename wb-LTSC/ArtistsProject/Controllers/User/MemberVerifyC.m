//
//  MemberVerifyC.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/26.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "MemberVerifyC.h"
#import "AuthenticationModel.h"
#import "MemVeriCell.h"
#import "JGBusOppFirstViewCell.h"
#import "MemberInterduceModel.h"
#import "MemChargeVC.h"
#define kMemVeriCell   @"MemVeriCell"



@interface MemberVerifyC ()<UITableViewDelegate, UITableViewDataSource,JGBusOppFirstViewDelegate>
{
    NSArray *array;
    AuthenticationModel *model;
    NSString *verified;
    MemberInterduceModel *memModel;
}
// tableView
@property (nonatomic, strong) UITableView *tableView;
// 状态
@property (nonatomic, strong) UILabel *state;
// dataDic
@property (nonatomic, strong) NSMutableDictionary *dataDict;

@end

@implementation MemberVerifyC

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[MemVeriCell class] forCellReuseIdentifier:kMemVeriCell];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JGBusOppFirstViewCell class]) bundle:nil] forCellReuseIdentifier:@"JGCell"];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}
- (UILabel *)state
{
    if (!_state) {
        _state = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 40)];
        _state.backgroundColor = BACK_VIEW_COLOR;
        _state.textAlignment = NSTextAlignmentCenter;
        _state.adjustsFontSizeToFitWidth = YES;
        _state.numberOfLines = 0;
        _state.font = kFont(14);
    }
    return _state;
}
- (NSMutableDictionary *)dataDict
{
    if (!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc] init];
    }
    return _dataDict;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"会员认证";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
//    _tableView.tableHeaderView = self.state;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    [self loadMemberIntroduce];
}

- (void)loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID,@"type":@"16"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getUserAuth" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        kPrintLog(responseObject)
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        model = [AuthenticationModel mj_objectWithKeyValues:responseObject];
        array = [[model.verified componentsSeparatedByString:@","]mutableCopy];
        if (responseObject[@"res"]&&[responseObject[@"res"] integerValue] == 0) {
            verified = @"2";
            self.state.text = @"未提交认证";
        }else{
            verified = model.verified;
            switch (model.verified.intValue) {//用户认证状态
                case -1:{
                    _state.text= [NSString stringWithFormat:@"抱歉,已驳回 驳回原因：%@",model.reason];
                }break;
                case 0:{
                    self.view.userInteractionEnabled=YES;
                    _state.text = @"等待认证";
                }break;
                case 1:{
                    _state.text=@"恭喜您,已通过认证";
                }break;
                case 2:{
                    _state.text=@"未提交认证";
                }break;
                default:
                    break;
            }
        }
        [self.tableView reloadData];
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}
// 会员介绍
- (void)loadMemberIntroduce
{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"groupcontent" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        kPrintLog(responseObject)
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        memModel = [MemberInterduceModel mj_objectWithKeyValues:responseObject];
        [self.tableView reloadData];
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AuthenticationModel *model = array[indexPath.row];
//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"text" cellClass:[MemVeriCell class] contentViewWidth:[self cellContentViewWith]];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CGSize Size = [self sizeForLblContent:memModel.hyjs fixMaxWidth:kScreenWidth - 30 andFondSize:14];
            return Size.height > 100?Size.height:100;
            
        }else{
            CGSize Size = [self sizeForLblContent:memModel.hytq fixMaxWidth:kScreenWidth - 30 andFondSize:14];
            return Size.height > 100?Size.height:100;
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            CGSize calculateSize = [self sizeForLblContent:[self.dataDict objectForKey:@"realname"] fixMaxWidth:kScreenWidth - 73 andFondSize:14];
            if (calculateSize.height >=200) return 200;
            return calculateSize.height > 20 ? (calculateSize.height +  30) : 50;
        }else{
            CGSize calculateSize = [self sizeForLblContent:[self.dataDict objectForKey:@"phone"] fixMaxWidth:kScreenWidth - 73 andFondSize:14];
            if (calculateSize.height >=200) return 200;
            return calculateSize.height > 20 ? (calculateSize.height +  30) : 50;
        }
    }else{
        return 70;
    }
}
#pragma mark - JGBusOppFirstViewDelegate -
- (void)JGBusOppFirstViewTextViewDidChange:(NSString *)string andTableViewCell:(JGBusOppFirstViewCell *)cell{
    if ([cell.titleLbl.text isEqualToString:@"姓名"]) {
        [self.dataDict setObject:string forKey:@"realname"];
    }else if ([cell.titleLbl.text isEqualToString:@"手机号"]) {
        [self.dataDict setObject:string forKey:@"phone"];
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
}
// 通过给定文字和字体大小在指定的最大宽度下，计算文字实际所占的尺寸
- (CGSize)sizeForLblContent:(NSString *)strContent fixMaxWidth:(CGFloat)w andFondSize:(int)fontSize{
    // 先获取文字的属性，特别是影响文字所占尺寸相关的
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 把该属性放到字典中
    NSDictionary *dicAttr = [[NSDictionary alloc] initWithObjectsAndKeys:font,NSFontAttributeName, nil];
    // 通过字符串的计算文字所占尺寸方法获取尺寸
    CGSize size = [strContent boundingRectWithSize:CGSizeMake(w, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dicAttr context:nil].size;
    return size;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
//        if ([array.firstObject isEqualToString:@"2"]) {
            return 40;
//        }return 50;
//        return [array[section] isEqualToString:@"2"]?0:50;
    }else if (section == 1){
        return 40;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 40)];
    view.backgroundColor = BACK_VIEW_COLOR;
    label.font = kFont(14);
    [view addSubview:label];
    if (section == 1) {
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"会员资料";
        return view;
    }else if(section == 0){
        return self.state;
    }else{
        return nil;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([model.verified isEqualToString:@"0"]) {
        return 2;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MemVeriCell *cell = [tableView dequeueReusableCellWithIdentifier:kMemVeriCell forIndexPath:indexPath];
        if (indexPath.row == 0){
            cell.title.text = @"会员介绍";
            cell.content.text = memModel.hyjs;
        }else{
            cell.title.text = @"会员特权";
            cell.content.text = memModel.hytq;
        }
        return cell;
    }else if (indexPath.section == 1) {
        JGBusOppFirstViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JGCell" forIndexPath:indexPath];
        cell.JGBusOppFirstViewDelegate = self;
        if (indexPath.row == 0) {
            cell.titleLbl.text = @"姓名";
            cell.contentTextV.text = model.realname;
        }else {
            cell.titleLbl.text = @"手机号";
            cell.contentTextV.text = model.phone;
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
        }
        UIButton *comBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [comBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
        [comBtn setTintColor:[UIColor whiteColor]];
        [comBtn setBackgroundColor:[UIColor hexChangeFloat:@"3eb78a"]];
        comBtn.frame = CGRectMake(25, 30, kScreenW - 50, 40);
        [comBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:comBtn];
        return cell;
    }
}
- (void)commitBtnAction
{
    if (_dataDict[@"realname"]  == nil || [_dataDict[@"realname"] isEqualToString:@""]) {
        [self showErrorHUDWithTitle:@"姓名输入错误" SubTitle:nil Complete:nil];
        return;
    }
    if (![[Global sharedInstance]isValidateMobile:_dataDict[@"phone"]]) {
        [self showErrorHUDWithTitle:@"手机号码错误" SubTitle:nil Complete:nil];
        return;
    }
    [self commitUserInfo];
}

//加载用户信息
- (void)commitUserInfo{
    
    //1.设置请求参数
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setValue:[Global sharedInstance].userID forKey:@"uid"];
    [dict setValue:_dataDict[@"realname"] forKey:@"realname"];
    [dict setValue:_dataDict[@"phone"] forKey:@"phone"];
    [dict setValue:@"16" forKey:@"type"];
    kPrintLog(dict)
//    [ArtRequest PostRequestWithActionName:@"userauth" andPramater:dict succeeded:^(id responseObject) {
//        kPrintLog(responseObject)
//    } failed:^(id responseObject) {
//        kPrintLog(responseObject)
//    }];
    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"userauth" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        ResultModel *result=[ResultModel modelWithDictionary:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        MemChargeVC *chargeVC = [[MemChargeVC alloc] init];
        [self.navigationController pushViewController:chargeVC animated:YES];
    }andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        kPrintLog(error)
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        
    }else{
       
    }
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
