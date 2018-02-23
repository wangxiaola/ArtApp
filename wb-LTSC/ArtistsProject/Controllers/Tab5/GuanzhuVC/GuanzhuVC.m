//
//  GuanzhuVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "GuanzhuVC.h"
#import "MessageCell.h"
#import "GuanzhuCell.h"
#import "MyHomePageDockerVC.h"

@interface GuanzhuVC ()

@property (strong, nonatomic) NSMutableArray *selectArray;

@end

@implementation GuanzhuVC

-(void)viewWillAppear:(BOOL)animated{
    if (![self isLogin]) {
        return ;
    }
    self.sortClass=@"1";
    self.actionName=@"followmelist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID?:@"0"}];
    self.view.backgroundColor=ColorHex(@"f6f6f6");
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_willDisappearBlock) _willDisappearBlock(_selectArray);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectArray = [[NSMutableArray alloc] initWithArray:self.atuser];
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuanzhuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GuanzhuCell"];
    if (cell==nil) {
        cell = [[GuanzhuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GuanzhuCell"];
    }
    [cell setArtTableViewCellDicValue:self.lstData[indexPath.row]];
    return cell;
//    NSString *identifier=@"MyFansCell";
//    GuanzhuCell *cell=(GuanzhuCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if (!cell){
//        cell=[[GuanzhuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        cell.backgroundColor=kWhiteColor;
//    }
//    MessageModel *model=[MessageModel objectWithKeyValues:self.lstData[indexPath.row]];
//    if (_willDisappearBlock) {
//        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        selectButton.frame = CGRectMake(0, 0, 30, 30);
//        [selectButton setImage:[UIImage imageNamed:@"勾选"] forState:UIControlStateNormal];
//        [selectButton setImage:[UIImage imageNamed:@"已勾选"] forState:UIControlStateSelected];
//        [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
//        selectButton.tag = indexPath.row;
//        for (MessageModel *message in _selectArray) {
//            if ([message.uid isEqualToString:model.uid]) {
//                selectButton.selected = YES;
//                break;
//            }
//        }
//        cell.accessoryView = selectButton;
//    }
//    cell.model=model;
//    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel *model=[MessageModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
    if (_willDisappearBlock) {
        GuanzhuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
      }else{
        MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
        vc.artId = model.uid;
          vc.navTitle = model.username;
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
