//
//  HShareVC
//
//  Created by HeLiulin on 15/10/29.
//  Copyright © 2015年 XICHUNZHAO. All rights reserved.
//

#import "HButton.h"
#import "HGridView.h"
#import "ArtShareView.h"
#import "HView.h"
#import "ListResultModel.h"
#import "AppDelegate.h"

#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <SinaWeiboConnector/SinaWeiboConnector.h>
#import "SIAlertView.h"


@interface ArtShareView ()
{
    UIView  *_bgView;
}
@end

@implementation ArtShareView

- (void)showShareView
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate.window addSubview:self];
}
- (void)dismissSemiModalView
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _bgView.top = kScreenH;
        
    }completion:^(BOOL finished) {
        [Global sharedInstance].shareId = @"";//清空分享id
        [self removeFromSuperview];
    }];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    //背景颜色
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSemiModalView)];
    [self addGestureRecognizer:tap];
    
    CGFloat btnWidth = kScreenW/5.0;
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, btnWidth * 2 + kScreenW/320*40)];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_bgView];
    
    
    NSArray* lstImages = @[ @"icon_share1", @"icon_share2", @"icon_share4",@"icon_share7", @"icon_share9", @"icon_share10" ];
        NSArray*  lstTitles = @[ @"微信好友", @"朋友圈", @"新浪微博", @"短信", @"复制链接", @"新窗口打开" ];
    
    UIScrollView *scollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, btnWidth+kScreenW/320*20)];
    scollView1.showsVerticalScrollIndicator = NO;
    scollView1.showsHorizontalScrollIndicator = NO;
    [_bgView addSubview:scollView1];
    
    for (int i = 0; i < lstImages.count; i++)
    {
        HButton* btnShare = [HButton new];
        btnShare.frame = CGRectMake(i * btnWidth,kScreenW/320*10, btnWidth, btnWidth);
        [btnShare setImage:[UIImage imageNamed:lstImages[i]] forState:UIControlStateNormal];
        btnShare.imageTextAlignment = HButtonImageTextAlignmentVertical;
        [btnShare setTitle:lstTitles[i] forState:UIControlStateNormal];
        [btnShare setTitleColor:kTitleColor forState:UIControlStateNormal];
        [btnShare.titleLabel setFont:[[Global sharedInstance] fontWithSize:12]];
        btnShare.tag = i + 1;
        [btnShare addTarget:self action:@selector(btnShare_Click:) forControlEvents:UIControlEventTouchUpInside];
        scollView1.contentSize =CGSizeMake(btnShare.right, btnWidth);
        [scollView1 addSubview:btnShare];
    }
    
    UIView *secconView = [[UIView alloc]initWithFrame:CGRectMake(0, _bgView.height/2, kScreenW, btnWidth)];
    [_bgView addSubview:secconView];
    
    BOOL  isSame=NO;
    NSString* uid = [NSString stringWithFormat:@"%@",[Global sharedInstance].userID];
    NSString* shareId = [NSString stringWithFormat:@"%@",[Global sharedInstance].shareId];
    
    if (shareId.length>0&&uid.length>0) {//如果是登录用户自己发布的分享
        if ([shareId isEqualToString:uid]) {
            isSame = YES;
        }
    }
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, _bgView.height/2, kScreenW - 20, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:lineView];
    [UIView animateWithDuration:0.25 animations:^{
        
        _bgView.top = kScreenH - btnWidth * 2.0  - 40;
    }];
}
- (void)customBtn_Click:(UIButton*)btn{
    switch (btn.tag) {
        case 20://编辑z
        {
            if ([[Global sharedInstance].isgroup integerValue] != 1) {
                [ArtUIHelper addHUDInView:SharedApplication.keyWindow text:@"暂无权限" hideAfterDelay:1.0];
                return;
            }
            if (self.selectEditClick) {
                self.selectEditClick();
            }
            [self dismissSemiModalView];
            break;
            
        }
        case 21://删除
        {
            if ([[Global sharedInstance].isgroup integerValue] != 1) {
                [ArtUIHelper addHUDInView:SharedApplication.keyWindow text:@"暂无权限" hideAfterDelay:1.0];
                return;
            }
            if (self.selectShanchuCilck) {
                self.selectShanchuCilck();
            }
            [self dismissSemiModalView];
            break;
            
        }
            
        case 22://置顶
        {
            if ([[Global sharedInstance].isgroup integerValue] != 1) {
                [ArtUIHelper addHUDInView:SharedApplication.keyWindow text:@"暂无权限" hideAfterDelay:1.0];
                return;
            }
            if (self.selectDingzhiCilck) {
                self.selectDingzhiCilck();
            }
            [self dismissSemiModalView];
            break;
        }
        case 23://收藏
        {
            if (self.selectShoucangCilck) {
                self.selectShoucangCilck();
            }
            [self dismissSemiModalView];
            break;
        }
        case 24: {
            //举报
            if (self.selectJubaoCilck) {
                self.selectJubaoCilck();
            }
            [self dismissSemiModalView];
            break;
        }
            
            
        default:
            break;
    }
}
- (void)btnShare_Click:(HButton*)button
{
    if (button.tag==2||button.tag==1) {
        if (_sharedes.length>130)
        {
            _sharedes = [_sharedes substringToIndex:130];
        }
        if (_sharetitle.length>130)
        {
            _sharetitle = [_sharetitle substringToIndex:130];
        }
    }
    UIImage *image=_shareimage;
    NSArray *imageArray = @[image];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:_sharedes
                                     images:imageArray //传入要分享的图片
                                        url:[NSURL URLWithString:_shareurl]
                                      title:_sharetitle
                                       type:SSDKContentTypeAuto];
    
    //分享类型
    SSDKPlatformType platformType;
    
    switch (button.tag)
    {
        case 1: //微信好友
        {
            platformType = SSDKPlatformSubTypeWechatSession;
            break;
        }
        case 2: //微信朋友圈
        {
            platformType = SSDKPlatformSubTypeWechatTimeline;
            break;
        }
        case 3: //新浪微博
        {
            platformType = SSDKPlatformTypeSinaWeibo;
            
            break;
        }
        case 4: //短信 使用shareSDK方法
        {
            platformType = SSDKPlatformTypeSMS;
            break;
        }
            //        case 5: //邮件 使用之前的方法 没有变
            //        {
            //            //platformType = SSDKPlatformTypeMail;
            //            UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"请输入邮件地址" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            //            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            //            [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
            //            [dialog show];
            //            return;
            //        }
        case 5: //复制链接
        {
            if (self.sharedes && self.sharedes.length > 0)
            {
                UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = _sharedes;
                //复制成功提示
                UIAlertView* fuzhi = [[UIAlertView alloc] initWithTitle:@"提示" message:@"复制成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [fuzhi show];
                
            }
            
            [self dismissSemiModalView];
            return;
        }
        case 6: //新窗口打开
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_shareurl]];
            [self dismissSemiModalView];
            return;
        }
        default:
            break;
    }
    [ShareSDK share:platformType //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {// 回调处理
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


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        return;
    }
    UITextField* nameField = [alertView textFieldAtIndex:0];
    
    if (nameField.text.length < 1) {
        //        [self showErrorHUDWithTitle:@"邮箱不能为空" SubTitle:nil Complete:nil];
        return;
    }
    NSLog(@"%@", nameField.text);
    NSMutableString* mailUrl = [[NSMutableString alloc] init];
    //添加收件人
    NSArray* toRecipients = [NSArray arrayWithObject:nameField.text];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:@"&subject=盛典鉴宝"];
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>email</b> body!"];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark - 短信
- (void)sendSmsMessageWithPhoneNumber:(NSString*)phoneNumber
{
    if ([MFMessageComposeViewController canSendText]) {
        [self displaySMSComposerSheetPhoneNumber:phoneNumber];
    }
    else {
        UIAlertView* msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备不支持发短信" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [msgbox show];
    }
}
- (void)displaySMSComposerSheetPhoneNumber:(NSString*)phoneNumber
{
    MFMessageComposeViewController* picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = (id<MFMessageComposeViewControllerDelegate>)self;
    
    //    picker.recipients = [NSArray arrayWithObject:phoneNumber];
    
    picker.body = [NSString stringWithFormat:@"%@", self.sharedes];
    //    [self presentViewController:picker animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController*)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed: {
            UIAlertView* msgbox = [[UIAlertView alloc] initWithTitle:@"提示" message:@"短信发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [msgbox show];
            
        } break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
