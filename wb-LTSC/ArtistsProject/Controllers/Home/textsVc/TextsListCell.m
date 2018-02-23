//
//  WorksFirstCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "TextsListCell.h"
#import "TextsListVc.h"
#import "HomeListDetailVc.h"
#import "MyHomePageDockerVC.h"

@interface TextsListCell ()
{
    BOOL _isHaveSize;
    UIButton *btnZan;
    HButton* btnMore;
    CangyouQuanDetailModel* model;
    HView* shareViewImage;
}
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;
@property(nonatomic,strong)UILabel * zanLabel;
@property(nonatomic,strong)UILabel * numsLabel;
@property(nonatomic,strong)UILabel * seeNums;
@property(nonatomic,strong)NSMutableDictionary* recentCellDic;
@end

@implementation TextsListCell

-(void)addContentViews{
    _recentCellDic = [[NSMutableDictionary alloc]init];
    _baseImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-T_WIDTH(75), T_WIDTH(15), T_WIDTH(60), T_WIDTH(60))];
    _baseImage.userInteractionEnabled = YES;
    _baseImage.layer.cornerRadius = T_WIDTH(30);
    _baseImage.layer.masksToBounds = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_baseImage addGestureRecognizer:tap];
    [self.contentView addSubview:_baseImage];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(T_WIDTH(15), T_WIDTH(15),SCREEN_WIDTH - T_WIDTH(100),T_WIDTH(20))];
    //_titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = ART_FONT(ARTFONT_OE);
    [self.contentView addSubview:_titleLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(T_WIDTH(15), getViewHeight(_titleLabel)+T_WIDTH(7),SCREEN_WIDTH - T_WIDTH(100),T_WIDTH(40))];
    _subLabel.numberOfLines = 0;
    //_subLabel.textColor = [UIColor whiteColor];
    _subLabel.textAlignment = NSTextAlignmentLeft;
    _subLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_subLabel];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(T_WIDTH(15), getViewHeight(_subLabel)+T_WIDTH(0),SCREEN_WIDTH-T_WIDTH(30),0)];
    line.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:line];
    
    //赞
    btnZan = [[UIButton alloc]init];
    btnZan.frame = CGRectMake(T_WIDTH(15), getViewHeight(line)+T_WIDTH(0), T_WIDTH(20),T_WIDTH(20));
    [btnZan addTarget:self action:@selector(btnZan_CLick) forControlEvents:UIControlEventTouchUpInside];
    [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_zan"] forState:UIControlStateNormal];
    [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_Azan"] forState:UIControlStateSelected];
    [self.contentView addSubview:btnZan];
    
    _zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(getViewWidth(btnZan)+ T_WIDTH(10), getViewHeight(line)+T_WIDTH(0), T_WIDTH(30),T_WIDTH(20))];
    //_zanLabel.textColor = [UIColor whiteColor];
    _zanLabel.textAlignment = NSTextAlignmentLeft;
    _zanLabel.font = ART_FONT(ARTFONT_OZ);
    [self.contentView addSubview:_zanLabel];
    
    //评论
    UIButton *btnComment = [[UIButton alloc]init];
    btnComment.frame = CGRectMake(getViewWidth(_zanLabel)+T_WIDTH(10), getViewHeight(line)+T_WIDTH(0), T_WIDTH(20),T_WIDTH(20));
    [btnComment setImage:[UIImage imageNamed:@"icon_cangyou_comment"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(btnCommit_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnComment];
    
    _numsLabel = [[UILabel alloc]initWithFrame:CGRectMake(getViewWidth(btnComment)+T_WIDTH(10), getViewHeight(line)+T_WIDTH(0), T_WIDTH(60),T_WIDTH(20))];
    //_numsLabel.textColor = [UIColor whiteColor];
    _numsLabel.textAlignment = NSTextAlignmentLeft;
    _numsLabel.font = ART_FONT(ARTFONT_OZ);
    [self.contentView addSubview:_numsLabel];

    _seeNums = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-T_WIDTH(75), getViewHeight(_baseImage)+T_WIDTH(5), T_WIDTH(60),T_WIDTH(20))];
    //_seeNums.textColor = [UIColor whiteColor];
    _seeNums.textAlignment = NSTextAlignmentCenter;
    _seeNums.font = ART_FONT(ARTFONT_OF);
    [self.contentView addSubview:_seeNums];
    
    btnMore = [[HButton alloc] init];
    btnMore.frame = CGRectMake(getViewWidth(_numsLabel)+T_WIDTH(40), getViewHeight(line)+T_WIDTH(0), T_WIDTH(20),T_WIDTH(20));
    [btnMore setImage:[UIImage imageNamed:@"homeMore"] forState:UIControlStateNormal];
    [btnMore addTarget:self action:@selector(btnEdit_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnMore];
    
    //自定义线条
    UIImageView *line1=[[UIImageView alloc]init];
    line1.backgroundColor=Art_LineColor;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(T_WIDTH(15));
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.mas_top).offset(0);
    }];
    
    shareViewImage = [[HView alloc] init];
    shareViewImage.hidden = YES;
    shareViewImage.backgroundColor = kClearColor;
    [self.contentView addSubview:shareViewImage];
    [shareViewImage mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    [_recentCellDic removeAllObjects];
    [_recentCellDic addEntriesFromDictionary:dic];
    model = [CangyouQuanDetailModel mj_objectWithKeyValues:dic];
    _titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"topictitle"]];
    _subLabel.text = dic[@"message"];
    id obj = dic[@"people"];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        _seeNums.hidden = NO;
        _baseImage.hidden = NO;
        [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!120a",dic[@"people"][@"avatar"]] tempTmage:@"temp_Default_headProtrait"];
        _seeNums.text = dic[@"people"][@"username"];
    }else{
        _seeNums.hidden = YES;
        _baseImage.hidden = YES;
    }
    
   _zanLabel.text = [NSString stringWithFormat:@"%@",dic[@"likenum"]];
   _numsLabel.text = [NSString stringWithFormat:@"%@",dic[@"commentnum"]];
    
    NSString* isLike = [NSString stringWithFormat:@"%@",dic[@"isLiked"]];
    if ([isLike isEqualToString:@"0"]) {
        btnZan.selected = NO;
    }else{
        btnZan.selected = YES;
    }
    
    NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        for (int i=0; i<arrayYuanlai.count; i++) {
            UIImageView* img = [shareViewImage viewWithTag:100+i];
            [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",arrayYuanlai[i]] tempTmage:@"icon_Default_Product.png"];
        }
    }
}

//赞点击事件
- (void)btnZan_CLick
{
    if (self.baseViews) {
        if (![(BaseController*)self.baseViews.containingViewController isNavLogin]) {
            return;
        }
    }else{
        if (![(BaseController*)self.containingViewController isNavLogin]) {
            return;
        }
        
//        if (self.isLogonClick){
//            if (!self.isLogonClick()) {
//                return;
//            }
//        }
    }
    
    if (!btnZan.selected){
        //NSLog(@"赞");
        [self Zan];
    }else{
        //NSLog(@"取消赞");
        [self cancelZan];
    }
}
////赞
- (void)Zan
{
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    
    NSString* topicidStr = [NSString stringWithFormat:@"%@",_recentCellDic[@"id"]];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID,
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"liketopic" andPramater:dict succeeded:^(id responseObject){
        
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"点赞" obj:responseObject]) {
            btnZan.selected = YES;
            NSInteger inter = [_zanLabel.text integerValue];
            _zanLabel.text = [NSString stringWithFormat:@"%ld",++inter];
        }else{
            NSString* msg = responseObject[@"msg"];
           if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                if (self.baseViews) {
                    [(BaseController*)self.baseViews.containingViewController logonAgain];
                }else{
                   [(BaseController*)self.containingViewController logonAgain];
                }
                
            }
        }
        
    } failed:^(id responseObject) {
        [superView.hudLoading hideAnimated:YES];
    }];
}

//取消点赞
- (void)cancelZan
{
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    
    NSString* topicidStr = [NSString stringWithFormat:@"%@",_recentCellDic[@"id"]];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID,
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"delliketopic" andPramater:dict succeeded:^(id responseObject){
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"取消赞" obj:responseObject]) {
            btnZan.selected = NO;
            NSInteger inter = [_zanLabel.text integerValue];
            _zanLabel.text = [NSString stringWithFormat:@"%ld",--inter];
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                if (self.baseViews) {
                    [(BaseController*)self.baseViews.containingViewController logonAgain];
                }else{
                    [(BaseController*)self.containingViewController logonAgain];
                }

            }
        }
        
    } failed:^(id responseObject) {
        [superView.hudLoading hideAnimated:YES];
    }];
}
//评论事件
-(void)btnCommit_Click{
    BaseController* superView = nil;
    if (self.baseViews){
        superView = (BaseController*)self.baseViews.containingViewController;
    }else{
        superView = (BaseController*)self.containingViewController;
    }
    if (![superView isNavLogin]) {
        return;
    }
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",_recentCellDic[@"id"]];
    detailVC.topictype = [NSString stringWithFormat:@"%@",_recentCellDic[@"topictype"]];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.isScrollToBottom = YES;
    [superView.navigationController pushViewController:detailVC animated:YES];
}
-(void)tapClick{
    NSDictionary* dic = _recentCellDic[@"people"];
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = dic[@"username"];
    vc.artId = dic[@"uid"];
    BaseController* superView = nil;
    if (self.baseViews){
        superView = (BaseController*)self.baseViews.containingViewController;
    }else{
        superView = (BaseController*)self.containingViewController;
    }

    [superView.navigationController pushViewController:vc animated:YES];
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
        if ([model.video stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            vc.videoArray = [model.video componentsSeparatedByString:@","];
        }
        vc.selectedImageList = imageList;
        vc.arrayRecorderSave = [ArtUIHelper stringToJSON:model.audio].mutableCopy;
        vc.photos = [model.photos componentsSeparatedByString:@","].mutableCopy;
        [self.baseViews.containingViewController.navigationController pushViewController:vc animated:YES];
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
        [(BaseController*)self.containingViewController showErrorHUDWithTitle:@"举报内容不能为空" SubTitle:nil Complete:nil];
        return;
    }
    if (![(BaseController*)self.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"正在举报" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
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
    ScrollViewController* superView = (ScrollViewController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"删除中" SubTitle:nil];
    NSString* userId=@"";
    if ([Global sharedInstance].userID.length>0) {
        userId = [Global sharedInstance].userID;
    }
    NSDictionary* dict = @{ @"uid" : userId,
                            @"topicid" : model.id };
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"deltopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [superView.hudLoading hideAnimated:YES];
                     if ([superView respondsToSelector:@selector(refreshData)]){
                         [superView refreshData];
                     }else{
                         //[self.delate deleteBtnClick];
                     }
                 }andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                     [superView.hudLoading hideAnimated:YES];
                 }];
}
- (void)shoucang
{
    if (![(BaseController*)self.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"正在收藏" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
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

@end
