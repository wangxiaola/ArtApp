//
//  PublishShopController.m
//  ArtistsProject
//
//  Created by 黄兵 on 2017/7/17.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "PublishShopController.h"
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
#import "orderDetailView.h"
#import "ShopCategoryController.h"
#define kTopHeight    20
#define kLineHeight   50
@interface PublishShopController ()<UITableViewDelegate, UITableViewDataSource>
{
    HImagePicker *imgHead;
    STextFieldWithTitle *txtClass,*txtName;
    STextFieldWithTitle *txtPrice;
    STextFieldWithTitle *txtYunfei;
    STextFieldWithTitle *txtKucun;
    STextFieldWithTitle *txtYishujia;
    JGTextView *jieshaoTF;
    UserInfoModel *model;
    HImageSelector *imgSel;
    HButton *commitBtn;
    HButton *btnRecord;
    HView *viewBottom;
    UISwitch *huiyuan;
    BOOL isChangeImage;
    NSIndexPath *indexAudioSelect;
    BOOL isSanemSelect;
    BOOL isVerified;
    NSMutableArray *arrayImageSave;
    NSString *idCardUrl1;
    NSString *idCardUrl2;
}
// 作品数组
@property (nonatomic, strong) NSMutableArray *imgurlArr;
// 二维码url
@property (nonatomic, strong) NSString *ewmUrl;

@end

@implementation PublishShopController

- (NSMutableArray *)imgurlArr
{
    if (!_imgurlArr) {
        _imgurlArr = [[NSMutableArray alloc] init];
    }
    return _imgurlArr;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    arrayImageSave = [NSMutableArray array];
    self.scrollView.backgroundColor = BACK_VIEW_COLOR;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"商品";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)leftBarItem_Click
{
    kPrintLog(@"返回");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定取消发布" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:nil];
    [alertVC addAction:action];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void) createView:(UIView *)contentView
{
    viewBottom=[HView new];
    viewBottom.backgroundColor=kWhiteColor;
    viewBottom.borderColor=kLineColor;
    viewBottom.borderWidth=HViewBorderWidthMake(0, 0, 0, 0);
    [contentView addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView);
        make.height.mas_equalTo(T_HEIGHT(60)+10);
    }];
    imgSel=[HImageSelector new];
    imgSel.baseVC = self;
    imgSel.allowScroll = YES;
    __block typeof (HImageSelector *) weakImgSel = imgSel;
    [viewBottom addSubview:imgSel];
    [imgSel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBottom).offset(0);
        make.left.equalTo(viewBottom).offset(0);
        make.right.equalTo(viewBottom).offset(-10);
        make.bottom.equalTo(viewBottom).offset(10);
    }];
    imgSel.maxNumberOfImage = 9;
    imgSel.allowEdit = YES;
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
    kWeakSelf;
    [imgSel setSelectAddBtnCilck:^(UIImage *image) {
        [weakSelf.imgurlArr removeAllObjects];
        kPrintLog(weakImgSel.listImages);
        kPrintLog(weakSelf.imgurlArr);
        isChangeImage=YES;
        [weakViewBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            if (weakImgSel.listImages.count==1) {
                make.height.mas_equalTo(kScreenW/4+20);
            }else{
                make.height.mas_equalTo((weakImgSel.listImages.count/4+1)*(kScreenW/4)+20);
            }
        }];
    }];
    //系统类目
    txtClass=[[STextFieldWithTitle alloc]init];
    txtClass.title = @"系统类目";
    txtClass.isBottom=NO;
    txtClass.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtClass = txtClass;
    txtClass.didTapBlock=^(){
        ShopCategoryController *classVC = [[ShopCategoryController alloc] init];
        [classVC setSaveBtnCilck:^(NSString *name, NSString *nameId) {
            weaktxtClass.submit= name;
            weaktxtClass.strTag = nameId;
        }];
        [weakSelf.navigationController pushViewController:classVC animated:YES];
    };
    [contentView addSubview:txtClass];
    [txtClass mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(viewBottom.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //名称
    txtName=[[STextFieldWithTitle alloc]init];
    txtName.title=@"名称";
    txtName.isMutable=YES;
    txtName.isMutableChage=YES;
    txtName.isBottom=NO;
    txtName.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weakTxtName = txtName;
    [contentView addSubview:txtName];
    txtName.didTapBlock=^(){
        TextVC *artText = [[TextVC alloc] init];
        artText.navTitle = @"名称";
        artText.fieldName =@"intro";
        artText.fieldValue =[Global sharedInstance].userInfo.intro;
        artText.actionName = @"edituserinfo";
        artText.placeholder = @"请输入名称";
        artText.maxLength = 100;
        artText.tableID = @"uid";
        //        artText.checkTips = @"师承不能为空";
        artText.isMultiLine = YES;
        artText.isBack = YES;
        [artText setSaveBtnCilck:^(NSString *name) {
            weakTxtName.submit=name;
        }];
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [txtName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtClass.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtName.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    txtName.borderColor=kLineColor;
    
    //价格
    txtPrice=[[STextFieldWithTitle alloc]init];
    txtPrice.title= @"价格";
    txtPrice.isBottom= NO;
    txtPrice.submit = @"价格为空时显示询价";
    txtPrice.headLineWidth = 0;
    __weak __typeof(STextFieldWithTitle *) weaktxtPrice = txtPrice;
    txtPrice.didTapBlock = ^(){
        TextVC *viewText = [[TextVC alloc] init];
        viewText.navTitle =@"价格";
        viewText.fieldName =@"tag";
        viewText.fieldValue =[Global sharedInstance].userInfo.tag;
        viewText.actionName = @"edituserinfo";
        viewText.placeholder = @"请输入商品价格";
        viewText.maxLength = 100;
        viewText.tableID = @"uid";
//        viewText.checkTips = @"价格不能为空";
        viewText.isMultiLine = NO;
        viewText.isBack=YES;
        [viewText setSaveBtnCilck:^(NSString * submit) {
            if (submit.length == 0) {
                weaktxtPrice.submit= @"¥：0";
            }else{
                weaktxtPrice.submit=[NSString stringWithFormat:@"¥：%.2f",[submit floatValue]];
            }
        }];
        [weakSelf.navigationController pushViewController:viewText animated:YES];
    };
    [contentView addSubview:txtPrice];
    [txtPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtName.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    
    //运费
    txtYunfei=[[STextFieldWithTitle alloc]init];
    txtYunfei.title=@"运费";
    txtYunfei.isBottom=NO;
    txtYunfei.submit = @"默认为0，卖家承担运费";
    txtYunfei.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtYunfei = txtYunfei;
    txtYunfei.didTapBlock=^(){
        TextVC *artText = [[TextVC alloc] init];
        artText.navTitle = @"运费";
        artText.fieldName =@"tag";
        artText.fieldValue =[Global sharedInstance].userInfo.intro;
        artText.actionName = @"edituserinfo";
        artText.placeholder = @"请输入运费";
        artText.maxLength = 100;
        artText.tableID = @"uid";
//        artText.checkTips = @"师承不能为空";
        artText.isMultiLine = NO;
        artText.isBack = YES;
        [artText setSaveBtnCilck:^(NSString *name) {
            if (name.length == 0) {
                weaktxtYunfei.submit= @"¥：0";
            }else{
                weaktxtYunfei.submit=[NSString stringWithFormat:@"¥：%.2f",[name floatValue]];
            }
        }];
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [contentView addSubview:txtYunfei];
    [txtYunfei mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtPrice.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
//    txtYunfei.borderColor=kLineColor;
//    txtYunfei.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    
    //库存
    txtKucun = [[STextFieldWithTitle alloc]init];
    txtKucun.title = @"库存";
    txtKucun.isBottom = NO;
    txtKucun.submit = @"1";
    txtKucun.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtKucun = txtKucun;
    txtKucun.didTapBlock=^(){
        TextVC *artText = [[TextVC alloc] init];
        artText.navTitle =@"库存";
        artText.fieldName =@"tag";
        artText.fieldValue =[Global sharedInstance].userInfo.intro;
        artText.actionName = @"edituserinfo";
        artText.placeholder = @"请输入您的库存";
        artText.maxLength = 100;
        artText.tableID = @"uid";
        artText.checkTips = @"库存不能为空";
        artText.isMultiLine = NO;
        artText.isBack = YES;
        [artText setSaveBtnCilck:^(NSString *name) {
            if (name.length == 0) {
                weaktxtKucun.submit=@"1";
            }else{
                weaktxtKucun.submit=name;
            }
        }];
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [contentView addSubview:txtKucun];
    [txtKucun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtYunfei.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtKucun.borderColor=kLineColor;
    txtKucun.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    //会员专属
    orderDetailView * lblAboutUs1=[[orderDetailView alloc]init];
    lblAboutUs1.title = @"会员专属";
    lblAboutUs1.borderWidth = HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:lblAboutUs1];
    [lblAboutUs1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtKucun.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    lblAboutUs1.borderColor=kLineColor;
    huiyuan = [[UISwitch alloc]init];
    huiyuan.on=YES;
    [lblAboutUs1 addSubview:huiyuan];
    [huiyuan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lblAboutUs1.mas_centerY);
        make.right.equalTo(lblAboutUs1).offset(-15);
    }];
    [huiyuan addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    lblAboutUs1.borderColor=kLineColor;
    lblAboutUs1.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);
    //艺术家
    txtYishujia = [[STextFieldWithTitle alloc]init];
    txtYishujia.title = @"艺术家";
    txtYishujia.isBottom = NO;
    txtYishujia.headLineWidth=0;
    __weak __typeof(STextFieldWithTitle *) weaktxtYishujia = txtYishujia;
    txtYishujia.didTapBlock=^(){
        TextVC *artText = [[TextVC alloc] init];
        artText.navTitle =@"艺术家";
        artText.fieldName =@"tag";
        artText.fieldValue =[Global sharedInstance].userInfo.intro;
        artText.actionName = @"edituserinfo";
        artText.placeholder = @"请输入艺术家";
        artText.maxLength = 100;
        artText.tableID = @"uid";
        artText.checkTips = @"艺术家不能为空";
        artText.isMultiLine = NO;
        artText.isBack = YES;
        [artText setSaveBtnCilck:^(NSString *name) {
                weaktxtYishujia.submit = name;
        }];
        [weakSelf.navigationController pushViewController:artText animated:YES];
    };
    [contentView addSubview:txtYishujia];
    [txtYishujia mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(lblAboutUs1.mas_bottom);
        make.height.mas_equalTo(kLineHeight);
    }];
    txtYishujia.borderColor=kLineColor;
    txtYishujia.borderWidth=HViewBorderWidthMake(0, 0, 1, 0);

    // 介绍
    HView *jieshaoBottom=[HView new];
    jieshaoBottom.backgroundColor=kWhiteColor;
    jieshaoBottom.borderColor=kLineColor;
    jieshaoBottom.borderWidth=HViewBorderWidthMake(0, 0, 0, 0);
    [contentView addSubview:jieshaoBottom];
    [jieshaoBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txtYishujia.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    UILabel *jieshao = [[UILabel alloc] init];
    jieshao.text = @"介绍";
    jieshao.textAlignment = NSTextAlignmentLeft;
    jieshao.font = kFont(14);
    [jieshaoBottom addSubview:jieshao];
    [jieshao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jieshaoBottom).offset(5);
        make.left.equalTo(jieshaoBottom).offset(15);
        make.width.mas_equalTo(kScreenW-30);
        make.height.mas_equalTo(25);
    }];
    jieshaoTF = [[JGTextView alloc] init];
    jieshaoTF.font = kFont(14);
    jieshaoTF.textAlignment = NSTextAlignmentLeft;
    [jieshaoBottom addSubview:jieshaoTF];
    [jieshaoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(jieshao).offset(20);
        make.left.equalTo(jieshaoBottom).offset(10);
        make.width.mas_equalTo(kScreenW-20);
        make.bottom.equalTo(jieshaoBottom).offset(-10);
    }];

    commitBtn = [HButton buttonWithType:(UIButtonTypeSystem)];
    [self.view addSubview:commitBtn];
    [commitBtn setTintColor:[UIColor whiteColor]];
    [commitBtn addTarget:self action:@selector(commitAutoInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    [commitBtn setTitle:@"发布" forState:(UIControlStateNormal)];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    commitBtn.backgroundColor = [UIColor blackColor];
}

- (void)switchAction:(id)sender
{
    
}
- (void)commitAutoInfo:(id)sender
{
    if (imgSel.listImages.count == 0) {
        [self showErrorHUDWithTitle:@"请添加商品图片" SubTitle:nil Complete:nil];
        return;
    }
    if (txtClass.submit.length == 0) {
        [self showErrorHUDWithTitle:@"请选择系统类目" SubTitle:nil Complete:nil];
        return;
    }if (txtName.submit.length == 0) {
        [self showErrorHUDWithTitle:@"请输入商品名称" SubTitle:nil Complete:nil];
        return;
    }if (jieshaoTF.text.length == 0) {
        [self showErrorHUDWithTitle:@"请输入商品介绍" SubTitle:nil Complete:nil];
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
        [self.imgurlArr addObject:[params objectForKey:@"url"]];
        [arrayImageSave addObject:idCardUrlPic];
        if (_imgurlArr.count >= imgSel.listImages.count) {
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
    NSString* strPic = [self objArrayToJSON:arrayImageSave];
    NSMutableDictionary* dicAll = @{@"postuid":[Global sharedInstance].userID?:@"0",
                                    @"topictype" : @"4",
                                     @"gtype" :txtClass.submit?:@"0",
                                     @"gtypename" : txtClass.strTag?:@"0",
                                     @"price" : txtPrice.submit ? : @"",
                                     @"yunfei" : txtYunfei.submit ? : @"0",
                                     @"kucun" : txtKucun.submit ? : @"1",
                                     @"huiyuan" : huiyuan.on ? @"1": @"2",
                                     @"people" : txtYishujia.submit ? : @"0",
                                     @"message" : jieshaoTF.text ? : @"",
                                     @"photos" : strPic ?: @""}.mutableCopy;
    kPrintLog(dicAll);
    HHttpRequest* request = [HHttpRequest new];
    [request httpPostRequestWithActionName:@"posttopic"
                               andPramater:dicAll
                      andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
                          kPrintLog(responseObject);
                          [self.hudLoading hideAnimated:YES];
                          ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                      }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject){
                     kPrintLog(responseObject);
                     [self.hudLoading hideAnimated:YES];
                     NSString *res=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
                     if (res.length>0 &&![res isEqualToString:@"(null)"]&&![res isEqualToString:@"(\n)"]){
                         if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"发布" obj:responseObject]) {
                             
                             
                         }else{
                             NSString* msg = responseObject[@"msg"];
                             if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                                 [self logonAgain];
                             }
                         }
                         
                     } else {
                         [self.hudLoading hideAnimated:YES];
                         [self showOkHUDWithTitle:@"提交成功" SubTitle:nil Complete:^{
                             
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
                         //[self.navigationController popViewControllerAnimated:YES];
                     }
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      kPrintLog(error);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
