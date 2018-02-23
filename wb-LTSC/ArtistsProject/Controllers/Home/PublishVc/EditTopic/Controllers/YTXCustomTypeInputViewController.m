//
//  YTXCustomTypeInputViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/19.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXCustomTypeInputViewController.h"

@interface YTXCustomTypeInputViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation YTXCustomTypeInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"identifier"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(okAction)];
}

- (void)okAction
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITextView *textView = [cell.contentView viewWithTag:100];
    if (_resultBlock) {
        _resultBlock(textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
    
    UITextView *textView = [cell.contentView viewWithTag:100];
    
    if (!textView) {
        if (_isFullScreenInput) {
            textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, cell.contentView.width - 10 * 2, cell.contentView.height - 10 * 2)];
        } else {
            textView = (UITextView *)[[UITextField alloc] initWithFrame:CGRectMake(10, 10, cell.contentView.width - 10 * 2, cell.contentView.height - 10 * 2)];
        }
        if ([self.title isEqualToString:@"价格"]||[self.title isEqualToString:@"运费"]||[self.title isEqualToString:@"库存"]) {
            textView.keyboardType = UIKeyboardTypeNumberPad;
        }
        textView.text = _editString ? : @"中文|English";
        textView.tag = 100;
        textView.font = kFont(15);
        [cell.contentView addSubview:textView];
        [textView becomeFirstResponder];
       
        if ([_editString containsString:@"##"]) {
            NSRange range = [_editString rangeOfString:@"##"];
            [textView setSelectedRange:NSMakeRange(range.location+1, 0)];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isFullScreenInput) {
        return self.view.frame.size.height;
    }
    return 50;
}

@end
