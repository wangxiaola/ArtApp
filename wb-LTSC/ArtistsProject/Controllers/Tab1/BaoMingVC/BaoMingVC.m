//
//  BaoMingVC.m
//  ShesheDa
//
//  Created by chen on 16/7/31.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "BaoMingVC.h"
#import "STextFieldWithTitle.h"
#import "PayNewVC.h"
#import "TextVC.h"

@interface BaoMingVC (){
    STextFieldWithTitle *txtSign,*txtBirthday,*txtBirthday1;
    STextFieldWithTitle *txtSign1,*txtPlace,*txtSign3;
    NSMutableArray *arrayCateCory;
    HTextView *txtView;
    NSString *strTotalMoney;
}

@end

@implementation BaoMingVC
@synthesize money,uID;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title=@"报名";
    [self loadData];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem=rightBar;
}

-(void)loadData{
    [self showLoadingHUDWithTitle:@"正在获取藏品类别" SubTitle:nil];
     NSDictionary *dict = @{};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"cataprice" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        arrayCateCory=[responseObject mutableCopy];
        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hideAnimated:YES];
    }];
}
- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}


- (void) createView:(UIView*)contentView{
    arrayCateCory=[[NSMutableArray alloc]init];
    __weak __typeof(self)weakSelf = self;
    
    //个性签名
    txtSign=[[STextFieldWithTitle alloc]init];
    txtSign.title=@"费用";
    txtSign.isBottom=NO;
    txtSign.isHideArrow=YES;
    txtSign.headLineWidth=0;
    [contentView addSubview:txtSign];
    [txtSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(20);
        make.height.mas_equalTo(45);
    }];
    txtSign.borderColor=kLineColor;
    txtSign.borderWidth=HViewBorderWidthMake(1, 0, 1, 0);
    txtSign.submit=money;
    
//    //绑定手机号
//    txtBirthday=[[STextFieldWithTitle alloc]init];
//    __weak __typeof(STextFieldWithTitle *) weakTxtBirthday=txtBirthday;
//    txtBirthday.title=@"鉴定方式";
//    txtBirthday.isBottom=NO;
//    txtBirthday.headLineWidth=0;
//    txtBirthday.didTapBlock = ^(){
//        HSingleCategoryChoiceVC *vc=[[HSingleCategoryChoiceVC alloc] init];
//        NSMutableArray *itemSex= [[NSMutableArray alloc] initWithCapacity:0];
//        [itemSex addObject:HKeyValuePair(@"1", @"现场一对一")];
//        [itemSex addObject:HKeyValuePair(@"2", @"视频认证")];
//        vc.items=itemSex;
//        
//        vc.numberOfColumns=1;
//        vc.navTitle=@"请选择类别";
//        vc.disabledClear=YES;
//        [vc setFinishSelectedBlock:^(NSArray<HKeyValuePair*> *selectItems) {
//            weakTxtBirthday.submit=selectItems[0].displayText;
//            weakTxtBirthday.strTag=selectItems[0].value;
//        }];
//        [weakSelf presentSemiViewController:vc];
//    };
//    [contentView addSubview:txtBirthday];
//    [txtBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(contentView);
//        make.top.equalTo(txtSign.mas_bottom).offset(20);
//        make.height.mas_equalTo(45);
//    }];
//    
//    //绑定手机号
//    txtBirthday1=[[STextFieldWithTitle alloc]init];
//    __weak __typeof(STextFieldWithTitle *) weaktxtBirthday1=txtBirthday1;
//    txtBirthday1.title=@"藏品类别";
//    txtBirthday1.isBottom=NO;
//    txtBirthday1.headLineWidth=0;
//    txtBirthday1.didTapBlock = ^(){
//        HSingleCategoryChoiceVC *vc=[[HSingleCategoryChoiceVC alloc] init];
//        NSMutableArray *itemSex= [[NSMutableArray alloc] initWithCapacity:0];
//        
//        if (arrayCateCory.count<1) {
//            return ;
//        }
//        
//        for (NSMutableDictionary *dicItem in arrayCateCory) {
//            [itemSex addObject:HKeyValuePair([dicItem objectForKey:@"cata_type"], [dicItem objectForKey:@"name"])];
//        }
//        vc.items=itemSex;
//        vc.numberOfColumns=1;
//        vc.navTitle=@"请选择类别";
//        vc.disabledClear=YES;
//        [vc setFinishSelectedBlock:^(NSArray<HKeyValuePair*> *selectItems) {
//            weaktxtBirthday1.submit=selectItems[0].displayText;
//            weaktxtBirthday1.strTag=selectItems[0].value;
//            
////            for (NSMutableDictionary *dicItem in arrayCateCory) {
////                if ([[dicItem objectForKey:@"cata_type"]isEqualToString:selectItems[0].value]) {
////                    strPrice=[dicItem objectForKey:@"price"];
////                    lblTip.text=[NSString stringWithFormat:@"极速鉴定费:%@元",strPrice];
////                }
////            }
//        }];
//        [weakSelf presentSemiViewController:vc];
//    };
//    [contentView addSubview:txtBirthday1];
//    [txtBirthday1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(contentView);
//        make.top.equalTo(txtBirthday.mas_bottom);
//        make.height.mas_equalTo(45);
//    }];
//    
//    //地区
//    txtPlace=[[STextFieldWithTitle alloc]init];
//    txtPlace.title=@"藏品件数";
//    txtPlace.isBottom=NO;
//    txtPlace.headLineWidth=0;
//    txtPlace.didTapBlock=^(){
//        TextVC *viewText = [[TextVC alloc] init];
//        viewText.navTitle =@"藏品件数";
//        viewText.placeholder = @"请输入藏品件数";
//        viewText.maxLength = 50;
//        viewText.checkTips = @"藏品件数不能为空";
//        viewText.isMultiLine = NO;
//        viewText.isBack=YES;
//        [viewText setSaveBtnCilck:^(NSString * name) {
//            [weakSelf getName:name];
//        }];
//        [weakSelf.navigationController pushViewController:viewText animated:YES];
//    };
//    [contentView addSubview:txtPlace];
//    [txtPlace mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(contentView);
//        make.top.equalTo(txtBirthday1.mas_bottom);
//        make.height.mas_equalTo(45);
//    }];
    
    //个性签名
    txtSign1=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtSign1=txtSign1;
    txtSign1.title=@"手机号";
    txtSign1.isBottom=NO;
    txtSign1.headLineWidth=0;
    txtSign1.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"手机号";
        viewText.placeholder = @"请输入您的手机号";
        viewText.maxLength = 200;
        viewText.checkTips = @"手机号不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtSign1.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtSign1];
    [txtSign1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSign.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    txtSign.borderColor=kLineColor;
    txtSign.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    txtSign3=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtSign3=txtSign3;
    txtSign3.title=@"姓名";
    txtSign3.isBottom=NO;
    txtSign3.headLineWidth=0;
    txtSign3.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"姓名";
        viewText.placeholder = @"请输入您的姓名";
        viewText.maxLength = 200;
        viewText.checkTips = @"姓名不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtSign3.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtSign3];
    [txtSign3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSign1.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    txtSign3.borderColor=kLineColor;
    txtSign3.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);

    //备注
    txtView=[[HTextView alloc]init];
    txtView.placeholder=@"备注";
    txtView.font=kFont(15);
    txtView.textColor=kTitleColor;
    txtView.backgroundColor=kWhiteColor;
    [contentView addSubview:txtView];
    [txtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSign3.mas_bottom).offset(30);
        make.height.mas_equalTo(150);
    }];
    
//    HLabel *lblTip=[[HLabel alloc]init];
//    lblTip.textColor=kTitleColor;
//    lblTip.font=kFont(15);
//    lblTip.textEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
//    lblTip.text=@"* 鉴定服务费根据藏品件数自动计算";
//    [contentView addSubview:lblTip];
//    [lblTip mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(contentView);
//        make.top.equalTo(txtView.mas_bottom).offset(30);
//    }];
}

- (void)getName:(NSString *)name{
        if ([self isPureNumandCharacters:name]) {
            txtPlace.submit = name;
            strTotalMoney=[NSString stringWithFormat:@"%.2f",money.floatValue*name.intValue];
            txtSign.submit = strTotalMoney;
        }else{
            [self showErrorHUDWithTitle:@"请输入整数" SubTitle:nil Complete:nil];
        }
}

//提交按钮点击事件
-(void)rightBar_Click{
    if (![self isNavLogin]) {
        return ;
    }
    [self.view endEditing:YES];
//    if (strTotalMoney.length<1) {
//        [self showErrorHUDWithTitle:@"请输入藏品件数" SubTitle:nil Complete:nil];
//        return ;
//    }
//    
//    if (txtBirthday.strTag.length<1) {
//        [self showErrorHUDWithTitle:@"请选择鉴定方式" SubTitle:nil Complete:nil];
//        return ;
//    }
//    
//    if (txtBirthday1.strTag.length<1) {
//        [self showErrorHUDWithTitle:@"请选择藏品类别" SubTitle:nil Complete:nil];
//        return ;
//    }
    
    if (txtSign1.submit.length<1) {
        [self showErrorHUDWithTitle:@"请输入手机号" SubTitle:nil Complete:nil];
        return ;
    }
    
    if (txtSign3.submit.length<1) {
        [self showErrorHUDWithTitle:@"请输入姓名" SubTitle:nil Complete:nil];
        return ;
    }
    
    [self showLoadingHUDWithTitle:@"正在报名..." SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0",
                           @"eid": uID?:@"0",
                           @"name":txtSign3.submit?:@"",
                           @"phone":txtSign1.submit?:@"",
                           @"note":txtView.text?:@"",
                           @"sex":@"0",
                           @"leibie":txtBirthday1.strTag?:@"",
                           @"jdfs":txtBirthday.strTag?:@"",
                           @"jianshu":txtPlace.submit?:@""};
    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"signupevent"
                               andPramater:dict
                      andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
                          ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        PayNewVC *vc=[[PayNewVC alloc]init];
        vc.money =  [NSString stringWithFormat:@"%.2f",[money floatValue]*100];
        vc.uID=uID;
        [self.navigationController pushViewController:vc animated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hide:YES];
    }];

}

@end
