//
//  EditDongtaiVC.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/17.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "EditDongtaiVC.h"
#import "H5VC.h"
#import "AudioTableViewCell.h"
#import "MainViewController.h"
#import "PlayerViewController.h"
#import "HDatePicker.h"
#import "UpYun.h"
#import "UserInfoVideoCell.h"
#import "WebviewCell.h"
#import "YTXCustomTypeViewController.h"
#import "YTXCustomTypeInputViewController.h"
#import "YTXPublishViewCell.h"
#import "HAddressSelector.h"
#import "RemindVc.h"
#import "MessageModel.h"

@interface EditDongtaiVC () <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate> {
    HView* viewBottom;
    HTextView* txt;
    HImageSelector* imgSel;
    UITableView *_tableView, *tabRecorder, *tabVideo, *tabWebview;
    NSMutableArray *arrayVideo, *arrayRecorder, *arrayWebview;
    NSMutableArray *arrayImageSave;
    AVPlayer* player;
    UIButton* btnRecord;
    UIButton* btnHuati;
    UIButton* btnRecommend;
    BOOL isUploadImageSuccess;
    BOOL isBofang;
    NSInteger iNumberChuan;
}
@property (nonatomic)AVAudioPlayer* avAudioPlayer;

@end

@implementation EditDongtaiVC
@synthesize state;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([_topictype isEqualToString:@"7"]) {
        self.navigationItem.title = @"近况";
    } else if ([_topictype isEqualToString:@"6"]) {
        self.navigationItem.title = @"作品";
    } else if ([_topictype isEqualToString:@"13"]) {
        self.navigationItem.title = @"艺术年表";
        _selectedType = @"艺术年表";
    } else if ([_topictype isEqualToString:@"17"]) {
        _selectedType = @"媒体报道";
        self.navigationItem.title = @"媒体报道";
    } else if ([_topictype isEqualToString:@"9"]) {
        _selectedType = @"咖们说|Comments";
        self.navigationItem.title = @"评论文字";
    } else if ([_topictype isEqualToString:@"16"]) {
        _selectedType = @"公益捐赠";
        self.navigationItem.title = @"公益捐赠";
    } else if ([_topictype isEqualToString:@"8"]) {
        _selectedType = @"展览经历";
        self.navigationItem.title = @"展览经历";
    } else if ([_topictype isEqualToString:@"14"]) {
        _selectedType = @"荣誉奖项";
        self.navigationItem.title = @"荣誉奖项";
    } else if ([_topictype isEqualToString:@"15"]) {
        _selectedType = @"收藏拍卖";
        self.navigationItem.title = @"收藏拍卖";
    } else if ([_topictype isEqualToString:@"18"]) {
        _selectedType = @"出版著作";
        self.navigationItem.title = @"出版著作";
    } else {
        self.navigationItem.title = @"动态";
    }
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBar_Click)];
    self.navigationItem.rightBarButtonItem = rightBar;
}


- (void)createView:(UIView*)contentView
{
    txt = [[HTextView alloc] init];
    txt.backgroundColor = kWhiteColor;
    txt.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 0);
    txt.placeholder = @"请输入发布内容";
    txt.text = _message;
    txt.textColor = kTitleColor;
    txt.font = kFont(15);
    [contentView addSubview:txt];
    [txt mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.equalTo(contentView);
        if ([_topictype isEqualToString:@"6"] || [_topictype isEqualToString:@"8"] || [_topictype isEqualToString:@"13"] || [_topictype isEqualToString:@"14"]|| [_topictype isEqualToString:@"15"] || [_topictype isEqualToString:@"16"] || [_topictype isEqualToString:@"18"] || [_topictype isEqualToString:@"17"] || [_topictype isEqualToString:@"9"]) {
            make.height.mas_equalTo(0);
        } else {
            make.height.mas_equalTo(80);
        }
    }];
    
    viewBottom = [HView new];
    viewBottom.backgroundColor = kWhiteColor;
    viewBottom.borderColor = kLineColor;
    viewBottom.borderWidth = HViewBorderWidthMake(0, 0, 1, 0);
    [contentView addSubview:viewBottom];
    [viewBottom mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(txt.mas_bottom);
        make.height.mas_equalTo(100);
    }];
    
    imgSel = [HImageSelector new];
    imgSel.baseVC = self;
    imgSel.allowScroll = YES;
    __block typeof(HImageSelector*) weakImgSel = imgSel;
    [viewBottom addSubview:imgSel];
    [imgSel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(viewBottom).offset(10);
        make.left.equalTo(viewBottom).offset(0);
        make.width.mas_equalTo(kScreenW - 20);
        make.bottom.equalTo(viewBottom).offset(-10); //height.mas_equalTo((kScreenW-75)/4);
    }];
    imgSel.maxNumberOfImage = 9;
    imgSel.allowEdit = YES;
    __weak typeof(viewBottom)weakViewBottom = viewBottom;
    [imgSel setSelectAddBtnCilck:^(UIImage* image) {
        [weakViewBottom mas_updateConstraints:^(MASConstraintMaker* make) {
            if (weakImgSel.listImages.count == 1) {
                make.height.mas_equalTo(kScreenW / 4 + 20);
            }
            else {
                make.height.mas_equalTo((weakImgSel.listImages.count / 4 + 1) * (kScreenW / 4) + 20);
            }
            
        }];
    }];
    
    
    [imgSel setSelectDelBtnCilck:^(NSInteger iNumber){
        if (arrayImageSave.count>0){
            if (arrayImageSave.count>iNumber) {
                [arrayImageSave removeObjectAtIndex:iNumber];
            }
        }
        [weakViewBottom mas_updateConstraints:^(MASConstraintMaker* make) {
            if (weakImgSel.listImages.count == 1) {
                make.height.mas_equalTo(kScreenW / 4 + 20);
            }
            else {
                make.height.mas_equalTo((weakImgSel.listImages.count / 4 + 1) * (kScreenW / 4) + 20);
            }
        }];
        
    }];
    
    __weak typeof(txt)weakTxt = txt;
    imgSel.didShowAlertBlock = ^() {
        [weakTxt resignFirstResponder];
        
    };
    
    UIView *bottomView = nil;
    if ([_topictype isEqualToString:@"7"]) {
        UIView *typeView = [[UIView alloc] init];
        typeView.userInteractionEnabled = YES;
        bottomView = typeView;
        typeView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:typeView];
        [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.top.equalTo(viewBottom.mas_bottom);
        }];
        @weakify(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self);
            YTXCustomTypeViewController *customTypeVC = [[YTXCustomTypeViewController alloc] init];
            customTypeVC.didSelectedString = ^(NSString *typeString, CUSTOM_TYPE customType) {
                self.selectedTypeLabel.text = typeString;
            };
            customTypeVC.customType = CUSTOM_TYPE_CAMERA_CLASS;
            [self.navigationController pushViewController:customTypeVC animated:YES];
        }];
        [typeView addGestureRecognizer:tap];
        
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.text = @"分类";
        typeLabel.font = kFont(15);
        [typeView addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(12);
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] init];
        [arrowImageView setImage:[UIImage imageNamed:@"icon_UserIndexVC_rightArrow"]];
        [typeView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
        }];
        
        _selectedTypeLabel = [[UILabel alloc] init];
        _selectedTypeLabel.text = _selectedType;
        _selectedTypeLabel.font = [UIFont systemFontOfSize:15];
        [typeView addSubview:_selectedTypeLabel];
        [_selectedTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(arrowImageView.mas_left).offset(-4);
        }];
    } else if ([_topictype isEqualToString:@"6"] || [_topictype isEqualToString:@"8"] || [_topictype isEqualToString:@"13"] || [_topictype isEqualToString:@"14"]|| [_topictype isEqualToString:@"15"] || [_topictype isEqualToString:@"16"] || [_topictype isEqualToString:@"18"] || [_topictype isEqualToString:@"17"] || [_topictype isEqualToString:@"9"]) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        [contentView addSubview:_tableView];
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[YTXPublishViewCell class] forCellReuseIdentifier:@"YTXPublishViewCell"];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(contentView);
            make.top.equalTo(viewBottom.mas_bottom);
            if ([_topictype isEqualToString:@"6"]) {
                make.height.mas_equalTo(240);
            } else if ([_topictype isEqualToString:@"13"]) {
                make.height.mas_equalTo(120);
            } else if ([_topictype isEqualToString:@"17"]) {
                make.height.mas_equalTo(160);
            } else if ([_topictype isEqualToString:@"9"]) {
                make.height.mas_equalTo(200);
            } else if ([_topictype isEqualToString:@"8"]) {
                make.height.mas_equalTo(280);
            } else if ([_topictype isEqualToString:@"15"]) {
                make.height.mas_equalTo(160);
            } else if ([_topictype isEqualToString:@"16"]) {
                make.height.mas_equalTo(160);
            } else if ([_topictype isEqualToString:@"18"]) {
                make.height.mas_equalTo(160);
            } else if ([_topictype isEqualToString:@"14"]) {
                make.height.mas_equalTo(200);
            } else {
                make.height.mas_equalTo(0);
            }
        }];
        bottomView = _tableView;
    } else {
        bottomView = viewBottom;
    }
    
    //录音按钮
    btnHuati = [[UIButton alloc] init];
    [btnHuati setTitle:@" 话题" forState:UIControlStateNormal];
    [btnHuati setImage:[UIImage imageNamed:@"话题"] forState:UIControlStateNormal];
    [btnHuati setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnHuati.titleLabel.font = kFont(15); //[[Global sharedInstance]fontWithSize:15];
    [btnHuati addTarget:self action:@selector(btnTopic_Click) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnHuati];
    [btnHuati mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(bottomView.mas_bottom).offset(10);
        make.width.mas_equalTo(DeviceSize.width * 0.25);
        make.height.mas_equalTo(40);
    }];
    btnHuati.imageEdgeInsets = UIEdgeInsetsMake(0, KKWidth(15), 0, 0);
    btnHuati.titleEdgeInsets = UIEdgeInsetsMake(0, KKWidth(15), 0, 0);
    
    btnRecommend = [[UIButton alloc] init];
    [btnRecommend setTitle:@" 提醒" forState:UIControlStateNormal];
    [btnRecommend setImage:[UIImage imageNamed:@"AT"] forState:UIControlStateNormal];
    [btnRecommend setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnRecommend.titleLabel.font = kFont(15); //[[Global sharedInstance]fontWithSize:15];
    [btnRecommend addTarget:self action:@selector(btnRecommend_Click) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnRecommend];
    [btnRecommend mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(bottomView.mas_bottom).offset(10);
        make.left.equalTo(btnHuati).offset(DeviceSize.width * 0.25);
        make.width.mas_equalTo(DeviceSize.width * 0.25);
        make.height.mas_equalTo(40);
    }];
    
    //录音按钮
    btnRecord = [[UIButton alloc] init];
    [btnRecord setTitle:@" 录音" forState:UIControlStateNormal];
    [btnRecord setImage:[UIImage imageNamed:@"发布录音"] forState:UIControlStateNormal];
    [btnRecord setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnRecord.titleLabel.font = kFont(15); //[[Global sharedInstance]fontWithSize:15];
    [btnRecord addTarget:self action:@selector(btnRecord_Click) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btnRecord];
    [btnRecord mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(bottomView.mas_bottom).offset(10);
        make.left.equalTo(btnRecommend).offset(DeviceSize.width * 0.25);
        make.width.mas_equalTo(DeviceSize.width * 0.25);
        make.height.mas_equalTo(40);
    }];
    
    
    HButton* btnVideo = [[HButton alloc] init];
    [btnVideo setTitle:@" 视频" forState:UIControlStateNormal];
    [btnVideo setImage:[UIImage imageNamed:@"发布视频"] forState:UIControlStateNormal];
    [btnVideo addTarget:self action:@selector(btnVideo_Click) forControlEvents:UIControlEventTouchUpInside];
    [btnVideo setTitleColor:kTitleColor forState:UIControlStateNormal];
    btnVideo.titleLabel.font = kFont(15);
    [contentView addSubview:btnVideo];
    [btnVideo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(bottomView.mas_bottom).offset(10);
        make.left.equalTo(btnRecord).offset(DeviceSize.width * 0.25);
        make.width.mas_equalTo(DeviceSize.width * 0.25);
        make.height.mas_equalTo(40);
    }];
    
    //    HButton* btnWebview = [[HButton alloc] init];
    //    [btnWebview setTitle:@" 网页" forState:UIControlStateNormal];
    //    [btnWebview setImage:[UIImage imageNamed:@"网页"] forState:UIControlStateNormal];
    //    [btnWebview addTarget:self action:@selector(btnWebview_Click) forControlEvents:UIControlEventTouchUpInside];
    //    [btnWebview setTitleColor:kTitleColor forState:UIControlStateNormal];
    //    btnWebview.titleLabel.font = kFont(15);
    //    [contentView addSubview:btnWebview];
    //    [btnWebview mas_makeConstraints:^(MASConstraintMaker* make) {
    //        make.top.equalTo(bottomView.mas_bottom).offset(10);
    //        make.left.equalTo(btnVideo).offset(DeviceSize.width * 0.25);
    //        make.width.mas_equalTo(DeviceSize.width * 0.25);
    //        make.height.mas_equalTo(40);
    //    }];
    btnHuati.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -KKWidth(15));
    btnHuati.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -KKWidth(15));
    tabRecorder = [[UITableView alloc] init];
    tabRecorder.delegate = self;
    tabRecorder.dataSource = self;
    tabRecorder.tableFooterView = [[HView alloc] init];
    [contentView addSubview:tabRecorder];
    [tabRecorder mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(btnRecord.mas_bottom).offset(10);
        make.height.mas_equalTo(40 * _arrayRecorderSave.count);
    }];
    tabRecorder.hidden = _arrayRecorderSave.count == 0 ? YES : NO;
    tabRecorder.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tabVideo = [[UITableView alloc] init];
    tabVideo.delegate = self;
    tabVideo.dataSource = self;
    tabVideo.tableFooterView = [UIView new];
    [contentView addSubview:tabVideo];
    [tabVideo mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(tabRecorder.mas_bottom).offset(10);
        make.height.mas_equalTo(_videoArray.count * 160);
    }];
    tabVideo.hidden = _videoArray.count == 0 ? YES : NO;
    
    tabWebview = [[UITableView alloc] init];
    tabWebview.delegate = self;
    tabWebview.dataSource = self;
    tabWebview.tableFooterView = [UIView new];
    [contentView addSubview:tabWebview];
    [tabWebview mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(tabVideo.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    tabWebview.hidden = YES;
    if (self.selectedImageList.count > 0){
        imgSel.listImages = self.selectedImageList.mutableCopy;
        [viewBottom mas_updateConstraints:^(MASConstraintMaker* make) {
            if (weakImgSel.listImages.count == 1) {
                make.height.mas_equalTo(kScreenW / 4 + 20);
            }
            else {
                make.height.mas_equalTo((weakImgSel.listImages.count / 4 + 1) * (kScreenW / 4) + 20);
            }
        }];
    }
    
    arrayVideo = [[NSMutableArray alloc] initWithArray:_videoArray];
    arrayImageSave = [[NSMutableArray alloc] init];
    if (self.photos.count > 0) {
        for (NSString *url in self.photos) {
            [arrayImageSave addObject:[self dictionaryToJson:@{ @"url" : url }]];
        }
    }
    arrayRecorder = [[NSMutableArray alloc] init];
    if (!_arrayRecorderSave) {
        _arrayRecorderSave = [[NSMutableArray alloc] init];
    } else {
        for (NSDictionary *dic in _arrayRecorderSave) {
            NSString* strAudio = [self dictionaryToJson:dic];
            [arrayRecorder addObject:strAudio];
        }
    }
    arrayWebview = [[NSMutableArray alloc] init];
}

- (void)upDataImage:(NSInteger)iNUmber
{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].MutAPIDomain = kMutAPIDomain;
    __block UpYun* uy = [[UpYun alloc] init];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    UIImage* image;
    if (_isEdit) {//编辑
        if (iNumberChuan<imgSel.listImages.count){
            image = imgSel.listImages[iNumberChuan];
        }
    }else{//发布
        image = imgSel.listImages[iNumberChuan];
    }
    
    NSData* eachImgData = UIImageJPEGRepresentation(image, 0.7);
    uy.successBlocker = ^(NSURLResponse* response, id responseData) {
        NSString* strPhoto = [responseData objectForKey:@"url"];
        NSString* strSavePath = @"";
        NSString* strSavaName = @"";
        if (strPhoto.length > 14) {
            strSavePath = [strPhoto substringToIndex:12];
            strSavaName = [strPhoto substringFromIndex:13];
        }
        //                            @"url":[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]],
        //                            @"name":@"none",
        //                            @"type":@"",
        //                            @"size":@"",
        //                            @"width":[],
        //                            @"height":@"225",
        //                            @"hash":@"none",
        //                            @"extension":@"png",
        //                            @"save_path":strSavePath,
        //                            @"save_name":strSavaName
        //                           };
        
        kPrintLog(responseData);
        //Id
        [params setValue:responseData[@"url"] forKey:@"path"];
        [params setValue:[NSString stringWithFormat:@"%@%@", kMutAPIDomain, [responseData objectForKey:@"url"]] forKey:@"url"];
        [params setValue:responseData[@"url"] forKey:@"name"];
        [params setValue:responseData[@"mimetype"] forKey:@"type"];
        [params setValue:responseData[@"file_size"] forKey:@"size"];
        [params setValue:responseData[@"hash"] forKey:@"hash"];
        [params setValue:responseData[@"image-type"] forKey:@"extension"];
        [params setValue:[NSString stringWithFormat:@"%f", image.size.height] forKey:@"height"];
        [params setValue:[NSString stringWithFormat:@"%f", image.size.width] forKey:@"width"];
        [params setValue:responseData[@"url"] forKey:@"save_path"];
        NSArray* array = [[NSString stringWithFormat:@"%@%@", kMutAPIDomain, [responseData objectForKey:@"url"]] componentsSeparatedByString:@"/"];
        [params setValue:array[array.count - 1] forKey:@"save_name"];
        NSString* idCardUrlPic = [self dictionaryToJson:params];
        [arrayImageSave addObject:idCardUrlPic];
        
        if (iNumberChuan >= imgSel.listImages.count-1) {
            NSLog(@"图片上传完毕");
            isUploadImageSuccess = YES;
            [self upDAtaRecorder];
        }
        else {
            iNumberChuan++;
            [self upDataImage:iNumberChuan];
        }
    };
    __weak typeof(uy)weakUp = uy;
    uy.failBlocker = ^(NSError* error) {
        [weakUp uploadFile:eachImgData saveKey:[self getSaveKeyWith:@"png"]];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    
    /**
     *	@brief	根据 文件路径 上传
     */
    [uy uploadFile:eachImgData saveKey:[self getSaveKeyWith:@"png"]];
}

- (void)updataRecorder11:(NSInteger)number11
{
    NSDictionary* dicAudioNow = _arrayRecorderSave[number11];
    NSURL* audioUrl = [dicAudioNow objectForKey:@"1"];
    NSData* voiceData = [NSData dataWithContentsOfURL:audioUrl];
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].MutAPIDomain = kMutAPIDomain;
    __block UpYun* uy = [[UpYun alloc] init];
    uy.successBlocker = ^(NSURLResponse* response, id responseData) {
        NSDictionary* dic = @{ @"duration" : [NSString stringWithFormat:@"%@", [dicAudioNow objectForKey:@"duration"]],
                               @"url" : [NSString stringWithFormat:@"%@%@", kMutAPIDomain, [responseData objectForKey:@"url"]] };
        NSString* strAudio = [self dictionaryToJson:dic];
        
        [arrayRecorder addObject:strAudio];
        NSInteger iNumber22 = number11 + 1;
        if (_arrayRecorderSave.count == iNumber22) {
            //完成
            [self wanchengChuanshu];
        }
        else {
            [self updataRecorder11:iNumber22];
        }
        
    };
    uy.failBlocker = ^(NSError* error) {
        [self.hudLoading hideAnimated:YES];
        [self showErrorHUDWithTitle:@"录音上传失败" SubTitle:nil Complete:nil];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    
    /**
     *	@brief	根据 文件路径 上传
     */
    [uy uploadFile:voiceData saveKey:[self getSaveKeyWith:@"mp3"]];
}

//上传音频文件
- (void)upDAtaRecorder
{
    if (_arrayRecorderSave.count > arrayRecorder.count) {
        [self updataRecorder11:arrayRecorder.count];
    }
    else {
        [self wanchengChuanshu];
    }
}

- (void)upDataImage11:(NSInteger)iNumber
{
    for (int i = 0; i < imgSel.listImages.count; i++) {
        NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:[NSString stringWithFormat:@"%d", i]];
        [thread start];
    }
}

- (void)downloadImage:(NSString*)url
{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].MutAPIDomain = kMutAPIDomain;
    __block UpYun* uy = [[UpYun alloc] init];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    uy.successBlocker = ^(NSURLResponse* response, id responseData) {
        NSString* strPhoto = [responseData objectForKey:@"url"];
        NSString* strSavePath = @"";
        NSString* strSavaName = @"";
        if (strPhoto.length > 14) {
            strSavePath = [strPhoto substringToIndex:12];
            strSavaName = [strPhoto substringFromIndex:13];
        }
        [params setValue:responseData[@"url"] forKey:@"path"];
        [params setValue:[NSString stringWithFormat:@"%@%@", kMutAPIDomain, [responseData objectForKey:@"url"]] forKey:@"url"];
        [params setValue:responseData[@"url"] forKey:@"name"];
        [params setValue:responseData[@"mimetype"] forKey:@"type"];
        [params setValue:responseData[@"file_size"] forKey:@"size"];
        [params setValue:responseData[@"hash"] forKey:@"hash"];
        [params setValue:responseData[@"image-type"] forKey:@"extension"];
        [params setValue:responseData[@"image-height"] forKey:@"height"];
        [params setValue:responseData[@"image-width"] forKey:@"width"];
        [params setValue:responseData[@"url"] forKey:@"save_path"];
        NSArray* array = [[NSString stringWithFormat:@"%@%@", kMutAPIDomain, [responseData objectForKey:@"url"]] componentsSeparatedByString:@"/"];
        [params setValue:array[array.count - 1] forKey:@"save_name"];
        //        NSDictionary *Pic=@{@"path":@"none",
        //                            @"url":[NSString stringWithFormat:@"%@%@",kMutAPIDomain,[responseData objectForKey:@"url"]],
        //                            @"name":@"none",
        //                            @"type":@"",
        //                            @"size":@"",
        //                            @"width":@"300",
        //                            @"height":@"225",
        //                            @"hash":@"none",
        //                            @"extension":@"png",
        //                            @"save_path":strSavePath,
        //                            @"save_name":strSavaName
        //                            };
        NSString* idCardUrlPic = [self dictionaryToJson:params];
        [arrayImageSave addObject:idCardUrlPic];
        if (arrayImageSave.count >= imgSel.listImages.count) {
            NSLog(@"图片上传完毕");
            isUploadImageSuccess = YES;
            [self upDAtaRecorder];
        }
    };
    uy.failBlocker = ^(NSError* error) {
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    
    UIImage* image = imgSel.listImages[url.intValue];
    /**
     *	@brief	根据 文件路径 上传
     */
    [uy uploadFile:image saveKey:[self getSaveKeyWith:@"png"]];
}

//完成传输
- (void)wanchengChuanshu
{
    NSString* strPic = [self objArrayToJSON:arrayImageSave];
    NSString* strAudio = @"";
    NSMutableArray* arrayAudioNew = [[NSMutableArray alloc] init];
    for (NSString *audio in arrayRecorder) {
        [arrayAudioNew addObject:audio];
    }
    if (arrayAudioNew.count > 0) {
        strAudio = [self objArrayToJSON:arrayAudioNew];
    }
    
    NSString* strVideo = @"";
    for (int i = 0; i < arrayVideo.count; i++) {
        if (i == 0) {
            strVideo = arrayVideo[i];
        }
        else {
            strVideo = [NSString stringWithFormat:@"%@,%@", strVideo, arrayVideo[i]];
        }
    }
    
    NSString* strWebview = @"";
    for (int i = 0; i < arrayWebview.count; i++) {
        if (i == 0) {
            strWebview = arrayWebview[i];
        }
        else {
            strWebview = [NSString stringWithFormat:@"%@,%@", strWebview, arrayWebview[i]];
        }
    }
    NSString* message = @"";
    NSString *catetype = @"";
    NSString *address = @"";
    NSString *planner = @"";
    NSString *starttime = @"";
    NSString *topictitle = @"";
    NSString *city = @"";
    NSString *award = @"";
    NSString *source = @"";
    if ([state isEqualToString:@"1"]) {
        message = [NSString stringWithFormat:@"#%@#%@", self.messageTop, txt.text];
    }else if ([_topictype isEqualToString:@"6"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        message = [cell subtitle];
        YTXPublishViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        catetype = [cell1 subtitle];
        YTXPublishViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        topictitle = [cell2 subtitle];
    } else if ([_topictype isEqualToString:@"13"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        message = [cell subtitle];
    } else if ([_topictype isEqualToString:@"8"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        planner = [cell subtitle];
        
        YTXPublishViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        message = [cell1 subtitle];
        
        YTXPublishViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        topictitle = [cell2 subtitle];
        
        YTXPublishViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        starttime = [cell3 subtitle];
        
        YTXPublishViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        city = [cell4 subtitle];
        
        YTXPublishViewCell *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        address = [cell5 subtitle];
    } else if ([_topictype isEqualToString:@"14"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        starttime = [cell subtitle];
        YTXPublishViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        topictitle = [cell1 subtitle];
        YTXPublishViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        award = [cell2 subtitle];
        YTXPublishViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        message = [cell3 subtitle];
    } else if ([_topictype isEqualToString:@"15"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        starttime = [cell subtitle];
        YTXPublishViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        source = [cell1 subtitle];
        YTXPublishViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        message = [cell2 subtitle];
    } else if ([_topictype isEqualToString:@"18"]) {
        YTXPublishViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        topictitle = [cell1 subtitle];
        YTXPublishViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        starttime = [cell2 subtitle];
        YTXPublishViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        message = [cell4 subtitle];
    } else if ([_topictype isEqualToString:@"16"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        starttime = [cell subtitle];
        YTXPublishViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        source = [cell1 subtitle];
        YTXPublishViewCell *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        message = [cell2 subtitle];
    } else if ([_topictype isEqualToString:@"17"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        topictitle = [cell subtitle];
        YTXPublishViewCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        source = [cell1 subtitle];
        YTXPublishViewCell *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        message = [cell3 subtitle];
    } else if ([_topictype isEqualToString:@"9"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        topictitle = [cell subtitle];
        YTXPublishViewCell *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        message = [cell4 subtitle];
    } else {
        message = txt.text;
    }
    
    NSUserDefaults *registrationID=[NSUserDefaults standardUserDefaults];
    NSString *fenleiID= [registrationID objectForKey:@"fenleiID"];
    NSMutableDictionary* dicAll = @{ @"topictype" : _topictype ? : @"",
                                     @"cata_type" : catetype,
                                     @"source" : source ? : @"",
                                     @"topictitle" : topictitle ? : @"",
                                     @"message" : message ? : @"",
                                     @"planner" : planner ? : @"",
                                     @"city" : city ? : @"",
                                     @"starttime" : starttime ? : @"",
                                     @"address" : address ? : @"",
                                     @"award" : award ? : @"",
                                     @"people" : _people ? : @"",
                                     @"postuid" : [Global sharedInstance].userID,
                                     @"photos" : strPic ?: @"",
                                     @"age" : _age ? : @"",
                                     @"width" : _width ? : @"",
                                     @"height" : _height ? : @"",
                                     @"long" : _longstr ? : @"",
                                     @"caizhi" : _format ? : @"",
                                     @"albumid" : fenleiID ? : @"",
                                     @"price" : @"",
                                     @"video" : strVideo,
                                     @"audio" : strAudio,
                                     @"source" : strWebview }.mutableCopy;
    if ([self.topictype isEqualToString:@"7"]) {
        [dicAll setObject:_selectedTypeLabel.text forKey:@"arttype"];
    } else if ([self.topictype isEqualToString:@"6"] || [self.topictype isEqualToString:@"9"]) {
        [dicAll setObject:_selectedType forKey:@"arttype"];
    }
    
    if (_isEdit) {
        [dicAll setObject:self.topicid forKey:@"topicid"];
    }
    
    if (self.atuser.count > 0) {
        [self atuserAction];
    }
    HHttpRequest* request = [HHttpRequest new];
    
    [request httpPostRequestWithActionName:_isEdit ? @"edittopic" : @"posttopic"
                               andPramater:dicAll
                      andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
                          [self.hudLoading hideAnimated:YES];
                          ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                      }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject){
                     [self.hudLoading hideAnimated:YES];
                     NSString *res=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"res"]];
                     if (res.length>0 &&![res isEqualToString:@"(null)"]&&![res isEqualToString:@"(\n)"]) {
                         [self showErrorHUDWithTitle:@"提示" SubTitle:[responseObject objectForKey:@"msg"] Complete:^{
                         }];
                     } else {
                         [self.hudLoading hide:YES];
                         [self showOkHUDWithTitle:@"提交成功" SubTitle:nil Complete:^{
                             
                             [self.navigationController popViewControllerAnimated:YES];
                         }];
                         //[self.navigationController popViewControllerAnimated:YES];
                     }
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [self.hudLoading hide:YES];
                  }];
}
- (void)atuserAction
{
    NSMutableDictionary *params = @{ @"uid" : [Global sharedInstance].userID }.mutableCopy;
    
    if (self.atuser.count > 0) {
        NSMutableArray *useridArray = [[NSMutableArray alloc] init];
        for (MessageModel *model in self.atuser) {
            [useridArray addObject:model.uid];
        }
        [params setObject:[useridArray componentsJoinedByString:@","] forKey:@"atuser"];
    }
    
    HHttpRequest* request = [HHttpRequest new];
    [request httpPostRequestWithActionName:@"atuser"
                               andPramater:params
                      andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
                          [self.hudLoading hide:YES];
                          ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
                          [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
                      }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [self.hudLoading hide:YES];
                     [self showOkHUDWithTitle:@"提交成功" SubTitle:nil Complete:^{
                         
                     }];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [self.hudLoading hide:YES];
                  }];
}

//发布按钮点击事件
- (void)rightBar_Click
{
    
    [self hideKeyBoard];
    if ([_topictype isEqualToString:@"6"]) {
        if (_age.length == 0) {
            [self showErrorHUDWithTitle:@"请输入年代" SubTitle:nil Complete:nil];
            return;
        }
        //        if (_longstr.length == 0 && _width.length == 0 && _height.length == 0) {
        //            [self showErrorHUDWithTitle:@"请输入尺寸" SubTitle:nil Complete:nil];
        //            return;
        //        }
        
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        if ([cell subtitle].length == 0) {
            [self showErrorHUDWithTitle:@"请输入名称" SubTitle:nil Complete:nil];
            return;
        }
        if (_selectedType.length == 0) {
            [self showErrorHUDWithTitle:@"请选择一个分类" SubTitle:nil Complete:nil];
            return;
        }
    } else if ([_topictype isEqualToString:@"7"]) {
        if (_selectedTypeLabel.text.length == 0) {
            [self showErrorHUDWithTitle:@"请选择一个分类" SubTitle:nil Complete:nil];
            return;
        }
        if ([self showCheckErrorHUDWithTitle:@"请输入发布内容" SubTitle:nil checkTxtField:(HTextField*)txt]) {
            return;
        }
    } else if ([_topictype isEqualToString:@"13"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if ([cell subtitle].length == 0){
            [self showErrorHUDWithTitle:@"请输入发布内容" SubTitle:nil Complete:nil];
            return;
        }
    } else if ([_topictype isEqualToString:@"8"]) {
        YTXPublishViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
        if ([cell subtitle].length == 0) {
            [self showErrorHUDWithTitle:@"请输入发布内容" SubTitle:nil Complete:nil];
            return;
        }
    } else if ([_topictype isEqualToString:@"13"]) {
        
    } else if ([_topictype isEqualToString:@"14"]) {
        
    } else if ([_topictype isEqualToString:@"15"]) {
        
    } else if ([_topictype isEqualToString:@"16"]) {
        
    } else if ([_topictype isEqualToString:@"18"]) {
        
    } else if ([_topictype isEqualToString:@"17"]) {
        
    } else if ([_topictype isEqualToString:@"9"]) {
        
    }else {
        if ([self showCheckErrorHUDWithTitle:@"请输入发布内容" SubTitle:nil checkTxtField:(HTextField*)txt]) {
            return;
        }
    }
    
    if (_isEdit) {
        iNumberChuan = _photos.count;
    } else {
        iNumberChuan = 0;
    }
    [self showLoadingHUDWithTitle:@"正在上传数据，请稍后" SubTitle:nil];
    isUploadImageSuccess = NO;
    
    if (_isEdit){//编辑
        if (imgSel.listImages.count>0) {
            [arrayImageSave removeAllObjects];
            iNumberChuan = 0;
            [self ArtupDataImage:iNumberChuan];
        }else {
            isUploadImageSuccess = YES;
            [self upDAtaRecorder];
        }
    }else{
        if (imgSel.listImages.count > iNumberChuan) {
            [arrayImageSave removeAllObjects];
            if (self.photos.count > 0) {
                for (NSString *url in self.photos) {
                    [arrayImageSave addObject:[self dictionaryToJson:@{ @"url" : url }]];
                }
            }
            [self upDataImage:iNumberChuan];
        }else {
            isUploadImageSuccess = YES;
            [self upDAtaRecorder];
        }
    }
}
-(void)ArtupDataImage:(NSInteger)iNUmber
{
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = kDEFAULT_BUCKET;
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = kDEFAULT_PASSCODE;
    [UPYUNConfig sharedInstance].MutAPIDomain = kMutAPIDomain;
    __block UpYun* uy = [[UpYun alloc] init];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    UIImage* image = imgSel.listImages[iNumberChuan];
    
    NSData* eachImgData = UIImageJPEGRepresentation(image, 0.7);
    uy.successBlocker = ^(NSURLResponse* response, id responseData) {
        NSString* strPhoto = [responseData objectForKey:@"url"];
        NSString* strSavePath = @"";
        NSString* strSavaName = @"";
        if (strPhoto.length > 14) {
            strSavePath = [strPhoto substringToIndex:12];
            strSavaName = [strPhoto substringFromIndex:13];
        }
        
        //Id
        [params setValue:responseData[@"url"] forKey:@"path"];
        [params setValue:[NSString stringWithFormat:@"%@%@", kMutAPIDomain, [responseData objectForKey:@"url"]] forKey:@"url"];
        [params setValue:responseData[@"url"] forKey:@"name"];
        [params setValue:responseData[@"mimetype"] forKey:@"type"];
        [params setValue:responseData[@"file_size"] forKey:@"size"];
        [params setValue:responseData[@"hash"] forKey:@"hash"];
        [params setValue:responseData[@"image-type"] forKey:@"extension"];
        [params setValue:[NSString stringWithFormat:@"%f", image.size.height] forKey:@"height"];
        [params setValue:[NSString stringWithFormat:@"%f", image.size.width] forKey:@"width"];
        [params setValue:responseData[@"url"] forKey:@"save_path"];
        NSArray* array = [[NSString stringWithFormat:@"%@%@", kMutAPIDomain, [responseData objectForKey:@"url"]] componentsSeparatedByString:@"/"];
        [params setValue:array[array.count - 1] forKey:@"save_name"];
        NSString* idCardUrlPic = [self dictionaryToJson:params];
        [arrayImageSave addObject:idCardUrlPic];
        
        iNumberChuan++;
        if (iNumberChuan >= imgSel.listImages.count) {
            NSLog(@"图片上传完毕");
            isUploadImageSuccess = YES;
            [self upDAtaRecorder];
        }else{
            [self upDataImage:iNumberChuan];
        }
    };
    uy.failBlocker = ^(NSError* error) {
        [uy uploadFile:eachImgData saveKey:[self getSaveKeyWith:@"png"]];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    
    /**
     *	@brief	根据 文件路径 上传
     **/
    [uy uploadFile:eachImgData saveKey:[self getSaveKeyWith:@"png"]];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    if ([tableView isEqual:_tableView]) {
        return 40;
    }
    if ([tableView isEqual:tabVideo]) {
        return 160;
    }
    if ([tableView isEqual:tabWebview]) {
        return 40;
    }
    return 40;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        if ([_topictype isEqualToString:@"13"]) {
            return 3;
        } else if ([_topictype isEqualToString:@"8"]) {
            return 7;
        } else if ([_topictype isEqualToString:@"15"]) {
            return 4;
        } else if ([_topictype isEqualToString:@"14"]) {
            return 5;
        } else if ([_topictype isEqualToString:@"16"]) {
            return 4;
        } else if ([_topictype isEqualToString:@"18"]) {
            return 4;
        } else if ([_topictype isEqualToString:@"17"]) {
            return 4;
        } else if ([_topictype isEqualToString:@"9"]) {
            return 5;
        } else {
            return 6;
        }
    }
    if ([tableView isEqual:tabRecorder]) {
        return _arrayRecorderSave.count;
    }
    if ([tableView isEqual:tabVideo]) {
        return arrayVideo.count;
    }
    if ([tableView isEqual:tabWebview]) {
        return arrayWebview.count;
    }
    return 0;
}

//设置编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:_tableView]) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{ //设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [_tableView setEditing:editing animated:animated];
    [tabRecorder setEditing:editing animated:animated]; //切换接收者的进入和退出编辑模式。
    [tabVideo setEditing:editing animated:animated]; //切换接收者的进入和退出编辑模式。
    [tabWebview setEditing:editing animated:animated]; //切换接收者的进入和退出编辑模式。
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{ //请求数据源提交的插入或删除指定行接收者。
    if ([tabRecorder isEqual:tableView]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) { //如果编辑样式为删除样式
            if (indexPath.row < [_arrayRecorderSave count]) {
                NSString *url = _arrayRecorderSave[indexPath.row][@"url"];
                for (NSString *dicStr in arrayRecorder) {
                    NSDictionary *dic = [self parseJSONStringToNSDictionary:dicStr];
                    if ([dic[@"url"] containsString:url]) {
                        [arrayRecorder removeObject:dicStr];
                        break;
                    }
                }
                [_arrayRecorderSave removeObjectAtIndex:indexPath.row];
                [tabRecorder mas_updateConstraints:^(MASConstraintMaker* make) {
                    make.height.mas_equalTo(40 * _arrayRecorderSave.count);
                }];
                [tabRecorder reloadData];
            }
        }
    }
    
    if ([tabVideo isEqual:tableView]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) { //如果编辑样式为删除样式
            if (indexPath.row < [arrayVideo count]) {
                [arrayVideo removeObjectAtIndex:indexPath.row];
                [tabVideo mas_updateConstraints:^(MASConstraintMaker* make) {
                    make.height.mas_equalTo(160 * arrayVideo.count);
                }];
                [tabVideo reloadData];
            }
        }
    }
    
    if ([tabWebview isEqual:tableView]) {
        if (editingStyle == UITableViewCellEditingStyleDelete) { //如果编辑样式为删除样式
            if (indexPath.row < [arrayWebview count]) {
                [arrayWebview removeObjectAtIndex:indexPath.row];
                [tabWebview mas_updateConstraints:^(MASConstraintMaker* make) {
                    make.height.mas_equalTo(40 * arrayWebview.count);
                }];
                [tabWebview reloadData];
            }
        }
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return @"删除";
}

//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer*)player successfully:(BOOL)flag
{
    isBofang = NO;
    for (NSIndexPath* i in [tabRecorder indexPathsForVisibleRows]) {
        AudioTableViewCell* cell = [tabRecorder cellForRowAtIndexPath:i];
        [cell endBofang];
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:_tableView]) {
        YTXPublishViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([[cell title] isEqualToString:@"分类"]) {
            @weakify(self);
            YTXCustomTypeViewController *customTypeVC = [[YTXCustomTypeViewController alloc] init];
            if ([_topictype isEqualToString:@"6"]) {
                customTypeVC.customType = CUSTOM_TYPE_WORKS_CLASS;
            } else if ([_topictype isEqualToString:@"9"]) {
                customTypeVC.customType = CUSTOM_TYPE_COMMENT;
            } else {
                customTypeVC.customType = CUSTOM_TYPE_OTHERS_CLASS;
            }
            @weakify(_tableView);
            customTypeVC.didSelectedString = ^(NSString *string, CUSTOM_TYPE customType) {
                @strongify(self);
                self.title = string;
                if ([string isEqualToString:@"艺术年表"]) {
                    self.topictype = @"13";
                    [weak__tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(120);
                    }];
                } else if ([string isEqualToString:@"展览经历"]) {
                    self.topictype = @"8";
                    [weak__tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(280);
                    }];
                } else if ([string isEqualToString:@"收藏拍卖"]) {
                    self.topictype = @"15";
                    [weak__tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(160);
                    }];
                } else if ([string isEqualToString:@"公益捐赠"]) {
                    self.topictype = @"16";
                    [weak__tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(160);
                    }];
                } else if ([string isEqualToString:@"出版著作"]) {
                    self.topictype = @"18";
                    [weak__tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(160);
                    }];
                } else if ([string isEqualToString:@"荣誉奖项"]) {
                    self.topictype = @"14";
                    [weak__tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(200);
                    }];
                }
                self.selectedType = string;
                [weak__tableView reloadData];
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            };
            [self.navigationController pushViewController:customTypeVC animated:YES];
        } else if ([[cell title] isEqualToString:@"年代"] || [[cell title] isEqualToString:@"尺寸"]) {
            @weakify(self);
            YTXCustomTypeViewController *customTypeVC = [[YTXCustomTypeViewController alloc] init];
            if ([[cell title] isEqualToString:@"尺寸"]) {
                customTypeVC.longstr = _longstr;
                customTypeVC.height = _height;
                customTypeVC.width = _width;
                customTypeVC.customType = CUSTOM_TYPE_SIZE;
            } else {
                customTypeVC.customType = CUSTOM_TYPE_AGE;
            }
            @weakify(_tableView);
            customTypeVC.didSelectedString = ^(NSString *string, CUSTOM_TYPE customType) {
                @strongify(self);
                self.age = string;
                [weak__tableView reloadData];
            };
            customTypeVC.didGetFormatString = ^(NSString *longstr, NSString *width, NSString *height) {
                @strongify(self);
                self.longstr = longstr;
                self.width = width;
                self.height = height;
                [weak__tableView reloadData];
            };
            [self.navigationController pushViewController:customTypeVC animated:YES];
        } else if ([[cell title] isEqualToString:@"时间"]) {
            HDatePicker *datePickerVC=[[HDatePicker alloc] init];
            [datePickerVC setFinishSelectedBlock:^(NSArray<HKeyValuePair *> *items) {
                NSString *time=items[0].value;
                _age=time;
                [_tableView reloadData];
            }];
            [self presentSemiViewController:datePickerVC];
        } else if ([[cell title] isEqualToString:@"城市"]) {
            @weakify(self);
            HAddressSelector *selector = [[HAddressSelector alloc] initWithFinishSelectedBlock:^(NSArray *IDs, NSArray *Names) {
                @strongify(self);
                self.city = [Names componentsJoinedByString:@""];
                [_tableView reloadData];
            } andClickedCancelButtonBlock:^{
                
            } andClickedClearButtonBlock:^{
                
            }];
            [self presentSemiViewController:selector];
        } else {
            @weakify(self);
            YTXCustomTypeInputViewController *customTypeVC = [[YTXCustomTypeInputViewController alloc] init];
            @weakify(_tableView);
            customTypeVC.title = [cell title];
            YTXPublishViewCell *viewCell = [tableView cellForRowAtIndexPath:indexPath];
            if (viewCell.subtitle.length > 0) {
                customTypeVC.editString = viewCell.subtitle;
            } else {
                customTypeVC.editString = @"";
            }
            customTypeVC.isFullScreenInput = YES;
            customTypeVC.resultBlock = ^(NSString *result) {
                @strongify(self);
                if ([self.topictype isEqualToString:@"13"]) {
                    _message = result;
                } else if ([self.topictype isEqualToString:@"8"]) {
                    if (indexPath.row == 1) {
                        _name = result;
                    } else if (indexPath.row == 2) {
                        _planner = result;
                    } else if (indexPath.row == 4) {
                        _city = result;
                    } else if (indexPath.row == 5) {
                        _address = result;
                    } else {
                        _message = result;
                    }
                } else if ([self.topictype isEqualToString:@"15"]) {
                    if (indexPath.row == 2) {
                        _source = result;
                    } else {
                        _message = result;
                    }
                } else if ([self.topictype isEqualToString:@"14"]) {
                    if (indexPath.row == 2) {
                        _name = result;
                    } else if (indexPath.row == 3) {
                        _award = result;
                    } else {
                        _message = result;
                    }
                } else if ([self.topictype isEqualToString:@"16"]) {
                    if (indexPath.row == 2) {
                        _source = result;
                    } else {
                        _message = result;
                    }
                } else if ([self.topictype isEqualToString:@"18"]) {
                    if (indexPath.row == 1) {
                        _name = result;
                    } else {
                        _message = result;
                    }
                } else if ([self.topictype isEqualToString:@"6"]) {
                    if (indexPath.row == 1) {
                        _name = result;
                    } else if (indexPath.row == 4) {
                        _format = result;
                    } else {
                        _message = result;
                    }
                } else if ([self.topictype isEqualToString:@"17"]) {
                    if (indexPath.row == 0) {
                        _name = result;
                    } else if (indexPath.row == 1) {
                        _source = result;
                    } else {
                        _message = result;
                    }
                } else if ([self.topictype isEqualToString:@"9"]) {
                    if (indexPath.row == 1) {
                        _name = result;
                    } else if (indexPath.row == 2) {
                        _age = result;
                    } else if (indexPath.row == 3) {
                        _people = result;
                    } else {
                        _message = result;
                    }
                }
                [weak__tableView reloadData];
            };
            [self.navigationController pushViewController:customTypeVC animated:YES];
        }
    }
    
    if ([tabRecorder isEqual:tableView]) {
        for (NSIndexPath* i in [tabRecorder indexPathsForVisibleRows]) {
            AudioTableViewCell* cell = [tabRecorder cellForRowAtIndexPath:i];
            [cell endBofang];
        }
        
        NSURL* urlAudio = [_arrayRecorderSave[indexPath.row] objectForKey:@"1"];
        AVAudioPlayer* playerr = [[AVAudioPlayer alloc] initWithContentsOfURL:urlAudio error:nil];
        self.avAudioPlayer = playerr;
        self.avAudioPlayer.delegate = self;
        AudioTableViewCell* cell = [tabRecorder cellForRowAtIndexPath:indexPath];
        if (isBofang) {
            [self.avAudioPlayer pause];
            isBofang = NO;
            [cell endBofang];
        }
        else {
            [self.avAudioPlayer play];
            isBofang = YES;
            [cell stateBofang];
        }
    }
    if ([tabVideo isEqual:tableView]) {
        PlayerViewController* vc = [[PlayerViewController alloc] init];
        NSString* strVideo = arrayVideo[indexPath.row];
        NSString* strVideoID = [self getVideoIDWithVideoUrl:strVideo];
        if (strVideoID.length > 0) {
            vc.videoID = strVideoID;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        [self showErrorHUDWithTitle:@"请输入正确的视频链接" SubTitle:nil Complete:nil];
    }
    if ([tabWebview isEqual:tableView]) {
        H5VC* h5 = [[H5VC alloc] init];
        h5.navTitle = @"网页链接";
        h5.url = arrayWebview[indexPath.row];
        [self.navigationController pushViewController:h5 animated:YES];
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:_tableView]) {
        
        YTXPublishViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTXPublishViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_topictype isEqualToString:@"13"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"事件"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else if ([_topictype isEqualToString:@"8"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"名称"];
                    [cell setSubtitle:_name];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"策展人"];
                    [cell setSubtitle:_planner];
                    break;
                }
                case 3:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 4:
                {
                    [cell setTitle:@"城市"];
                    [cell setSubtitle:_city];
                    break;
                }
                case 5:
                {
                    [cell setTitle:@"地点"];
                    [cell setSubtitle:_address];
                    break;
                }
                case 6:
                {
                    [cell setTitle:@"内容"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else if ([_topictype isEqualToString:@"14"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"活动"];
                    [cell setSubtitle:_name];
                    break;
                }
                case 3:
                {
                    [cell setTitle:@"奖项"];
                    [cell setSubtitle:_award];
                    break;
                }
                case 4:
                {
                    [cell setTitle:@"作品"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else if ([_topictype isEqualToString:@"15"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"机构"];
                    [cell setSubtitle:_source];
                    break;
                }
                case 3:
                {
                    [cell setTitle:@"作品"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else if ([_topictype isEqualToString:@"16"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"机构"];
                    [cell setSubtitle:_source];
                    break;
                }
                case 3:
                {
                    [cell setTitle:@"作品"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else if ([_topictype isEqualToString:@"18"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"名称"];
                    [cell setSubtitle:_name];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 3:
                {
                    [cell setTitle:@"内容"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else if ([_topictype isEqualToString:@"17"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"标题"];
                    [cell setSubtitle:_name];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"来源"];
                    [cell setSubtitle:_source];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 3:
                {
                    [cell setTitle:@"网页链接"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else if ([_topictype isEqualToString:@"9"]) {
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"标题"];
                    [cell setSubtitle:_name];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"时间"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 3:
                {
                    [cell setTitle:@"作者"];
                    [cell setSubtitle:_people];
                    break;
                }
                case 4:
                {
                    [cell setTitle:@"文字"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        } else {
            cell.textLabel.font = kFont(15);
            switch (indexPath.row) {
                case 0:
                {
                    [cell setTitle:@"分类"];
                    [cell setSubtitle:_selectedType];
                    break;
                }
                case 1:
                {
                    [cell setTitle:@"名称"];
                    [cell setSubtitle:_name];
                    break;
                }
                case 2:
                {
                    [cell setTitle:@"年代"];
                    [cell setSubtitle:_age];
                    break;
                }
                case 3:
                {
                    NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
                    if (_longstr.length > 0) {
                        [sizeArray addObject:_longstr];
                    }
                    if (_width.length > 0) {
                        [sizeArray addObject:_width];
                    }
                    if (_height.length > 0) {
                        [sizeArray addObject:_height];
                    }
                    
                    [cell setTitle:@"尺寸"];
                    if (sizeArray.count > 0) {
                        [cell setSubtitle:[[sizeArray componentsJoinedByString:@" X "] stringByAppendingString:@" cm"]];
                    }
                    break;
                }
                case 4:
                {
                    [cell setTitle:@"材质"];
                    [cell setSubtitle:_format];
                    break;
                }
                case 5:
                {
                    [cell setTitle:@"介绍"];
                    [cell setSubtitle:_message];
                    break;
                }
            }
        }
        
        return cell;
    }
    if ([tableView isEqual:tabRecorder]) {
        NSString* identifier = @"MyCouponCell";
        AudioTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[AudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = ColorHex(@"f6f6f6");
        }
        cell.tag = indexPath.row;
        cell.name = [Global sharedInstance].userInfo.nickname ? [Global sharedInstance].userInfo.nickname : @"我";
        cell.dic = _arrayRecorderSave[indexPath.row];
        [cell setBtndelBlock:^{
            NSString *url = _arrayRecorderSave[indexPath.row][@"url"];
            for (NSString *dicStr in arrayRecorder) {
                NSDictionary *dic = [self parseJSONStringToNSDictionary:dicStr];
                if ([dic[@"url"] containsString:url]) {
                    [arrayRecorder removeObject:dicStr];
                    break;
                }
            }
            [_arrayRecorderSave removeObjectAtIndex:indexPath.row];
            [tabRecorder mas_updateConstraints:^(MASConstraintMaker* make) {
                make.height.mas_equalTo(40 * _arrayRecorderSave.count);
            }];
            [tabRecorder reloadData];
        }];
        return cell;
    }
    if ([tableView isEqual:tabVideo]) {
        NSString* identifier = @"MyCouponCellVideo";
        UserInfoVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UserInfoVideoCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.videoUrl = arrayVideo[indexPath.row];
        [cell setBtndelBlock:^{
            [arrayVideo removeObjectAtIndex:indexPath.row];
            [tabVideo mas_updateConstraints:^(MASConstraintMaker* make) {
                make.height.mas_equalTo(160 * arrayVideo.count);
            }];
            [tabVideo reloadData];
        }];
        return cell;
    }
    
    if ([tableView isEqual:tabWebview]) {
        NSString* identifier = @"MyTabWebviewo";
        WebviewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WebviewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.Url = arrayWebview[indexPath.row];
        [cell setBtndelBlock:^{
            [arrayWebview removeObjectAtIndex:indexPath.row];
            [tabWebview mas_updateConstraints:^(MASConstraintMaker* make) {
                make.height.mas_equalTo(40 * arrayWebview.count);
            }];
            [tabWebview reloadData];
        }];
        return cell;
    }
    
    return nil;
}

- (void)btnVideo_Click
{
    YTXCustomTypeInputViewController *inputVC = [[YTXCustomTypeInputViewController alloc] init];
    inputVC.isFullScreenInput = YES;
    inputVC.editString = @"";
    inputVC.title = @"优酷视频链接";
    inputVC.resultBlock = ^(NSString *name) {
        NSString* strID = [self getVideoIDWithVideoUrl:name];
        if (strID.length < 1) {
            [self showErrorHUDWithTitle:@"请输入正确的视频网址" SubTitle:nil Complete:nil];
            return;
        }
        
        [arrayVideo addObject:name];
        [tabVideo mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(arrayVideo.count * 160);
        }];
        tabVideo.hidden = NO;
        [tabVideo reloadData];
    };
    [self.navigationController pushViewController:inputVC animated:YES];
    //    TextVC* viewText = [[TextVC alloc] init];
    //    viewText.navTitle = @"视频链接";
    //    viewText.placeholder = @"请输入视频链接网址";
    //    viewText.maxLength = 10000;
    //    viewText.checkTips = @"视频链接不能为空";
    //    viewText.isMultiLine = YES;
    //    viewText.isBack = YES;
    //    [viewText setSaveBtnCilck:^(NSString* name) {
    //        NSString* strID = [self getVideoIDWithVideoUrl:name];
    //        if (strID.length < 1) {
    //            [self showErrorHUDWithTitle:@"请输入正确的视频网址" SubTitle:nil Complete:nil];
    //            return;
    //        }
    //
    //        [arrayVideo addObject:name];
    //        [tabVideo mas_updateConstraints:^(MASConstraintMaker* make) {
    //            make.height.mas_equalTo(arrayVideo.count * 160);
    //        }];
    //        tabVideo.hidden = NO;
    //        [tabVideo reloadData];
    //    }];
    //    [self.navigationController pushViewController:viewText animated:YES];
}

- (NSString*)getSaveKeyWith:(NSString*)suffix
{
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

- (NSString*)getDateString
{
    NSDate* curDate = [NSDate date]; //获取当前日期
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"]; //这里去掉 具体时间 保留日期
    NSString* curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}

//话题按钮点击事件
- (void)btnTopic_Click
{
    if ([_topictype isEqualToString:@"7"]) {
        [txt becomeFirstResponder];
        txt.text = [NSString stringWithFormat:@"%@##",txt.text];
        NSRange range = [txt.text rangeOfString:@"##"];
        [txt setSelectedRange:NSMakeRange(range.location+1, 0)];
    } else {
        _message = [NSString stringWithFormat:@"%@##",_message?:@""];
        YTXCustomTypeInputViewController *customTypeInputVC = [[YTXCustomTypeInputViewController alloc] init];
        customTypeInputVC.isFullScreenInput = YES;
        customTypeInputVC.editString = _message;
        customTypeInputVC.resultBlock = ^(NSString *result) {
            _message = result;
            txt.text = _message;
            [_tableView reloadData];
        };
        [self.navigationController pushViewController:customTypeInputVC animated:YES];
    }
}

- (void)btnRecommend_Click
{
    RemindVc *vc = [[RemindVc alloc] init];
    @weakify(self);
    vc.title = @"提醒谁看";
    vc.atuser = self.atuser;
    vc.willDisappearBlock = ^(NSArray *atuser) {
        @strongify(self);
        self.atuser = atuser;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//录音按钮点击事件
- (void)btnRecord_Click
{
    UIStoryboard* secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController* test2obj = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [test2obj setBtnRecorderCilck:^(NSURL* btndiurl, double audioTime) {
        NSLog(@"%@  %f", btndiurl, audioTime);
        NSDictionary* dicRecorder = @{ @"1" : btndiurl,
                                       @"duration" : @(audioTime) };
        [_arrayRecorderSave addObject:dicRecorder];
        [tabRecorder mas_updateConstraints:^(MASConstraintMaker* make) {
            make.height.mas_equalTo(40 * _arrayRecorderSave.count);
        }];
        tabRecorder.hidden = NO;
        [tabRecorder reloadData];
    }];
    [self.navigationController pushViewController:test2obj animated:YES];
}

//网页链接
- (void)btnWebview_Click
{
//    TextVC* viewText = [[TextVC alloc] init];
//    viewText.navTitle = @"网页链接";
//    viewText.placeholder = @"请输入网址";
//    viewText.maxLength = 10000;
//    viewText.checkTips = @"网址不能为空";
//    viewText.isMultiLine = YES;
//    viewText.isBack = YES;
//    [viewText setSaveBtnCilck:^(NSString* name) {
//        [arrayWebview addObject:name];
//        [tabWebview mas_updateConstraints:^(MASConstraintMaker* make) {
//            make.height.mas_equalTo(arrayWebview.count * 40);
//        }];
//        tabWebview.hidden = NO;
//        [tabWebview reloadData];
//    }];
//    [self.navigationController pushViewController:viewText animated:YES];
}

@end
