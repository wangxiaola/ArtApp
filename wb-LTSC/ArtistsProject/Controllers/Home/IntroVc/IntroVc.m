//
//  IntroVc.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.

#import "IntroVc.h"
#import "IntroAudioCell.h"
#import "IntroImageCell.h"
#import "IntroVideoCell.h"
#import "IntroDescribe.h"
#import "IntroHeadCell.h"
#import "IntroListCell.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "SiXinVC.h"
#import "IntroListVc.h"
#import "PlayerViewController.h"

#define SECTION_NUMS 10
#define SECTION_FIRST 0//audio
#define SECTION_SECOND 1//
#define SECTION_THREED 2//
#define SECTION_FOURTH 3//
#define SECTION_TIFTH 4//
#define SECTION_SIXTH 5
#define SECTION_SEVENTH 6
#define SECTION_EIGHTH 7
#define SECTION_NINTH 8
#define SECTION_TENTH 9
#define SECTION_ELEVEN 10



#define HEAD_CELL_HEIGHT (SCREEN_WIDTH/2)

@interface IntroVc ()
{
    //关注 私信
    UIButton *attentionView,*PrivateBtn;
    IntroDescribe* _descibeCell;
    CGFloat _listCellHeight;
    UserInfoModel *userModel;
}

@property(nonatomic,copy)NSString* yearStr;
@property(nonatomic,strong)UIImageView* headView;
@property(nonatomic,strong)UIImageView* iconViw;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* addLabel;
@property(nonatomic,strong)NSMutableDictionary* introDic;
@property(nonatomic,strong)NSMutableArray* arrayPlayer;//保存视频id
@property(nonatomic,strong)NSMutableArray* arrayVideoImage;//保存视频背景图片
@property(nonatomic,strong)NSArray* classifyArr;
@end

@implementation IntroVc
-(void)createView{
    
    [super createView];
    _introDic = [[NSMutableDictionary alloc]init];
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.tableHeaderView = self.headView;
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _arrayPlayer = [[NSMutableArray alloc]init];
    _arrayVideoImage = [[NSMutableArray alloc]init];
}

-(void)loadData{
    
    NSDictionary * dict = @{@"uid":self.artId?self.artId:[[Global sharedInstance] getBundleID],
                            @"cuid":[Global sharedInstance].userID?[Global sharedInstance].userID:@"0"
                            };
    [self showLoadingHUDWithTitle:@"加载中" SubTitle:nil];
    __weak typeof(self)weakSelf = self;
    
    [ArtRequest GetRequestWithActionName:@"jianjieindex" andPramater:dict succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        [self.hudLoading hideAnimated:YES];
        [self loadUserData];
        //个人简介
        weakSelf.model=[UserInfoModel mj_objectWithKeyValues:responseObject[@"grjj"]];
        [_introDic addEntriesFromDictionary:responseObject];
        [self.tabView reloadData];
        [weakSelf loadUserInfo:responseObject[@"grjj"]];
        
    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.hudLoading hideAnimated:YES];
        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
        
    }];
}

#pragma mark --个人信息
-(void)loadUserInfo:(NSDictionary*)dic{
    _nameLabel.text = dic[@"nickname"];
    _addLabel.text = dic[@"location"];
    CGSize addSize = [_addLabel sizeThatFits:CGSizeMake(100, 20)];
    _addLabel.frame =  CGRectMake(_headView.bounds.size.width/2-(addSize.width +    T_WIDTH(40))/2, getViewHeight(_nameLabel)+T_WIDTH(9), addSize.width +T_WIDTH(40),T_WIDTH(20));
    _headView.hidden = NO;
    //头像
    [_iconViw sd_setImageWithUrlStr:dic[@"avatar"] tempTmage:@"temp_Default_headProtrait"];
    //    //视频
    NSString *strVideo=dic[@"video"];
    if (strVideo.length>2) {
        NSMutableArray *arrayVideo=[[strVideo  componentsSeparatedByString:@","] mutableCopy];
        for (NSString *strPic in arrayVideo) {
            if (strPic.length<2) {
                [arrayVideo removeObject:strPic];
            }
        }
        [_arrayVideoImage removeAllObjects];
        [_arrayPlayer removeAllObjects];
        [self getImage:arrayVideo withNumber:0];
    }
}
//视频
- (void)getImage:(NSMutableArray *)arrayVideo withNumber:(int)iNumber{
    //1.设置请求参数
    NSString *strVideoID=[self getVideoIDWithVideoUrl:arrayVideo[iNumber]];
    if (strVideoID.length<1) {
        return ;
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTION_NUMS;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==SECTION_FIRST){//语音
        if (![ArtUIHelper ischaracterString:_introDic[@"audio"]]) {
            NSArray* audio = _introDic[@"audio"];
            return audio.count>0?audio.count:0;
        }
        return 0;
    }else if(section==SECTION_SECOND){
        
        if (_arrayVideoImage.count>0){
            return 1;
        }
        return 0;
    }else if (section==SECTION_THREED){//photo
        NSDictionary* usrDic = _introDic[@"grjj"];
        if (![ArtUIHelper ischaracterString:usrDic[@"photo"]]) {
            NSArray* photoArr = usrDic[@"photo"];
            
            return photoArr.count>0?1:0;
        }
        return 0;
        
    }else if (section==SECTION_FOURTH){
        NSDictionary* usrDic = _introDic[@"grjj"];
        
        if (usrDic[@"intro"]) {
            return 1;
        }
    }else if (section>SECTION_FOURTH&&section<SECTION_ELEVEN){
        NSString* keyStr = self.classifyArr[section-SECTION_TIFTH][@"keyStr"];
        NSArray* arr = _introDic[keyStr][@"info"];
        if(arr.count>0&&arr.count<6){
            return arr.count+1;
        }else if(arr.count>6){
            return 7;
        }else{
            return 0;
        }
        
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==SECTION_FIRST) {
        return   T_WIDTH(60);
    }else if (indexPath.section==SECTION_SECOND){
        return T_WIDTH(87);
    }else if (indexPath.section==SECTION_THREED){
        return T_WIDTH(87);
    }else if (indexPath.section==SECTION_FOURTH){
        
        NSDictionary* usrDic = _introDic[@"grjj"];
        NSString* contentStr = [NSString stringWithFormat:@"%@",usrDic[@"intro"]];
        if (_descibeCell) {
            return [_descibeCell heightWithContent:contentStr];
        }
        
    }else if (indexPath.section>SECTION_FOURTH&&indexPath.section<SECTION_ELEVEN){//艺术年表
        if (indexPath.row==0) {
            return HEAD_CELL_HEIGHT;
        }else if(indexPath.row>0&&indexPath.row<6){
            return _listCellHeight>0?_listCellHeight:1;
        }else{
            return 40;
        }
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==SECTION_FIRST) {
        IntroAudioCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroAudioCell"];
        if (cell==nil) {
            cell = [[IntroAudioCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroAudioCell"];
        }
        
        [cell setArtTableViewCellDicValue:nil];
        
        return cell;
    }else if (indexPath.section==SECTION_SECOND){
        IntroVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroVideoCell"];
        if (cell==nil) {
            cell = [[IntroVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroVideoCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(87))];
            cell.selectImgCilck = ^(NSInteger index){
                // 播放视频
                PlayerViewController *vc=[[PlayerViewController alloc]init];
                vc.videoID=_arrayPlayer[index];
                kPrintLog(_arrayPlayer[indexPath.row]);
                [self.obj.navigationController pushViewController:vc animated:YES];
//                [ArtUIHelper addHUDInView:self.view text:@"暂未开通" hideAfterDelay:1.0];
            };
        }
        if (_arrayVideoImage.count>0) {
            [cell setArtTableViewCellArrValue:_arrayVideoImage];
        }
        
        return cell;
    }else if (indexPath.section==SECTION_THREED){
        IntroImageCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroImageCell"];
        if (cell==nil) {
            cell = [[IntroImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroImageCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, T_WIDTH(87))];
            __weak typeof(self) weakSelf = self;
            cell.selectImgCilck = ^(NSArray* arr,UIImageView* imgView){
                NSMutableArray *photos = [[NSMutableArray alloc]init];
                for (NSDictionary* photoDic in arr) {
                    [photos addObject:photoDic[@"photo"]];
                }
                NSArray *photosURL = [IDMPhoto photosWithURLs:photos];
                IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photosURL animatedFromView:imgView];
                browser.dismissOnTouch = YES;
                browser.displayArrowButton = NO;
                browser.displayActionButton = NO;
                browser.displayDoneButton = NO;
                browser.autoHideInterface = NO;
                browser.displayCounterLabel     = YES;
                browser.useWhiteBackgroundColor = NO;
                browser.usePopAnimation=YES;
                browser.scaleImage=imgView.image;
                browser.trackTintColor  = [UIColor colorWithWhite:0.8 alpha:1];
                [browser setInitialPageIndex:imgView.tag];
                [weakSelf.obj presentViewController:browser animated:YES completion:nil];
            };
        }
        NSDictionary* usrDic = _introDic[@"grjj"];
        NSArray* photoArr = usrDic[@"photo"];
        [cell setArtTableViewCellArrValue:photoArr];
        return cell;
    }else if (indexPath.section==SECTION_FOURTH){
        IntroDescribe* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroDescribe"];
        if (cell==nil) {
            cell = [[IntroDescribe alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroDescribe" frame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        }
        _descibeCell = cell;
        return cell;
    }else if (indexPath.section>SECTION_FOURTH&&indexPath.section<SECTION_ELEVEN){//艺术年表
        if (indexPath.row==0) {
            IntroHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IntroHeadCell"];
            if (cell==nil) {
                cell = [[IntroHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroHeadCell" frame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_CELL_HEIGHT)];
            }
            NSString* keyStr = self.classifyArr[indexPath.section-SECTION_TIFTH][@"keyStr"];
            NSString* titleStr = self.classifyArr[indexPath.section-SECTION_TIFTH][@"title"];
            NSString* subtitle = self.classifyArr[indexPath.section-SECTION_TIFTH][@"subtitle"];
            
            NSDictionary* dic = _introDic[keyStr];
            if (dic.count>0) {
                [cell setArtTableViewHeadCellDicValue:dic andTitle:titleStr subTitle:subtitle];
            }
            return cell;
        }else if (indexPath.row>0&&indexPath.row<6){
            IntroListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IntroListCell"];
            if (cell==nil) {
                cell = [[IntroListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IntroListCell"];
            }
            
            __weak typeof(self)weakSelf = self;
            cell.baseViews = weakSelf.view;
            
            cell.yearBlock = ^(NSString* str){
                self.yearStr = str;
            };
            NSString* keyStr = self.classifyArr[indexPath.section-SECTION_TIFTH][@"keyStr"];
            NSArray* arr = _introDic[keyStr][@"info"];
            if (arr.count>0) {
              _listCellHeight = [cell setIntroListCellDicValue:arr[indexPath.row-1] yearStr:self.yearStr];
            }

            
            return cell;
        }else{//查看全部
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (cell==nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
            }
            cell.textLabel.text = @"查看全部";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
        
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section>SECTION_FOURTH&&indexPath.section<SECTION_ELEVEN){
        
        if (indexPath.row>0&&indexPath.row<6){//进详情
            NSString* keyStr = self.classifyArr[indexPath.section-SECTION_TIFTH][@"keyStr"];
            NSArray* arr = _introDic[keyStr][@"info"];
            
            NSDictionary* dic = arr[indexPath.row-1];
            HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
            detailVC.topicid = [NSString stringWithFormat:@"%@",dic[@"id"]];
            detailVC.topictype = [NSString stringWithFormat:@"%@",dic[@"topictype"]];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.obj.navigationController pushViewController:detailVC animated:YES];
            
        }else{//进列表
            
            NSDictionary* dic = self.classifyArr[indexPath.section-SECTION_TIFTH];
            NSString* titleStr = dic[@"title"];
            NSString* subtitle = dic[@"subtitle"];
            
            IntroListVc* listVc = [[IntroListVc alloc] init];
            listVc.artId = self.artId;
            listVc.isOpenHeaderRefresh = YES;
            listVc.isOpenFooterRefresh = YES;
            listVc.topictypeStr =dic[@"topictype"];
            //listVc.albumidStr = [NSString stringWithFormat:@"%@",dic[@"id"]];
            listVc.navTitle = [NSString stringWithFormat:@"%@%@",titleStr,subtitle];
            listVc.hidesBottomBarWhenPushed = YES;
            [self.view.containingViewController.navigationController pushViewController:listVc animated:YES];
            
        }
    }
}
-(UIImageView*)headView{
    if (_headView==nil) {
        _headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,T_WIDTH(250))];
        _headView.hidden = YES;
        _headView.userInteractionEnabled = YES;
        _iconViw = [[UIImageView alloc]initWithFrame:CGRectMake(_headView.bounds.size.width/2-T_WIDTH(50),T_WIDTH(30), T_WIDTH(100),T_WIDTH(100))];
        //_iconViw.layer.borderWidth = 10;
        //_iconViw.layer.borderColor = [[UIColor redColor] CGColor];
        _iconViw.layer.cornerRadius = T_WIDTH(50);
        _iconViw.layer.masksToBounds = YES;
        [_headView addSubview:_iconViw];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headView.bounds.size.width/2-T_WIDTH(50), getViewHeight(_iconViw)+T_WIDTH(15), T_WIDTH(100),T_WIDTH(20))];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = ART_FONT(ARTFONT_OE);
        [_headView addSubview:_nameLabel];
        
        _addLabel = [[UILabel alloc]initWithFrame:CGRectMake(_headView.bounds.size.width/2-T_WIDTH(100), getViewHeight(_nameLabel)+T_WIDTH(9), T_WIDTH(200),T_WIDTH(20))];
        _addLabel.textAlignment = NSTextAlignmentCenter;
        _addLabel.font = ART_FONT(ARTFONT_OT);
        [_headView addSubview:_addLabel];
        UIImageView* addImg = [[UIImageView alloc]init];
        addImg.image = [UIImage imageNamed:@"address"];
        [_addLabel addSubview:addImg];
        [addImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(T_WIDTH(10));
            make.centerY.equalTo(_addLabel);
            make.height.mas_equalTo(KKWidth(28));
            make.width.mas_equalTo(KKWidth(18));
            
        }];
        
        attentionView = [UIButton buttonWithType:UIButtonTypeCustom];
        [attentionView setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
        [attentionView setImage:[UIImage imageNamed:@"haveattention"] forState:UIControlStateSelected];
        [attentionView addTarget:self action:@selector(addGuanzhu) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:attentionView];
        [attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addLabel.mas_bottom).offset(15);
            make.right.equalTo(_headView).offset(-kScreenW/2-7);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(25);
        }];
        
        PrivateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [PrivateBtn setImage:[UIImage imageNamed:@"PrivateBtn"] forState:UIControlStateNormal];
        [PrivateBtn addTarget:self action:@selector(PrivateClick) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:PrivateBtn];
        [PrivateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_addLabel.mas_bottom).offset(15);
            make.left.equalTo(_headView).offset(kScreenW/2+7);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(25);
        }];
    }
    return _headView;
}
- (void)imgVideo_Click:(UITapGestureRecognizer *)tapClick{
    
        // 播放视频
        PlayerViewController *vc=[[PlayerViewController alloc]init];
        vc.videoID=_arrayPlayer[tapClick.view.tag];
        [self.navigationController pushViewController:vc animated:YES];
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

-(void)PrivateClick
{
    if (![(BaseController*)self.view.containingViewController isNavLogin]) {
        return;
    }
    SiXinVC* vc = [[SiXinVC alloc] init];
//    vc.cID = self.model.uid;
    vc.cID = @"3";
    vc.navTitle =[NSString stringWithFormat:@"%@私信",userModel.nickname];
    vc.hidesBottomBarWhenPushed = YES;
    [self.view.containingViewController.navigationController pushViewController:vc animated:YES];
}

//添加关注
- (void)addGuanzhu{
    if (![(BaseController*)self.view.containingViewController isNavLogin]) {
        return;
    }
    if (!attentionView.selected){
        //NSLog(@"关注");
        NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                                @"tuid" : self.model.uid };
        [ArtRequest PostRequestWithActionName:@"addaction" andPramater:dict succeeded:^(id responseObject){
            if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"关注" obj:responseObject]) {
                attentionView.selected = YES;
                
            }else{
                NSString* msg = responseObject[@"msg"];
                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [(BaseController*)self.view.containingViewController logonAgain];
                }
            }
            
            
        } failed:^(id responseObject) {
            
        }];
        
    }else{
        //NSLog(@"取消关注");
        NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                                @"tuid" : self.model.uid };
        
        [ArtRequest PostRequestWithActionName:@"delaction" andPramater:dict succeeded:^(id responseObject){
            if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"取消关注" obj:responseObject]) {
                attentionView.selected = NO;
                
            }else{
                NSString* msg = responseObject[@"msg"];
                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [(BaseController*)self.view.containingViewController logonAgain];
                }
            }
            
            
        } failed:^(id responseObject) {
            
        }];
        
    }
    
}

-(NSArray*)classifyArr{
    if (_classifyArr==nil) {
        _classifyArr = @[@{
                             @"keyStr" : @"zljl",
                             @"title" : @"重要展览",
                             @"subtitle":@"Exhibition",
                             @"topictype":@"8"
                             },
                         
                         @{
                             @"keyStr" : @"ysnb",
                             @"title" : @"艺术年表",
                             @"subtitle":@"Chronology",
                             @"topictype":@"13"
                             },
                    
                         @{
                             @"keyStr" : @"ryjx",
                             @"title" : @"荣誉奖项",
                             @"subtitle":@"Won the award",
                             @"topictype":@"14"
                             },
                         @{
                             @"keyStr" : @"cjgz",
                             @"title" : @"收藏拍卖",
                             @"subtitle":@"Important collectors",
                             @"topictype":@"15"
                             },
                         @{
                             @"keyStr" : @"gyjz",
                             @"title" : @"公益捐赠",
                             @"subtitle":@"Charitable Donations",
                             @"topictype":@"16"
                             },
                         @{
                             @"keyStr" : @"cbzz",
                             @"title" : @"出版刊登",
                             @"subtitle":@"Publication Book",
                             @"topictype":@"18"
                             }
                         
                         ];
        
    }
    return  _classifyArr;
}

@end
