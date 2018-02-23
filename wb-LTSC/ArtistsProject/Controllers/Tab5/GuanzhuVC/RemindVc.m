//
//  GuanzhuVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "RemindVc.h"
#import "MessageCell.h"
#import "RemindCell.h"
#import "MyHomePageDockerVC.h"

@interface RemindVc ()

@property (strong, nonatomic) NSMutableArray *selectArray;

@end

@implementation RemindVc

-(void)viewWillAppear:(BOOL)animated{
    if (![self isLogin]) {
        return ;
    }
    self.sortClass=@"1";
    self.actionName=@"followmelist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID}];
    self.view.backgroundColor=ColorHex(@"f6f6f6");
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    _selectArray = [[NSMutableArray alloc] initWithArray:self.atuser];
   }

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
-(void)rightBar_Click{
if(_willDisappearBlock) _willDisappearBlock(_selectArray);
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem = rightBar;

}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier=@"RemindCell";
    RemindCell *cell=(RemindCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[RemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=kWhiteColor;
    }
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    if (_willDisappearBlock) {
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.frame = CGRectMake(0, 0, 30, 30);
        [selectButton setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"已勾选"] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.tag = indexPath.row;
        for (MessageModel *message in _selectArray) {
            if ([message.uid isEqualToString:model.uid]) {
                selectButton.selected = YES;
                break;
            }
        }
        cell.accessoryView = selectButton;
    }
    cell.model=model;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    if (_willDisappearBlock) {
        RemindCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *button = (UIButton *)cell.accessoryView;
        button.selected = !button.selected;
        if (button.selected) {
            [_selectArray addObject:model];
        } else {
            for (MessageModel *message in _selectArray) {
                if ([message.uid isEqualToString:model.uid]) {
                    [_selectArray removeObject:message];
                    break;
                }
            }
        }
    } else {
        MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
        vc.navTitle=model.username;
        vc.artId=model.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)selectAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lstData[sender.tag]];
    if (sender.selected) {
        [_selectArray addObject:model];
    } else {
        for (MessageModel *message in _selectArray) {
            if ([message.uid isEqualToString:model.uid]) {
                [_selectArray removeObject:message];
                break;
            }
        }
    }
}

@end
