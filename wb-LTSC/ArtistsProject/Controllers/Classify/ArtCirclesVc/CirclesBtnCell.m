//
//  CirclesBtnCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/16.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "CirclesBtnCell.h"
#import "CangyouQuanDetailModel.h"
#import "ArtCirclesVc.h"

@interface CirclesBtnCell ()
{
    HView* shareViewImage;
    CangyouQuanDetailModel* model;
}
@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UIButton* btnZan;
@end

@implementation CirclesBtnCell

-(void)addContentViews{
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = kColor6;
    _timeLabel.font = ART_FONT(ARTFONT_OZ);
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(120), T_WIDTH(20)));
    }];
    
    CGFloat imgWidth  = (SCREEN_WIDTH-34)/3;
    
    //赞
    _btnZan = [[UIButton alloc]init];
    [_btnZan addTarget:self action:@selector(btnZan_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [_btnZan setImage:[UIImage imageNamed:@"icon_appraisal_zan"] forState:UIControlStateNormal];
    [_btnZan setImage:[UIImage imageNamed:@"icon_appraisal_Azan"] forState:UIControlStateSelected];
    [self.contentView addSubview:_btnZan];
    [_btnZan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.equalTo(self.contentView.mas_right).offset(-imgWidth-15);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(20), T_WIDTH(20)));
    }];
    
    //评论
    UIButton *btnComment = [[UIButton alloc]init];
    [btnComment setImage:[UIImage imageNamed:@"icon_cangyou_comment"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(btnCommit_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnComment];
    [btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.equalTo(self.contentView.mas_right).offset(-imgWidth/2-T_WIDTH(10)-15);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(20), T_WIDTH(20)));
    }];
    
    UIButton *moreBtn = [[UIButton alloc]init];
    [moreBtn setImage:[UIImage imageNamed:@"detailMore"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(btnShare_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.equalTo(self.contentView.mas_right).offset(-15-T_WIDTH(25));
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(25), T_WIDTH(20)));
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
    model = [CangyouQuanDetailModel mj_objectWithKeyValues:dic];
    
    NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        for (int i=0; i<arrayYuanlai.count; i++) {
            UIImageView* img = [shareViewImage viewWithTag:100+i];
            [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",arrayYuanlai[i]] tempTmage:@"icon_Default_Product.png"];
        }
        
    }

    
    NSString* timeStr = [NSString stringWithFormat:@"%@",dic[@"dateline"]];
    if (timeStr.length>0) {
        _timeLabel.text = [self compareCurrentTime:timeStr];
    }else{
        _timeLabel.text = @" ";
    }
    
    NSString* isLike = [NSString stringWithFormat:@"%@",dic[@"isLiked"]];
    if ([isLike isEqualToString:@"0"]){
        _btnZan.selected = NO;
    }else{
        _btnZan.selected = YES;
    }
}

-(NSString *)compareCurrentTime:(NSString *)time
{
    //time为传入的秒数 时间戳是自 1970 年 1 月 1 日（00:00:00 GMT）以来的秒数
    //算出发布的时间
    NSDate* timeDate = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    NSDate* currentTime = [NSDate date];//当前时间
    //得到时间差
    NSTimeInterval  timeInterval =   [currentTime timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    
    return  result;
}

-(void)btnZan_CLick:(UIButton*)send{
    if (![(BaseController*)self.contentView.containingViewController isNavLogin]) {
        return;
    }
    if (!_btnZan.selected){
        //NSLog(@"赞");
        [self Zan];
    }else{
        //NSLog(@"取消赞");
        [self cancelZan];
    }
}
//评论事件
-(void)btnCommit_Click{
    BaseController* superView = (BaseController*)self.contentView.containingViewController;
    if (![superView isNavLogin]) {
        return;
    }
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
    detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.isScrollToBottom = YES;
    [superView.navigationController pushViewController:detailVC animated:YES];
    
}
////赞
- (void)Zan
{
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    
    NSString* topicidStr = [NSString stringWithFormat:@"%@",model.id];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID?:@"0",
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"liketopic" andPramater:dict succeeded:^(id responseObject){
        
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"点赞" obj:responseObject]) {
            _btnZan.selected = YES;
//           ArtCirclesVc * superView = (ArtCirclesVc*)self.containingViewController;
//             [superView.hudLoading hideAnimated:YES];
//            if ([superView respondsToSelector:@selector(loadAgain)]){
//                [superView loadAgain];
//            }
            
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [(ArtCirclesVc*)self.containingViewController logonAgain];
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
    
    NSString* topicidStr = [NSString stringWithFormat:@"%@",model.id];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID?:@"0",
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"delliketopic" andPramater:dict succeeded:^(id responseObject){
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"取消赞" obj:responseObject]){
            _btnZan.selected = NO;
//            ArtCirclesVc * superView = (ArtCirclesVc*)self.containingViewController;
//            [superView.hudLoading hideAnimated:YES];
//            if ([superView respondsToSelector:@selector(loadAgain)]){
//                [superView loadAgain];
//            }
            
            
        }else{
            NSString* msg = responseObject[@"msg"];
            
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [(ArtCirclesVc*)self.containingViewController logonAgain];
            }
            
        }
        
    } failed:^(id responseObject) {
        [superView.hudLoading hideAnimated:YES];
    }];
}

-(void)btnShare_Click{
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
    ScrollViewController* superView = (ScrollViewController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"删除中" SubTitle:nil];
    NSString* userId=@"";
    if ([Global sharedInstance].userID.length>0) {
        userId = [Global sharedInstance].userID;
    }
    NSDictionary* dict = @{ @"uid" : userId?:@"0",
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

@end
