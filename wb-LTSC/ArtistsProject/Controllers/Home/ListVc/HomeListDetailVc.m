//
//  HomeListDetailVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//
#import "HomeListDetailVc.h"
#import "ListTitleCell.h"
#import "IntroAudioCell.h"
#import "IntroVideoCell.h"
#import "DetailSourceCell.h"
#import "YTXTopicDetailPhotoViewCell.h"
#import "YTXTopicMessageViewCell.h"
#import "AnyWorksHeadCell.h"
#import "AnyWorkListCell.h"
#import "YTXTopicAuthorViewCell.h"
#import "ZanHeadCell.h"
#import "ZanListCell.h"
#import "ListRecordCell.h"
#import "LikeUsersCell.h"
#import "CommentListCell.h"
#import "CangyouQuanDetailModel.h"
#import "YTXGoodsModel.h"
#import "MyHomePageDockerVC.h"
#import "sendBtn.h"
#import "PraiseListVc.h"
#import "ZanShangVc.h"
#import "CommentListVc.h"
#import "SiXinVC.h"
#import "PayNewVC.h"
#import "PlayerViewController.h"
#import "YTXOrderConfirmViewController.h"

#define SECTION_NUMS 12
#define SECTION_FIRST 0//audio
#define SECTION_SECOND 1//
#define SECTION_THREED 2//
#define SECTION_FOURTH 3//
#define SECTION_TIFTH 4//
#define SECTION_SIXTH 5
#define SECTION_SEVENTH 6
#define SOURCE_CELL 7
#define AUTHOR 8//作者
#define ZAN_SHANG 9//赞赏区
#define LIKE_LISTS 10//点赞区
#define COMMENT_LISTS 11//评论区


@interface HomeListDetailVc ()<UITextFieldDelegate>
{
    IDMPhotoBrowser* browser;
    UITextField* _commentField;
    BOOL isReply;
    NSString* strReply;//回复评论时传回复的评论id
    sendBtn* _detailPayBtn;
    sendBtn *_qiatanBtn;
    UIButton* shopBtn;//立即购买
    CangyouQuanDetailModel * model;
    UserInfoModel *userModel;
    HView* shareViewImage;
}
@property (nonatomic, strong)CangyouQuanDetailModel *topicModel;
@property (nonatomic, strong)YTXGoodsModel * goodsModel;
@property(nonatomic,strong)NSMutableDictionary* listDic;
@property (nonatomic, strong) YTXTopicMessageViewCell *messageCell;
@property(nonatomic,strong)ListRecordCell* recordCell;
@property (nonatomic, assign) CGFloat height;
@property(nonatomic,strong)NSMutableArray* zanShangArr;
@property(nonatomic,strong)NSMutableArray* guanLianWorksArr;//关联作品
@property(nonatomic,strong)NSMutableArray* guanLianArr;//关联记录
@property(nonatomic,strong)NSMutableArray* arrayPlayer;//保存视频id
@property(nonatomic,strong)NSMutableArray* arrayVideoImage;//保存视频背景图片
@end

@implementation HomeListDetailVc
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self loadData];
}
//加载用户信息
- (void)loadUserData{
    
    //1.设置请求参数
    NSDictionary *dict = @{@"uid":@"3"};
    //    //2.开始请求
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"userinfo" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        ResultModel *result=[ResultModel modelWithDictionary:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        kPrintLog(responseObject)
        userModel=[UserInfoModel modelWithDictionary:responseObject];
    }andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
    }];
}


-(void)createView{
    [super createView];
    _listDic = [[NSMutableDictionary alloc]init];
    _zanShangArr = [[NSMutableArray alloc]init];
    _guanLianArr = [[NSMutableArray alloc]init];
     _guanLianWorksArr = [[NSMutableArray alloc]init];
    _arrayPlayer = [[NSMutableArray alloc]init];
    _arrayVideoImage = [[NSMutableArray alloc]init];
    sendBtn *customButton = [[sendBtn alloc]init];
    customButton.frame = CGRectMake(0, 0, 40, 20);
    customButton.imgFrame = CGRectMake(20, 4, 20, 12);
    [customButton addTarget:self action:@selector(btnEdit_Click) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"detailMore"] forState:UIControlStateNormal];
    customButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    UIBarButtonItem* leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = leftBarItem;
    
    if (self.topictype.integerValue!=4) {
        self.tabView.hidden = YES;
        self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tabView.separatorColor = [UIColor clearColor];
        [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }else{
    self.tabView.hidden = YES;
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.separatorColor = [UIColor clearColor];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
    UIImageView* footView = [[UIImageView alloc]init];
    footView.userInteractionEnabled = YES;
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.equalTo(self.tabView.mas_bottom).offset(0);
    }];
    shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shopBtn.tag = 99;
    shopBtn.backgroundColor = [UIColor hexChangeFloat:@"ebb263"];
    [shopBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:shopBtn];
    [shopBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.and.bottom.equalTo(footView);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH-T_WIDTH(120));
    }];
    
    _detailPayBtn = [[sendBtn alloc]init];
    [_detailPayBtn setTitle:@"洽购" forState:UIControlStateNormal];
        _detailPayBtn.tag = 88;
    _detailPayBtn.titleFrame = CGRectMake(T_WIDTH(120)/2+shopBtn.endX, 11, 30, 20);
    _detailPayBtn.imgFrame = CGRectMake(T_WIDTH(120)/2+shopBtn.endX-30, 15, 20, 15);
    _detailPayBtn.titleLabel.font = ART_FONT(ARTFONT_OFI);
    [_detailPayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_detailPayBtn setImage:[UIImage imageNamed:@"shopBtn"] forState:UIControlStateNormal];
    [_detailPayBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_detailPayBtn];
    [_detailPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(footView);
        make.left.mas_equalTo(shopBtn.mas_right);
        make.right.mas_equalTo(0);
     }];
    
        _qiatanBtn = [[sendBtn alloc]init];
        _qiatanBtn.hidden = YES;
        [_qiatanBtn setTitle:@"洽购" forState:UIControlStateNormal];
        _qiatanBtn.tag = 77;
        _qiatanBtn.titleFrame = CGRectMake(kScreenW/2, 11, 30, 20);
        _qiatanBtn.imgFrame = CGRectMake(kScreenW/2-30, 15, 20, 15);
        _qiatanBtn.titleLabel.font = ART_FONT(ARTFONT_OFI);
        [_qiatanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_qiatanBtn setImage:[UIImage imageNamed:@"shopBtn"] forState:UIControlStateNormal];
        [_qiatanBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _qiatanBtn.hidden = YES;
        [footView addSubview:_qiatanBtn];
        [_qiatanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(footView);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    [self.tabView registerClass:[ListTitleCell class]
         forCellReuseIdentifier:@"ListTitleCell"];
    [self.tabView registerClass:[YTXTopicDetailPhotoViewCell class] forCellReuseIdentifier:@"YTXTopicDetailPhotoViewCell"];
    [self.tabView registerClass:[YTXTopicMessageViewCell class] forCellReuseIdentifier:@"YTXTopicMessageViewCell"];
    [self.tabView registerClass:[YTXTopicMessageViewCell class] forCellReuseIdentifier:@"height"];
    [self.tabView registerClass:[YTXTopicAuthorViewCell class] forCellReuseIdentifier:@"YTXTopicAuthorViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeight:) name:@"webViewHeightDidChangeOnTopicDetail" object:nil];
    YTXTopicMessageViewCell *cell = [self.tabView dequeueReusableCellWithIdentifier:@"height"];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    _messageCell = cell;
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
    
    
    shareViewImage = [[HView alloc] init];
    shareViewImage.hidden = YES;
    shareViewImage.backgroundColor = kClearColor;
    [self.view addSubview:shareViewImage];
    [shareViewImage mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(SCREEN_HEIGHT, 0, 0, 0));
    }];
    
    for (int i=0; i<9; i++) {
        UIImageView* img1 = [[UIImageView alloc] init];
        img1.hidden = YES;
        img1.contentMode = UIViewContentModeScaleAspectFill;
        img1.clipsToBounds = YES;
        img1.tag = 100+i;
        img1.layer.masksToBounds = YES;
        [shareViewImage addSubview:img1];
        [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.edges.equalTo(shareViewImage).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTION_NUMS;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row = 0;
    switch (section) {
        case 0:
        {
            if ([_topictype isEqualToString:@"9"] || [_topictype isEqualToString:@"17"]){
                row = 1;
            }else{
                row = 0;
            }
            
        }
            break;
        case 1:
        {
            //视频
            NSArray *array = [self.topicModel.video componentsSeparatedByString:@","];
            NSMutableArray *realArray = [[NSMutableArray alloc] init];
            for (NSString *string in array) {
                if (string.length > 0) {
                    [realArray addObject:string];
                }
            }
            row = realArray.count>0?1:0;
            
        }
            break;
        case 2:
        {
            //语音
            NSData *audioData = [self.topicModel.audio dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jsonError = nil;
            if (audioData) {
                NSArray *array = [NSJSONSerialization JSONObjectWithData:audioData options:NSJSONReadingAllowFragments error:&jsonError];
                row = array.count;
            } else {
                row = 0;
            }
            
        }
            break;
        case 3:
        {
            //图片
            row = self.topicModel.photoscbk.count;
            
            
        }
            break;
        case 4:
        {
            //作文内容
            row = 1;
        }
            break;
        case 5:
        {//部分作品
            
            if (_guanLianWorksArr.count >0) {
                row = _guanLianWorksArr.count+1;
            }else{
                if ([Global sharedInstance].userID &&[[Global sharedInstance].isgroup integerValue] == 1) {
                    row = 2;
                }else{
                    row = 0;
                }
            }
//            row = _guanLianWorksArr.count>0?_guanLianWorksArr.count+1:2;
            
        }
            break;
        case 6:
        {//相关记录
            if (_guanLianArr.count >0) {
                row = _guanLianArr.count+1;
            }else{
                if ([Global sharedInstance].userID &&[[Global sharedInstance].isgroup integerValue] == 1) {
                    row = 2;
                }else{
                    row = 0;
                }
            }
//                row = _guanLianArr.count>0?_guanLianArr.count+1:2;
            
        }
            break;
            //
        case SOURCE_CELL:
        {
            if (_topicModel.sourceText.length>0) {
                row = 1;
            }
        }
            break;
        case AUTHOR:
        {
            //作文发表者
            row = 1;
            
        }
            break;
        case ZAN_SHANG:
        {
            //赞赏
            if ([Global sharedInstance].ishideMoney) {
                if (_zanShangArr.count>0) {
                    row = _zanShangArr.count+1;
                }else{
                    row = 1;
                }

            }else{
                row = 0;
            }
          break;
        }
        case LIKE_LISTS:
        {
            //赞
            row = 1;
            break;
        }
        case COMMENT_LISTS:
        {
            //评论
            
            id arr = _listDic[@"comments"];
            if ([arr isKindOfClass:[NSArray class]]) {
                NSArray* commentArr = _listDic[@"comments"];
                row = commentArr.count>0?commentArr.count+1:0;
            }
            break;
        }
            
    }
    return row;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
        {
            //标题
            height = [ListTitleCell heightWithModel:self.topicModel];
            break;
        }
        case 1:{//视频
            height = T_WIDTH(87);
            break;
        }
        case 2:{//语音
            height = T_WIDTH(60);
            break;
        }
        case 3:
        {
            if (self.topicModel.photoscbk.count > 0) {
                //图片
                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:indexPath.row];
                height = kScreenW / [photoscbkModel.cbk floatValue] + 7;//加间隔5
            } else {
                height = 0;
            }
            break;
        }
        case 4:
        {
            //作文
            _messageCell.isResult = NO;
            _messageCell.detailModel = self.topicModel;
            height = _messageCell.getHeight + _height;
            break;
        }
        case 5:
        {
            if (_guanLianWorksArr.count > 0) {

                if (indexPath.row==0){
                    height = 40;
                }else{
                   height = (SCREEN_WIDTH/1.5+10);}
            }else{
                if ([Global sharedInstance].userID &&[[Global sharedInstance].isgroup integerValue] == 1) {
                    if (indexPath.row == 0) {
                        height =40;
                    }else{
                        height = 60;}
                    }else{
                        height = 0;
                    }
                }
            break;
        }
        case 6:
        {
            if (_guanLianArr.count>0){
                if (indexPath.row==0) {
                    height = 40;
                }else{
                    NSDictionary* dic = _guanLianArr[indexPath.row-1];
                    if (_recordCell) {
                        height = [_recordCell heightWithModel:dic];
                    }}
            }else{
                if ([Global sharedInstance].userID &&[[Global sharedInstance].isgroup integerValue] == 1) {
                    if (indexPath.row == 0) {
                        height =40;
                    }else{
                        height = 60;
                    }
                }else{
                    height = 0;
                }
                
            }
            break;
        }
        case SOURCE_CELL:
        {
            height = 40;
           
        }
            break;
        case AUTHOR:
        {
//            作文作者
//            if ([Global sharedInstance].userID &&[[Global sharedInstance].isgroup integerValue] == 1) {
//                height = [YTXTopicAuthorViewCell defaultCellHeight];
//            }else{
                height = 0;
//            }
            break;
        }
        case ZAN_SHANG:
        {
            //赞赏
            if (indexPath.row==0) {
                height = 90;
            }else{
                height = 50;
            }
            break;
        }
        case LIKE_LISTS:
        {
            //赞
            height = 60;
            break;
        }
        case COMMENT_LISTS:
        {
            height = 60;
            break;
        }
            
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section){
        case 0:
        {
            //标题
            ListTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListTitleCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.topicModel;
            return cell;
        }
        case 1:{
            IntroVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroVideoCell"];
            if (cell==nil) {
                cell = [[IntroVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroVideoCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(87))];
            }
            cell.selectImgCilck = ^(NSInteger index){
                // 播放视频
                PlayerViewController *vc=[[PlayerViewController alloc]init];
                vc.videoID=_arrayPlayer[index];
                [self.navigationController pushViewController:vc animated:YES];
                //                [ArtUIHelper addHUDInView:self.view text:@"暂未开通" hideAfterDelay:1.0];
            };
            //视频
            NSArray *array = [self.topicModel.video componentsSeparatedByString:@","];
            NSMutableArray *realArray = [[NSMutableArray alloc] init];
            for (NSString *string in array) {
                if (string.length > 0) {
                    [realArray addObject:string];
                }
            }
            
            if (realArray.count>0) {
                [cell setArtTableViewCellArrValue:_arrayVideoImage];
            }
            
            return cell;
        }
        case 2:{//语音
            IntroAudioCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroAudioCell"];
            if (cell==nil) {
                cell = [[IntroAudioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroAudioCell"];
            }
            NSArray *audioArray = [ArtUIHelper stringToJSON:self.topicModel.audio];
            NSDictionary *dict = [audioArray objectOrNilAtIndex:indexPath.row];
            [cell setArtTableViewCellDicValue:dict name:self.topicModel.user.username];
            
            return cell;
        }
        case 3:
        {
            //图片
            YTXTopicDetailPhotoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTXTopicDetailPhotoViewCell" forIndexPath:indexPath];
            if (self.topicModel.photoscbk.count > 0) {
                cell.photo = [self.topicModel.photoscbk objectAtIndex:indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                @weakify(self);
                cell.imageTapBlock = ^(photoscbkModel *photo, UIImageView *tapImage) {
                    @strongify(self);
                    NSArray* arrayPhoto = [self.topicModel.photos componentsSeparatedByString:@","];
                    NSArray* photosWithURL = [IDMPhoto photosWithURLs:arrayPhoto];
                    
                    NSMutableArray* photos = [NSMutableArray arrayWithArray:photosWithURL];
                    browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:tapImage];
                    browser.dismissOnTouch = YES;
                    browser.displayArrowButton = NO;
                    browser.displayActionButton = NO;
                    browser.displayDoneButton = NO;
                    browser.autoHideInterface = NO;
                    browser.displayCounterLabel     = YES;
                    browser.useWhiteBackgroundColor = NO;
                    browser.usePopAnimation=YES;
                    
                    UIImageView* imageClick = (UIImageView*)tapImage;
                    browser.scaleImage = imageClick.image;
                    browser.trackTintColor = [UIColor colorWithWhite:0.8 alpha:1];
                    [browser setInitialPageIndex:indexPath.row];
                    [self presentViewController:browser animated:YES completion:nil];
                };
            }
            return cell;
        }
        case 4:
        {
            //作文
            YTXTopicMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTXTopicMessageViewCell" forIndexPath:indexPath];
            cell.isResult = NO;
            cell.detailModel = self.topicModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 5:
        {
//            if (_guanLianArr.count > 0) {
            if (_guanLianWorksArr.count > 0) {
            if (indexPath.row==0){
                
                //部分作品
                AnyWorksHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AnyWorksHeadCell"];
                if (cell==nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"AnyWorksHeadCell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }//workArr.count
                cell.model = [CangyouQuanDetailModel mj_objectWithKeyValues:_listDic];
                [cell setWorkHead:@"商品" num:[NSString stringWithFormat:@"%ld",_guanLianWorksArr.count] uid:self.topicModel.user.uid];
                return cell;
            }
            /* */
                AnyWorkListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AnyWorkListCell"];
                if (cell==nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"AnyWorkListCell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if (indexPath.row > 0) {
                    NSDictionary* dic = _guanLianWorksArr[indexPath.row-1];
                    [cell setAnyWorkListDic:dic];
                }
               
                __weak typeof(self)weakSelf = self;
                cell.detailBtnCilck = ^(NSDictionary* dic){
                    [weakSelf enterDetailWithDict:dic];
                };
                return cell;
            }else{
                if ([Global sharedInstance].userID &&[[Global sharedInstance].isgroup integerValue] == 1) { // 用户登录且是编辑管理用户组
                    if (indexPath.row==0){
                        
                        //部分作品
                        AnyWorksHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AnyWorksHeadCell"];
                        if (cell==nil) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"AnyWorksHeadCell" owner:self options:nil] lastObject];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }//workArr.count
                        cell.model = [CangyouQuanDetailModel mj_objectWithKeyValues:_listDic];
                        [cell setWorkHead:@"商品" num:[NSString stringWithFormat:@"%ld",_guanLianWorksArr.count] uid:self.topicModel.user.uid];
                        return cell;
                    }
                    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WorksAlertCell"];
                    if (cell==nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WorksAlertCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel*  alertLabel = [[UILabel alloc]init];
                        alertLabel.text = @"暂无信息";
                        alertLabel.textColor = kColor3;
                        alertLabel.textAlignment = NSTextAlignmentCenter;
                        [cell.contentView addSubview:alertLabel];
                        [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.center.equalTo(cell.contentView);
                            make.size.mas_equalTo(CGSizeMake(80, 20));
                        }];
                        
                    }
                    return cell;
                }
            }
        }
        case 6:
        {
            if (_guanLianArr.count>0) {
            //相关记录
            if (indexPath.row==0) {
                AnyWorksHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AnyWorksHeadCell"];
                if (cell==nil) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"AnyWorksHeadCell" owner:self options:nil] lastObject];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                cell.model = [CangyouQuanDetailModel mj_objectWithKeyValues:_listDic];
                [cell setWorkHead:@"记录" num:[NSString stringWithFormat:@"%ld",_guanLianArr.count] uid:self.topicModel.user.uid];
                return cell;
            }
                ListRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ListRecordCell"];
                if (cell==nil) {
                    cell = [[ListRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListRecordCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                _recordCell = cell;
                __weak typeof(self)weakSelf = self;
                cell.detailBtnCilck = ^(NSDictionary* dic){
                    [weakSelf enterDetailWithDict:dic];
                };
                return cell;
            }else{
                if ([Global sharedInstance].userID &&[[Global sharedInstance].isgroup integerValue] == 1){
                    // 用户已登录且是编辑用户组
                    if (indexPath.row==0) {
                        AnyWorksHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AnyWorksHeadCell"];
                        if (cell==nil) {
                            cell = [[[NSBundle mainBundle]loadNibNamed:@"AnyWorksHeadCell" owner:self options:nil] lastObject];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                        }
                        cell.model = [CangyouQuanDetailModel mj_objectWithKeyValues:_listDic];
                        [cell setWorkHead:@"记录" num:[NSString stringWithFormat:@"%ld",_guanLianArr.count] uid:self.topicModel.user.uid];
                        return cell;
                    }
                    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WorksAlertCell"];
                    if (cell==nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WorksAlertCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        UILabel*  alertLabel = [[UILabel alloc]init];
                        alertLabel.text = @"暂无信息";
                        alertLabel.textColor = kColor3;
                        alertLabel.textAlignment = NSTextAlignmentCenter;
                        [cell.contentView addSubview:alertLabel];
                        [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.center.equalTo(cell.contentView);
                            make.size.mas_equalTo(CGSizeMake(80, 20));
                        }];
                    }
                    return cell;
                }

            }

                   }
        case SOURCE_CELL:
        {
            DetailSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailSourceCell"];
            if (cell==nil) {
                cell = [[DetailSourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailSourceCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
            [cell setDetailSourceCell:_topicModel];
                return cell;
        }
        case AUTHOR:  // 作者信息
        {
//            if ([Global sharedInstance].userID&&[[Global sharedInstance].isgroup integerValue] == 1) {
//            //作文的作者
//            YTXTopicAuthorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTXTopicAuthorViewCell" forIndexPath:indexPath];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//            cell.model = self.topicModel.user;
//            __weak typeof(self)weakSelf = self;
//            cell.accountTouch = ^(UserInfoUserModel *sendModel) {
//                MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
//                vc.navTitle = sendModel.username;
//                vc.artId = sendModel.uid;
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            };
//            return cell;
//            }
        }
        case ZAN_SHANG:
        {
            //赞赏
            if (indexPath.row==0) {
                ZanHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZanHeadCell"];
                if (cell==nil) {
                    cell = [[ZanHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZanHeadCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    __weak typeof(self)weakSelf = self;
                    cell.shangSendClick = ^(){
                        if (![weakSelf isFinishLogin]) {
                            return ;
                        };
                        ZanShangVc* vc = [[ZanShangVc alloc]init];
                        vc.whichControl = NSStringFromClass([weakSelf class]);
                        vc.navTitle = [NSString stringWithFormat:@"赞赏 %@",self.topicModel.user.username];
                        vc.topicId = self.topicid;
                        vc.tagStr = self.topicModel.user.tag;
                        vc.userName = self.topicModel.user.username;
                        vc.iconStr = self.topicModel.user.avatar;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    };
                    
                }
                [cell setArtTableViewCellDicValue:_zanShangArr.count];
                return cell;
                
            }else{
                ZanListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZanListCell"];
                if (cell==nil) {
                    cell = [[ZanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZanListCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if (_zanShangArr.count>0) {
                    [cell setArtTableViewCellDicValue:_zanShangArr[indexPath.row-1]];
                }
                
                return cell;
                
            }
            
            
        }
            
        case LIKE_LISTS:
        {
            //赞
            LikeUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeUsersCell"];
            if (cell==nil) {
                cell = [[LikeUsersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LikeUsersCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSArray* workArr = _listDic[@"likeuser"];
            [cell setArtTableViewCellArrValue:workArr];
            [cell setArtTableViewCellDicValue:_listDic];
            cell.enterBtnClick = ^(){
                PraiseListVc* detailVC = [[PraiseListVc alloc]init];
                detailVC.navTitle = @"赞过的人";
                detailVC.topicid = [NSString stringWithFormat:@"%@",self.topicid];
                detailVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:detailVC animated:YES];
                
            };
            cell.selectImgCilck = ^(NSDictionary* dic){
                //进个人主页
                MyHomePageDockerVC *vc=[[MyHomePageDockerVC alloc]init];
                vc.navTitle=dic[@"username"];
                vc.artId=dic[@"uid"];
                [self.navigationController pushViewController:vc animated:YES];
            };
            return cell;
        }
        case COMMENT_LISTS:
        {
            NSArray* commentArr = _listDic[@"comments"];
            if (indexPath.row<commentArr.count) {
                CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentListCell"];
                if (cell==nil) {
                    cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentListCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                NSArray* commentArr = _listDic[@"comments"];
                cell.sendBtnClick = ^(NSDictionary* dic){
                    [_commentField becomeFirstResponder];
                    isReply = YES;
                    NSDictionary* dicComment = dic;
                    _commentField.text = [NSString stringWithFormat:@"回复 @%@: ", dicComment[@"author"][@"username"]];
                    strReply = [NSString stringWithFormat:@"%@",dic[@"author"][@"uid"]];
                };
                [cell setArtTableViewCellDicValue:commentArr[indexPath.row]];
                return cell;
            }else{
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
                if (cell==nil) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [cell.contentView addSubview:btn];
                    [btn addTarget:self action:@selector(seeAllComment) forControlEvents:UIControlEventTouchUpInside];
                    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    [btn setTitleColor:kColor4 forState:UIControlStateNormal];
                    btn.titleLabel.font = ART_FONT(ARTFONT_OZ);
                    [btn setTitle:@"查看全部评论" forState:UIControlStateNormal];
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
                    }];
                }
                return cell;
            }
        }
            
    }
    return nil;
}
-(void)seeAllComment{
    CommentListVc* vc = [[CommentListVc alloc]init];
    vc.navTitle = @"评论";
    vc.isOpenFooterRefresh = YES;
    vc.isOpenHeaderRefresh = YES;
    vc.topictypeStr = self.topicid;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==SECTION_NUMS-1) {
        return 44;
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==SECTION_NUMS-1) {
        UIImageView* footView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        footView.userInteractionEnabled = YES;
        footView.backgroundColor = BACK_VIEW_COLOR;
        [self.view addSubview:footView];
        _commentField = [[UITextField alloc]init];
        _commentField.backgroundColor = RGB(230, 230, 230);
        _commentField.delegate = self;
        _commentField.clearsOnBeginEditing = YES;
        _commentField.clearButtonMode = UITextFieldViewModeAlways;
        _commentField.font = ART_FONT(ARTFONT_OTH);
        _commentField.textColor = RGB(150, 150, 150);
        _commentField.placeholder = @"我也说两句...";
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor blackColor];
        btn.titleLabel.font = ART_FONT(ARTFONT_OF);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"评论" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        if ([Global sharedInstance].userID&&[[Global sharedInstance].isgroup integerValue] == 1) { // 判断用户已登录且是编辑管理用户组，则显示评论框
//            [footView addSubview:_commentField];
//            [_commentField mas_makeConstraints:^(MASConstraintMaker *make){
//                make.top.and.bottom.equalTo(footView);
//                make.bottom.mas_equalTo(footView.mas_bottom).offset(-10);
//                make.left.mas_equalTo(15);
//                make.width.mas_equalTo(SCREEN_WIDTH-90);
//            }];
//            [footView addSubview:btn];
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(footView);
//                make.bottom.mas_equalTo(footView.mas_bottom).offset(-10);
//                make.left.mas_equalTo(_commentField.mas_right);
//                make.right.mas_equalTo(-15);
//            }];
//        }
        return footView;
    }
    return nil;
}
//评论
-(void)commentBtnClick{
    if (![self isNavLogin]) {
        return;
    }
    [self hideKeyBoard];
    if (_commentField.text.length < 1||[_commentField.text isEqualToString:@"我也说两句..."]) {
        [self showErrorHUDWithTitle:@"请输入评论内容" SubTitle:nil Complete:nil];
        return;
    }
    
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"id" : self.topicid,
                            @"type" : @"2",
                            @"replyid" : strReply ?: @"0",
                            @"message" : _commentField.text };
    
    [self showLoadingHUDWithTitle:@"正在发送评论" SubTitle:nil];
    __weak typeof(self)wself = self;
    [ArtRequest PostRequestWithActionName:@"topiccomment" andPramater:dict succeeded:^(id responseObject){
        [wself.hudLoading hideAnimated:YES];
        [wself loadData];
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"评论" obj:responseObject]) {
            //评论成功
        }else{
            NSString* msg = responseObject[@"msg"];
            
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [self logonAgain];
            }
        }
        
    } failed:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
    }];
    
}
-(void)refreshData{
    [self loadData];
}

- (void)loadData{
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID ?: @"0",
                            @"topicid" : [NSString stripNullWithString:self.topicid],
                            @"type" : [NSString stripNullWithString:_topictype]
                            };
    kPrintLog(dict);
    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:@"topicdetail" andPramater:dict succeeded:^(id responseObject) {
        [self.hudLoading hideAnimated:YES];
    kPrintLog(responseObject)
        //个人简介
        self.topicModel = [CangyouQuanDetailModel mj_objectWithKeyValues:responseObject];
        model = [CangyouQuanDetailModel mj_objectWithKeyValues:responseObject];
        [self loadShipingDataWithString:_topicModel.video];
        NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
        if (arrayYuanlai.count>0) {
            for (int i=0; i<arrayYuanlai.count; i++) {
                UIImageView* img = [shareViewImage viewWithTag:100+i];
                [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",arrayYuanlai[i]] tempTmage:@"icon_Default_Product.png"];
            }
        }
        self.goodsModel = [YTXGoodsModel modelWithDictionary:responseObject];
        [self.listDic addEntriesFromDictionary:responseObject];
        [self loadUserData];
        [self loadGuanLianWorksData];
         [self loadGuanLianJIluData];
        
        self.tabView.hidden = NO;
        [self.tabView reloadData];
        if (self.isScrollToBottom){
            [self scrollViewToBottom:self.isScrollToBottom];
        }
        if ([self.topictype isEqualToString:@"4"]){
            if (self.topicModel.kucun.integerValue == 0||self.topicModel.sellprice.integerValue == 0) {
//                [_detailPayBtn setFrame:CGRectMake(0, 0, kScreenW, 40)];
                _detailPayBtn.hidden = YES;
                shopBtn.hidden = YES;
                _qiatanBtn.hidden = NO;
                [_qiatanBtn setTitle:@"洽购" forState:UIControlStateNormal];
            } else {
                _detailPayBtn.hidden = NO;
                shopBtn.hidden = NO;
                _qiatanBtn.hidden = YES;
                [_detailPayBtn setTitle:@"洽购" forState:UIControlStateNormal];
            }
        }else{
            
        }
        
        
    }failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
    }];
    
    [self loadZhanShangData];
    
}
- (void)loadShipingDataWithString:(NSString *)string
{
    if (string.length>2) {
        NSMutableArray *arrayVideo=[[string  componentsSeparatedByString:@","] mutableCopy];
        for (NSString *strPic in arrayVideo) {
            if (strPic.length<2) {
                [arrayVideo removeObject:strPic];
            }
        }
        kPrintLog(arrayVideo);
        [_arrayVideoImage removeAllObjects];
        [_arrayPlayer removeAllObjects];
        [self getImage:arrayVideo withNumber:0];
    }
}
//视频
- (void)getImage:(NSMutableArray *)arrayVideo withNumber:(int)iNumber{
    //1.设置请求参数
    NSString *strVideoID=[self getVideoIDWithVideoUrl:arrayVideo[iNumber]];
    kPrintLog(strVideoID);
    if (strVideoID.length < 1) {
        return;
    }
    [_arrayPlayer addObject:strVideoID];
    //    //特殊参数
    NSDictionary *dict = @{@"client_id":youKuclientId,
                           @"video_id":strVideoID};
    //1.管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    manager.requestSerializer.timeoutInterval=20.0f;//超时时间
    
    NSString *url = @"https://openapi.youku.com/v2/videos/show.json";
    //4 请求
    [manager GET:url parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject allKeys] containsObject:@"bigThumbnail"]) {
            NSString *strVideoUrl=[responseObject objectForKey:@"bigThumbnail"];
            [_arrayVideoImage addObject:strVideoUrl];
            int iVideoNumber=iNumber+1;
            if (_arrayVideoImage.count==arrayVideo.count) {
                [self.tabView reloadData];
            }else{
                [self getImage:arrayVideo withNumber:iVideoNumber];
            }
        }
        
    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        
    }];
    
}
//根据url获取视频id
- (NSString*)getVideoIDWithVideoUrl:(NSString*)strVideo
{
    NSString* sub = @"";
    NSUInteger i = 0;
    NSUInteger iMoren = 4;
    NSRange start = [strVideo rangeOfString:@"vid="];
    i = start.location + iMoren;
    if (start.length == 0) {
        start = [strVideo rangeOfString:@"id_"];
        iMoren = 3;
        i = start.location + iMoren;
    }
    if (start.length == 0) {
        return @"";
    }
    //NSLog(@"%lu", (unsigned long)strVideo.length);
    for (; i < strVideo.length; i++) {
        NSString* strCoin = [strVideo substringWithRange:NSMakeRange(i, 1)];
        int asciiCode = [strCoin characterAtIndex:0]; //65
        if (!((47 < asciiCode && asciiCode < 58) || (64 < asciiCode && asciiCode < 91) || (96 < asciiCode && asciiCode < 123) || asciiCode == 61)) {
            break;
        }
    }
    sub = [strVideo substringWithRange:NSMakeRange(start.location + iMoren, i - start.location - iMoren)];
    return sub;
}

-(void)loadZhanShangData{
    NSDictionary *dict = @{@"topicid":self.topicid,
                           @"num":@"10"};
    __weak typeof(self)weakf = self;
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"zslist" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        __strong typeof(weakf)strongSelf = weakf;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [strongSelf.zanShangArr removeAllObjects];
            [strongSelf.zanShangArr addObjectsFromArray:responseObject];
            [strongSelf.tabView reloadData];
        }
        
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        
    }];
    
}
-(void)loadGuanLianJIluData{
    
    NSDictionary *dict = @{@"ids":_topicModel.relation_ids,
                           };
    __weak typeof(self)weakf = self;
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getguanlian" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        __strong typeof(weakf)strongSelf = weakf;
       
        if ([responseObject isKindOfClass:[NSArray class]]){
                [strongSelf.guanLianArr removeAllObjects];
                [strongSelf.guanLianArr addObjectsFromArray:responseObject];
                [strongSelf.tabView reloadData];
        }
        
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        __strong typeof(weakf)strongSelf = weakf;
        [strongSelf.guanLianArr removeAllObjects];
        [strongSelf.tabView reloadData];
    }];
    
}
-(void)loadGuanLianWorksData{
    
    NSDictionary *dict = @{@"ids":_topicModel.work_ids,
                           };
    kPrintLog(dict);
    __weak typeof(self)weakf = self;
    HHttpRequest *request = [[HHttpRequest alloc] init];
    [request httpGetRequestWithActionName:@"getguanlian" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask *operation, id responseObject) {
        [self.hudLoading hideAnimated:YES];
        ResultModel *result=[ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    } andDidRequestSuccessBlock:^(NSURLSessionTask *operation, id responseObject) {
        __strong typeof(weakf)strongSelf = weakf;
        kPrintLog(responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]){
            [strongSelf.guanLianWorksArr removeAllObjects];
            [strongSelf.guanLianWorksArr addObjectsFromArray:responseObject];
            [strongSelf.tabView reloadData];
        }
        
    } andDidRequestFailedBlock:^(NSURLSessionTask *operation, NSError *error) {
        __strong typeof(weakf)strongSelf = weakf;
        [strongSelf.guanLianWorksArr removeAllObjects];
        [strongSelf.tabView reloadData];
    }];
    
}



- (void)changeHeight:(NSNotification *)notify
{
    NSNumber *height = notify.object;
    [self.tabView beginUpdates];
    _height = [height floatValue];
    [self.tabView endUpdates];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section==5) {
        if (row>0) {
             if (_guanLianWorksArr.count>0) {
            AnyWorkListCell* cell = (AnyWorkListCell*)[tableView cellForRowAtIndexPath:indexPath];
            [self enterDetailWithDict:cell.model.mj_keyValues];
             }
        }
        
    }else if(section==6) {
        if (row>0) {
             if (_guanLianArr.count>0) {
            ListRecordCell* cell = (ListRecordCell*)[tableView cellForRowAtIndexPath:indexPath];
            [self enterDetailWithDict:cell.recordkDic];
             }
        }
    }
    
}
#pragma - mark - 进详情
-(void)enterDetailWithDict:(NSDictionary*)dic{
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",dic[@"id"]];
    detailVC.topictype = [NSString stringWithFormat:@"%@",dic[@"topictype"]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)buyBtnClick:(UIButton *)btn{
    if (![self isNavLogin]) {
        return;
    }
    if(btn.tag == 99){
        
        YTXOrderConfirmViewController *order = [[YTXOrderConfirmViewController alloc] init];
        order.goodsModel = self.goodsModel;
        [self.navigationController pushViewController:order animated:YES];
        return;
//        PayNewVC *vc=[[PayNewVC alloc]init];
//        vc.money=self.goodsModel.sellprice;
//        vc.uID=self.goodsModel.gid;
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (btn.tag == 88){
        if ([_detailPayBtn.titleLabel.text isEqualToString:@"购买"]) {
            PayNewVC *vc=[[PayNewVC alloc]init];
            vc.money=self.goodsModel.sellprice;
            vc.uID=self.goodsModel.gid;
            [self.navigationController pushViewController:vc animated:YES];
        }else{//洽购
            SiXinVC *VC = [[SiXinVC alloc] init];
//            VC.cID = self.topicModel.user.uid;
            VC.cID = @"3";
            VC.navTitle =[NSString stringWithFormat:@"%@私信",userModel.nickname];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }else if (btn.tag == 77){
        if (_qiatanBtn.hidden == NO){
            SiXinVC *VC = [[SiXinVC alloc] init];
//            VC.cID = self.topicModel.user.uid;
            VC.cID = @"3";
            VC.navTitle =[NSString stringWithFormat:@"%@私信",userModel.nickname];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tabView.contentSize.height > self.tabView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tabView.contentSize.height - self.tabView.frame.size.height);
        [self.tabView setContentOffset:offset animated:animated];
    }
}
-(void)btnEdit_Click{
    
    
    OSMessage* msg = [[OSMessage alloc] init];
    NSInteger toptc = [model.topictype integerValue];
    switch (toptc) {
        case 1:
        {
            NSString* strCangpinResult = @"";
            
            switch (model.status.intValue) {
                case 1: {
                    strCangpinResult = @"真";
                } break;
                case 2: {
                    strCangpinResult = @"假";
                } break;
                case 3: {
                    strCangpinResult = @"无法鉴定";
                } break;
                case 4: {
                    strCangpinResult = @"未鉴定";
                } break;
                default:
                    break;
            }
            
            msg.title = [NSString stringWithFormat:@"%@ | %@ | %@", model.topictitle, model.message, strCangpinResult];
        }
            break;
        case 2:
        {
            msg.title = [NSString stringWithFormat:@"%@ ",model.message];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 4:
        {
            msg.title = [NSString stringWithFormat:@"%@ | %@ ",model.gtype,model.topictitle];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 6:
        {
            NSString*string =model.alt;
            string = [string substringFromIndex:7];
            msg.title = [NSString stringWithFormat:@"%@ | %@ | %@",model.topictitle,model.age,model.zuopinGuigeText];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 7:
        {
            msg.title = [NSString stringWithFormat:@"%@",
                         model.message];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 8:
        {
            
            msg.title = [NSString stringWithFormat:@"%@ | %@ | %@ | %@ ",
                         model.topictitle,model.starttime,model.city,model.address];
            if (model.photoscbk.count > 0){
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 9:
        {
            
            msg.title = [NSString stringWithFormat:@"%@ | 作者: %@ ",
                         model.topictitle,model.peopleUserName];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
            
        case 12:
        {
            msg.title = [NSString stringWithFormat:@"%@ ",
                         model.message];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 13:
        {
            msg.title = [NSString stringWithFormat:@"%@",
                         model.message];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 14:
        {
            
            
            msg.title = [NSString stringWithFormat:@"%@ | %@ | %@ | 获奖作品：%@ ",model.age,model.topictitle,model.award,model.message];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 15:
        {
            
            
            msg.title = [NSString stringWithFormat:@"时间：%@ | 机构：%@ | 作品：%@ ",model.age,model.source,model.message];
            
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 17:
        {
            
            msg.title = [NSString stringWithFormat:@"%@ | %@ ",
                         model.source,model.topictitle];
            if (model.photoscbk.count > 0) {
                photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
            }
        }
            break;
        case 18:
        {
            msg.title = [NSString stringWithFormat:@"%@ | %@ | %@ ",
                         model.age,model.topictitle,model.message];
        }
            break;
            
    }
    [Global sharedInstance].shareId=model.user.uid;
    HShareVC *shareVc = [[HShareVC alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    shareVc.msg = msg;
    if (model.photoscbk.count > 0) {
        photoscbkModel *photoscbkModel = [model.photoscbk objectOrNilAtIndex:0];
        msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
        shareVc.shareimage= [UIImage imageWithData:msg.image];
    }else
    {
        shareVc.shareimage=[UIImage imageNamed:@"icon_share12"];
    }
    shareVc.sharetitle=msg.title;
    shareVc.sharedes=msg.desc;
    shareVc.shareurl=model.alt;
    shareVc.msg = msg;
    
    shareVc.deleteEdit = YES;
    shareVc.userID = model.user.uid;
    [shareVc showShareView];

    [shareVc setSelectJubaoCilck:^{
        //举报功能
        NSLog(@"举报");
        [self jubao];
    }];
    [shareVc setSelectShoucangCilck:^{
        //收藏功能
        NSLog(@"收藏");
        [self shoucang];
    }];
    [shareVc setSelectShanchuCilck:^{
        //删除功能
        NSLog(@"删除");
        [self deleteDongtai];
    }];
    [shareVc setSelectDingzhiCilck:^{
        //删除功能
        NSLog(@"置顶");
        [self dongtaizhiding];
    }];
    [shareVc setSelectEditClick:^{
        NSLog(@"编辑");
        NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
        
        NSMutableArray *imageList = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrayYuanlai.count; i ++) {
            UIImageView *imageView = [shareViewImage viewWithTag:i+100];
            [imageList addObject:imageView.image];
        }
        
        PublishDongtaiVC *vc = [[PublishDongtaiVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isEdit = YES;
        vc.topicid = model.id;
        vc.selectedType = model.arttype;
        if (model.topictype.integerValue==8) {
            vc.age = model.starttime;
        }else
        {
            vc.age = model.age;
        }
        if (model.topictype.integerValue==4) {
            vc.selectedType = model.gtypename;
            vc.selectTypeId = model.gtype;
        }else
        {
            vc.selectedType = model.arttype;
        }
        vc.longstr = model.longstr;
        vc.width = model.width;
        vc.height = model.height;
        vc.format = model.caizhi;
        vc.source = model.sourceUserName;
        vc.message = model.message;
        vc.city = model.city;
        vc.name = model.topictitle;
        vc.planner = model.planner;
        vc.address = model.address;
        vc.award = model.award;
        vc.people = model.peopleUserName;
        vc.topictype = model.topictype;
        vc.kucun = model.kucun;
        vc.yunfei = model.yunfei;
        vc.price = [NSString stringWithFormat:@"%.2f",[model.sellprice floatValue]/100];
        vc.huiyuan = model.huiyuan;
        if ([model.video stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            vc.videoArray = [model.video componentsSeparatedByString:@","];
        }
        vc.selectedImageList = imageList;
        vc.arrayRecorderSave = [ArtUIHelper stringToJSON:model.audio].mutableCopy;
        vc.photos = [model.photos componentsSeparatedByString:@","].mutableCopy;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
//举报
- (void)jubao
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"请输入举报内容" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    [dialog show];
}
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        return;
    }
    UITextField* nameField = [alertView textFieldAtIndex:0];
    
    if (nameField.text.length < 1) {
        [(BaseController*)self showErrorHUDWithTitle:@"举报内容不能为空" SubTitle:nil Complete:nil];
        return;
    }
    if (![(BaseController*)self.view.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.view.containingViewController;
    [superView showLoadingHUDWithTitle:@"正在举报" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"tid" : model.id,
                            @"reason" : nameField.text ?: @"" };
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"denounce" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [superView.hudLoading hideAnimated:YES];
                     [superView showOkHUDWithTitle:@"举报成功" SubTitle:nil Complete:nil];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hideAnimated:YES];
                  }];
}

//删除动态
- (void)deleteDongtai
{
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"删除中" SubTitle:nil];
    NSString* userId=@"";
    if ([Global sharedInstance].userID.length>0) {
        userId = [Global sharedInstance].userID;
    }
    NSDictionary* dict = @{ @"uid" : userId,
                            @"topicid" : model.id };
    kPrintLog(dict);
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"deltopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        kPrintLog(responseObject);
        [self.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     kPrintLog(responseObject);
                     [self.hudLoading hideAnimated:YES];
                     if ([self respondsToSelector:@selector(loadData)]){
                        [self loadData];
                     }else{
                         //[self.delate deleteBtnClick];
                     }
                 }andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                     kPrintLog(error);
                     [self.hudLoading hideAnimated:YES];
              }];
}

- (void)dongtaizhiding
{
    kPrintLog(@"置顶");
    //1.设置请求参数
    [self showLoadingHUDWithTitle:@"置顶中" SubTitle:nil];
    NSString *userId = @"";
    if ([Global sharedInstance].userID.length>0) {
        userId = [Global sharedInstance].userID;
    }
    NSDictionary* dict = @{ @"uid" : userId,
                            @"id" : model.id };
    kPrintLog(dict);
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"addtop" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        kPrintLog(responseObject);
        [self.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [self showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     kPrintLog(responseObject);
                     [self.hudLoading hideAnimated:YES];
                     if ([self respondsToSelector:@selector(loadData)]){
                         [self loadData];
                     }else{
                         //[self.delate deleteBtnClick];
                     }
                 }andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                     kPrintLog(error);
                     [self.hudLoading hideAnimated:YES];
                 }];
}

- (void)shoucang
{
    if (![(BaseController*)self.view.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.view.containingViewController;
    [superView showLoadingHUDWithTitle:@"正在收藏" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"topicid" : model.id };
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"collecttopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [superView.hudLoading hideAnimated:YES];
                     [superView showOkHUDWithTitle:@"收藏成功" SubTitle:nil Complete:nil];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hideAnimated:YES];
                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    // Dispose of any resources that can be recreated.
}


@end
