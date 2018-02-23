//
//  YTXPublishWorksViewController.m
//  ShesheDa
//
//  Created by Hongwei Chen on 2016/12/19.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXPublishWorksViewController.h"
#import "HImageSelector.h"
#import "YTXCustomTypeViewController.h"

@interface YTXPublishWorksViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    HImageSelector *imgSel;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSString *selectedType;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *format;

@end

@implementation YTXPublishWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithRGB:0xf4f4f4];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PublishWorksNormalCellsIds"];
    
    [self createHeaderView];
    [self createBottomView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAction)];
}

- (void)publishAction
{
    
}


#pragma mark - UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PublishWorksNormalCellsIds" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = kFont(15);
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"分类";
            UILabel *detailTextLabel = [cell.contentView viewWithTag:200];
            if (!detailTextLabel) {
                detailTextLabel = [[UILabel alloc] init];
                detailTextLabel.tag = 200;
                detailTextLabel.font = kFont(15);
                detailTextLabel.textColor = [UIColor blackColor];
                [cell.contentView addSubview:detailTextLabel];
                [detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30);
                    make.centerY.mas_equalTo(0);
                }];
            }
            detailTextLabel.text = _selectedType;
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"名称";
            UITextView *textView = [cell.contentView viewWithTag:100];
            if (!textView) {
                textView = [[UITextView alloc] init];
                textView.tag = 100;
                textView.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:textView];
            }
            textView.text = @"作品集";
            textView.frame = CGRectMake(100, 10, CGRectGetWidth(cell.contentView.frame) - 100 - 20, cell.contentView.frame.size.height - 20);
            textView.textAlignment = NSTextAlignmentRight;
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"年代";
            UILabel *detailTextLabel = [cell.contentView viewWithTag:200];
            if (!detailTextLabel) {
                detailTextLabel = [[UILabel alloc] init];
                detailTextLabel.tag = 200;
                detailTextLabel.font = kFont(15);
                detailTextLabel.textColor = [UIColor blackColor];
                [cell.contentView addSubview:detailTextLabel];
                [detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30);
                    make.centerY.mas_equalTo(0);
                }];
            }
            detailTextLabel.text = _age;
            break;
        }
        case 3:
        {
            cell.textLabel.text = @"尺寸";
            UILabel *detailTextLabel = [cell.contentView viewWithTag:200];
            if (!detailTextLabel) {
                detailTextLabel = [[UILabel alloc] init];
                detailTextLabel.tag = 200;
                detailTextLabel.font = kFont(15);
                detailTextLabel.textColor = [UIColor blackColor];
                [cell.contentView addSubview:detailTextLabel];
                [detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-30);
                    make.centerY.mas_equalTo(0);
                }];
            }
            detailTextLabel.text = _size;
            break;
        }
        case 4:
        {
            cell.textLabel.text = @"材质";
            UITextView *textView = [cell.contentView viewWithTag:100];
            if (!textView) {
                textView = [[UITextView alloc] init];
                textView.tag = 100;
                textView.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:textView];
            }
            textView.text = @"布画油画";
            textView.frame = CGRectMake(100, 10, CGRectGetWidth(cell.contentView.frame) - 100 - 20, cell.contentView.frame.size.height - 20);
            textView.textAlignment = NSTextAlignmentRight;
            break;
        }
        case 5:
        {
            cell.textLabel.text = @"介绍";
            UITextView *textView = [cell.contentView viewWithTag:100];
            if (!textView) {
                textView = [[UITextView alloc] init];
                textView.tag = 100;
                textView.font = [UIFont systemFontOfSize:15];
                [cell.contentView addSubview:textView];
            }
            textView.text = @"此书里包括了......此书里包括了......此书里包括了......此书里包括了......";
            textView.frame = CGRectMake(100, 10, CGRectGetWidth(cell.contentView.frame) - 100 - 20, cell.contentView.frame.size.height - 20);
            textView.textAlignment = NSTextAlignmentLeft;
            break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        return 88;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 5 || indexPath.row == 4) {
        return;
    }
    
//    @weakify(self);
//    YTXCustomTypeViewController *customTypeVC = [[YTXCustomTypeViewController alloc] init];
//    switch (indexPath.row) {
//        case 0:
//            customTypeVC.customType = CUSTOM_TYPE_CLASS;
//            break;
//        case 2:
//            customTypeVC.customType = CUSTOM_TYPE_AGE;
//            break;
//        case 3:
//            customTypeVC.customType = CUSTOM_TYPE_SIZE;
//            break;
//    }
//    customTypeVC.didSelectedString = ^(NSString *string, CUSTOM_TYPE customType) {
//        @strongify(self);
//        switch (customType) {
//            case CUSTOM_TYPE_CLASS:
//                self.selectedType = string;
//                break;
//            case CUSTOM_TYPE_AGE:
//                self.age = string;
//                break;
//            case CUSTOM_TYPE_SIZE:
//                self.size = string;
//                break;
//        }
//        [self.tableView reloadData];
//    };
//    [self.navigationController pushViewController:customTypeVC animated:YES];
}


#pragma mark - HeaderView

- (void)createHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    imgSel = [HImageSelector new];
    imgSel.baseVC = self;
    imgSel.allowScroll = YES;
    __block typeof(HImageSelector*) weakImgSel = imgSel;
    [headerView addSubview:imgSel];
    [imgSel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
    imgSel.maxNumberOfImage = 9;
    imgSel.allowEdit = YES;
    [imgSel setSelectAddBtnCilck:^(UIImage* image) {
        [headerView mas_updateConstraints:^(MASConstraintMaker* make) {
            if (weakImgSel.listImages.count == 1) {
                make.height.mas_equalTo(kScreenW / 4 + 20);
            }
            else {
                make.height.mas_equalTo((weakImgSel.listImages.count / 4 + 1) * (kScreenW / 4) + 20);
            }
        }];
    }];
    [imgSel setSelectDelBtnCilck:^(NSInteger iNumber){
        
    }];
    
    [imgSel setSelectDelBtnCilck:^(NSInteger iNumber){
        
    }];
    
    self.tableView.tableHeaderView = headerView;
}


#pragma mark - BottomView

- (void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    NSArray *stringArray = @[@"话题",@"提醒",@"录音",@"视频"];
    for (int i = 0; i < stringArray.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[stringArray objectOrNilAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:stringArray[i]] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [bottomView addSubview:button];
        
        button.frame = CGRectMake(i * (bottomView.width / 4),
                                  0,
                                  bottomView.width / 4,
                                  bottomView.height);
    }
    
    _tableView.tableFooterView = bottomView;
}

@end
