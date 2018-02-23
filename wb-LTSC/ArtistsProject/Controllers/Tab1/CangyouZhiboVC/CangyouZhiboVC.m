//
//  CangyouZhiboVC.m
//  ShesheDa
//
//  Created by chen on 16/8/5.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouZhiboVC.h"
#import "CangyouQuanDetailModel.h"
#import "CangyouQuanDetailCell.h"
#import "HomeListDetailVc.h"
#import "NSString+YTXAdd.h"

@interface CangyouZhiboVC ()

@end

@implementation CangyouZhiboVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_topicName) {
        _topicName = _model.name;
    }
    [self customNavBar];
}

-(void)viewWillAppear:(BOOL)animated{
    self.actionName=@"htlist";
    self.dicParamters=[[NSMutableDictionary alloc] initWithDictionary: @{@"topicname":_topicName}];
    
    self.sortClass=@"1";
    
    [super viewWillAppear:animated];
    self.view.backgroundColor=ColorHex(@"f6f6f6");
    self.tab.backgroundColor=ColorHex(@"f6f6f6");
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)customNavBar {
    HView *viewNav=[[HView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 160)];
    viewNav.backgroundColor = [UIColor colorWithHexString:@"#C4B173"];
    [self.view addSubview:viewNav];
    [self.tab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(160);
    }];
    HButton *btnCancel=[[HButton alloc]init];
    [btnCancel setImage:[UIImage imageNamed:@"icon_NavBar_Left"] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(leftBarItem_Click) forControlEvents:UIControlEventTouchUpInside];
    [viewNav addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewNav).offset(30);
        make.left.equalTo(viewNav).offset(20);
    }];
    
    HLabel * navTitle=[[HLabel alloc]init];
    navTitle.textColor = kWhiteColor;
    navTitle.font = kFont(14);
    
    navTitle.text = [NSString stringWithFormat:@"%@   %@",[_model.poster stringByReplacingOccurrencesOfString:@"发起的话题" withString:@""],[NSString stringWithFormat:@"发起话题于%@",[_model.postTime stringWithFormat:@"yyyy年MM月"]]];
    [viewNav addSubview:navTitle];
    [navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnCancel);
        make.centerX.equalTo(viewNav);
    }];
    
    UILabel * topicNameLabel = [[UILabel alloc]init];
    topicNameLabel.textColor = kWhiteColor;
    topicNameLabel.text = _topicName;
    topicNameLabel.font = kFont(16);
    topicNameLabel.numberOfLines = 2;
    topicNameLabel.textAlignment = NSTextAlignmentCenter;
    [viewNav addSubview:topicNameLabel];
    [topicNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(navTitle.mas_bottom).offset(30);
        make.left.equalTo(viewNav).offset(20);
        make.right.equalTo(viewNav).offset(-20);
    }];
    
    UILabel * shareLabel = [[UILabel alloc]init];
    shareLabel.textColor = kWhiteColor;
    shareLabel.numberOfLines = 2;
    shareLabel.font = kFont(14);
    
    shareLabel.text = [NSString stringWithFormat:@"%@个分享",[NSString stripNullWithString:[_model.shareCount stringByReplacingOccurrencesOfString:@"个分享" withString:@"\n"]]];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    [viewNav addSubview:shareLabel];
    
    UILabel * broweLabel = [[UILabel alloc]init];
    broweLabel.textColor = kWhiteColor;
    broweLabel.numberOfLines = 2;
    broweLabel.textAlignment = NSTextAlignmentCenter;
    broweLabel.font = kFont(14);
    broweLabel.text = [NSString stringWithFormat:@"%@次浏览",[NSString stripNullWithString:[_model.browseCount stringByReplacingOccurrencesOfString:@"次浏览" withString:@"\n"]]];
    
    [viewNav addSubview:broweLabel];
    
    CGFloat width = (kScreenW - 20 * 3) / 2;
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicNameLabel.mas_bottom).offset(20);
        make.left.equalTo(viewNav).offset(20);
        make.right.equalTo(broweLabel.mas_left).offset(-20);
        make.width.mas_equalTo(width);
    }];
    [broweLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(viewNav).offset(-20);
        make.width.mas_equalTo(width);
        make.top.equalTo(topicNameLabel.mas_bottom).offset(20);
    }];
    
        
}

//返回按钮点击事件
- (void)leftBarItem_Click {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 列表视图代理方法

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel objectWithKeyValues:self.lstData[indexPath.row]];
    return [self getCellHeight:model];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel objectWithKeyValues:self.lstData[indexPath.row]];
    NSString *identifier=[NSString stringWithFormat:@"MyFansCell%@",model.id];
    CangyouQuanDetailCell *cell=(CangyouQuanDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell){
        cell=[[CangyouQuanDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=ColorHex(@"f6f6f6");
    }
    
    cell.model=model;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CangyouQuanDetailModel *model=[CangyouQuanDetailModel mj_objectWithKeyValues:self.lstData[indexPath.row]];
   
    
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = model.id;
    detailVC.topictype = @"2";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(CGFloat)getCellHeight:(CangyouQuanDetailModel *)model{
    CGFloat cellHeight=45;
    //个人信息头像部分高度
    cellHeight=45+15;
    //下面状态显示高度
    switch (model.topictype.intValue) {
        case 1:{
            cellHeight=cellHeight+30;
        }break;
        case 2:{
            NSArray *arrayAudio=[self stringToJSON:model.audio];
            cellHeight=cellHeight+arrayAudio.count*50;
        }break;
        case 3:{
            cellHeight=cellHeight;
        }break;
        default:
            break;
    }
    //正文内容显示
    CGSize messageHeight=[model.message sizeWithFontSize:13 andMaxWidth:kScreenW-25 andMaxHeight:1000];
    cellHeight=cellHeight+messageHeight.height+20;
    
    //根据图片的个数改变cell的高度
    NSArray *arrayYuanlai=[model.photos componentsSeparatedByString:@","];
    NSMutableArray *arrayPhoto=[[NSMutableArray alloc]init];
    
    for (NSString *arrayPhotoUrl in arrayYuanlai) {
        if (arrayPhotoUrl.length>3) {
            [arrayPhoto addObject:arrayPhotoUrl];
        }
    }
    switch (arrayPhoto.count) {
        case 1:{
            cellHeight=cellHeight+kScreenW;
        }break;
        case 2:{
            cellHeight=cellHeight+(kScreenW-30)/3*2+20;
        }break;
        case 3:{
            cellHeight=cellHeight+(kScreenW-30)/3*2+20;
        }break;
        case 4:{
            cellHeight=cellHeight+(kScreenW-30)/3*2+20;
        }break;
        case 5:{
            cellHeight=cellHeight+(kScreenW-30)/3*2+20;
        }break;
        case 6:{
            cellHeight=cellHeight+(kScreenW-30)/3*2+20;
        }break;
        case 7:{
            cellHeight=cellHeight+(kScreenW-40)/3+(kScreenW-30)/3*2+30;
        }break;
        case 8:{
            cellHeight=cellHeight+(kScreenW-40)/3+(kScreenW-30)/3*2+30;
        }break;
        case 9:{
            cellHeight=cellHeight+(kScreenW-40)/3+(kScreenW-30)/3*2+30;
        }break;
        default:
            break;
    }
    
    //添加状态栏
    cellHeight=cellHeight+55;
    
    //视频
    NSString *strVideo=model.video;
    if (strVideo.length>2) {
        NSMutableArray *arrayVideo=[[strVideo componentsSeparatedByString:@","] mutableCopy];
        for (NSString *strPic in arrayVideo) {
            if (strPic.length<2) {
                [arrayVideo removeObject:strPic];
            }
        }
        cellHeight=cellHeight+170*arrayVideo.count+10;
    }
    
    NSString *strWebUrl=model.source;
    NSArray *arrayWebUrl=[strWebUrl componentsSeparatedByString:@","];
    NSMutableArray *arrayWebUrlLink=[[NSMutableArray alloc]init];
    for (NSString *strWeb in arrayWebUrl) {
        if (strWeb.length>1) {
            [arrayWebUrlLink addObject:strWeb];
        }
    }
    if (arrayWebUrlLink.count>0) {
        cellHeight=cellHeight+40;
    }
    
    return cellHeight;
}



@end
