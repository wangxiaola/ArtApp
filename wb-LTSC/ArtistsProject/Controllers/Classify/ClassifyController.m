//
//  ClassifyController.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/27.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ClassifyController.h"
#import "ClassifyCell.h"
#import "YTXMyFriendsViewController.h"
#import "ArtCirclesVc.h"
#import "KaMenShuoVc.h"
#import "YTXInviteCodeViewController.h"
#import "SearchViewController.h"
#import "AppraisalMeetingVC.h"
#import "YTXGoodsViewController.h"
#import "YTXWebViewController.h"
#import "AdvertisingViewController.h"
#define ONE_ONE_CELL (T_WIDTH(40))

@interface ClassifyController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_nameLabel;
}
@property(nonatomic,strong)UITableView* tbView;
@property(nonatomic,strong)NSArray* classifyArr;
@end

@implementation ClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Do any additional setup after loading the view.
//    UIImageView* navView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 112,40)];
//    [navView setImage:[UIImage imageNamed:@"yishuqu"]];
//    self.navigationItem.titleView=navView;
    
    UIView* userview = [[UIView alloc]initWithFrame:CGRectMake(0,0,160, 44)];
    self.navigationItem.titleView = userview;
    //艺术家名称
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text = [NSString stringWithFormat:@"%@",@"劳特斯辰业务线"];
    _nameLabel.font = [UIFont fontWithName:@"GBK.TTF" size:18];
    _nameLabel.textColor = [UIColor hexChangeFloat:@"870000"];
    CGSize tempSize = [_nameLabel sizeThatFits:CGSizeMake(160, 44)];
    _nameLabel.frame = CGRectMake(30, 3,tempSize.width, 24);
    _nameLabel.centerX = userview.centerX;
    [userview addSubview:_nameLabel];
    
    //副名称
    UILabel *lbl = [[UILabel alloc]init];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = [NSString stringWithFormat:@"%@",@"LOTUS CHEN BUSINESS LINE"];
    lbl.textColor = [UIColor hexChangeFloat:@"870000"];
    lbl.font = ART_FONT(11);
    //    lbl.font = [UIFont fontWithName:@"DINPro-Light.TTF" size:8];
    CGSize subSize = [lbl sizeThatFits:CGSizeMake(160, 15)];
    lbl.frame = CGRectMake(30, 26,subSize.width, 15);
    [userview addSubview:lbl];
    lbl.centerX = userview.centerX;
    
    _classifyArr = @[@[@{
                           @"title" : @"签约艺术家/演员",
                           @"icon" : @"艺术家",
                        }
                       ],
                     @[@{
                           @"title" : @"主要展馆",
                           @"icon" : @"展览",
                        }
                       ],
                     @[
                       @{
                           @"title" : @"影视传媒",
                            @"icon" : @"影视传媒",
                        },
                       @{
                           @"title" : @"经纪团队",
                           @"icon" : @"艺人经纪",
                        },
                       @{
                           @"title" : @"对外演出",
                           @"icon" : @"对外演出",
                        }
                       ],
                     @[@{
                           @"title" : @"展览展示及活动",
                           @"icon" : @"展览展示",
                           },
                       @{
                           @"title" : @"空间租赁",
                           @"icon" : @"空间租赁",
                        }],
                     @[@{
                            @"title" : @"广告宣传",
                            @"icon" : @"广告宣传"
                         }],
                     @[@{
                           @"title" : @"艺术品国际运输",
                           @"icon" : @"货物进出口",
                        }
                       ],
                      @[@{
                         @"title" : @"艺术品质押",
                         @"icon" : @"艺术教育",
                         }]
                    ];

    _tbView  = [[UITableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
//    _tbView.scrollEnabled = NO;
    _tbView.tableFooterView = [UIImageView new];
    _tbView.delegate = self;
    _tbView.dataSource = self;
    _tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_tbView];
    
    if (ISIOS7Later) {//ios7之前
        [self.tbView setSeparatorInset:UIEdgeInsetsZero];
    }
    if (ISIOS8Later) {//iOS8之前
        [self.tbView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _classifyArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_classifyArr[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ONE_ONE_CELL;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassifyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ClassifyCell"];
    if (cell==nil){
        cell = [[ClassifyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClassifyCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, ONE_ONE_CELL)];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary* dic;
    dic = _classifyArr[indexPath.section][indexPath.row];
    [cell setClassifyImg:dic[@"icon"] title:dic[@"title"] subImg:nil];
    return cell;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView* img = [[UIImageView alloc]init];
    if (section == 0 ) {
        img.frame =  CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(15));
    }else if(section < _classifyArr.count){
        img.frame = CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(20));
    }
    img.backgroundColor = BACK_VIEW_COLOR;
    return img;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return T_WIDTH(15);
    }else if(section < _classifyArr.count){
        return T_WIDTH(20);
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            
            if (indexPath.row==0) {//签约艺术家/演员
                YTXMyFriendsViewController * VC = [[YTXMyFriendsViewController alloc]init];
                VC.title  = @"签约艺术家/演员";
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }
            break;
        case 1:
         if (indexPath.row==0){//主要展馆
             AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
             AppraisalMeeting.title  = @"主要展馆";
             AppraisalMeeting.type = @"4";
             AppraisalMeeting.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:AppraisalMeeting animated:YES];
        }
            break;
        case 2:
          if(indexPath.row == 0){//影视传媒
             AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
             AppraisalMeeting.title  = @"影视传媒";
             AppraisalMeeting.type = @"5";
             AppraisalMeeting.hidesBottomBarWhenPushed = YES;
             [self.navigationController pushViewController:AppraisalMeeting animated:YES];
         }else if (indexPath.row == 1) {//经济团队
                AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
                AppraisalMeeting.title  = @"经济团队";
                AppraisalMeeting.type = @"6";
                AppraisalMeeting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:AppraisalMeeting animated:YES];
            }else if (indexPath.row == 2){//对外演出
                AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
                AppraisalMeeting.title  = @"对外演出";
                AppraisalMeeting.type = @"7";
                AppraisalMeeting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:AppraisalMeeting animated:YES];
            }
            break;
        case 3:
        {
            if (indexPath.row == 0) {//展览展示及活动
                AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
                AppraisalMeeting.title  = @"展览展示及活动";
                AppraisalMeeting.type = @"8";
                AppraisalMeeting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:AppraisalMeeting animated:YES];
            }else if(indexPath.row == 1){//空间租赁
                AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
                AppraisalMeeting.title  = @"空间租赁";
                AppraisalMeeting.type = @"2";
                AppraisalMeeting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:AppraisalMeeting animated:YES];
            }
        }
            break;
            case 4:
        {
            if (indexPath.row == 0) {//广告宣传
                AdvertisingViewController *advertisingVC = [[AdvertisingViewController alloc] init];
                [self.navigationController pushViewController:advertisingVC animated:YES];
            }
        }
            break;
        case 5:
        {
            if (indexPath.row == 0) {//艺术品国际运输
                AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
                AppraisalMeeting.title  = @"艺术品国际运输";
                AppraisalMeeting.type = @"9";
                AppraisalMeeting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:AppraisalMeeting animated:YES];
            }
        }
            break;
        case 6:
        {
            if (indexPath.row == 0) {//艺术品质押
                AppraisalMeetingVC *AppraisalMeeting=[[AppraisalMeetingVC alloc]init];
                AppraisalMeeting.title  = @"艺术品质押";
                AppraisalMeeting.type = @"10";
                AppraisalMeeting.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:AppraisalMeeting animated:YES];
            }
        }
            break;
            
            
        default:
            break;
    }
    
}

-(void)pushToWebViewController:(NSString *)urlString title:(NSString *)title
{
    YTXWebViewController *webVC = [[YTXWebViewController alloc]init];
    webVC.naviTitle = title;
    webVC.url = [NSURL URLWithString:urlString];
    [self.navigationController pushViewController:webVC animated:YES];
}
//搜索
-(void)rightPublicAction{
    SearchViewController * VC = [[SearchViewController alloc]init];
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

//去掉tableview的section headerview的粘性
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
@end
