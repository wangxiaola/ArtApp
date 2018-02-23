//
//  WorksFirstCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RecentFirstCell.h"
#import "HomeListDetailVc.h"
#import "OpenShareHeader.h"
#import "PublishDongtaiVC.h"

@interface RecentFirstCell ()
{
    UIButton *btnZan;
    CangyouQuanDetailModel* model;
    HView* shareViewImage;
}
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;
@property(nonatomic,strong)UILabel * zanLabel;
@property(nonatomic,strong)UILabel * numsLabel;
@property(nonatomic,strong)UIButton * seeNums;
@property(nonatomic,strong)UIImageView* btnBaseView;
@end

@implementation RecentFirstCell

-(void)addContentViews{

    _baseImage = [[UIImageView alloc]init];
    _baseImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_baseImage];
//    self.contentView.backgroundColor = [UIColor hexChangeFloat:@"e7e7e7"];
    [_baseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 15, 0));
    }];
}

- (void)setupCellStyle:(HomeImageModel *)homeModel
{
    [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!2b1",homeModel.photo] tempTmage:@"icon_Default_Product.png"];
}

-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    model = [CangyouQuanDetailModel mj_objectWithKeyValues:dic];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",dic[@"topictitle"]];
    
    
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    NSInteger interIndex = model.topictype.integerValue;
    switch (interIndex) {
        case 1:
        {
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
            }
            if (model.catetypeName.length > 0) {
                [resultArr addObject:model.catetypeName];
            }
            if (model.statusName.length > 0) {
                [resultArr addObject:model.statusName];
            }
            
        }
            break;
        case 3:
        {
            if (model.message.length > 0) {
                [resultArr addObject:model.message];
            }
            
        }
            break;
        case 4:
            
        {
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
            }
            
            if (model.gtypename.length > 0) {
                [resultArr addObject:model.gtypename];
            }
            
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
        }
            break;
        case 6:
        {
            
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
            
            NSString* widthStr = [NSString stringWithFormat:@"%@",model.width];
            NSString* heightStr = [NSString stringWithFormat:@"%@",model.height];
            NSString* longStr = [NSString stringWithFormat:@"%@",model.longstr];
            NSString* sizeStr = [ArtUIHelper returnWidth:widthStr Height:heightStr Long:longStr];
            
            if (sizeStr.length>0) {
                [resultArr addObject:sizeStr];
            }
            
            if (model.caizhi.length > 0) {
                [resultArr addObject:model.caizhi];
            }
            
        }
            break;
        case 7:
        {
            
            if (model.message.length > 0) {
                [resultArr addObject:model.message];
            }
            
            if (model.arttype.length > 0) {
                [resultArr addObject:model.arttype];
            }
            
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
            
        }
            break;
        case 8:
        {
            
            
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
            }
            
            if (model.city.length > 0) {
                [resultArr addObject:model.city];
            }
            if (model.address.length > 0) {
                [resultArr addObject:model.address];
            }
            
            if (model.starttime.length > 0) {
                [resultArr addObject:model.starttime];
            }
        }
            break;
        case 9:
        {
            
            if (model.peopleUserName.length>0) {
                [resultArr addObject:model.peopleUserName];
            }
            
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
            
            
            if (model.message.length > 0) {
                [resultArr addObject:model.message];
            }
        }
            break;
        case 13:
        {
            if (model.message.length > 0) {
                [resultArr addObject:model.message];
            }
            [resultArr addObject:@"艺术年表"];
            
            
            if (model.age.length>0) {
                [resultArr addObject:model.age];
            }
        }
            break;
        case 14:
        {
            [resultArr addObject:@"荣誉奖项"];
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
            }
            if (model.award.length > 0) {
                [resultArr addObject:model.award];
            }
            if (model.message.length > 0) {
                [resultArr addObject:[NSString stringWithFormat:@"获奖作品：%@",model.message]];
            }
            
            
            
            
            if (model.age.length>0) {
                [resultArr addObject:model.age];
            }
        }
            break;
            
        case 15:
        {
            [resultArr addObject:@"收藏拍卖"];
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
            
            if (model.sourceUserName.length>0) {
                [resultArr addObject:model.sourceUserName];
            }
            
            if (model.message.length > 0) {
                [resultArr addObject:model.message];
            }
            
            
        }
            break;
        case 16:
        {
            [resultArr addObject:@"公益捐赠"];
            
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
            
            if (model.sourceUserName.length>0) {
                [resultArr addObject:model.sourceUserName];
            }
            
            if (model.message.length > 0) {
                [resultArr addObject:model.message];
            }
            
        }
            break;
            
        case 17:
        {
            
            if (model.sourceUserName.length>0) {
                [resultArr addObject:model.sourceUserName];
            }
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
        }
            break;
            
        case 18:
        {
            
            [resultArr addObject:@"出版著作"];
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
            }
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
            }
            if (model.message.length > 0) {
                [resultArr addObject:model.message];
            }
        }
            break;
            
            
        default:
            break;
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[resultArr componentsJoinedByString:@" | "]];
    if (interIndex==17){
        [attributedString appendString:@"  "];
        NSTextAttachment *text = [[NSTextAttachment alloc] init];
        text.image = [UIImage imageNamed:@"lianjie"];
        text.bounds = CGRectMake(0,-3, _subLabel.font.pointSize, _subLabel.font.pointSize);
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 网页链接" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204),NSFontAttributeName:_subLabel.font}]];
    }else{
        if (model.video.length>0){//视频图标
            NSTextAttachment *text = [[NSTextAttachment alloc] init];
            text.image = [UIImage imageNamed:@"icon_video"];
            text.bounds = CGRectMake(0,-3, _subLabel.font.pointSize, _subLabel.font.pointSize);
            [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204),NSFontAttributeName:_subLabel.font}]];
        }
    }
    
    _subLabel.attributedText = attributedString;
    CGSize tempSize = [_subLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-30, T_WIDTH(15))];
    [_subLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (tempSize.height<60) {
            
            make.height.mas_equalTo(tempSize.height);
        }else{
            make.height.mas_equalTo(60);
        }
        
    }];
    
    
    _zanLabel.text = [NSString stringWithFormat:@"%@",dic[@"likenum"]];
    _numsLabel.text = [NSString stringWithFormat:@"%@",dic[@"commentnum"]];
    NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        NSString* imgUrl = arrayYuanlai[0];
        [_baseImage sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!2b1",imgUrl] tempTmage:@"icon_Default_Product.png"];
        for (int i=0; i<arrayYuanlai.count; i++) {
            UIImageView* img = [shareViewImage viewWithTag:100+i];
            [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",arrayYuanlai[i]] tempTmage:@"icon_Default_Product.png"];
        }
        
    }
    
    NSString* isLike = [NSString stringWithFormat:@"%@",dic[@"isLiked"]];
    if ([isLike isEqualToString:@"0"]) {
        btnZan.selected = NO;
    }else{
        btnZan.selected = YES;
    }
}

//赞点击事件
- (void)btnZan_CLick
{
    if (![(BaseController*)self.baseViews.containingViewController isNavLogin]) {
        return;
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
    NSString* topicidStr = [NSString stringWithFormat:@"%@",model.id];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID,
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"liketopic" andPramater:dict succeeded:^(id responseObject){
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"点赞" obj:responseObject]){
            btnZan.selected = YES;
            NSInteger inter = [_zanLabel.text integerValue];
            _zanLabel.text = [NSString stringWithFormat:@"%ld",++inter];
        }else{
            NSString* msg = responseObject[@"msg"];
            if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                [(BaseController*)self.baseViews.containingViewController logonAgain];
            }
        }
        
    } failed:^(id responseObject) {
        
    }];
}

//取消点赞
- (void)cancelZan
{
    //1.设置请求参数
    BaseController* superView = (BaseController*)self.containingViewController;
    
    NSString* topicidStr = [NSString stringWithFormat:@"%@",model.id];
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
                [(BaseController*)self.baseViews.containingViewController logonAgain];
            }
        }
        
    } failed:^(id responseObject) {
        [superView.hudLoading hideAnimated:YES];
    }];
}
//
//评论事件
-(void)btnCommit_Click{
    if (![(BaseController*)self.baseViews.containingViewController isNavLogin]) {
        return;
    }
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = [NSString stringWithFormat:@"%@",model.id];
    detailVC.topictype = [NSString stringWithFormat:@"%@",model.topictype];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.isScrollToBottom = YES;
    BaseController* superView = (BaseController*)self.baseViews.containingViewController;
    [superView.navigationController pushViewController:detailVC animated:YES];
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
    ScrollViewController* superView = (ScrollViewController*)self.contentView.containingViewController;
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
    if (![(BaseController*)self.baseViews.containingViewController isNavLogin]) {
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
