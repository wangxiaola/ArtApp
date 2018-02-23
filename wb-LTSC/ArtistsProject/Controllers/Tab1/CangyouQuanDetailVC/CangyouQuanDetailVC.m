//
//  CangyouQuanDetailVC.m
//  ShesheDa
//
//  Created by MengTuoChina on 16/7/23.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouQuanDetailVC.h"
#import "CangyouQuanDetailCell.h"
#import "CangyouQuanDetailModel.h"
#import "HomeListDetailVc.h"
#import "PublishDongtaiVC.h"
//#import "YTXTopicDetailViewController.h"
#import "NSMutableAttributedString+YTXCangyouquanCell.h"
//#import "YTXWebViewController.h"

@interface CangyouQuanDetailVC ()<zhiDingProtocol>{
    CGFloat cellImageHeight;
}

@end

@implementation CangyouQuanDetailVC
@synthesize state,userID,isHideNav;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    if (self.isHideTab) {
    //        self.tabBarController.tabBar.hidden=YES;
    //    }
    cellImageHeight=3;
    if ([state isEqualToString:@"1"]) {
        self.tabBarController.tabBar.hidden=YES;
        if (![Global sharedInstance].userID) {
            return ;
        }
        self.actionName=@"actiontopic";
        self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":[Global sharedInstance].userID?:@"0",@"artist":@"1"}];
        
    }else if ([state isEqualToString:@"2"]){
        self.tabBarController.tabBar.hidden=YES;
        self.actionName=@"topiclist";
        self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"cuid":[Global sharedInstance].userID?:@"0",@"artist":@"1"}];
    }else if ([state isEqualToString:@"3"]){
        self.actionName=@"topiclist";
        if (userID.length<1) {
            userID=[Global sharedInstance].userID;
        }
        if (_isHidePush) {
            self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0",@"postuid":userID?userID:[[Global sharedInstance] getBundleID]}];
            if ([[NSString stringWithFormat:@"%@",userID] isEqualToString:@"0"]) {
                
                self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"postuid":[[Global sharedInstance] getBundleID]}];
            }else{
                self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"postuid":userID}];
                
            }
            
        }else{
            self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"cuid":[Global sharedInstance].userID?:@"0",@"postuid":userID}];
        }
    }
    
    else if ([state isEqualToString:@"4"]){
        self.actionName=@"liketopiclist";
        if (userID.length<1) {
            userID=[Global sharedInstance].userID;
        }
        self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"uid":userID}];
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if ([isHideNav isEqualToString:@"1"]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.navigationController.navigationBar setTranslucent:YES];
        
    }
    
    self.sortClass=@"1";
    [super viewWillAppear:animated];
    self.tab.scrollsToTop=YES;
    [self reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden=NO;
}
-(void)viewDidLoad{
    
    [super viewDidLoad];
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([[Global sharedInstance].userID isEqualToString:userID]&&[state isEqualToString:@"3"]) {
        HView *viewBottom=[[HView alloc]init];
        viewBottom.userInteractionEnabled=YES;
        viewBottom.backgroundColor=kClearColor;
        //[self.view addSubview:viewBottom];
        //[viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.right.equalTo(self.view);
           // make.bottom.equalTo(self.view);
          //make.height.mas_equalTo(45);
        //}];
        viewBottom.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapBottom=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnPublish_Click)];
        //[viewBottom addGestureRecognizer:tapBottom];
        if (_isHidePush) {
            
        }else{
            HButton *btnPublish=[[HButton alloc]init];
            [btnPublish setImage:[UIImage imageNamed:@"icon_cangyou_publish"] forState:UIControlStateNormal];
            [btnPublish addTarget:self action:@selector(btnPublish_Click) forControlEvents:UIControlEventTouchUpInside];
            //[viewBottom addSubview:btnPublish];
            //[btnPublish mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.centerY.equalTo(viewBottom);
                //make.right.equalTo(viewBottom).offset(-15);
            //}];
        }
    }
    
    HView *viewHead=[[HView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    viewHead.backgroundColor=ColorHex(@"f6f6f6");
    self.tab.tableHeaderView=viewHead;
    
}


-(void)btnPublish_Click{
    //PublishDongtaiVC *vc=[[PublishDongtaiVC alloc]init];
    //vc.hidesBottomBarWhenPushed = YES;
   // [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 列表视图代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lstData.count>0?self.lstData.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    id obj = self.lstData;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel objectWithKeyValues:self.lstData[indexPath.section]];
    return [self getCellHeight:model];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.lstData[indexPath.section]];
    NSString *identifier=[NSString stringWithFormat:@"MyFansCell%@",@"model.id"];
    if ([self.isYiSuJiaJinKuang isEqualToString:@"isYiSuJiaJinKuang"]){
        identifier = @"isYiSuJiaJinKuang";
    }
    CangyouQuanDetailCell *cell=(CangyouQuanDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[CangyouQuanDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.isYiSuJiaJinKuang = self.isYiSuJiaJinKuang;
    }
    
    __weak CangyouQuanDetailVC* wself=self;
    cell.manager = wself;
    cell.model=model;
    cell.topicModel = model;
    cell.typeStr = [NSString stringWithFormat:@"%@",self.lstData[indexPath.section][@"topictype"]];
    cell.topictype = [NSString stringWithFormat:@"%@",self.lstData[indexPath.section][@"topictype"]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0001;
    }
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel objectWithKeyValues:self.lstData[indexPath.section]];
    if ([model.topictype isEqualToString:@"17"]) {
//        YTXWebViewController *VC = [[YTXWebViewController alloc] init];
//        VC.url = [NSURL URLWithString:model.message];
//        [self.navigationController pushViewController:VC animated:YES];
    } else {
//        [Global sharedInstance].publishId=@"";
//        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
//        [user setObject:@"" forKey:@"center"];
//        [user synchronize];

//        YTXTopicDetailViewController *vc=[[YTXTopicDetailViewController alloc]init];
//        vc.topicid = model.id;
//        vc.pagestr=@"1";
//        vc.topictype = model.topictype;
//        vc.username=[[self.lstData[indexPath.section] objectForKey:@"user"]objectForKey:@"username"];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)getCellHeight:(CangyouQuanDetailModel *)model
{
    float imgHeight = KKWidth(68-40-30);
    if([self.isYiSuJiaJinKuang isEqualToString:@"isYiSuJiaJinKuang"]) {
        imgHeight = KKWidth(68);
    }
    
    float space = 10;
    float contentW = self.view.frame.size.width - space * 2;
    
    CGFloat cellHeight = imgHeight + space;
    
    cellHeight += 20;
    
    HLabel *heightLabel = [[HLabel alloc] init];
    heightLabel.numberOfLines = 3;
    heightLabel.font = kFont(15);
    
    //下面状态显示高度 
    switch (model.topictype.intValue) {
        case 1:
        {
            NSMutableArray *stateArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stateArray addObject:model.topictitle];
            }
            if (model.catetypeName.length > 0) {
                [stateArray addObject:model.catetypeName];
            }
            if (model.statusName.length > 0) {
                [stateArray addObject:model.statusName];
            }
            
            NSString* strCangpinState = @"";
            if (stateArray.count > 0) {
                strCangpinState = [stateArray componentsJoinedByString:@" | "];
            }
            
            heightLabel.text = strCangpinState;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            
            if (![model.status isEqualToString:@"4"]) {
                NSMutableArray *resultArray = [[NSMutableArray alloc] init];
                [resultArray addObject:@"鉴定结论："];
                if (model.statusName.length > 0) {
                    [resultArray addObject:model.statusName];
                }
                if (model.ageText.length > 0) {
                    [resultArray addObject:model.ageText];
                }
                if (model.priceText.length > 0) {
                    [resultArray addObject:model.ageText];
                }
                NSString* strCangpinState = [resultArray componentsJoinedByString:@" | "];
                heightLabel.text = strCangpinState;
                cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            }
            break;
        }
        case 2:
        case 3:
        {
            heightLabel.text = model.message;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            NSArray *arrayAudio = [self stringToJSON:model.audio];
            if (arrayAudio.count > 0) {
                cellHeight += ((arrayAudio.count - 1) * KKWidth(10)) + (arrayAudio.count * KKWidth(55)) + 2;
            }
            break;
        }
        case 4:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.gtypename.length > 0) {
                [stringArray addObject:model.gtypename];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            if (![model.video isEqualToString:@""]) {
                [attribuedString appendLine];
                [attribuedString appendIconVideo];
            }
            heightLabel.attributedText = attribuedString;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 6:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (model.zuopinGuigeText.length > 0) {
                [stringArray addObject:model.zuopinGuigeText];
            }
            if (model.caizhi.length > 0) {
                [stringArray addObject:model.caizhi];
            }
            if (model.arttype.length > 0) {
                [stringArray addObject:model.arttype];
            }
            
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:string];
            if (![model.video isEqualToString:@""]) {
                [attribuedString appendLine];
                [attribuedString appendIconVideo];
            }
            
            heightLabel.attributedText = attribuedString;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 7:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            if (model.arttype.length > 0) {
                [stringArray addObject:model.arttype];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            heightLabel.attributedText = attribuedString;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 8:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.starttime.length > 0) {
                [stringArray addObject:model.starttime];
            }
            if (model.city.length > 0) {
                [stringArray addObject:model.city];
            }
            if (model.address.length > 0) {
                [stringArray addObject:model.address];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            heightLabel.attributedText = attributedString;
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            heightLabel.attributedText = attributedString;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 9:
        {
            NSString *people = @"";
            if ([model.people isKindOfClass:[NSString class]]) {
                people = model.people;
            } else if ([model.people isKindOfClass:[NSDictionary class]]) {
                people = model.people[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (people.length > 0) {
                [stringArray addObject:people];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            heightLabel.attributedText = attributedString;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 13:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            [stringArray addObject:@"艺术年表"];
            
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            heightLabel.attributedText = attributedString;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 14:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.award.length > 0) {
                [stringArray addObject:model.award];
            }
            if (model.message.length > 0) {
                [stringArray addObject:[NSString stringWithFormat:@"获奖作品：%@",model.message]];
            }
            [stringArray addObject:@"荣誉奖项"];
            
            heightLabel.text = [stringArray componentsJoinedByString:@" | "];
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 15:
        {
            NSString *source = @"";
            if ([model.source isKindOfClass:[NSString class]]) {
                source = model.source;
            } else if ([model.source isKindOfClass:[NSDictionary class]]) {
                source = model.source[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (source.length > 0) {
                [stringArray addObject:source];
            }
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            [stringArray addObject:@"收藏拍卖"];
            heightLabel.text = [stringArray componentsJoinedByString:@" | "];
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 16:
        {
            NSString *source = @"";
            if ([model.source isKindOfClass:[NSString class]]) {
                source = model.source;
            } else if ([model.source isKindOfClass:[NSDictionary class]]) {
                source = model.source[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (source.length > 0) {
                [stringArray addObject:source];
            }
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            [stringArray addObject:@"公益捐赠"];
            
            heightLabel.text = [stringArray componentsJoinedByString:@" | "];
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 17:
        {
            NSString *source = @"";
            if ([model.source isKindOfClass:[NSString class]]) {
                source = model.source;
            } else if ([model.source isKindOfClass:[NSDictionary class]]) {
                source = model.source[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (source.length > 0) {
                [stringArray addObject:source];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            //heightLabel.text = [stringArray componentsJoinedByString:@" | "];
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            heightLabel.attributedText = attribuedString;
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
        case 18:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            [stringArray addObject:@"出版著作"];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            heightLabel.text = [stringArray componentsJoinedByString:@" | "];
            cellHeight += [heightLabel sizeThatFits:CGSizeMake(contentW, FLT_MAX)].height;
            break;
        }
    }
    
    //根据图片的个数改变cell的高度
    NSArray *arrayYuanlai=[model.photos componentsSeparatedByString:@","];
    NSMutableArray *arrayPhoto=[[NSMutableArray alloc]init];
    
    for (NSString *arrayPhotoUrl in arrayYuanlai) {
        if (arrayPhotoUrl.length>3) {
            [arrayPhoto addObject:arrayPhotoUrl];
        }
    }
    
    cellHeight += 2;
    switch (arrayPhoto.count) {
        case 1:{
            cellHeight += kScreenW;
        }break;
        case 2:{
            cellHeight += (kScreenW-cellImageHeight)/3*2;
        }break;
        case 3:{
            cellHeight += (kScreenW-cellImageHeight)/3*2+cellImageHeight;
        }break;
        case 4:{
            cellHeight += (kScreenW-cellImageHeight*2)/3*2+cellImageHeight;
        }break;
        case 5:{
            cellHeight += (kScreenW-cellImageHeight*2)/3*2+cellImageHeight;
        }break;
        case 6:{
            cellHeight += (kScreenW-cellImageHeight*2)/3*2+cellImageHeight;
        }break;
        case 7:{
            cellHeight += kScreenW;
        }break;
        case 8:{
            cellHeight += kScreenW;
        }break;
        case 9:{
            cellHeight += kScreenW;
        }break;
        default:
            break;
    }
    
    //添加状态栏
    cellHeight += space + 20;
    return ceil(space + cellHeight + space);
}

/**
 *  补全分割线方法
 */
- (void)viewDidLayoutSubviews
{
    if ([self.tab respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tab setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tab respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tab setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPat
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//置顶
-(void)zhidingBtnClick{
    [self.tab setContentOffset:CGPointMake(0, 0)];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tab)
//    {
//        CGFloat sectionHeaderHeight = 8;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

@end
