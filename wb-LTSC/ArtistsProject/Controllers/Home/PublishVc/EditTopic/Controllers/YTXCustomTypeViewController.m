//
//  YTXCustomTypeViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/19.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXCustomTypeViewController.h"
#import "YTXCustomTypeInputViewController.h"

@interface YTXCustomTypeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *customTypeList;

@end

@implementation YTXCustomTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    switch (_customType) {
        case CUSTOM_TYPE_WORKS_CLASS: {
            self.title = @"选择分类";
            _customTypeList = [[NSMutableArray alloc] init];
            [self getalbum];
            break;
        }
        case CUSTOM_TYPE_CAMERA_CLASS: {
            self.title = @"选择分类";
            _customTypeList = [[NSMutableArray alloc] init];
            [self getalbum];
            break;
        }
        case CUSTOM_TYPE_OTHERS_CLASS: {
            _customTypeList = [[NSMutableArray alloc] initWithArray:@[@"艺术年表",@"重要展览",@"收藏拍卖",@"荣誉奖项",@"公益捐赠",@"出版著作"]];
            break;
        }
        case CUSTOM_TYPE_AGE:
            self.title = @"选择年代";
            _customTypeList = @[@"2017",@"2016",@"2015",@"2014",@"2013",@"2012",@"2011",@"2010",@"2009",@"2008",@"2007",@"2006",@"2005",@"2004",@"2003",@"2002",@"2001",@"2000",@"90年代",@"80年代",@"70年代"].mutableCopy;
            break;
        case CUSTOM_TYPE_SIZE:
            self.title = @"选择尺寸";
            _customTypeList = @[@"长cm",@"宽cm",@"高cm"].mutableCopy;
            break;
        case CUSTOM_TYPE_COMMENT:
            _customTypeList = [[NSMutableArray alloc] initWithArray:@[@"咖们说|comments"]];
            [self getalbum];
            break;
    }

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        if (CUSTOM_TYPE_WORKS_CLASS == _customType || CUSTOM_TYPE_CAMERA_CLASS == _customType) {
            make.bottom.mas_equalTo(-50);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    
    if (_customType == CUSTOM_TYPE_WORKS_CLASS || _customType == CUSTOM_TYPE_CAMERA_CLASS || _customType == CUSTOM_TYPE_COMMENT) {
        UIButton *addTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addTypeBtn.backgroundColor = [UIColor blackColor];
        [addTypeBtn setTitle:@"新增分类" forState:UIControlStateNormal];
        [addTypeBtn addTarget:self action:@selector(addNewType) forControlEvents:UIControlEventTouchUpInside];
        [addTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:addTypeBtn];
        [addTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.bottom.and.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    
    if (_customType == CUSTOM_TYPE_SIZE) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okAction)];
    }
}

- (void)getalbum
{
    NSDictionary *dic = @{
                          @"uid" : [Global sharedInstance].userID,
                          @"type" : (_customType == CUSTOM_TYPE_CAMERA_CLASS ? @"2" : (_customType == CUSTOM_TYPE_COMMENT ? @"3" : @"1"))
                          };
    __weak typeof(self)weakSelf = self;
    [ArtRequest GetRequestWithActionName:@"getalbum" andPramater:dic succeeded:^(id responseObject) {
        [self.hudLoading hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *msg = responseObject[@"msg"];
            [weakSelf showErrorHUDWithTitle:msg SubTitle:nil Complete:nil];
        } else if ([responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf.customTypeList removeAllObjects];
            for (NSDictionary *dic in responseObject) {
                [weakSelf.customTypeList addObject:dic];
            }
            [weakSelf.tableView reloadData];
        }

        
    } failed:^(id responseObject) {
         [weakSelf showErrorHUDWithTitle:@"获取数据失败" SubTitle:nil Complete:nil];
    }];
}

- (void)addalbumWithName:(NSString *)name
{
    NSDictionary *dic = @{
                          @"uid" : [Global sharedInstance].userID,
                          @"name" : name,
                          @"type" : (_customType == CUSTOM_TYPE_CAMERA_CLASS ? @"2" : (_customType == CUSTOM_TYPE_COMMENT ? @"3" : @"1"))
                          };
    __weak typeof(self)weakSelf = self;
    [ArtRequest PostRequestWithActionName:@"addalbum" andPramater:dic succeeded:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *msg = responseObject[@"msg"];
            [weakSelf showErrorHUDWithTitle:msg SubTitle:nil Complete:nil];
        } else if ([responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf getalbum];
        }

    } failed:^(id responseObject) {
         [weakSelf showErrorHUDWithTitle:@"添加分类上传到服务器失败" SubTitle:nil Complete:nil];
    }];
}

- (void)delalbumWithId:(NSString *)albumId
{
    NSDictionary *dic = @{
                          @"uid" : [Global sharedInstance].userID,
                          @"type" : (_customType == CUSTOM_TYPE_CAMERA_CLASS ? @"2" : (_customType == CUSTOM_TYPE_COMMENT ? @"3" : @"1")),
                          @"id" : albumId
                          };
    __weak typeof(self)weakSelf = self;
      [ArtRequest PostRequestWithActionName:@"delalbum" andPramater:dic succeeded:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *msg = responseObject[@"msg"];
            [weakSelf showErrorHUDWithTitle:msg SubTitle:nil Complete:nil];
        } else if ([responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf getalbum];
        }
    } failed:^(id responseObject) {
 [weakSelf showErrorHUDWithTitle:@"删除失败" SubTitle:nil Complete:nil];
    }];
}

- (void)editalbumWithId:(NSString *)albumId name:(NSString *)name
{
    NSDictionary *dic = @{
                          @"uid" : [Global sharedInstance].userID,
                          @"name" : name,
                          @"id" : albumId,
                          @"type" : (_customType == CUSTOM_TYPE_CAMERA_CLASS ? @"2" : (_customType == CUSTOM_TYPE_COMMENT ? @"3" : @"1"))
                          };
    __weak typeof(self)weakSelf = self;
    [ArtRequest PostRequestWithActionName:@"editalbum" andPramater:dic succeeded:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *msg = responseObject[@"msg"];
            [weakSelf showErrorHUDWithTitle:msg SubTitle:nil Complete:nil];
        } else if ([responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf.customTypeList removeAllObjects];
            for (NSDictionary *dic in responseObject) {
                [weakSelf.customTypeList addObject:dic];
            }
            [weakSelf.tableView reloadData];
        }
    } failed:^(id responseObject) {
         [weakSelf showErrorHUDWithTitle:@"编辑失败" SubTitle:nil Complete:nil];
    }];
}

#pragma mark - Actions

- (void)okAction
{
    NSString *longstr = @"";
    NSString *width = @"";
    NSString *height = @"";
    for (int i = 0; i < 3; i++)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITextView *textView = [cell.contentView viewWithTag:100];
        if (i == 0) {
            longstr = textView.text;
        } else if (i == 1) {
            width = textView.text;
        } else {
            height = textView.text;
        }
    }
    
    if (_didGetFormatString) {
        _didGetFormatString(longstr, width, height);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - BtnActions

- (void)addNewType
{
    __weak typeof(self)weakSelf = self;
    YTXCustomTypeInputViewController *inputVC = [[YTXCustomTypeInputViewController alloc] init];
    inputVC.title = @"新建分类";
    inputVC.resultBlock = ^(NSString *result) {
        [weakSelf addalbumWithName:result];
    };
    [self.navigationController pushViewController:inputVC animated:YES];
}


#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _customTypeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id obj = _customTypeList[indexPath.row];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = obj[@"name"];
    } else if ([obj isKindOfClass:[NSString class]]) {
        cell.textLabel.text = obj;
    }
    if (_customType == CUSTOM_TYPE_SIZE) {
        UITextField *textView = [cell.contentView viewWithTag:100];
        if (!textView) {
            textView = [[UITextField alloc] init];
            textView.tag = 100;
            textView.keyboardType = UIKeyboardTypeNumberPad;
            textView.font = kFont(15);
            [cell.contentView addSubview:textView];
        }
        switch (indexPath.row) {
            case 0:
                [textView becomeFirstResponder];
                textView.text = _longstr ? : @"";
                break;
            case 1:
                textView.text = _width ? : @"";
                break;
            case 2:
                textView.text = _height ? : @"";
                break;
            default:
                break;
        }
        textView.frame = CGRectMake(100, 10, CGRectGetWidth(cell.contentView.frame) - 100 - 20, cell.contentView.frame.size.height - 20);
        textView.textAlignment = NSTextAlignmentRight;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.customType == CUSTOM_TYPE_WORKS_CLASS || self.customType == CUSTOM_TYPE_CAMERA_CLASS || (indexPath.row == 0&& self.customType == CUSTOM_TYPE_COMMENT)){
//        return NO;
//    }
    /* CUSTOM_TYPE_WORKS_CLASS,
     CUSTOM_TYPE_CAMERA_CLASS,
     CUSTOM_TYPE_OTHERS_CLASS,
     CUSTOM_TYPE_AGE,
     CUSTOM_TYPE_SIZE,*/
        if (self.customType == CUSTOM_TYPE_OTHERS_CLASS|| (indexPath.row == 0&& self.customType == CUSTOM_TYPE_COMMENT)){
            return NO;
        }
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSDictionary *dic = weakSelf.customTypeList[indexPath.row];
        [weakSelf delalbumWithId:dic[@"id"]];
    }];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        YTXCustomTypeInputViewController *inputVC = [[YTXCustomTypeInputViewController alloc] init];
        NSDictionary *dic = weakSelf.customTypeList[indexPath.row];
        inputVC.editString = dic[@"name"];
        inputVC.resultBlock = ^(NSString *result) {
            [weakSelf editalbumWithId:dic[@"id"] name:result];
        };
        [weakSelf.navigationController pushViewController:inputVC animated:YES];
    }];
    return @[editAction,deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_customType == CUSTOM_TYPE_SIZE) {
        return;
    }
    
    if (_didSelectedString) {
        id obj = _customTypeList[indexPath.row];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            _didSelectedString(_customTypeList[indexPath.row][@"name"],self.customType);
            NSString *fenleiID=[NSString stringWithFormat:@"%@",_customTypeList[indexPath.row][@"id"]];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:fenleiID forKey:@"fenleiID"];
            [defaults synchronize];
    
        } else {
            _didSelectedString(_customTypeList[indexPath.row],self.customType);
            
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
