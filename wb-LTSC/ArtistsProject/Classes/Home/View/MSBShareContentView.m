//
//  MSBShareContentView.m
//  meishubao
//
//  Created by T on 16/11/17.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBShareContentView.h"
#import "GeneralConfigure.h"
#import "MSBShareCustomBtn.h"

#import <Social/Social.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <MessageUI/MessageUI.h>

static const CGFloat kMSBShareTopContentViewH = 118.f;
static const CGFloat kMSBShareBottomContentViewH = (kMSBShareContentViewH - 2 * kMSBShareTopContentViewH);
@interface MSBShareContentView ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, weak) UIView  *topContentView;
@property (nonatomic, weak) MSBShareCustomBtn  *qqBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *weixinBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *weiQBtn;
//@property (nonatomic, weak) MSBShareCustomBtn  *weiboBtn;
@property (nonatomic, weak) CAShapeLayer  *shapeLayerLineMiddle;

@property (nonatomic, weak) UIView  *middleContentView;
@property (nonatomic, weak) MSBShareCustomBtn  *sysBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *msgBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *mailBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *fuzhiBtn;

@property (nonatomic, weak) UIButton  *bottomContentView;

@property (nonatomic, weak) UIButton  *contentView;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) UIImage *img;

@end

@implementation MSBShareContentView

+ (instancetype)shareInstance{
    static MSBShareContentView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MSBShareContentView alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if (self == [super init]) {
        //self.backgroundColor = RGBCOLOR(238, 238, 238);
        self.dk_backgroundColorPicker = DKColorPickerWithKey(SHAREBG_TOP);
        //
        UIView  *topContentView = [UIView new];
        [topContentView setBackgroundColor:[UIColor clearColor]];
        self.topContentView = topContentView;
        [self addSubview:topContentView];
        
        CAShapeLayer  *shapeLayerLineMiddle = [CAShapeLayer layer];
        [shapeLayerLineMiddle setBackgroundColor:RGBCOLOR(200, 199, 204).CGColor];
        self.shapeLayerLineMiddle = shapeLayerLineMiddle;
        [topContentView.layer addSublayer:shapeLayerLineMiddle];
        
        MSBShareCustomBtn  *qqBtn = [self btnTitle:@"QQ" image:@"qq_icon" nightImage:@"qq_icon" type:MSBShareTypeQQ];
        self.qqBtn = qqBtn;
        [topContentView addSubview:qqBtn];
        
        MSBShareCustomBtn  *weixinBtn =  [self btnTitle:@"微信" image:@"detailpage_sharewx" nightImage:@"detailpage_sharewx" type:MSBShareTypeWeixin];
        self.weixinBtn = weixinBtn;
        [topContentView addSubview:weixinBtn];
        
        MSBShareCustomBtn  *weiQBtn= [self btnTitle:@"朋友圈" image:@"detailpage_share_friendquan" nightImage:@"detailpage_share_friendquan" type:MSBShareTypeWeiQ];
        self.weiQBtn = weiQBtn;
        [topContentView addSubview:weiQBtn];
        
//        MSBShareCustomBtn  *weiboBtn= [self btnTitle:@"微博" image:@"detailpage_share_weibo" nightImage:@"detailpage_share_weibo" type:MSBShareTypeWeibo];
//        self.weiboBtn = weiboBtn;
//        [topContentView addSubview:weiboBtn];
        //
        UIView  *middleContentView = [UIView new];
        [middleContentView setBackgroundColor:[UIColor clearColor]];
        self.middleContentView = middleContentView;
        [self addSubview:middleContentView];

        MSBShareCustomBtn  *sysBtn = [self btnTitle:@"系统分享" image:@"" nightImage:@"" type:MSBShareTypeSystem];
        self.sysBtn = sysBtn;
        
        [middleContentView addSubview:sysBtn];
        MSBShareCustomBtn  *msgBtn = [self btnTitle:@"短信" image:@"" nightImage:@"" type:MSBShareTypeMsg];
        self.msgBtn = msgBtn;
        
        [middleContentView addSubview:msgBtn];
        MSBShareCustomBtn  *mailBtn = [self btnTitle:@"邮件" image:@"" nightImage:@"" type:MSBShareTypeMail];
        self.mailBtn = mailBtn;
        [middleContentView addSubview:mailBtn];
        
        MSBShareCustomBtn  *fuzhiBtn = [self btnTitle:@"复制链接" image:@"" nightImage:@"" type:MSBShareTypeCopy];
        self.fuzhiBtn = fuzhiBtn;
        [middleContentView addSubview:fuzhiBtn];


        //
        UIButton  *bottomContentView = [UIButton new];
        //[bottomContentView setBackgroundColor:[UIColor whiteColor]];
        bottomContentView.dk_backgroundColorPicker = DKColorPickerWithKey(SHAREBG_BOTTOM);
        [bottomContentView setTitle:@"取消" forState:UIControlStateNormal];
        [bottomContentView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottomContentView.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [bottomContentView dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        self.bottomContentView = bottomContentView;
        [bottomContentView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomContentView];
    }
    return self;
}

- (void)setBtnImage {

    UIImage *messageImage = [UIImage imageNamed:@"detailpage_share_system"];
    UIImage *shareImage = [UIImage imageNamed:@"detailpage_share_message"];
    UIImage *storeNormalImage = [UIImage imageNamed:@"detailpage_share_mail"];
    UIImage *fuzhiImage = [UIImage imageNamed:@"detailpage_share_copylink"];
    if (THEME_NORMAL) {
        messageImage =  [messageImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
        shareImage = [shareImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
        storeNormalImage = [storeNormalImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
        fuzhiImage = [fuzhiImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
    }else{
        messageImage =  [messageImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        shareImage = [shareImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        storeNormalImage = [storeNormalImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        fuzhiImage = [fuzhiImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
    }

    [self.sysBtn setImage:messageImage forState:UIControlStateNormal];
    [self.msgBtn setImage:shareImage forState:UIControlStateNormal];
    [self.mailBtn setImage:storeNormalImage forState:UIControlStateNormal];
    [self.fuzhiBtn setImage:fuzhiImage forState:UIControlStateNormal];
}

- (MSBShareCustomBtn *)btnTitle:(NSString *)title image:(NSString *)image nightImage:(NSString *)nightImage type:(MSBShareType)type{
    MSBShareCustomBtn  *shareBtn = [MSBShareCustomBtn buttonWithType:UIButtonTypeCustom];
    [shareBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [shareBtn.imageView setContentMode:UIViewContentModeCenter];
    [shareBtn setTitle:title forState:UIControlStateNormal];
    if (image.length != 0 || image != nil) {
        [shareBtn dk_setImage:DKImagePickerWithNames(image,nightImage,image) forState:UIControlStateNormal];
    }
    //[shareBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//    [shareBtn dk_setImage:DKImagePickerWithNames(image,nightImage,image) forState:UIControlStateNormal];
    [shareBtn setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
    [shareBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [shareBtn setTag:type];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return shareBtn;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //
    self.topContentView.frame = CGRectMake(25, 0, SCREEN_WIDTH-50, kMSBShareTopContentViewH);
    self.shapeLayerLineMiddle.frame = CGRectMake(0, kMSBShareTopContentViewH - 0.5f, self.topContentView.width, 0.5f);
    CGFloat topY = (kMSBShareTopContentViewH - ICONHEIGHT - TITLEHEIGHT) * 0.5;
    CGFloat topW = (SCREEN_WIDTH-50) / 4;
    CGFloat topH = ICONHEIGHT + TITLEHEIGHT;
    //CGFloat padding = (self.topContentView.width-topW*3)/2;
    self.qqBtn.frame = CGRectMake(0, topY, topW, topH);
    self.weixinBtn.frame = CGRectMake(CGRectGetMaxX(self.qqBtn.frame), topY, topW, topH);
    self.weiQBtn.frame = CGRectMake(CGRectGetMaxX(self.weixinBtn.frame), topY, topW, topH);
    //self.weiboBtn.frame = CGRectMake(CGRectGetMaxX(self.weiQBtn.frame), topY, topW, topH);
    
    //
    self.middleContentView.frame = CGRectMake(25.f, CGRectGetMaxY(self.topContentView.frame), SCREEN_WIDTH-50.f, kMSBShareTopContentViewH);
    self.sysBtn.frame = CGRectMake(0, topY, topW, topH);
    self.msgBtn.frame = CGRectMake(CGRectGetMaxX(self.sysBtn.frame), topY, topW, topH);
    self.mailBtn.frame = CGRectMake(CGRectGetMaxX(self.msgBtn.frame), topY, topW, topH);
    self.fuzhiBtn.frame = CGRectMake(CGRectGetMaxX(self.mailBtn.frame), topY, topW, topH);
    
    //
    self.bottomContentView.frame = CGRectMake(0, CGRectGetMaxY(self.middleContentView.frame), SCREEN_WIDTH, kMSBShareBottomContentViewH);
}

#pragma mark - Method
- (void)show{
    [self setBtnImage];
    UIButton *contentView = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView setBackgroundColor:RGBALCOLOR(0, 0, 0, 0.3f)];
    self.contentView = contentView;
    [contentView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    contentView.frame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kMSBShareContentViewH);
    NSEnumerator *fontToBackWindows = [[UIApplication sharedApplication] windows].reverseObjectEnumerator;

    CGFloat addBottomHeight = isiPhoneX?iPhoneXBottomHeight:0;

    for (UIWindow *window in fontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            [contentView addSubview:self];
            [window addSubview:contentView];
            [UIView animateWithDuration:.25 animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -(kMSBShareContentViewH + addBottomHeight));
            } completion:^(BOOL finished) {
            }];
            break;
        }
    }
}

- (void)dismiss{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.contentView.hidden = YES;
    }];
}

-(void)removeSelf
{
    [self removeFromSuperview];
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    //NSLog(@"我被移除了...");
}

- (void)shareBtnClick:(MSBShareCustomBtn *)btn{
    [self dismiss];
    switch (btn.tag) {
        case MSBShareTypeQQ:
        {
            [self removeSelf];
            if (![QQApiInterface isQQInstalled]) {
                [self.articleDetialVC hudTip:@"未安装QQ"];
                return;
            }
            [self umShareToPlatformType:UMSocialPlatformType_QQ];
            break;
        }
        case MSBShareTypeWeixin:
        {
            [self removeSelf];
            if (![WXApi isWXAppInstalled]) {
                [self.articleDetialVC hudTip:@"未安装微信"];
            }
            [self umShareToPlatformType:UMSocialPlatformType_WechatSession];
            break;
        }
        case MSBShareTypeWeiQ:
        {
            [self removeSelf];
            if (![WXApi isWXAppInstalled]) {
                [self.articleDetialVC hudTip:@"未安装微信"];
            }
             [self umShareToPlatformType:UMSocialPlatformType_WechatTimeLine];
            break;
        }
//        case MSBShareTypeWeibo:
//        {
//             [self umShareToPlatformType:UMSocialPlatformType_Sina];
//            break;
//        }
        case MSBShareTypeSystem:
        {
            [self shareSystemClick];
            break;
        }
        case MSBShareTypeMsg:
        {
            [self showMessageView:nil title:_title body:[NSString stringWithFormat:@"%@%@",_title,_url]];
            break;
        }
        case MSBShareTypeMail:
        {
            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
                
                [self sendEmailAction]; // 调用发送邮件的代码
            }else {
            
                UIAlertController *alert    = [UIAlertController alertControllerWithTitle:nil message:@"进入设置,添加邮箱账户,允许\"中国美术报\"进行邮件分享" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *setAction    = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url]) {
                    
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    }
                }];
                
                UIAlertAction *cannelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:setAction];
                [alert addAction:cannelAction];
                [self.articleDetialVC presentViewController:alert animated:YES completion:nil];
            }
            break;
        }
        case MSBShareTypeCopy:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _url;
            [self.articleDetialVC hudTip:@"复制链接成功"];
            [self removeSelf];
            break;
        }
            
        default:
            break;
    }
    
}

// 系统分享
- (void)shareSystemClick{
    NSArray* activityItems = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@\n%@",_title,_url],
                              _img,nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionWithItemsHandler block = ^(NSString* activityType, BOOL completed, NSArray * returnedItems, NSError * activityError){
        if(completed){
            [self.articleDetialVC showSuccess:@"分享成功"];
        }else{
            NDLog(@"Cancel the share");
        }
        [activityVC dismissViewControllerAnimated:YES completion:nil];
        [self removeSelf];
    };
    
    activityVC.completionWithItemsHandler = block;
    
    [self.articleDetialVC presentViewController:activityVC animated:YES completion:nil];
}

// 电子邮件
- (void)sendEmailAction{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    //[mailCompose setSubject:@"邮件主题"];
//    // 设置收件人
//    [mailCompose setToRecipients:@[@"邮箱号码"]];
//    // 设置抄送人
//    [mailCompose setCcRecipients:@[@"邮箱号码"]];
//    // 设置密抄送
//    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
   // NSString *emailContent = @"邮件内容";
    // 是否为HTML格式
   /// [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
        [mailCompose setMessageBody:[NSString stringWithFormat:@"<html><body><p>%@</p><a href='%@'>%@</a></body></html>",_title,_url,_url] isHTML:YES];
    
    /**
     *  添加附件
     */
    //UIImage *image = [UIImage imageNamed:@"image"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@""];
//
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"233333"];
    
    // 弹出邮件发送视图
    [self.articleDetialVC presentViewController:mailCompose animated:YES completion:nil];
}

// MFMailComposeViewControllerDelegate的代理方法：
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error{
    switch (result){
        case MFMailComposeResultCancelled: // 用户取消编辑
            [self.articleDetialVC hudTip:@"取消编辑"];
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
             [self.articleDetialVC hudTip:@"保存邮件"];
            break;
        case MFMailComposeResultSent: // 用户点击发送
             [self.articleDetialVC hudTip:@"发送"];
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            [self.articleDetialVC showError:@"发送邮件失败"];
            break;
    }
    // 关闭邮件发送视图
    [self.articleDetialVC dismissViewControllerAnimated:YES completion:nil];
    [self removeSelf];
}

// 短信
- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self.articleDetialVC presentViewController:controller animated:YES completion:nil];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"该设备不支持短信功能"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self.articleDetialVC presentViewController:alertController animated:YES completion:nil];
    }
}
// MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [self.articleDetialVC dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MessageComposeResultCancelled:
            [self.articleDetialVC hudTip:@"取消发送"];
            break;
        case MessageComposeResultSent:
            [self.articleDetialVC showSuccess:@"已发送"];
            break;
        case MessageComposeResultFailed:
            [self.articleDetialVC showError:@"发送失败"];
            break;
            
        default:
            break;
    }
    [self removeSelf];
}

- (void)shareTitle:(NSString *)title  desc:(NSString *)desc url:(NSString *)url img:(UIImage *)img{
    _title = title;
    _desc = desc;
    _url = url;
    _img = img;
    
}

// 分享
- (void)umShareToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title descr:_desc  thumImage:_img];
    shareObject.webpageUrl = _url;
     messageObject.shareObject = shareObject;
//    __weak __block typeof(self) weakSelf = self;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self.articleDetialVC completion:^(id data, NSError *error) {
        if (error) {
            NDLog(@"error======%@", error);
           [self.articleDetialVC showError:@"分享失败"];
        }else{
            [self.articleDetialVC showSuccess:@"分享成功"];
            if (self.post_id && self.post_type) {
                [self uploadToServerShareSuccess];
            }
        }
    }];
}

// 上传分享成功
- (void)uploadToServerShareSuccess {

    [[LLRequestServer shareInstance] requestRepeatIncrementWithPostid:self.post_id type:self.post_type success:^(LLResponse *response, id data) {
        
        NDLog(@"上传分享成功");
    } failure:^(LLResponse *response) {
        
        NDLog(@"上传分享失败");
    } error:^(NSError *error) {
        
        NDLog(@"上传分享错误");
    }];
}

@end
