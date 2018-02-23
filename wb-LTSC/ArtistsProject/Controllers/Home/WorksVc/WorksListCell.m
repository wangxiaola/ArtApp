//
//  WorksListCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/4.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "WorksListCell.h"


@interface WorksListCell ()
{
    HView* shareViewImage;
    UIButton* _seeNums;
    CangyouQuanDetailModel* model;
}
@property(nonatomic,strong)UIImageView* backImg;
@property(nonatomic,strong)UILabel* describe;
@end

@implementation WorksListCell
-(void)addContentViews{
    _backImg = [[UIImageView alloc]init];
    [self.contentView addSubview:_backImg];
    [_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0,0,10,0));
    }];
    UIImageView* zhezhaocheng = [[UIImageView alloc]init];
    zhezhaocheng.userInteractionEnabled = YES;
    [zhezhaocheng setImage:[UIImage imageNamed:@"zhezhaocheng"]];
    [self.contentView addSubview:zhezhaocheng];
    [zhezhaocheng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0,0,10,0));
    }];
    _describe = [[UILabel alloc]init];
    _describe.textColor = [UIColor whiteColor];
    _describe.textAlignment = NSTextAlignmentLeft;
    _describe.font = ART_FONT(ARTFONT_OTH);
    [self.contentView addSubview:_describe];
    [_describe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
    _seeNums = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seeNums setImage:[UIImage imageNamed:@"ShareBtn"] forState:UIControlStateNormal];
    [_seeNums addTarget:self action:@selector(btnEdit_Click) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_seeNums];
    [_seeNums mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(50, 30));
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
    NSMutableString* contentStr = [[NSMutableString alloc]init];
    if (dic[@"topictitle"]) {
        [contentStr appendFormat:@"%@",dic[@"topictitle"]];
    }
    NSString* age = [NSString stringWithFormat:@"%@",dic[@"age"]];
    if (age.length>=4) {
        [contentStr appendFormat:@" | %@",age];
    }
    NSString* widht = [NSString stringWithFormat:@"%@",dic[@"width"]];
    NSString* height = [NSString stringWithFormat:@"%@",dic[@"height"]];
    NSString* longStr = [NSString stringWithFormat:@"%@",dic[@"long"]];
    
    NSString* sum = [ArtUIHelper returnWidth:widht Height:height Long:longStr];
    if (sum.length>0) {
       [contentStr appendFormat:@" | %@",sum];
    }
   
    _describe.text = contentStr;
    NSArray* arr = [dic[@"photos"] componentsSeparatedByString:@","];
    [_backImg sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!3b2",arr[0]] tempTmage:@"icon_Default_Product.png"];
    
    NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
    if (arrayYuanlai.count>0) {
        for (int i=0; i<arrayYuanlai.count; i++) {
            UIImageView* img = [shareViewImage viewWithTag:100+i];
            [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",arrayYuanlai[i]] tempTmage:@"icon_Default_Product.png"];
        }
        
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
