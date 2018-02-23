//
//  InviteVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/13.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "InviteVc.h"
#import "ClassifyCell.h"
#import "sendBtn.h"
#import "InviteFriendsModel.h"
#import "LBAddressBookVC.h"

#define ONE_ONE_CELL (T_WIDTH(40))
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <SinaWeiboConnector/SinaWeiboConnector.h>

@interface InviteVc ()<UIAlertViewDelegate>
{
InviteFriendsModel *model;
}
@property(nonatomic,strong)NSArray* classifyArr;
@property(nonatomic,strong)UIImageView* headView;
@property(nonatomic,strong)UIImageView* iconViw;
@property(nonatomic,strong)NSDictionary* userdic;
@property(nonatomic,strong)OSMessage *msg;
@property(strong,nonatomic)NSString *strShare;
@end

@implementation InviteVc
-(void)createView{
    [super createView];
    self.tabView.separatorColor = CELL_LINE_COLOR;
     self.tabView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tabView.tableHeaderView = self.headView;
    self.tabView.backgroundColor = BACK_VIEW_COLOR;
    self.tabView.tableFooterView = [UIImageView new];
    self.tabView.scrollEnabled = NO;
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _classifyArr = @[@{
                         @"title" : @"分享到朋友圈",
                         @"icon" : @"icon_share2",
                         },
                     @{
                         @"title" : @"微信好友",
                         @"icon" : @"icon_share1",
                         },
                     @{
                         @"title" : @"新浪微博",
                         @"icon" : @"icon_share4",
                         },
//                     @{
//                         @"title" : @"QQ空间",
//                         @"icon" : @"icon_share5",
//                         },
                     @{
                         @"title" : @"手机通讯录好友",
                         @"icon" : @"icon_share7",
                         },
                     @{
                         @"title" : @"发送邮件",
                         @"icon" : @"icon_share8",
                         },
                     @{
                         @"title" : @"复制链接",
                         @"icon" : @"icon_share9",
                         },
                     
                     ];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else if(section==1){
        return 3;
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ONE_ONE_CELL;
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
    if (indexPath.section==0) {
        dic = _classifyArr[indexPath.row];
    }else if(indexPath.section==1){
        dic = _classifyArr[indexPath.row+3];
    }
    
    [cell setClassifyImg:dic[@"icon"] title:dic[@"title"] subImg:nil];
    
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView* img = [[UIImageView alloc]init];
    img.frame =  CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(20));
    img.backgroundColor = BACK_VIEW_COLOR;
    return img;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return T_WIDTH(20);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0://朋友圈
                {
                    NSString *strDesc=[self.userdic objectForKey:@"nmae"];
                    NSString *desc=[self.userdic objectForKey:@"message"];
                    NSString *domain=[self.userdic objectForKey:@"domain"];
                    NSString *_sharedes=[NSString stringWithFormat:@"%@:%@|%@",strDesc,desc,domain];
                    UIImage *image=_iconViw.image;//[UIImage imageNamed:@"icon_Placeholdder_2"];
                    NSArray *imageArray = @[image];
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//                    _sharedes = kShareTitle;
                    [shareParams SSDKSetupShareParamsByText:_sharedes
                                                     images:imageArray //传入要分享的图片
                                                        url:[NSURL URLWithString:domain]
                                                      title:_sharedes
                                                       type:SSDKContentTypeText];
                    
                    //分享类型
                    SSDKPlatformType platformType;
                    platformType = SSDKPlatformSubTypeWechatTimeline;
                    [ShareSDK share:platformType //传入分享的平台类型
                         parameters:shareParams
                     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理
                         switch (state) {
                             case SSDKResponseStateSuccess:
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     SIAlertView* alert = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"分享成功"];
                                     [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:nil];
                                     [alert show];
                                 });
                                 break;
                             }
                             case SSDKResponseStateFail:
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     SIAlertView* alert = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"分享失败"];
                                     [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:nil];
                                     [alert show];
                                 });
                                 break;
                             }
                             default:
                                 break;
                         }
                         
                     }];
                }
                    break;
                case 1://微信好友
                {
                    NSString *strDesc=[self.userdic objectForKey:@"name"];
                    NSString *desc=[self.userdic objectForKey:@"message"];
                    NSString *domain=[self.userdic objectForKey:@"domain"];
                    NSString *_sharedes=[NSString stringWithFormat:@"%@:%@|%@",strDesc,desc,domain];
                    UIImage *image=_iconViw.image;//[UIImage imageNamed:@"icon_Placeholdder_2.png"];
                    NSArray *imageArray = @[image];
                    //        NSString * str = @"https://itunes.apple.com/us/app/%E7%9B%9B%E5%85%B8%E9%89%B4%E5%AE%9D/id1145469172?mt=8";
                    ////        NSString* url = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    //        NSURL *_shareurl=[NSURL URLWithString:str];
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    [shareParams SSDKSetupShareParamsByText:_sharedes
                                                     images:imageArray //传入要分享的图片
                                                        url:[NSURL URLWithString:domain]
                                                      title:_sharedes
                                                       type:SSDKContentTypeText];
                    
                    //分享类型
                    SSDKPlatformType platformType;
                    platformType = SSDKPlatformSubTypeWechatSession;
                    [ShareSDK share:platformType //传入分享的平台类型
                         parameters:shareParams
                     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理
                         switch (state) {
                             case SSDKResponseStateSuccess:
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     SIAlertView* alert = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"分享成功"];
                                     [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:nil];
                                     [alert show];
                                 });
                                 break;
                             }
                             case SSDKResponseStateFail:
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     SIAlertView* alert = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"分享失败"];
                                     [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:nil];
                                     [alert show];
                                 });
                                 break;
                             }
                             default:
                                 break;
                         }
                         
                         
                     }];

                }
                    break;
                case 2://新浪微博
                {
                    NSString *strDesc=[self.userdic objectForKey:@"name"];
                    NSString *desc=[self.userdic objectForKey:@"message"];
                    NSString *domain=[self.userdic objectForKey:@"domain"];
                    NSString *_sharedes=[NSString stringWithFormat:@"%@:%@|%@",strDesc,desc,domain];
                    UIImage *image=_iconViw.image;//[UIImage imageNamed:@"icon_Placeholdder_2.png"];
                    NSArray *imageArray = @[image];
                    //        NSString * str = @"https://itunes.apple.com/us/app/%E7%9B%9B%E5%85%B8%E9%89%B4%E5%AE%9D/id1145469172?mt=8";
                    ////        NSString* url = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    //        NSURL *_shareurl=[NSURL URLWithString:str];
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    [shareParams SSDKSetupShareParamsByText:_sharedes
                                                     images:imageArray //传入要分享的图片
                                                        url:[NSURL URLWithString:domain]
                                                      title:_sharedes
                                                       type:SSDKContentTypeText];
                    
                    //分享类型
                    SSDKPlatformType platformType;
                    platformType = SSDKPlatformTypeSinaWeibo;
                    [ShareSDK share:platformType //传入分享的平台类型
                         parameters:shareParams
                     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) { // 回调处理
                         kPrintLog(error);
                         switch (state) {
                             case SSDKResponseStateSuccess:
                             {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     SIAlertView* alert = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"分享成功"];
                                     [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:nil];
                                     [alert show];
                                 });
                                 break;
                             }
                             case SSDKResponseStateFail:
                             {
                                 kPrintLog(error)
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     SIAlertView* alert = [[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"分享失败"];
                                     [alert addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:nil];
                                     [alert show];
                                 });
                                 break;
                             }
                             default:
                                 break;
                         }
                         
                         
                     }];

                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0://手机通信录
                {
                    LBAddressBookVC *vc=[[LBAddressBookVC alloc]init];
                    vc.msg=self.msg;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1://邮件
                {
                    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入邮件地址" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
                    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
                    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
                    [dialog show];

                }
                    break;
                case 2://复制链接
                {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = self.msg.link;
                    [self showOkHUDWithTitle:@"已复制至粘贴板" SubTitle:nil Complete:nil];
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
}
-(UIImageView*)headView{
    if (_headView==nil) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,T_WIDTH(120))];
        _headView.userInteractionEnabled = YES;
        UIImageView* img1 = [[UIImageView alloc]init];
                img1.frame = CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(15));
              img1.backgroundColor = BACK_VIEW_COLOR;
        [_headView addSubview:img1];

        _iconViw = [[UIImageView alloc]initWithFrame:CGRectMake(_headView.bounds.size.width/2-T_WIDTH(40),getViewHeight(img1)+T_WIDTH(10), T_WIDTH(80),T_WIDTH(80))];
        [_headView addSubview:_iconViw];
        }
    return _headView;
}
//获取用户信息
-(void)loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?[Global sharedInstance].userID:@""};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"invite" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        _userdic=[NSDictionary dictionaryWithDictionary:responseObject];
        [_iconViw sd_setImageWithURL:[NSURL URLWithString:_userdic[@"photo"]]];
        if (!_iconViw.image) {
            _iconViw.image = [UIImage imageNamed:@"AppIcon.png"];
        }
        model=[InviteFriendsModel mj_objectWithKeyValues:responseObject];
        self.msg = [[OSMessage alloc] init];
        self.msg.title = @"盛典鉴宝";
        self.msg.desc =model.message;
        UIImage *dataImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.avatar]]];
        NSData* shareImage = UIImagePNGRepresentation(dataImage);
        NSData* shareThumbImage =UIImagePNGRepresentation([[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.photo]]] imageCompressForWidth:60]);
        self.msg.image = shareImage;
        self.msg.thumbnail = shareThumbImage;
        self.msg.link = model.domain;
        self.strShare=model.message;
        [self.hudLoading hide:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hide:YES];
    }];
}

//-(void)loadData{
//    
//   NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?[Global sharedInstance].userID:@""};    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
//    __weak typeof(self)weakSelf = self;
//    
//    [ArtRequest GetRequestWithActionName:@"invite" andPramater:dict succeeded:^(id responseObject) {
//        [weakSelf.hudLoading hideAnimated:YES];
//        _userdic=[NSDictionary dictionaryWithDictionary:responseObject];
//        [_iconViw sd_setImageWithURL:[NSURL URLWithString:_userdic[@"photo"]]];
//    } failed:^(id responseObject) {
//        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
//        __strong typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf.hudLoading hideAnimated:YES];
//        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
//            [strongSelf loadData];
//        }];
//        
//    }];
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=0) {
        return ;
    }
    UITextField *nameField = [alertView textFieldAtIndex:0];
    
    if (nameField.text.length<1) {
        [self showErrorHUDWithTitle:@"邮箱不能为空" SubTitle:nil Complete:nil];
        return ;
    }
    NSLog(@"%@",nameField.text);
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject:nameField.text];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"", nil];
    //    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //    //添加密送
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"", nil];
    //    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //
    //    //添加主题
    //    [mailUrl appendString:@"&subject=盛典鉴宝"];
    //    //添加邮件内容
    //    [mailUrl appendString:@"&body=<b>email</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

@end
