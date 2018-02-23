//
//  MSBFeedController.m
//  meishubao
//
//  Created by T on 16/11/24.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBFeedController.h"
#import "GeneralConfigure.h"

#import "HMTextView.h"
@interface MSBFeedController ()
@property (nonatomic, weak) HMTextView  *textView;
@end

@implementation MSBFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = self.defaultBgColor;
    self.title = @"意见反馈";
//     [self setTitle:@"意见反馈"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self commitInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitInit{
    HMTextView *textView = [HMTextView new];
    textView.placehoderColor =RGBALCOLOR(209, 209, 209, 0.5);
    textView.dk_textColorPicker =DKColorPickerWithRGB(0x030303, 0x989898);
    textView.placehoder = @"写下您需要的帮助和问题反馈……";
    [textView.layer setCornerRadius:5.f];
    textView.layer.dk_borderColorPicker = DKColorPickerWithRGB(0xaaaaaa, 0x282828);
    [textView.layer setBorderWidth:0.5f];
    [textView setClipsToBounds:YES];
//    [textView setBackgroundColor:[UIColor whiteColor]];
    textView.dk_backgroundColorPicker =DKColorPickerWithKey(BG);
    [textView setFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 92)];
    self.textView = textView;
    [self.view addSubview:textView];
    
    MSBCustomBtn *submitBtn = [MSBCustomBtn buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setFrame: CGRectMake(10, CGRectGetMaxY(textView.frame) + 10, SCREEN_WIDTH - 20, 37.f)];
    [submitBtn addTarget:self action:@selector(summitClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)summitClick{
    [self.view endEditing:YES];
    
    if (self.textView.text.length==0) {
        [self hudTip:@"多少写点内容吧!"];
        return;
    }
    [self hudLoding];
    __weak __block typeof(self ) weakSelf = self;
    [[LLRequestBaseServer shareInstance] requestSubmitFeedbackWithDesc:self.textView.text contact_info:nil name:nil success:^(LLResponse *response, id data) {
        [weakSelf showSuccess:@"反馈成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(LLResponse *response) {

        [weakSelf showError:@"反馈失败"];
    } error:^(NSError *error) {

        [weakSelf showError:@"反馈失败"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
