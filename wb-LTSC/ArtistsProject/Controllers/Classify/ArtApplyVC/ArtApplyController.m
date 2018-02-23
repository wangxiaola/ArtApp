//
//  ArtApplyController.m
//  ShesheDa
//
//  Created by XICHUNZHAO on 15/12/16.
//  Copyright © 2015年 上海翔汇网络有限公司. All rights reserved.
//

#import "ArtApplyController.h"
#import "HImagePicker.h"
#import "STextFieldWithTitle.h"
#import "UserInfoModel.h"
#import "AuthenticationVC.h"
#import "UpYun.h"
#import "MainViewController.h"
#import "AudioTableViewCell.h"
#import "UserInfoVideoCell.h"
#import "ArtTextViewController.h"
#import "TextVC.h"
#import "HDatePicker.h"
#import "JGTextView.h"
#import "ZJBLStoreShopTypeAlert.h"
#import "ArtExpClassVC.h"
#import "ArtPlaceController.h"
#import "AuthenticationModel.h"

#define kTopHeight    20
#define kLineHeight   50

@interface ArtApplyController ()<UITableViewDelegate,UITableViewDataSource>{
    HImagePicker *imgHead;
    HLabel *lblState;
    STextFieldWithTitle *txtClass,*txtColledge;
    STextFieldWithTitle *txtEducation;
    STextFieldWithTitle *txtTeacher;
    STextFieldWithTitle *txtJigou,*txtPlace,*txtName,*txtPhone;
    STextFieldWithTitle *txtIntroduce;
    JGTextView *jianliTF;
    UserInfoModel *model;
    HImageSelector *imgSel;
    HImageSelector *imgSel1;
    HButton *commitBtn;
    HButton *btnRecord;
    UITableView *tabRecorder,*tabVideo;
    NSMutableArray *arrayRecorder,*arrayVideo,*arrayPic,*arrayImageSave,*arrayPic1,*arrayImageSave1;
    AVPlayer * player;
    HView *viewBottom;
    HView *viewBottom1;
    BOOL isChangeImage;
    NSIndexPath *indexAudioSelect;
    BOOL isSanemSelect;
    BOOL isVerified;
    
    NSString *idCardUrl1;
    NSString *idCardUrl2;
}

// 作品数组
@property (nonatomic, strong) NSMutableArray *imgurlArr;
// 二维码url
@property (nonatomic, strong) NSString *ewmUrl;
@end

@implementation ArtApplyController

- (NSMutableArray *)imgurlArr
{
    if (!_imgurlArr) {
        _imgurlArr = [[NSMutableArray alloc] init];
    }
    return _imgurlArr;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.scrollView.backgroundColor = BACK_VIEW_COLOR;
    arrayPic = [NSMutableArray array];
    arrayPic1 = [NSMutableArray array];
    arrayImageSave = [NSMutableArray array];
    arrayImageSave1 = [NSMutableArray array];
    [self loadData];
}
//获取用户信息
- (void)loadData{
    if(![[Global sharedInstance] userID]){
        [ArtUIHelper addHUDInView:self.view text:@"您尚未登录" hideAfterDelay:1.0];
        return;
    }
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":[Global sharedInstance].userID?:@"0",@"type":@"2"};
    kPrintLog(dict)
    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getUserAuth" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        model=[UserInfoModel mj_objectWithKeyValues:responseObject[@"public"]];
        if (responseObject[@"res"]&&[responseObject[@"res"] integerValue] == 0) {
            lblState.text=@"未提交认证";
        }else{
            switch (model.verified.intValue) {//用户认证状态
            case -1:{
                lblState.text = [NSString stringWithFormat:@"抱歉,已驳回 原因：%@",model.reason];
//                lblState.text = @"抱歉，已驳回";
            }break;
            case 0:{
                self.view.userInteractionEnabled=YES;
                isVerified = YES;
                lblState.text=@"等待认证";
                commitBtn.hidden = YES;
                
            }break;
            case 1:{
                lblState.text=@"恭喜您,已通过认证";
            }break;
            case 2:{
                lblState.text=@"未提交认证";
            }break;
            default:
                break;
            }
        }
        [self loadUserInfo];
//        [self.hudLoading hideAnimated:YES];
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
//        [self.hudLoading hideAnimated:YES];
    }];
}
- (void)loadUserInfo{
    [arrayRecorder removeAllObjects];
    [arrayPic removeAllObjects];
    [arrayVideo removeAllObjects];
    [arrayPic1 removeAllObjects];
    NSMutableArray * arrayPicSave=[[model.artwork componentsSeparatedByString:@","] mutableCopy];
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
                    make.height.mas_equalTo(kScreenW/4+20+30);
                }else{
                    make.height.mas_equalTo((arrayPic.count/4+1)*(kScreenW/4)+20+30);
                }
            }];
        });
    });
    NSMutableArray * arrayPicSave1=[[model.wxphoto componentsSeparatedByString:@","] mutableCopy];
    for (NSString *strUrl in arrayPicSave1) {
        if (strUrl.length<5) {
            [arrayPicSave1 removeObject:strUrl];
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (arrayPicSave1.count>0) {
            for (NSString *strPic in arrayPicSave1) {
                UIImage *imgSave=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!120a",strPic]]]];
                if (imgSave) {
                    [arrayPic1 addObject:imgSave];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            imgSel1.listImages= arrayPic1;
            [viewBottom1 mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(kScreenW/4+20+30);
            }];
        });
    });

    [Global sharedInstance].userInfo=model;
    kPrintLog(model.realname);
//    txtClass.submit = model.czlb;
    txtClass.submit = [UserDefaults objectForKey:@"artClass"];
    txtColledge.submit = model.byyx;
    txtEducation.submit = model.xl;
    txtTeacher.submit = model.sc;
    txtJigou.submit = model.rzjg;
    txtPlace.submit = [UserDefaults objectForKey:@"artApyPlace"];
    txtName.submit = model.realname;
    txtPhone.submit = model.phone;
    jianliTF.text = model.intro;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"申请合作";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void) createView:(UIView *)contentView
{
    // 认证状态
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
        make.height.mas_equalTo(40);
    }];
    //创作类别
    txtClass=[[STextFieldWithTitle alloc]init];
    txtClass.title = @"创作类别";
    txtClass.isBottom=NO;
    txtClass.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtClass = txtClass;
    txtClass.didTapBlock=^(){
        ArtExpClassVC *classVC = [[ArtExpClassVC alloc] init];
        [classVC setSaveBtnCilck:^(NSString *name, NSString *nameId) {
            weaktxtClass.submit= name;
            weaktxtClass.strTag = nameId;
        }];
        [weakSelf.navigationController pushViewController:classVC animated:YES];
    };
    [contentView addSubview:txtClass];
    [txtClass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lblState.mas_bottom).offset(0);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //毕业院校
    txtColledge = [[STextFieldWithTitle alloc]init];
    txtColledge.title=@"毕业院校";
    txtColledge.headLineWidth=0;
    txtColledge.isBottom=NO;
    __weak __typeof(STextFieldWithTitle *) weakTxtColledge = txtColledge;
    txtColledge.didTapBlock=^(){
        TextVC *artText = [[TextVC alloc] init];
        artText.navTitle =@"毕业院校";
        artText.fieldName =@"intro";
        artText.fieldValue =[Global sharedInstance].userInfo.intro;
        artText.actionName = @"edituserinfo";
        artText.placeholder = @"请输入您的毕业院校";
        artText.maxLength = 100;
        artText.tableID = @"uid";
        artText.checkTips = @"毕业院校不能为空";
        artText.isMultiLine = YES;
        artText.isBack = YES;
        [artText setSaveBtnCilck:^(NSString *name) {
            weakTxtColledge.submit=name;
        }];
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [contentView addSubview:txtColledge];
    [txtColledge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtClass.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //学历
    txtEducation=[[STextFieldWithTitle alloc]init];
    txtEducation.title= @"学历";
    txtEducation.isBottom= NO;
    txtEducation.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtEducation = txtEducation;
    txtEducation.didTapBlock = ^(){
        NSArray *array = @[@"博士",@"硕士",@"本科",@"专科",@"其他"];
        [ZJBLStoreShopTypeAlert showWithTitle:nil titles:array selectIndex:^(NSInteger selectIndex) {
            NSLog(@"选择了第%ld个",selectIndex);
        } selectValue:^(NSString *selectValue) {
            NSLog(@"选择的值为%@",selectValue);
            weaktxtEducation.submit = selectValue;
        } showCloseButton:NO];
    };
    [contentView addSubview:txtEducation];
    [txtEducation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtColledge.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //师承
    txtTeacher=[[STextFieldWithTitle alloc]init];
    txtTeacher.title=@"师承";
    txtTeacher.isBottom=NO;
    txtTeacher.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtTeacher = txtTeacher;
    txtTeacher.didTapBlock=^(){
        TextVC *artText = [[TextVC alloc] init];
        artText.navTitle =@"师承";
        artText.fieldName =@"intro";
        artText.fieldValue =[Global sharedInstance].userInfo.intro;
        artText.actionName = @"edituserinfo";
        artText.placeholder = @"请输入您的师承";
        artText.maxLength = 100;
        artText.tableID = @"uid";
        artText.checkTips = @"师承不能为空";
        artText.isMultiLine = YES;
        artText.isBack = YES;
        [artText setSaveBtnCilck:^(NSString *name) {
            NSArray *array = [name componentsSeparatedByString:@","];
            
            weaktxtTeacher.submit=name;
        }];
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [contentView addSubview:txtTeacher];
    [txtTeacher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtEducation.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtTeacher.borderColor=kLineColor;
    txtTeacher.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    //任职机构
    txtJigou=[[STextFieldWithTitle alloc]init];
    txtJigou.title=@"任职机构";
    txtJigou.isBottom=NO;
    txtJigou.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtJigou = txtJigou;
    txtJigou.didTapBlock=^(){
        TextVC *artText = [[TextVC alloc] init];
        artText.navTitle =@"任职机构";
        artText.fieldName =@"intro";
        artText.fieldValue =[Global sharedInstance].userInfo.intro;
        artText.actionName = @"edituserinfo";
        artText.placeholder = @"请输入您的任职机构";
        artText.maxLength = 100;
        artText.tableID = @"uid";
        artText.checkTips = @"任职机构不能为空";
        artText.isMultiLine = YES;
        artText.isBack = YES;
        [artText setSaveBtnCilck:^(NSString *name) {
            weaktxtJigou.submit=name;
        }];
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [contentView addSubview:txtJigou];
    [txtJigou mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtTeacher.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtJigou.borderColor=kLineColor;
    txtJigou.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    //地区
    txtPlace=[[STextFieldWithTitle alloc]init];
    txtPlace.title=@"地区";
    txtPlace.isBottom=NO;
    txtPlace.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtPlace = txtPlace;
    txtPlace.didTapBlock=^(){
//        ArtPlaceController *artPlace = [[ArtPlaceController alloc]init];
//        [artPlace setSaveBtnCilck:^(NSString *name) {
//            weaktxtPlace.submit=name;
//        }];
//        [weakSelf.navigationController pushViewController:artPlace animated:YES];
        HAddressSelector* pop = [[HAddressSelector alloc] initWithFinishSelectedBlock:^(NSArray* IDs, NSArray* Names) {
            
            NSMutableArray* selectedItems = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < IDs.count; i++) {
                HKeyValuePair* item = [[HKeyValuePair alloc] initWithValue:IDs[i] andDisplayText:Names[i]];
                [selectedItems addObject:item];
            }
            if (Names.count > 0) {
                weaktxtPlace.submit=[NSString stringWithFormat:@"%@",Names[0]];
                weaktxtPlace.strTag=[NSString stringWithFormat:@"%@",IDs[0]];
            }if (Names.count > 1){
                weaktxtPlace.submit=[NSString stringWithFormat:@"%@-%@",Names[0],Names[1]];
                weaktxtPlace.strTag=[NSString stringWithFormat:@"%@-%@",IDs[0],IDs[1]];}
            if (Names.count>2) {
                weaktxtPlace.submit=[NSString stringWithFormat:@"%@-%@",weaktxtPlace.submit,Names[2]];
                weaktxtPlace.strTag=[NSString stringWithFormat:@"%@-%@",weaktxtPlace.strTag,IDs[2]];
            }
            
        }
        andClickedCancelButtonBlock:nil
        andClickedClearButtonBlock:nil];
        [weakSelf presentSemiViewController:pop];

    };
    [contentView addSubview:txtPlace];
    [txtPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtJigou.mas_bottom).offset(kTopHeight);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtPlace.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    txtPlace.borderColor=kLineColor;
    
    //姓名
    txtName=[[STextFieldWithTitle alloc]init];
    txtName.title=@"姓名";
    txtName.isMutable=YES;
    txtName.isMutableChage=YES;
    txtName.isBottom=NO;
    txtName.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weakTxtName = txtName;
    [contentView addSubview:txtName];
    txtName.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"姓名";
        viewText.fieldName =@"tag";
        viewText.fieldValue =[Global sharedInstance].userInfo.tag;
        viewText.actionName = @"edituserinfo";
        viewText.placeholder = @"请输入您的姓名";
        viewText.maxLength = 100;
        viewText.tableID=@"uid";
        viewText.checkTips = @"姓名不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * submit) {
            weakTxtName.submit=submit;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [txtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtPlace.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtName.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    txtName.borderColor=kLineColor;
    
    //手机号
    txtPhone=[[STextFieldWithTitle alloc]init];
    txtPhone.title = @"手机号";
    txtPhone.isMutable=YES;
    txtPhone.isMutableChage=YES;
    txtPhone.isBottom=NO;
    txtPhone.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weakTxtPhone = txtPhone;
    txtPhone.didTapBlock=^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"手机号";
        viewText.fieldName =@"tag";
        viewText.fieldValue =[Global sharedInstance].userInfo.tag;
        viewText.actionName = @"edituserinfo";
        viewText.placeholder = @"请输入您的手机号";
        viewText.maxLength = 100;
        viewText.tableID=@"uid";
        viewText.checkTips = @"手机号不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * submit) {
            weakTxtPhone.submit=submit;
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtPhone];
    [txtPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtName.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtPhone.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    txtPhone.borderColor=kLineColor;
    
    viewBottom=[HView new];
    viewBottom.backgroundColor=kWhiteColor;
    viewBottom.borderColor=kLineColor;
    viewBottom.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtPhone.mas_bottom).offset(kTopHeight);
        make.height.mas_equalTo(125);
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"作品(至少5张)";
    label.textAlignment = NSTextAlignmentLeft;
    label.font = kFont(14);
    [viewBottom addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBottom).offset(10);
        make.left.equalTo(viewBottom).offset(10);
        make.width.mas_equalTo(kScreenW-25);
        make.height.mas_equalTo(25);
    }];
    
    imgSel=[HImageSelector new];
    imgSel.baseVC = self;
    imgSel.allowScroll = YES;
    __block typeof (HImageSelector *) weakImgSel = imgSel;
    [viewBottom addSubview:imgSel];
    [imgSel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label).offset(30);
        make.left.equalTo(viewBottom).offset(0);
        make.right.equalTo(viewBottom).offset(-10);
        make.bottom.equalTo(viewBottom).offset(-10);
    }];
    imgSel.maxNumberOfImage = 9;
    imgSel.allowEdit = YES;
    imgSel.cropScale=DBCameraImageScale_1x1;
    
    __weak __typeof(HView *)weakViewBottom = viewBottom;
    [imgSel setSelectDelBtnCilck:^(NSInteger iNUmber) {
        isChangeImage=YES;
        [weakViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20+30);
            }else{
                make.height.mas_equalTo((weakImgSel.listImages.count/4+1)*(kScreenW/4)+20+30);
            }
        }];
    }];
    [imgSel setSelectAddBtnCilck:^(UIImage *image) {
        [weakSelf.imgurlArr removeAllObjects];
        kPrintLog(weakImgSel.listImages);
        kPrintLog(weakSelf.imgurlArr);
        isChangeImage=YES;
        [weakViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20+30);
            }else{
                make.height.mas_equalTo((weakImgSel.listImages.count/4+1)*(kScreenW/4)+20+30);
            }
        }];
//        [weakSelf showLoadingHUDWithTitle:@"正在上传图片,请稍后" SubTitle:nil];
//        [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
//        [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
//        [UPYUNConfig sharedInstance].MutAPIDomain=kMutAPIDomain;
//        for (NSInteger i = 0; i < weakImgSel.listImages.count ; i++) {
//        NSData *eachImgData = UIImageJPEGRepresentation(weakImgSel.listImages[i], 1);
//        __block UpYun *uy = [[UpYun alloc] init];
//        NSMutableDictionary * params = [NSMutableDictionary  dictionary];
//        uy.successBlocker = ^(NSURLResponse *response, id responseData) {
//            NSLog(@"response body %@", responseData);
//            [weakSelf.hudLoading hideAnimated:YES];
//            NSString *strPhoto = [responseData objectForKey:@"url"];
//            NSString *strSavePath=@"";
//            NSString *strSavaName=@"";
//            [weakSelf.imgurlArr addObject:[NSString stringWithFormat:@"%@%@",kMutAPIDomain,strPhoto]];
//            if (strPhoto.length>14) {
//                strSavePath=[strPhoto substringToIndex:12];
//                strSavaName=[strPhoto substringFromIndex:13];
//            }
//            //            NSDictionary *dic=@{@"path":@"none",
//            //                                @"url":[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]],
//            //                                @"name":@"none",
//            //                                @"type":[responseData objectForKey:@"mimetype"],
//            //                                @"size":[responseData objectForKey:@"file_size"],
//            //                                @"width":@"300",
//            //                                @"height":@"225",
//            //                                @"hash":@"none",
//            //                                @"extension":@"png",
//            //                                @"save_path":strSavePath,
//            //                                @"save_name":strSavaName
//            //                                };
//            
////            [params setValue:responseData[@"url"] forKey:@"path"];
////            [params setValue:[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]] forKey:@"url"];
////            [weakSelf.imgurlArr addObject:[params objectForKey:@"url"]];
////            [params setValue:responseData[@"url"] forKey:@"name"];
////            [params setValue:responseData[@"mimetype"] forKey:@"type"];
////            [params setValue:responseData[@"file_size"] forKey:@"size"];
////            [params setValue:responseData[@"hash"] forKey:@"hash"];
////            [params setValue:responseData[@"image-type"] forKey:@"extension"];
////            [params setValue:responseData[@"image-height"] forKey:@"height"];
////            [params setValue:responseData[@"image-width"] forKey:@"width"];
////            [params setValue:responseData[@"url"] forKey:@"save_path"];
////            NSArray *array = [[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]] componentsSeparatedByString:@"/"];
////            [params setValue:array[array.count-1] forKey:@"save_name"];
////            idCardUrl1=[self dictionaryToJson:params];//[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]];
////            NSLog(@"%@",idCardUrl1);
//        };
//        uy.failBlocker = ^(NSError * error) {
//            [weakSelf.hudLoading hideAnimated:YES];
//            //            [weakSelf showErrorHUDWithTitle:@"图片上传失败" SubTitle:nil Complete:nil];
//            [uy uploadFile:eachImgData saveKey:[weakSelf getSaveKeyWith:@"png"]];
//        };
//        uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
//            NSLog(@"%f",percent);
//        };
//        /**
//         *	@brief	根据 文件路径 上传
//         */
//        [uy uploadFile:eachImgData saveKey:[weakSelf getSaveKeyWith:@"png"]];
//        }
    }];
    // 简历
    HView *jianliBottom=[HView new];
    jianliBottom.backgroundColor=kWhiteColor;
    jianliBottom.borderColor=kLineColor;
    jianliBottom.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:jianliBottom];
    [jianliBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewBottom.mas_bottom).offset(kTopHeight);
        make.height.mas_equalTo(200);
    }];
    UILabel *jianli = [[UILabel alloc] init];
    jianli.text = @"简历";
    jianli.textAlignment = NSTextAlignmentLeft;
    jianli.font = kFont(14);
    [jianliBottom addSubview:jianli];
    [jianli mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jianliBottom).offset(10);
        make.left.equalTo(jianliBottom).offset(10);
        make.width.mas_equalTo(kScreenW-20);
        make.height.mas_equalTo(25);
    }];
    jianliTF = [[JGTextView alloc] init];
    jianliTF.font = kFont(14);
    [jianliBottom addSubview:jianliTF];
    [jianliTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jianli).offset(30);
        make.left.equalTo(jianliBottom).offset(10);
        make.width.mas_equalTo(kScreenW-20);
        make.bottom.equalTo(jianliBottom).offset(-10);
    }];
    //上传微信二维码
    viewBottom1 = [HView new];
    viewBottom1.backgroundColor=kWhiteColor;
    viewBottom1.borderColor=kLineColor;
    viewBottom1.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:viewBottom1];
    [viewBottom1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(jianliBottom.mas_bottom).offset(kTopHeight);
        make.height.mas_equalTo(125);
    }];
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"上传微信二维码";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.font = kFont(14);
    [viewBottom1 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBottom1).offset(10);
        make.left.equalTo(viewBottom1).offset(10);
        make.width.mas_equalTo(kScreenW-25);
        make.height.mas_equalTo(25);
    }];
    imgSel1=[HImageSelector new];
    imgSel1.baseVC = self;
    imgSel1.allowScroll = YES;
    __block typeof (HImageSelector *) weakImgSel1 = imgSel1;
    [viewBottom1 addSubview:imgSel1];
    [imgSel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1).offset(30);
        make.left.equalTo(viewBottom1).offset(0);
        make.right.equalTo(viewBottom1).offset(-10);
        make.bottom.equalTo(viewBottom1).offset(-10);
    }];
    imgSel1.maxNumberOfImage=1;
    imgSel1.allowEdit=YES;
    imgSel1.cropScale=DBCameraImageScale_1x1;
    
    __weak __typeof(HView *)weakViewBottom1 = viewBottom1;
    [imgSel1 setSelectDelBtnCilck:^(NSInteger iNUmber) {
        isChangeImage=YES;
        [weakViewBottom1 mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel1.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20+30);
            }else{
                make.height.mas_equalTo((weakImgSel1.listImages.count/4+1)*(kScreenW/4)+20+30);
            }
        }];
    }];
    [imgSel1 setSelectAddBtnCilck:^(UIImage *image) {
        
        isChangeImage=YES;
        [weakViewBottom1 mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel1.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20+30);
            }else{
                make.height.mas_equalTo((weakImgSel1.listImages.count/4+1)*(kScreenW/4)+20+30);
            }
        }];
        kPrintLog(weakImgSel1.listImages);
        isChangeImage=YES;
        [weakViewBottom1 mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel1.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20+30);
            }else{
                make.height.mas_equalTo((weakImgSel1.listImages.count/4+1)*(kScreenW/4)+20+30);
            }
        }];
        [weakSelf showLoadingHUDWithTitle:@"正在上传图片,请稍后" SubTitle:nil];
        [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
        [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
        [UPYUNConfig sharedInstance].MutAPIDomain=kMutAPIDomain;
        for (NSInteger i = 0; i < weakImgSel1.listImages.count ; i++) {
            NSData *eachImgData = UIImageJPEGRepresentation(weakImgSel1.listImages[i], 1);
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
                weakSelf.ewmUrl = [params objectForKey:@"url"];
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
//                idCardUrl2=[self dictionaryToJson:params];//[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]];
//                NSLog(@"%@",idCardUrl2);
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
        }

    }];
    commitBtn = [HButton buttonWithType:(UIButtonTypeSystem)];
    [contentView addSubview:commitBtn];
    [commitBtn setTintColor:[UIColor whiteColor]];
    [commitBtn addTarget:self action:@selector(commitAutoInfo) forControlEvents:(UIControlEventTouchUpInside)];
    [commitBtn setTitle:@"提交认证" forState:(UIControlStateNormal)];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(25);
        make.right.equalTo(contentView).offset(-25);
        make.top.equalTo(viewBottom1.mas_bottom).offset(kTopHeight);
        make.height.mas_equalTo(50);
    }];
    commitBtn.backgroundColor = [UIColor blackColor];
}

- (void)commitAutoInfo
{
    if (txtClass.submit.length == 0) {
        [self showErrorHUDWithTitle:@"请输入创作类别" SubTitle:nil Complete:nil];
        return;
    }if (txtColledge.submit.length == 0) {
        [self showErrorHUDWithTitle:@"请输入毕业院校" SubTitle:nil Complete:nil];
        return;
    }if (txtEducation.submit.length == 0) {
        [self showErrorHUDWithTitle:@"请输入学历" SubTitle:nil Complete:nil];
        return;
    }if (txtTeacher.submit.length == 0) {
        [self showErrorHUDWithTitle:@"请输入师承" SubTitle:nil Complete:nil];
        return;
    }if (txtJigou.submit.length == 0) {
        [self showErrorHUDWithTitle:@"请输入任职机构" SubTitle:nil Complete:nil];
        return;
    }if (txtPlace.submit == 0) {
        [self showErrorHUDWithTitle:@"请输入地区" SubTitle:nil Complete:nil];
        return;
    }if (txtName.submit == 0) {
        [self showErrorHUDWithTitle:@"请输入姓名" SubTitle:nil Complete:nil];
        return;
    }if (txtPhone.submit == 0) {
        [self showErrorHUDWithTitle:@"请输入手机号" SubTitle:nil Complete:nil];
        return;
    }if (txtClass.submit == 0) {
        [self showErrorHUDWithTitle:@"请输入创作类别" SubTitle:nil Complete:nil];
        return;
    }if (imgSel.listImages.count < 5) {
        [self showErrorHUDWithTitle:@"请上传作品至少5幅" SubTitle:nil Complete:nil];
        return;
    }if (jianliTF.text.length == 0) {
        [self showErrorHUDWithTitle:@"请输入简历信息" SubTitle:nil Complete:nil];
        return;
    }if (imgSel1.listImages.count < 1) {
        [self showErrorHUDWithTitle:@"请上传微信二维码" SubTitle:nil Complete:nil];
        return;
    }
    [self showLoadingHUDWithTitle:@"正在上传数据,请稍后..." SubTitle:@""];
    if (imgSel.listImages.count>0&&isChangeImage) {
        [self upDataImage:0];
    }else{
        [self upArtAuthData];
    }
}
- (void)upDataImage:(int)iNUmber{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].MutAPIDomain=kMutAPIDomain;
    __block UpYun *uy = [[UpYun alloc] init];
    NSMutableDictionary * params = [NSMutableDictionary  dictionary];
    UIImage *image = imgSel.listImages[iNUmber];
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
        [params setValue:[NSString stringWithFormat:@"%@%@",kMutAPIDomain,strPhoto] forKey:@"url"];
//        [params setValue:responseData[@"url"] forKey:@"name"];
//        [params setValue:responseData[@"mimetype"] forKey:@"type"];
//        [params setValue:responseData[@"file_size"] forKey:@"size"];
//        [params setValue:responseData[@"hash"] forKey:@"hash"];
//        [params setValue:responseData[@"image-type"] forKey:@"extension"];
//        [params setValue:responseData[@"image-height"] forKey:@"height"];
//        [params setValue:responseData[@"image-width"] forKey:@"width"];
//        [params setValue:responseData[@"url"] forKey:@"save_path"];
//        NSArray *array = [[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]] componentsSeparatedByString:@"/"];
//        [params setValue:array[array.count-1] forKey:@"save_name"];
//        NSString * idCardUrlPic=[self dictionaryToJson:params];
        [self.imgurlArr addObject:[params objectForKey:@"url"]];
        if (_imgurlArr.count==imgSel.listImages.count) {
            NSLog(@"图片上传完毕");
            kPrintLog(_imgurlArr);
            [self upArtAuthData];
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
- (void)upArtAuthData
{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    NSArray *arrayLocation=[txtPlace.strTag componentsSeparatedByString:@"-"];
    NSString *zuopingUrl = [_imgurlArr componentsJoinedByString:@","];
//
//    [dict setObject:zuopingUrl forKey:@"artwork"];//作品
    NSDictionary *dicAll=@{@"uid":[Global sharedInstance].userID?:@"0",
                           @"type":@"2",
                           @"czlb":txtClass.strTag?:@"",
                           @"byyx":txtColledge.submit?:@"",
                           @"xl":txtEducation.submit?:@"",
                           @"sc":txtTeacher.submit?:@"",
                           @"rzjg":txtJigou.submit?:@"",
                           @"province":arrayLocation.count==3?arrayLocation[0]:@"",
                           @"city":arrayLocation.count==3?arrayLocation[1]:@"",
                           @"area":arrayLocation.count==3?arrayLocation[2]:@"",
                           @"location":txtPlace.submit?:@"",
                           @"name":txtName.submit?:@"",
                           @"phone":txtPhone.submit?:@"",
                           @"intro":jianliTF.text?:@"",
                           @"artwork":zuopingUrl?:@"",
                           @"wxphoto":_ewmUrl?:@""
                           } ;

//    [dict setObject:@"2" forKey:@"type"];// 艺术家认证类型
//    [dict setObject:txtClass.submit forKey:@"czlb"];// 创作类别
//    [dict setObject:txtColledge.submit forKey:@"byyx"];// 毕业院校
//    [dict setObject:txtEducation.submit forKey:@"xl"];// 学历
//    [dict setObject:txtTeacher.submit forKey:@"sc"];// 师承
//    [dict setObject:txtJigou.submit forKey:@"rzjg"];// 任职机构
//    if (array.count == 3) {
//        [dict setObject:array[0] forKey:@"province"];// 省
//        [dict setObject:array[1] forKey:@"city"];// 市
//        [dict setObject:array[2] forKey:@"area"];// 区
//    }else{
//        [dict setObject:@"" forKey:@"province"];// 省
//        [dict setObject:@"" forKey:@"city"];// 市
//        [dict setObject:@"" forKey:@"area"];// 区
//    }
//    [dict setObject:txtPlace.submit forKey:@"location"];// 地址
//    [dict setObject:txtName.submit forKey:@"name"];// 姓名
//    [dict setObject:txtPhone.submit forKey:@"phone"];//电话
//    [dict setObject:jianliTF.text forKey:@"intro"];// 简历
//    
//    NSString *zuopingUrl = [_imgurlArr componentsJoinedByString:@","];
//    
//    [dict setObject:zuopingUrl forKey:@"artwork"];//作品
//    [dict setObject:_ewmUrl forKey:@"wxphoto"];//微信二维码
    
    kPrintLog(dicAll);
    HHttpRequest* request = [HHttpRequest new];
    [request httpPostRequestWithActionName:@"userauth"
                               andPramater:dicAll
                      andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
                          [self.hudLoading hideAnimated:YES];
                          
                          ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                      }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     kPrintLog(responseObject);
                     [self.hudLoading hideAnimated:YES];
                     if (txtClass.strTag) {
                         [UserDefaults setObject:txtClass.submit forKey:@"artClass"]; // 保存创作类别
                         [UserDefaults setObject:txtClass.strTag forKey:@"artClassId"];
                     }
                     [UserDefaults setObject:txtPlace.submit forKey:@"artApyPlace"]; // 保存地址信息
                     [self showOkHUDWithTitle:@"提交成功" SubTitle:nil Complete:^{
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [self.hudLoading hideAnimated:YES];
                  }];

}

- (NSString *)privatekey{
    return [NSString stringWithFormat:@"%@upload%@",[Global sharedInstance].userID,[Global sharedInstance].token].md5;
}
- (NSString *)getSaveKeyWith:(NSString *)suffix {
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
