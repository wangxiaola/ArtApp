//
//  MSBShareCommentView.m
//  meishubao
//
//  Created by T on 16/12/22.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBShareCommentView.h"
#import "GeneralConfigure.h"
#import "MSBShareCustomBtn.h"
#import "MSBCommentView.h"
#import <MessageUI/MessageUI.h>
static const CGFloat kMSBShareTopContentViewH = 118.f;
static const CGFloat kMSBShareBottomContentViewH = kMSBShareCommentViewH - kMSBShareTopContentViewH;
@interface MSBShareCommentView ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, weak) UIView  *topContentView;
@property (nonatomic, weak) MSBShareCustomBtn  *answerBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *zhuanfaBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *fuzhiBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *storeBtn;
@property (nonatomic, weak) CAShapeLayer  *shapeLayerLineMiddle;

@property (nonatomic, weak) UIView  *middleContentView;
@property (nonatomic, weak) MSBShareCustomBtn  *sysBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *msgBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *mailBtn;
@property (nonatomic, weak) MSBShareCustomBtn  *jubaoBtn;

@property (nonatomic, weak) UIButton  *bottomContentView;

@property (nonatomic, weak) UIButton  *contentView;
@end

@implementation MSBShareCommentView

+ (instancetype)shareInstance{
    static MSBShareCommentView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MSBShareCommentView alloc] init];
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
        
//        CAShapeLayer  *shapeLayerLineMiddle = [CAShapeLayer layer];
//        [shapeLayerLineMiddle setBackgroundColor:RGBCOLOR(200, 199, 204).CGColor];
//        self.shapeLayerLineMiddle = shapeLayerLineMiddle;
//        [topContentView.layer addSublayer:shapeLayerLineMiddle];
        
        MSBShareCustomBtn  *answerBtn = [self btnTitle:@"回复" image:@"" type:MSBShareCommentTypeAnswer];
        self.answerBtn = answerBtn;
        [topContentView addSubview:answerBtn];
        
//        MSBShareCustomBtn  *zhuanfaBtn =  [self btnTitle:@"转发" image:@"detailpage_share_zhuanfa" type:MSBShareCommentTypeZhuanfa];
//        self.zhuanfaBtn = zhuanfaBtn;
//        [topContentView addSubview:zhuanfaBtn];
        
        MSBShareCustomBtn  *fuzhiBtn= [self btnTitle:@"复制" image:@"" type:MSBShareCommentTypeCopy];
        self.fuzhiBtn = fuzhiBtn;
        [topContentView addSubview:fuzhiBtn];
        
//        MSBShareCustomBtn  *storeBtn= [self btnTitle:@"收藏" image:@"detailpage_share_store" type:MSBShareCommentTypeStore];
//        self.storeBtn = storeBtn;
//        [topContentView addSubview:storeBtn];
        //
//        UIView  *middleContentView = [UIView new];
//        [middleContentView setBackgroundColor:[UIColor clearColor]];
//        self.middleContentView = middleContentView;
//        [self addSubview:middleContentView];
//        
//        MSBShareCustomBtn  *sysBtn = [self btnTitle:@"系统分享" image:@"detailpage_share_system" type:MSBShareCommentTypeSystem];
//        self.sysBtn = sysBtn;
//        [middleContentView addSubview:sysBtn];
//        MSBShareCustomBtn  *msgBtn = [self btnTitle:@"短信" image:@"detailpage_share_message" type:MSBShareCommentTypeMsg];
//        self.msgBtn = msgBtn;
//        [middleContentView addSubview:msgBtn];
//        MSBShareCustomBtn  *mailBtn = [self btnTitle:@"邮件" image:@"detailpage_share_mail" type:MSBShareCommentTypeMail];
//        self.mailBtn = mailBtn;
//        [middleContentView addSubview:mailBtn];
        MSBShareCustomBtn  *jubaoBtn = [self btnTitle:@"举报" image:@"" type:MSBShareCommentTypeJubao];
        self.jubaoBtn = jubaoBtn;
        [topContentView addSubview:jubaoBtn];
        
        //
        UIButton  *bottomContentView = [UIButton new];
//        [bottomContentView setBackgroundColor:[UIColor whiteColor]];
        bottomContentView.dk_backgroundColorPicker = DKColorPickerWithKey(SHAREBG_BOTTOM);
        [bottomContentView setTitle:@"取消" forState:UIControlStateNormal];
        //[bottomContentView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bottomContentView dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [bottomContentView.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        self.bottomContentView = bottomContentView;
        [bottomContentView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomContentView];
    }
    return self;
}

- (void)setBtnImage {

    UIImage * answerImage = [UIImage imageNamed:@"detailpage_share_answer"];
    UIImage * copyImage = [UIImage imageNamed:@"detailpage_share_copylink"];
    UIImage * reportImage = [UIImage imageNamed:@"detailpage_share_jubao"];

    if (THEME_NORMAL) {
        answerImage =  [answerImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
        copyImage = [copyImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
        reportImage = [reportImage imageWithTintColor:RGBCOLOR(35, 23, 20)];
    }else{
        answerImage =  [answerImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        copyImage = [copyImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
        reportImage = [reportImage imageWithTintColor:RGBCOLOR(221, 118, 125)];
    }

    [self.answerBtn setImage:answerImage forState:UIControlStateNormal];
    [self.fuzhiBtn setImage:copyImage forState:UIControlStateNormal];
    [self.jubaoBtn setImage:reportImage forState:UIControlStateNormal];
}

- (MSBShareCustomBtn *)btnTitle:(NSString *)title image:(NSString *)image type:(MSBShareCommentType)type{
    MSBShareCustomBtn  *shareBtn = [MSBShareCustomBtn buttonWithType:UIButtonTypeCustom];
    [shareBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [shareBtn.imageView setContentMode:UIViewContentModeCenter];
    [shareBtn setTitle:title forState:UIControlStateNormal];
    //[shareBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    //[shareBtn setTitleColor:RGBCOLOR(0, 0, 0) forState:UIControlStateNormal];
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
    //self.shapeLayerLineMiddle.frame = CGRectMake(0, kMSBShareTopContentViewH - 0.5f, self.topContentView.width, 0.5f);
    CGFloat topY = (kMSBShareTopContentViewH - ICONHEIGHT - TITLEHEIGHT) * 0.5;
    CGFloat topW = (SCREEN_WIDTH-50) / 4;
    CGFloat topH = ICONHEIGHT + TITLEHEIGHT;
    self.answerBtn.frame = CGRectMake(0, topY, topW, topH);
    //self.zhuanfaBtn.frame = CGRectMake(CGRectGetMaxX(self.answerBtn.frame), topY, topW, topH);
    self.fuzhiBtn.frame = CGRectMake(CGRectGetMaxX(self.answerBtn.frame), topY, topW, topH);
    //self.storeBtn.frame = CGRectMake(CGRectGetMaxX(self.fuzhiBtn.frame), topY, topW, topH);
    
    //
//    self.middleContentView.frame = CGRectMake(25.f, CGRectGetMaxY(self.topContentView.frame), SCREEN_WIDTH-50.f, kMSBShareTopContentViewH);
//    self.sysBtn.frame = CGRectMake(0, topY, topW, topH);
//    self.msgBtn.frame = CGRectMake(CGRectGetMaxX(self.sysBtn.frame), topY, topW, topH);
//    self.mailBtn.frame = CGRectMake(CGRectGetMaxX(self.msgBtn.frame), topY, topW, topH);
    self.jubaoBtn.frame = CGRectMake(CGRectGetMaxX(self.fuzhiBtn.frame), topY, topW, topH);
    
    //
    self.bottomContentView.frame = CGRectMake(0, CGRectGetMaxY(self.topContentView.frame), SCREEN_WIDTH, kMSBShareBottomContentViewH);
}

#pragma mark - Method
- (void)show{
    [self setBtnImage];
    UIButton *contentView = [UIButton buttonWithType:UIButtonTypeCustom];
    [contentView setBackgroundColor:RGBALCOLOR(0, 0, 0, 0.3f)];
    self.contentView = contentView;
    [contentView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    contentView.frame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kMSBShareCommentViewH);
    NSEnumerator *fontToBackWindows = [[UIApplication sharedApplication] windows].reverseObjectEnumerator;

    CGFloat addBottomHeight = isiPhoneX?iPhoneXBottomHeight:0;

    for (UIWindow *window in fontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal) {
            [contentView addSubview:self];
            [window addSubview:contentView];
            [UIView animateWithDuration:.25 animations:^{
                self.transform = CGAffineTransformMakeTranslation(0, -(kMSBShareCommentViewH + addBottomHeight));
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
}

-(void)replyComment:(replyCommentBlock)block
{
    self.replyBlock = block;
}

-(void)reportComment:(reportCommentBlock)block
{
    self.reportBlock = block;
}

-(void)setMsb_copyContent:(NSString *)msb_copyContent
{
    if (!msb_copyContent || msb_copyContent.length == 0) {
        return;
    }
    _msb_copyContent = msb_copyContent;
}

- (void)shareBtnClick:(MSBShareCustomBtn *)btn{
    [self dismiss];
    switch (btn.tag) {
        case MSBShareCommentTypeAnswer:
        {
            //[self removeSelf];
            [MSBCommentView commentshowSuccess:^(NSString *commentText) {
                if (self.replyBlock) {
                    self.replyBlock(commentText);
                }
            }];
            break;
        }
//        case MSBShareCommentTypeZhuanfa:
//        {
//            [self removeSelf];
//            break;
//        }
        case MSBShareCommentTypeCopy:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _msb_copyContent;
            [self.articleDetialVC hudTip:@"复制完成"];
            //[self removeSelf];
            break;
        }
//        case MSBShareCommentTypeStore:
//        {
//            [self removeSelf];
//            break;
//        }
//        case MSBShareCommentTypeSystem:
//        {
//            [self shareSystemClick];
//            break;
//        }
//        case MSBShareCommentTypeMsg:
//        {
//            [self showMessageView:nil title:nil body:nil];
//            break;
//        }
//        case MSBShareCommentTypeMail:
//        {
//            if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
//                [self sendEmailAction]; // 调用发送邮件的代码
//            }
//            break;
//        }
        case MSBShareCommentTypeJubao:
        {
            if (self.reportBlock) {
                self.reportBlock(self.comment_id);
            }
            break;
        }
            
        default:
            break;
    }
    
}

// 系统分享
- (void)shareSystemClick{
    NSArray* activityItems = [[NSArray alloc] initWithObjects:@"这里是标题",
                              @"http://link",
                              [UIImage imageNamed:@"image_name"],nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    UIActivityViewControllerCompletionHandler block = ^(NSString* activityType, BOOL completed){
        if(completed){
            NSLog(@"Share success");
        }else{
            NSLog(@"Cancel the share");
        }
        [activityVC dismissViewControllerAnimated:YES completion:nil];
        [self removeSelf];
    };
    
    activityVC.completionHandler = block;
    
    [self.articleDetialVC presentViewController:activityVC animated:YES completion:nil];
}

// 电子邮件
- (void)sendEmailAction{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"邮件主题"];
    //    // 设置收件人
    //    [mailCompose setToRecipients:@[@"邮箱号码"]];
    //    // 设置抄送人
    //    [mailCompose setCcRecipients:@[@"邮箱号码"]];
    //    // 设置密抄送
    //    [mailCompose setBccRecipients:@[@"邮箱号码"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
    //    UIImage *image = [UIImage imageNamed:@"image"];
    //    NSData *imageData = UIImagePNGRepresentation(image);
    //    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
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
            [self.articleDetialVC hudTip:@"用户取消编辑"];
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            [self.articleDetialVC hudTip:@"用户保存邮件"];
            break;
        case MFMailComposeResultSent: // 用户点击发送
            [self.articleDetialVC hudTip:@"用户点击发送"];
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


@end
