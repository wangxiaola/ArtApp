//
//  AuthenticationVC.m
//  ShesheDa
//
//  Created by chen on 16/7/7.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "AuthenticationVC.h"
#import "STextFieldWithTitle.h"
#import "UpYun.h"
#import "AuthenticationModel.h"
#import "TextVC.h"

@interface AuthenticationVC (){
    STextFieldWithTitle *txtName,*txtSex;
    STextFieldWithTitle *txtPlace;
    STextFieldWithTitle *txtBirthday;
    STextFieldWithTitle *txtLivingPlace;
    STextFieldWithTitle *txtSign,*txtCode,*txtTroduct;
    HImagePicker *imgHead;
    NSString *idCardUrl;
    BOOL isVerified;
    HLabel *lblState;
    HLabel *info;
}

@end

@implementation AuthenticationVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title=@"开通鉴定";
    
//    [self loadData];//加载用户数据

}

//控件放在这个方法里面才有滑动效果
- (void)createView:(UIView *)contentView{
    __weak __typeof(self) weakSelf=self;

    lblState=[[HLabel alloc]init];
    lblState.textColor=ColorHex(@"f6f6f6");
    lblState.font=kFont(16);
    lblState.textColor=kTitleColor;
    lblState.textAlignment=NSTextAlignmentCenter;
    [contentView addSubview:lblState];
    [lblState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.mas_equalTo(60);
    }];
    
    //昵称
    txtName=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtName=txtName;
    txtName.title=@"姓名";
    txtName.isBottom=NO;
    txtName.headLineWidth=0;
    txtName.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"昵称";
        viewText.placeholder = @"请输入您的昵称";
        viewText.maxLength = 20;
        viewText.checkTips = @"昵称不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtName.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtName];
    [txtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lblState.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    //性别
    txtSex=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtSex=txtSex;
    txtSex.title=@"手机号";
    txtSex.headLineWidth=0;
    txtSex.isBottom=NO;
    txtSex.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"手机";
        viewText.placeholder = @"请输入您的手机号码";
        viewText.maxLength = 20;
        viewText.checkTips = @"手机号码不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtSex.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtSex];
    [txtSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtName.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    //绑定手机号
    txtBirthday=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtBirthday=txtBirthday;
    txtBirthday.title=@"鉴定类别";
    txtBirthday.isBottom=NO;
    txtBirthday.headLineWidth=0;
    txtBirthday.didTapBlock = ^(){
        HSingleCategoryChoiceVC *vc=[[HSingleCategoryChoiceVC alloc] init];
        NSMutableArray *itemSex= [[NSMutableArray alloc] initWithCapacity:0];
        [itemSex addObject:HKeyValuePair(@"1", @"陶瓷认证专家")];
        [itemSex addObject:HKeyValuePair(@"2", @"玉器认证专家")];
        [itemSex addObject:HKeyValuePair(@"3", @"铜器认证专家")];
        [itemSex addObject:HKeyValuePair(@"4", @"书画认证专家")];
        [itemSex addObject:HKeyValuePair(@"5", @"钱币认证专家")];
        [itemSex addObject:HKeyValuePair(@"6", @"杂项认证专家")];
        vc.items=itemSex;

        vc.numberOfColumns=1;
        vc.navTitle=@"请选择类别";
        vc.disabledClear=YES;
        [vc setFinishSelectedBlock:^(NSArray<HKeyValuePair*> *selectItems) {
            weakTxtBirthday.submit=selectItems[0].displayText;
            weakTxtBirthday.strTag=selectItems[0].value;
        }];
        [weakSelf presentSemiViewController:vc];
    };
    [contentView addSubview:txtBirthday];
    [txtBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSex.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    //区域
    //地区
    txtLivingPlace=[[STextFieldWithTitle alloc]init];
    txtLivingPlace.title=@"地区";
    txtLivingPlace.isBottom=NO;
    txtLivingPlace.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weakLivingPlace=txtLivingPlace;

    txtLivingPlace.didTapBlock=^(){
        HAddressSelector* pop = [[HAddressSelector alloc] initWithFinishSelectedBlock:^(NSArray* IDs, NSArray* Names) {
            
            NSMutableArray* selectedItems = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < IDs.count; i++) {
                HKeyValuePair* item = [[HKeyValuePair alloc] initWithValue:IDs[i] andDisplayText:Names[i]];
                [selectedItems addObject:item];
            }
            weakLivingPlace.submit=[NSString stringWithFormat:@"%@-%@",Names[0],Names[1]];
            weakLivingPlace.strTag=[NSString stringWithFormat:@"%@-%@",IDs[0],IDs[1]];
            if (Names.count>2) {
                weakLivingPlace.submit=[NSString stringWithFormat:@"%@-%@",weakLivingPlace.submit,Names[2]];
                weakLivingPlace.strTag=[NSString stringWithFormat:@"%@-%@",weakLivingPlace.strTag,IDs[2]];
            }
            
        }
                                                          andClickedCancelButtonBlock:nil
                                                           andClickedClearButtonBlock:nil];
        
        [weakSelf presentSemiViewController:pop];
        
    };
    [contentView addSubview:txtLivingPlace];
    
    [txtLivingPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtBirthday.mas_bottom);
        make.height.mas_equalTo(45);
    }];

    
    info=[[HLabel alloc]init];
    info.textColor=ColorHex(@"f6f6f6");
    info.font=kFont(16);
    info.textColor=kTitleColor;
    info.textAlignment=NSTextAlignmentLeft;
    info.text = @"提现资料（身份证与银行卡的姓名一致）";
    [contentView addSubview:info];
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(20);
        make.top.equalTo(txtLivingPlace.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    //地区
    txtPlace=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtPlace=txtPlace;
    txtPlace.title=@"银行帐号";
    txtPlace.isBottom=NO;
    txtPlace.headLineWidth=0;
    txtPlace.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"银行帐号";
        viewText.placeholder = @"请输入您的银行帐号";
        viewText.maxLength = 30;
        viewText.checkTips = @"银行帐号不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtPlace.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtPlace];
    [txtPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(info.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    //个性签名
    txtSign=[[STextFieldWithTitle alloc]init];
    __weak __typeof(STextFieldWithTitle *) weakTxtSign=txtSign;
    txtSign.title=@"开户行";
    txtSign.isBottom=NO;
    txtSign.headLineWidth=0;
    txtSign.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"开户行";
        viewText.placeholder = @"请输入您的开户行";
        viewText.maxLength = 50;
        viewText.checkTips = @"开户行不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * name) {
            weakTxtSign.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtSign];
    [txtSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtPlace.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    txtSign.borderColor=kLineColor;
    txtSign.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    
    HView *viewBottom=[HView new];
    viewBottom.backgroundColor=kWhiteColor;
    viewBottom.borderColor=kLineColor;
    viewBottom.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSign.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    //个人头像
    imgHead=[[HImagePicker alloc]init];
    [viewBottom addSubview:imgHead];
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewBottom);
        make.left.equalTo(contentView).offset(10);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(400/3);
    }];
    imgHead.image = [UIImage imageNamed:@"AlbumAddBtn"];
    imgHead.allowCrop=YES;
    imgHead.cropScale=DBCameraImageScale_4x3;
    imgHead.cropWidth=300;
    [imgHead setDidSelectedImageBlcok:^(UIImage *image) {
        
        kPrintLog(image);
        [weakSelf showLoadingHUDWithTitle:@"正在上传图片,请稍后" SubTitle:nil];
        [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
        [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
        [UPYUNConfig sharedInstance].MutAPIDomain=kMutAPIDomain;
        NSData *eachImgData = UIImageJPEGRepresentation(image, 1);
        
        __block UpYun *uy = [[UpYun alloc] init];
        NSMutableDictionary * params = [NSMutableDictionary  dictionary];
        uy.successBlocker = ^(NSURLResponse *response, id responseData) {
            kPrintLog(responseData);
          [weakSelf.hudLoading hideAnimated:YES];
            NSString *strPhoto=[responseData objectForKey:@"url"];
            NSString *strSavePath=@"";
            NSString *strSavaName=@"";
            if (strPhoto.length>14) {
                strSavePath=[strPhoto substringToIndex:12];
                strSavaName=[strPhoto substringFromIndex:13];
            }
//            NSDictionary *dic=@{@"path":@"none",
//                                @"url":[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]],
//                                @"name":@"none",
//                                @"type":[responseData objectForKey:@"mimetype"],
//                                @"size":[responseData objectForKey:@"file_size"],
//                                @"width":@"300",
//                                @"height":@"225",
//                                @"hash":@"none",
//                                @"extension":@"png",
//                                @"save_path":strSavePath,
//                                @"save_name":strSavaName
//                                };
            
            [params setValue:responseData[@"url"] forKey:@"path"];
            [params setValue:[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]] forKey:@"url"];
            [params setValue:responseData[@"url"] forKey:@"name"];
            [params setValue:responseData[@"mimetype"] forKey:@"type"];
            [params setValue:responseData[@"file_size"] forKey:@"size"];
            [params setValue:responseData[@"hash"] forKey:@"hash"];
            [params setValue:responseData[@"image-type"] forKey:@"extension"];
            [params setValue:responseData[@"image-height"] forKey:@"height"];
            [params setValue:responseData[@"image-width"] forKey:@"width"];
            [params setValue:responseData[@"url"] forKey:@"save_path"];
            NSArray *array = [[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]] componentsSeparatedByString:@"/"];
            [params setValue:array[array.count-1] forKey:@"save_name"];
            idCardUrl=[self dictionaryToJson:params];//[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]];
            NSLog(@"%@",idCardUrl);
        };
        uy.failBlocker = ^(NSError * error) {
             [weakSelf.hudLoading hideAnimated:YES];
//            [weakSelf showErrorHUDWithTitle:@"图片上传失败" SubTitle:nil Complete:nil];
            [uy uploadFile:eachImgData saveKey:[weakSelf getSaveKeyWith:@"png"]];
        };
        uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
            NSLog(@"%f",percent);
        };
        
        /**
         *	@brief	根据 文件路径 上传
         */
        
        [uy uploadFile:eachImgData saveKey:[weakSelf getSaveKeyWith:@"png"]];
    }];

    HLabel *lblTitle=[[HLabel alloc]init];
    lblTitle.textColor=kTitleColor;
    lblTitle.text=@"上传身份证照片";
    lblTitle.font=[[Global sharedInstance]fontWithSize:16];
    [viewBottom addSubview:lblTitle];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewBottom);
        make.left.equalTo(imgHead.mas_right).offset(20);
    }];
    
    //向右的箭头
    UIImageView *imgRight=[[UIImageView alloc]init];
    imgRight.image=[UIImage imageNamed:@"icon_HComboBox_right"];
    [viewBottom addSubview:imgRight];
    [imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewBottom);
        make.right.equalTo(viewBottom).offset(-5);
        make.width.height.mas_equalTo(15);
    }];
}

//获取用户信息
- (void)loadData{
    if(![[Global sharedInstance] userID]){
        [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
        return;
    }
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getUserAuth" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        
        [self.hudLoading hide:YES];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        
        AuthenticationModel* model=[AuthenticationModel objectWithKeyValues:responseObject];
        txtName.submit=model.realname;
        txtSex.submit=model.phone;
        txtBirthday.strTag=model.user_verified_category_id;
        
        switch (model.user_verified_category_id.intValue) {
            case 1:{
                 txtBirthday.submit=@"陶瓷认证专家";
            }break;
            case 2:{
                 txtBirthday.submit=@"玉器认证专家";
            }break;
            case 3:{
                  txtBirthday.submit=@"铜器认证专家";
            }break;
            case 4:{
                  txtBirthday.submit=@"书画认证专家";
            }break;
            case 5:{
                   txtBirthday.submit=@"钱币认证专家";
            }break;
            case 6:{
                  txtBirthday.submit=@"杂项认证专家";
            }break;
            default:
                break;
        }
        txtPlace.submit=model.card;
        txtSign.submit=model.bank;
        [imgHead sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"icon_IDCard_Default"]];
        switch (model.verified.intValue) {//用户认证状态
            case -1:{
                lblState.text=@"抱歉,已驳回";
                UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
                self.navigationItem.rightBarButtonItem=rightBar;
            }break;
            case 0:{
                self.view.userInteractionEnabled=YES;
                isVerified=YES;
                lblState.text=@"等待认证";
            }break;
            case 1:{
                lblState.text=@"恭喜您,已通过认证";
                UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"修改" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
                self.navigationItem.rightBarButtonItem=rightBar;
            }break;
            case 2:{
                lblState.text=@"未提交认证";
                UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
                self.navigationItem.rightBarButtonItem=rightBar;
            }break;
            default:
                break;
        }

        [self.hudLoading hide:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hide:YES];
    }];
}


//提交按钮点击事件
-(void)rightBar_Click{
    if (isVerified) {
        [self showErrorHUDWithTitle:@"资料正在审核中..." SubTitle:nil Complete:nil];
        return ;
    }
    
    NSDictionary *dicAll=@{@"authtype":txtBirthday.strTag?:@"",
                           @"name":txtName.submit?:@"",
                           @"phone":txtSex.submit?:@"",
                           @"card":txtPlace.submit?:@"",
                           @"bank":txtSign.submit?:@"",
                           @"photo":idCardUrl?:@""} ;
    
    [self showLoadingHUDWithTitle:@"正在提交数据..." SubTitle:nil];
    HHttpRequest* request = [HHttpRequest new];
    [request httpPostRequestWithActionName:@"userauth"
                               andPramater:dicAll
                      andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
                          [self.hudLoading hide:YES];
                          ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                      }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [self.hudLoading hide:YES];
                     [self showOkHUDWithTitle:@"提交成功" SubTitle:nil Complete:^{
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [self.hudLoading hide:YES];
                  }];

}

-(NSString *)privatekey{
    return [NSString stringWithFormat:@"%@upload%@",[Global sharedInstance].userID,[Global sharedInstance].token].md5;
}

- (NSString * )getSaveKeyWith:(NSString *)suffix {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    /**
     *	@brief	更多方式 参阅 http://docs.upyun.com/api/form_api/#_4
     */
}

- (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}

@end
