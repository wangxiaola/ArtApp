//
//  UserInfoVC.m
//  ShesheDa
//
//  Created by XICHUNZHAO on 15/12/16.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import "UserInfoVC.h"
#import "HImagePicker.h"
#import "STextFieldWithTitle.h"
#import "UserInfoModel.h"
#import "AuthenticationVC.h"
#import "UpYun.h"
#import "MainViewController.h"
#import "AudioTableViewCell.h"
#import "UserInfoVideoCell.h"
#import "PlayerViewController.h"
#import "ArtTextViewController.h"
#import "TextVC.h"
#import "HDatePicker.h"

@interface UserInfoVC ()<UITableViewDelegate,UITableViewDataSource>{
    HImagePicker *imgHead;
    STextFieldWithTitle *txtName,*txtSex;
    STextFieldWithTitle *txtPlace;
    STextFieldWithTitle *txtBirthday;
    STextFieldWithTitle *txtLivingPlace;
    STextFieldWithTitle *txtSign,*txtCode,*txtTroduct;
    UserInfoModel *model;
    HImageSelector *imgSel;
    HButton *btnRecord;
    UITableView *tabRecorder,*tabVideo;
    NSMutableArray *arrayRecorder,*arrayVideo,*arrayPic,*arrayImageSave;
    AVPlayer * player;
    HView *viewBottom;
    BOOL isChangeImage;
    NSIndexPath *indexAudioSelect;
    BOOL isSanemSelect;
}

@end

@implementation UserInfoVC

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"个人信息";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem=rightBar;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) createView:(UIView *)contentView
{
    //头部
    HView *viewTop=[[HView alloc]init];
    viewTop.backgroundColor=[UIColor whiteColor];
    [contentView addSubview:viewTop];
    [viewTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(10);
        make.height.mas_equalTo(80);
    }];
    viewTop.borderWidth=HViewBorderWidthMake(1, 0, 1, 0);
    viewTop.borderColor=kLineColor;
    
    //头像
    UILabel *lblHeadTitle=[[UILabel alloc]init];
    lblHeadTitle.text=@"头像";
    lblHeadTitle.textColor=kTitleColor;
    lblHeadTitle.font=[[Global sharedInstance]fontWithSize:13];
    [viewTop addSubview:lblHeadTitle];
    [lblHeadTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewTop);
        make.left.equalTo(viewTop).offset(15);
    }];
    
    __weak __typeof(self) weakSelf=self;
    //个人头像
    imgHead=[[HImagePicker alloc]init];
    [viewTop addSubview:imgHead];
    [imgHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewTop);
        make.right.equalTo(contentView).offset(-25);
        make.width.height.mas_equalTo(60);
    }];
    imgHead.image = [UIImage imageNamed:@"temp_Default_headProtrait"];
    imgHead.allowCrop=YES;
    imgHead.cropScale=DBCameraImageScale_1x1;
    imgHead.cropWidth=300;
    [imgHead setDidSelectedImageBlcok:^(UIImage *image) {
        [weakSelf uploadHeadPic:image];
    }];
    
    //向右的箭头
    UIImageView *imgRight=[[UIImageView alloc]init];
    imgRight.image=[UIImage imageNamed:@"icon_HComboBox_right"];
    [viewTop addSubview:imgRight];
    [imgRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewTop);
        make.right.equalTo(viewTop).offset(-5);
        make.width.height.mas_equalTo(15);
    }];
    
    //昵称
    txtName=[[STextFieldWithTitle alloc]init];
    txtName.title=@"昵称";
    txtName.isBottom=NO;
    txtName.headLineWidth=0;
    txtName.didTapBlock=^(){
    
        
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"昵称";
        viewText.fieldName =@"nickname";
        viewText.fieldValue =[Global sharedInstance].userInfo.nickname;
        viewText.actionName = @"edituserinfo";
        viewText.placeholder = @"请输入您的昵称";
        viewText.maxLength = 20;
        viewText.tableID=@"uid";
        viewText.checkTips = @"昵称不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString *name) {
          txtName.submit=name;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];

      
    };
    [contentView addSubview:txtName];
    [txtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewTop.mas_bottom).offset(22);
        make.height.mas_equalTo(45);
    }];
    
    //性别
    txtSex=[[STextFieldWithTitle alloc]init];
    txtSex.title=@"性别";
    txtSex.headLineWidth=0;
    txtSex.isBottom=NO;
    txtSex.didTapBlock=^(){
        HSingleCategoryChoiceVC *vc=[[HSingleCategoryChoiceVC alloc] init];
        NSMutableArray *itemSex= [[NSMutableArray alloc] initWithCapacity:0];
        [itemSex addObject:HKeyValuePair(@"1", @"男")];
        [itemSex addObject:HKeyValuePair(@"2", @"女")];
        vc.items=itemSex;
        [vc setFinishSelectedBlock:^(NSArray<HKeyValuePair*> *selectItems) {
            txtSex.submit=selectItems[0].displayText;
            txtSex.strTag=selectItems[0].value;
        }];
        vc.numberOfColumns=1;
        vc.navTitle=@"请选择性别";
        vc.disabledClear=YES;
        [weakSelf presentSemiViewController:vc];
    };
    [contentView addSubview:txtSex];
    [txtSex mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtName.mas_bottom);
        make.height.mas_equalTo(45);
    }];
  
    //绑定手机号
    txtBirthday=[[STextFieldWithTitle alloc]init];
    txtBirthday.title= @"生日";
    txtBirthday.isBottom= NO;
    txtBirthday.headLineWidth=0;
    txtBirthday.didTapBlock = ^(){
        HDatePicker *datePickerVC=[[HDatePicker alloc] init];
        [datePickerVC setFinishSelectedBlock:^(NSArray<HKeyValuePair *> *items) {
            NSString *time=items[0].value;
            txtBirthday.submit=time;
             }];
        [weakSelf presentSemiViewController:datePickerVC];
    };
    [contentView addSubview:txtBirthday];
    [txtBirthday mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSex.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    
    //地区
    txtPlace=[[STextFieldWithTitle alloc]init];
    txtPlace.title=@"地区";
    txtPlace.isBottom=NO;
    txtPlace.headLineWidth=0;
    txtPlace.didTapBlock=^(){
        HAddressSelector* pop = [[HAddressSelector alloc] initWithFinishSelectedBlock:^(NSArray* IDs, NSArray* Names) {

        NSMutableArray* selectedItems = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < IDs.count; i++) {
            HKeyValuePair* item = [[HKeyValuePair alloc] initWithValue:IDs[i] andDisplayText:Names[i]];
            [selectedItems addObject:item];
        }
            txtPlace.submit=[NSString stringWithFormat:@"%@-%@",Names[0],Names[1]];
            txtPlace.strTag=[NSString stringWithFormat:@"%@-%@",IDs[0],IDs[1]];
            if (Names.count>2) {
                txtPlace.submit=[NSString stringWithFormat:@"%@-%@",txtPlace.submit,Names[2]];
                txtPlace.strTag=[NSString stringWithFormat:@"%@-%@",txtPlace.strTag,IDs[2]];
            }

        }
            andClickedCancelButtonBlock:nil
            andClickedClearButtonBlock:nil];
        [weakSelf presentSemiViewController:pop];
    };
    [contentView addSubview:txtPlace];
    [txtPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtBirthday.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    txtPlace.borderColor=kLineColor;
    txtPlace.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    //个性签名
    txtSign=[[STextFieldWithTitle alloc]init];
    txtSign.title=@"标签";
    txtSign.isBottom=NO;
    txtSign.headLineWidth=0;
    txtSign.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"标签";
        viewText.fieldName =@"tag";
        viewText.fieldValue =[Global sharedInstance].userInfo.tag;
        viewText.actionName = @"edituserinfo";
        viewText.placeholder = @"请输入您的标签";
        viewText.maxLength = 100;
        viewText.tableID=@"uid";
        viewText.checkTips = @"标签不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * submit) {
            txtSign.submit=submit;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtSign];
    [txtSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtPlace.mas_bottom).offset(22);
        make.height.mas_equalTo(45);
    }];

    //我的邀请码
    txtCode=[[STextFieldWithTitle alloc]init];
    txtCode.title=@"认证";
    txtCode.isBottom=NO;
    txtCode.headLineWidth=0;
    txtCode.didTapBlock=^(){
        AuthenticationVC *authen=[[AuthenticationVC alloc]init];
        [weakSelf.navigationController pushViewController:authen animated:YES];
    };
    [contentView addSubview:txtCode];
    [txtCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtSign.mas_bottom);
        make.height.mas_equalTo(45);
    }];
    txtCode.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    txtCode.borderColor=kLineColor;
    
    txtTroduct=[[STextFieldWithTitle alloc]init];
    txtTroduct.title=@"简介";
    txtTroduct.isMutable=YES;
    txtTroduct.isMutableChage=YES;
    txtTroduct.isBottom=NO;
    txtTroduct.headLineWidth=0;
     __weak __typeof(STextFieldWithTitle *) weakTxtTroduct = txtTroduct;
    txtTroduct.didTapBlock=^(){
        
        ArtTextViewController* artText = [[ArtTextViewController alloc]init];
        artText.navTitle =@"简介";
                artText.fieldName =@"intro";
                artText.fieldValue =[Global sharedInstance].userInfo.intro;
                artText.actionName = @"edituserinfo";
                artText.placeholder = @"请输入您的简介";
                artText.maxLength = 100;
                artText.tableID=@"uid";
                artText.checkTips = @"简介不能为空";
                artText.isMultiLine = YES;
                artText.isBack=YES;
                [artText setSaveBtnCilck:^(NSString *name) {
                    weakTxtTroduct.submit=name;
                }];
        artText.titleContent =  [Global sharedInstance].userInfo.intro;
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [contentView addSubview:txtTroduct];
    [txtTroduct mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtCode.mas_bottom).offset(22);
    }];
    txtTroduct.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    txtTroduct.borderColor=kLineColor;
    
    viewBottom=[HView new];
    viewBottom.backgroundColor=kWhiteColor;
    viewBottom.borderColor=kLineColor;
    viewBottom.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtTroduct.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    imgSel=[HImageSelector new];
    imgSel.baseVC = self;
    imgSel.allowScroll=YES;
    __block typeof (HImageSelector *) weakImgSel = imgSel;
    [viewBottom addSubview:imgSel];
    [imgSel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBottom).offset(10);
        make.left.equalTo(viewBottom).offset(10);
        make.width.mas_equalTo(kScreenW-20);
        make.bottom.equalTo(viewBottom).offset(-10);
    }];
    imgSel.maxNumberOfImage=9;
    imgSel.allowEdit=YES;
    imgSel.cropScale=DBCameraImageScale_1x1;
    
    __weak __typeof(HView *)weakViewBottom = viewBottom;
    [imgSel setSelectDelBtnCilck:^(NSInteger iNUmber) {
        isChangeImage=YES;
        [weakViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20);
            }else{
                make.height.mas_equalTo((weakImgSel.listImages.count/4+1)*(kScreenW/4)+20);
            }
        }];
    }];
    [imgSel setSelectAddBtnCilck:^(UIImage *image) {
        isChangeImage=YES;
        [weakViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20);
            }else{
                make.height.mas_equalTo((weakImgSel.listImages.count/4+1)*(kScreenW/4)+20);
            }
        }];
    }];
    
    tabRecorder=[[UITableView alloc]init];
    tabRecorder.delegate=self;
    tabRecorder.dataSource=self;
    tabRecorder.tableFooterView=[[HView alloc]init];
    tabRecorder.separatorStyle=UITableViewCellSeparatorStyleNone;
    [contentView addSubview:tabRecorder];
    [tabRecorder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewBottom.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    tabRecorder.hidden=YES;
    
    //录音按钮
    btnRecord=[[HButton alloc]init];
    [btnRecord setTitle:@"录音" forState:UIControlStateNormal];
    [btnRecord setImage:[UIImage imageNamed:@"icon_userinfo_addaudio"] forState:UIControlStateNormal];
    [btnRecord addTarget:self action:@selector(btnRecord_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnRecord setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnRecord.titleLabel.font=kFont(15);//[[Global sharedInstance]fontWithSize:15];
    [contentView addSubview:btnRecord];
    [btnRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(tabRecorder.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    tabVideo=[[UITableView alloc]init];
    tabVideo.delegate=self;
    tabVideo.dataSource=self;
    tabVideo.tableFooterView=[UIView new];
    [contentView addSubview:tabVideo];
    [tabVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(btnRecord.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    tabVideo.hidden=YES;
    
    HButton * btnVideo=[[HButton alloc]init];
    [btnVideo setTitle:@"视频链接" forState:UIControlStateNormal];
    [btnVideo setImage:[UIImage imageNamed:@"icon_userinfo_addvideo"] forState:UIControlStateNormal];
    [btnVideo addTarget:self action:@selector(btnVideo_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnVideo setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnVideo.titleLabel.font=kFont(15);//[[Global sharedInstance]fontWithSize:15];
    [contentView addSubview:btnVideo];
    [btnVideo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.equalTo(tabVideo.mas_bottom).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];

    arrayVideo=[[NSMutableArray alloc]init];
    arrayRecorder=[[NSMutableArray alloc]init];
    arrayPic=[[NSMutableArray alloc]init];
    arrayImageSave=[[NSMutableArray alloc]init];
}

//获取用户信息
-(void)loadData{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"正在获取个人信息" SubTitle:nil];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"userinfo" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hide:YES];
        ResultModel *result=[ResultModel objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject);
        model=[UserInfoModel objectWithKeyValues:responseObject];
        [self loadUserInfo];
        [self.hudLoading hide:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        [self.hudLoading hide:YES];
    }];
}

-(void)loadUserInfo{
    [arrayRecorder removeAllObjects];
    [arrayPic removeAllObjects];
    [arrayVideo removeAllObjects];
    
   NSMutableArray * arrayPicSave=[[model.photo componentsSeparatedByString:@","] mutableCopy];
    for (NSString *strUrl in arrayPicSave) {
        if (strUrl.length<5) {
            [arrayPicSave removeObject:strUrl];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (arrayPicSave.count>0) {
                for (NSString *strPic in arrayPicSave) {
                    UIImage *imgSave=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!120a",strPic]]]];
                    if (imgSave) {
                        [arrayPic addObject:imgSave];
                    }
                }
            }
        dispatch_async(dispatch_get_main_queue(), ^{
                imgSel.listImages=arrayPic;
                [viewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
                    if (arrayPic.count==1) {
                        make.height.mas_equalTo(kScreenW/4+20);
                    }else{
                        make.height.mas_equalTo((arrayPic.count/4+1)*(kScreenW/4)+20);
                    }
                }];
        });
    });
   
    NSArray *array=[ArtUIHelper stringToJSON:model.audio];
    if (array.count>0) {
        [tabRecorder mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo((array.count)*60);
        }];
        tabRecorder.hidden=NO;
    }else{
        [tabRecorder mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
        tabRecorder.hidden=YES;
    }
    if (array>0) {
        arrayRecorder=[array mutableCopy];
        [tabRecorder reloadData];
    }

    NSString *strVideo=model.video;
    
    if (strVideo.length>3) {
        NSArray *arrayVideoShow=[strVideo componentsSeparatedByString:@","];
        arrayVideo=[arrayVideoShow mutableCopy];
        [tabVideo reloadData];
    }
    
    if (arrayVideo.count<1) {
        tabVideo.hidden=YES;
        [tabVideo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
        }];
    }else{
        tabVideo.hidden=NO;
        [tabVideo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(arrayVideo.count*160);
        }];
    }
    [Global sharedInstance].userInfo=model;
    [imgHead sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    txtName.submit=model.nickname;
    txtSex.strTag=model.sex;
    //性别
    switch (model.sex.intValue) {
        case 0:{
            txtSex.submit=@"无";
        }break;
        case 1:{
            txtSex.submit=@"男";
        }break;
        case 2:{
            txtSex.submit=@"女";
        }break;
            
        default:
            break;
    }

    if (model.birth.intValue!=0) {
        txtBirthday.submit=[self changeTime:model.birth];
    }
    txtPlace.submit=model.location;
    
    txtSign.submit=model.tag;
    txtTroduct.submit=model.intro;
    switch (model.auth.intValue) {
        case 0:{
            txtCode.submit=@"非专家";
        }break;
        case 1:{
           txtCode.submit=@"陶瓷";
        }break;
        case 2:{
            txtCode.submit=@"玉器";
        }break;
        case 3:{
            txtCode.submit=@"铜器";
        }break;
        case 4:{
            txtCode.submit=@"书画";
        }break;
        case 5:{
            txtCode.submit=@"钱币";
        }break;
        case 6:{
           txtCode.submit=@"杂项";
        }break;
        default:
            break;
    }
}

- (void) uploadHeadPic:(UIImage*)image
{
    [self showLoadingHUDWithTitle:@"正在上传图片,请稍后" SubTitle:nil];
    //AFN3.0+基于封住HTPPSession的句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID,
                           @"avatar":[Global sharedInstance].userID,
                           @"privatekey":[self privatekey]};
    
    //formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
    [manager POST:[NSString stringWithFormat:@"%@?ac=upload",AppUrlRoot] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data =  UIImageJPEGRepresentation(image, 0.2f);
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpeg", str];
        
        //上传
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"]
         3. 要保存在服务器上的[文件名]
         4. 上传文件的[mimeType]
         */
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"上传成功");
        [self.hudLoading hideAnimated:YES];
        [self showOkHUDWithTitle:@"头像上传成功" SubTitle:nil Complete:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.hudLoading hideAnimated:YES];
        [self showOkHUDWithTitle:@"头像上传失败" SubTitle:nil Complete:nil];
    }];
}

-(NSString *)privatekey{
    return [NSString stringWithFormat:@"%@upload%@",[Global sharedInstance].userID,[Global sharedInstance].token].md5;
}

-(NSString *)changeTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}

//时间转为时间出
-(NSString *)changeTime1:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate* date = [formatter dateFromString:time];
    return [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}

- (NSString * )getSaveKeyWith:(NSString *)suffix {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/uploads/audio/art1284/%@.%@", [self getDateString], suffix];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tabVideo isEqual:tableView]) {
        return 160;
    }
    if ([tabRecorder isEqual:tableView]) {
        return 60;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:tabRecorder]) {
        return arrayRecorder.count;
    }
    if ([tableView isEqual:tabVideo]) {
        return arrayVideo.count;
    }

    return 0;
}

//设置编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [tabRecorder setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
    [tabVideo setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if ([tabRecorder isEqual:tableView]) {
        if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
            if (indexPath.row<[arrayRecorder count]) {
                [arrayRecorder removeObjectAtIndex:indexPath.row];
                [tabRecorder reloadData];
                [tabRecorder mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo((arrayRecorder.count)*60);
                }];
            }
        }
    }
    
    if ([tabVideo isEqual:tableView]) {
        if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
            if (indexPath.row<[arrayVideo count]) {
                [arrayVideo removeObjectAtIndex:indexPath.row];
                [tabVideo reloadData];
                [tabVideo mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(arrayVideo.count*160);
                }];
            }
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tabRecorder isEqual:tableView]) {
        for (NSIndexPath* i in [tabRecorder indexPathsForVisibleRows])
        {
            AudioTableViewCell *cell=[tabRecorder cellForRowAtIndexPath:i];
            [cell endBofang];
        }
        
        NSMutableDictionary *dic=arrayRecorder[indexPath.row];
        NSURL * url  = [NSURL URLWithString:[dic objectForKey:@"url"]];
        AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
         player = [[AVPlayer alloc]initWithPlayerItem:songItem];
        [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        if (indexPath==indexAudioSelect) {
            isSanemSelect=YES;
        }else{
            isSanemSelect=NO;
        }
        indexAudioSelect=indexPath;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    }
    if ([tabVideo isEqual:tableView]) {
        NSString *videoUrl=arrayVideo[indexPath.row];
        NSString *videoID=[self getVideoIDWithVideoUrl:videoUrl];
        if (videoID.length<1) {
            return;
        }
        // 播放视频
        PlayerViewController *vc=[[PlayerViewController alloc]init];
        vc.videoID=videoID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)playbackFinished:(NSNotification *)notice {
    isSanemSelect=NO;
    AudioTableViewCell *cell=[tabRecorder cellForRowAtIndexPath:indexAudioSelect];
    [cell endBofang];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        [self.hudLoading hide:YES];
        switch (player.status) {
            case AVPlayerStatusUnknown:
                //                BASE_INFO_FUN(@"KVO：未知状态，此时不能播放");
                NSLog(@"不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                //                self.status = SUPlayStatusReadyToPlay;
                //                BASE_INFO_FUN(@"KVO：准备完毕，可以播放");
                NSLog(@"可以播放");
                if (isSanemSelect) {
                    
                    [player pause];
                     [object removeObserver:self forKeyPath:@"status"];
                    AudioTableViewCell *cell=[tabRecorder cellForRowAtIndexPath:indexAudioSelect];
                    [cell endBofang];
                    indexAudioSelect=nil;
                    
                }else{
                    [player play];
                    AudioTableViewCell *cell=[tabRecorder cellForRowAtIndexPath:indexAudioSelect];
                    [cell stateBofang];
                    [object removeObserver:self forKeyPath:@"status"];
                }
                break;
            case AVPlayerStatusFailed:
                //                BASE_INFO_FUN(@"KVO：加载失败，网络或者服务器出现问题");
                NSLog(@"播放出现问题");
                break;
            default:
                break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:tabRecorder]) {
        NSString *identifier=@"MyCouponCell";
        AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.backgroundColor=ColorHex(@"f6f6f6");
        }
        cell.dic=arrayRecorder[indexPath.row];
         cell.name=model.nickname;
        return cell;
    }
    if ([tableView isEqual:tabVideo]) {
        NSString *identifier=@"MyCouponCellVideo";
        UserInfoVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UserInfoVideoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        cell.videoUrl=arrayVideo[indexPath.row];
        return cell;
    }

    return nil;
}

-(void)btnVideo_Click{
    
    TextVC *viewText = [[TextVC alloc] init];
    viewText.navTitle =@"视频链接";
    viewText.placeholder = @"请输入视频链接网址";
    viewText.maxLength = 10000;
    viewText.checkTips = @"视频链接不能为空";
    viewText.isMultiLine = YES;
    viewText.isBack=YES;
    [viewText setSaveBtnCilck:^(NSString * name) {
        NSString *strID=[self getVideoIDWithVideoUrl:name];
        if (strID.length<1) {
            [self showErrorHUDWithTitle:@"请输入正确的视频网址" SubTitle:nil Complete:nil];
            return ;
        }
        
        [arrayVideo addObject:name];
        [tabVideo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(arrayVideo.count*160);
        }];
        tabVideo.hidden=NO;
        [tabVideo reloadData];
    }];
    [self.navigationController pushViewController:viewText animated:YES];
}

//录音按钮点击事件
-(void)btnRecord_Click{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [test2obj setBtnRecorderCilck:^(NSURL *btndiurl, double audioTime) {
        NSData *voiceData=[NSData dataWithContentsOfURL:btndiurl];
        [self showLoadingHUDWithTitle:@"正在上传录音,请稍后" SubTitle:nil];
        [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
        [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
        [UPYUNConfig sharedInstance].MutAPIDomain=kMutAPIDomain;
        __block UpYun *uy = [[UpYun alloc] init];
        uy.successBlocker = ^(NSURLResponse *response, id responseData) {
            [self.hudLoading hide:YES];
            NSLog(@"%@",btnRecord);
            NSDictionary *dic=@{@"duration":[NSString stringWithFormat:@"%f",audioTime],
                                @"url":[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]]};
            [arrayRecorder addObject:dic];
            [tabRecorder mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo((arrayRecorder.count)*60);
            }];
            tabRecorder.hidden=NO;
            [tabRecorder reloadData];
        };
        uy.failBlocker = ^(NSError * error) {
            [self.hudLoading hide:YES];
            [self showErrorHUDWithTitle:@"录音上传失败" SubTitle:nil Complete:nil];
        };
        uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
            NSLog(@"%f",percent);
        };
        
        /**
         *	@brief	根据 文件路径 上传
         */
        [uy uploadFile:voiceData saveKey:[self getSaveKeyWith:@"mp3"]];
    }];
    [self.navigationController pushViewController:test2obj animated:YES];
}

-(void)rightBar_Click{
    [self showLoadingHUDWithTitle:@"正在上传数据,请稍后..." SubTitle:@""];
    if (imgSel.listImages.count>0&&isChangeImage) {
        [self upDataImage:0];
    }else{
        [self upDAtaRecorder];
    }
}

-(void)upDataImage:(int)iNUmber{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].MutAPIDomain=kMutAPIDomain;
    __block UpYun *uy = [[UpYun alloc] init];
    NSMutableDictionary * params = [NSMutableDictionary  dictionary];
    UIImage *image=imgSel.listImages[iNUmber];
    NSData *eachImgData = UIImageJPEGRepresentation(image, 1);
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSString *strPhoto=[responseData objectForKey:@"url"];
        NSString *strSavePath=@"";
        NSString *strSavaName=@"";
        if (strPhoto.length>14) {
            strSavePath=[strPhoto substringToIndex:12];
            strSavaName=[strPhoto substringFromIndex:13];
        }
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
        NSString * idCardUrlPic=[self dictionaryToJson:params];
        
        [arrayImageSave addObject:idCardUrlPic];
        if (arrayImageSave.count==imgSel.listImages.count) {
            NSLog(@"图片上传完毕");
            [self upDAtaRecorder];
        }else{
            [self upDataImage:iNUmber+1];
        }
    };
    uy.failBlocker = ^(NSError * error) {
        [uy uploadFile:eachImgData saveKey:[self getSaveKeyWith:@"png"]];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f",percent);
    };
    
    
    /**
     *	@brief	根据 文件路径 上传
     */
    [uy uploadFile:eachImgData saveKey:[self getSaveKeyWith:@"png"]];
    
}

-(void)upDAtaRecorder{
     NSString *strPic=@"";
    if (isChangeImage) {
        strPic=[self objArrayToJSON:arrayImageSave];
    }else{
        [arrayImageSave removeAllObjects];
        NSMutableArray * arrayPicSave=[[model.photo componentsSeparatedByString:@","] mutableCopy];
        for (NSString *strUrl in arrayPicSave) {
            if (strUrl.length<5) {
                [arrayPicSave removeObject:strUrl];
            }
        }
        
        for (NSString *strPic in arrayPicSave) {
            NSDictionary *Pic=@{@"path":@"none",
                                @"url":strPic,
                                @"name":@"none",
                                @"type":@"",
                                @"size":@"",
                                @"width":@"300",
                                @"height":@"225",
                                @"hash":@"none",
                                @"extension":@"png",
                                @"save_path":@"",
                                @"save_name":@""
                                };
            NSString * idCardUrlPic=[self dictionaryToJson:Pic];
            
            [arrayImageSave addObject:idCardUrlPic];
        }
        strPic=[self objArrayToJSON:arrayImageSave];
    }
    NSArray *arrayLocation=[txtPlace.strTag componentsSeparatedByString:@"-"];
    NSString *strAudio=@"";//[self objArrayToJSON:arrayRecorder];
    NSMutableArray *arrayAudioNew=[[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in arrayRecorder) {
        [arrayAudioNew addObject:[self dictionaryToJson:dic]];
    }
    if (arrayAudioNew.count>0) {
        strAudio=[self objArrayToJSON:arrayAudioNew];
    }

//    for (int i=0; i<arrayRecorder.count; i++) {
//        if (i==0) {
//            strAudio=[self dictionaryToJson:arrayRecorder[i]];
//        }else{
//            strAudio=[NSString stringWithFormat:@"%@,%@",strAudio,[self dictionaryToJson:arrayRecorder[i]]];
//        }
//    }
    
    NSString *strVideo=@"";
    for (int i=0; i<arrayVideo.count; i++) {
        if (i==0) {
            strVideo=arrayVideo[i];
        }else{
            strVideo=[NSString stringWithFormat:@"%@,%@",strVideo,arrayVideo[i]];
        }
    }
        NSDictionary *dicAll=@{@"uid":[Global sharedInstance].userID,
                               @"nickname":txtName.submit?:@"",
                               @"sex":txtSex.strTag?:@"",
                               @"birth":txtBirthday.submit?[self changeTime1:txtBirthday.submit]:@"",
                               @"province":arrayLocation.count==3?arrayLocation[0]:@"",
                               @"city":arrayLocation.count==3?arrayLocation[1]:@"",
                               @"area":arrayLocation.count==3?arrayLocation[2]:@"",
                               @"location":txtPlace.submit?:@"",
                               @"tag":txtSign.submit?:@"",
                               @"auth":[Global sharedInstance].userInfo.auth?:@"",
                               @"intro":txtTroduct.submit?:@"",
                               @"photo":strPic?:@"",
                               @"audio":strAudio?:@"",
                               @"video":strVideo?:@""} ;
    
        HHttpRequest* request = [HHttpRequest new];
        [request httpPostRequestWithActionName:@"edituserinfo"
            andPramater:dicAll
            andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
                [self.hudLoading hide:YES];
                ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
                [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
            }
            andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                [self.hudLoading hide:YES];
                [self showOkHUDWithTitle:@"更新成功" SubTitle:nil Complete:^{
    
                }];
                [self.navigationController popViewControllerAnimated:YES];
            }
            andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                [self.hudLoading hide:YES];
            }];

}

@end
