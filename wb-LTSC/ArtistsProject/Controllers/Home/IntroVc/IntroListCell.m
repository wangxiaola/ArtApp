//
//  WorksFirstCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "IntroListCell.h"
#import "HomeListDetailVc.h"

@interface IntroListCell ()
{
    BOOL _isHavePhoto;
    CangyouQuanDetailModel *model;
    UIButton *btnZan;
    UIButton* _seeNums;
}
@property(nonatomic,strong)UIImageView* baseImage;
@property(nonatomic,strong)UILabel* yearLabel;
@property(nonatomic,strong)UIImageView* titImgView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * zanLabel;
@property(nonatomic,strong)UILabel * numsLabel;
@property(nonatomic,strong)NSMutableArray * contentArr;
@property(nonatomic,strong)NSMutableDictionary* recentCellDic;
@property(nonatomic,strong)CangyouQuanDetailModel *topicModel;
@end

@implementation IntroListCell

-(void)addContentViews{
    
    _recentCellDic = [[NSMutableDictionary alloc]init];
    _contentArr = [[NSMutableArray alloc]init];
    _yearLabel = [[UILabel alloc]init];
    _yearLabel.textAlignment = NSTextAlignmentLeft;
    _yearLabel.font = ART_FONT(ARTFONT_OE);
    [self.contentView addSubview:_yearLabel];
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.top.equalTo(self.contentView).with.offset(15);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView* line = [[UIImageView alloc]init];
    line.backgroundColor = RGB(235, 235, 235);
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.left.equalTo(_yearLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(0.5);
        
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = ART_FONT(ARTFONT_OF);
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_yearLabel.mas_right).offset(0);
        make.top.equalTo(_yearLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(0);
    }];
    
    
    _baseImage = [[UIImageView alloc]init];
    _baseImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_baseImage];
    [_baseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.left.equalTo(_yearLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(0);
    }];
    
    for (int i=0; i<4; i++) {
        UIImageView* img = [[UIImageView alloc]init];
        img.tag = 100+i;
        [_baseImage addSubview:img];
        
        img.backgroundColor = [UIColor orangeColor];
        CGFloat imgWidth  = (SCREEN_WIDTH-T_WIDTH(90)-15)/4;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(_baseImage);
            make.width.mas_equalTo(imgWidth);
            make.left.equalTo(_baseImage).offset(i*(imgWidth+5));
        }];
    }
    
    _titImgView = [[UIImageView alloc]init ];
    _titImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:_titImgView];
    [_titImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_baseImage.mas_bottom).offset(15);
        make.left.equalTo(_yearLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.mas_equalTo(T_WIDTH(20));
    }];
    
    //赞
    btnZan = [[UIButton alloc]init];
    [btnZan addTarget:self action:@selector(btnZan_CLick:) forControlEvents:UIControlEventTouchUpInside];
    [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_zan"] forState:UIControlStateNormal];
    [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_Azan"] forState:UIControlStateSelected];
    [_titImgView addSubview:btnZan];
    [btnZan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(_titImgView);
        make.left.equalTo(_titImgView).offset(0);
        make.width.mas_equalTo(T_WIDTH(20));
        
    }];
    
    _zanLabel = [[UILabel alloc]init];
    _zanLabel.textAlignment = NSTextAlignmentLeft;
    _zanLabel.font = ART_FONT(ARTFONT_OZ);
    [_titImgView addSubview:_zanLabel];
    [_zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(_titImgView);
        make.left.equalTo(btnZan.mas_right).offset(T_WIDTH(10));
        make.width.mas_equalTo(T_WIDTH(20));
    }];
    
    //评论
    UIButton *btnComment = [[UIButton alloc]init];
    [btnComment setImage:[UIImage imageNamed:@"icon_cangyou_comment"] forState:UIControlStateNormal];
    [btnComment addTarget:self action:@selector(btnCommit_Click) forControlEvents:UIControlEventTouchUpInside];
    [_titImgView addSubview:btnComment];
    [btnComment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(_titImgView);
        make.left.equalTo(_zanLabel.mas_right).offset(T_WIDTH(10));
        make.width.mas_equalTo(T_WIDTH(20));
    }];
    
    _numsLabel = [[UILabel alloc]init];
    _numsLabel.textAlignment = NSTextAlignmentLeft;
    _numsLabel.font = ART_FONT(ARTFONT_OZ);
    [_titImgView addSubview:_numsLabel];
    [_numsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(_titImgView);
        make.left.equalTo(btnComment.mas_right).offset(T_WIDTH(10));
        make.width.mas_equalTo(T_WIDTH(20));
    }];
    
    _seeNums = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seeNums setImage:[UIImage imageNamed:@"ShareBtn"] forState:UIControlStateNormal];
    [_seeNums addTarget:self action:@selector(btnEdit_Click) forControlEvents:UIControlEventTouchUpInside];
    [_titImgView addSubview:_seeNums];
    [_seeNums mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titImgView);
        make.right.equalTo(_titImgView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    
}

//赞点击事件
- (void)btnZan_CLick:(UIButton*)send
{
    if (self.baseViews) {
        if (![(BaseController*)self.baseViews.containingViewController isNavLogin]) {
            return;
        }
    }else{
        if (![(BaseController*)self.containingViewController isNavLogin]) {
            return;
        }
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
    NSString* topicidStr = [NSString stringWithFormat:@"%@",_recentCellDic[@"id"]];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID,
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"liketopic" andPramater:dict succeeded:^(id responseObject){
        
        NSInteger inter = [_zanLabel.text integerValue];
        _zanLabel.text = [NSString stringWithFormat:@"%ld",++inter];
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"点赞" obj:responseObject]) {
            btnZan.selected = YES;
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
        
    }];
}

//取消点赞
- (void)cancelZan
{
    //1.设置请求参数
    
    NSString* topicidStr = [NSString stringWithFormat:@"%@",_recentCellDic[@"id"]];
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID,
                            @"topicid" : topicidStr };
    //    //2.开始请求
    [ArtRequest PostRequestWithActionName:@"delliketopic" andPramater:dict succeeded:^(id responseObject){
        NSInteger inter = [_zanLabel.text integerValue];
        _zanLabel.text = [NSString stringWithFormat:@"%ld",--inter];
        if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"取消赞" obj:responseObject]) {
            btnZan.selected = NO;
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
        
    }];
}
//评论事件
-(void)btnCommit_Click{
    BaseController* superView = (BaseController*)self.baseViews.containingViewController;
    if (self.baseViews){
        superView = (BaseController*)self.baseViews.containingViewController;
    }else{
        superView = (BaseController*)self.containingViewController;
    }
    if (![superView isNavLogin]) {
        return;
    }
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.isScrollToBottom = YES;
    detailVC.topicid = [NSString stringWithFormat:@"%@",_recentCellDic[@"id"]];
    detailVC.topictype = [NSString stringWithFormat:@"%@",_recentCellDic[@"topictype"]];
    detailVC.hidesBottomBarWhenPushed = YES;
    [superView.navigationController pushViewController:detailVC animated:YES];
}
#pragma - mark - 年表列表cell
-(CGFloat)setIntroListCellDicValue:(NSDictionary *)dic yearStr:(NSString *)StrYear{
    CGFloat cellHight = (15*3+20);
    
    [_recentCellDic removeAllObjects];
    [_recentCellDic addEntriesFromDictionary:dic];
    [_contentArr removeAllObjects];
    
    NSString* topicStr = [NSString stringWithFormat:@"%@",dic[@"topictype"]];
    NSInteger topicInter = [topicStr integerValue];
    
    NSString* yearStr = @"";
    
    NSMutableArray* contentArr = [[NSMutableArray alloc]init];
    
    switch (topicInter){
        case 8:
        {//zljl－重要展览
            yearStr = [NSString stringWithFormat:@"%@",dic[@"starttime"]];
            NSString*  time = [NSString stringWithFormat:@"%@",dic[@"starttime"]];
            if (time.length>4){
                NSArray* arr = [time componentsSeparatedByString:@"-"];
                if (arr.count>=3) {
                    [contentArr addObject:[NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]]];
                }
                
            }
            
            NSString*  topictitle = [NSString stringWithFormat:@"%@",dic[@"topictitle"]];
            if (topictitle.length>0) {
                [contentArr addObject:topictitle];
            }
            
            NSString*  city = [NSString stringWithFormat:@"%@",dic[@"city"]];
            if (city.length>0) {
                [contentArr addObject:city];
            }
            
            NSString*  address = [NSString stringWithFormat:@"%@",dic[@"address"]];
            if (address.length>0) {
                [contentArr addObject:address];
            }
            
            NSString*  planner = [NSString stringWithFormat:@"%@",dic[@"planner"]];
            if (planner.length>0) {
                [contentArr addObject:[NSString stringWithFormat:@"策展人:%@",planner]];
            }
            
        }
            break;
        case 13:
        {//ysnb－艺术年表
            yearStr = [NSString stringWithFormat:@"%@",dic[@"age"]];
            NSString*  time = [NSString stringWithFormat:@"%@",dic[@"starttime"]];
            if (time.length>4){
                NSArray* arr = [time componentsSeparatedByString:@"-"];
                if (arr.count>=3) {
                    [contentArr addObject:[NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]]];
                }
                
            }

            
            NSString*  message = [NSString stringWithFormat:@"%@",dic[@"message"]];
            if (message.length>0) {
                [contentArr addObject:message];
            }
            
        }
            break;
        case 14:
        {//ryjx－荣誉奖项
            yearStr = [NSString stringWithFormat:@"%@",dic[@"age"]];
            NSString*  time = [NSString stringWithFormat:@"%@",dic[@"starttime"]];
            if (time.length>4){
                NSArray* arr = [time componentsSeparatedByString:@"-"];
                if (arr.count>=3) {
                    [contentArr addObject:[NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]]];
                }
                
            }

            
            NSString*  topictitle = [NSString stringWithFormat:@"%@",dic[@"topictitle"]];
            if (topictitle.length>0) {
                [contentArr addObject:topictitle];
            }
            
            NSString*  Award = [NSString stringWithFormat:@"%@",dic[@"award"]];
            if (Award.length>0) {
                [contentArr addObject:Award];
            }
            
            NSString*  message = [NSString stringWithFormat:@"%@",dic[@"message"]];
            if (message.length>0) {
                [contentArr addObject:message];
            }

        }
            break;
            
        case 15:
        {//cjgz－收藏拍卖
            yearStr = [NSString stringWithFormat:@"%@",dic[@"age"]];
            NSString*  time = [NSString stringWithFormat:@"%@",dic[@"starttime"]];
            if (time.length>4){
                NSArray* arr = [time componentsSeparatedByString:@"-"];
                if (arr.count>=3) {
                    [contentArr addObject:[NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]]];
                }
                
            }

            NSString*  source = [NSString stringWithFormat:@"%@",dic[@"source"]];
            if (source.length>0) {
                [contentArr addObject:source];
            }
            
            NSString*  message = [NSString stringWithFormat:@"%@",dic[@"message"]];
            if (message.length>0) {
                [contentArr addObject:[NSString stringWithFormat:@"作品: %@",message]];
            }

        }
            break;
            
        case 16:
        {//gyjz－公益捐赠
            yearStr = [NSString stringWithFormat:@"%@",dic[@"age"]];
            NSString*  time = [NSString stringWithFormat:@"%@",dic[@"starttime"]];
            if (time.length>4){
                NSArray* arr = [time componentsSeparatedByString:@"-"];
                if (arr.count>=3) {
                    [contentArr addObject:[NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]]];
                }
                
            }
            
            NSString*  source = [NSString stringWithFormat:@"%@",dic[@"source"]];
            if (source.length>0) {
                [contentArr addObject:source];
            }
            
            NSString*  message = [NSString stringWithFormat:@"%@",dic[@"message"]];
            if (message.length>0) {
                [contentArr addObject:[NSString stringWithFormat:@"作品: %@",message]];
            }
        }
            break;
        case 18:
        {//cbzz－出版刊登
            yearStr = [NSString stringWithFormat:@"%@",dic[@"age"]];
            NSString*  time = [NSString stringWithFormat:@"%@",dic[@"starttime"]];
            if (time.length>4){
                NSArray* arr = [time componentsSeparatedByString:@"-"];
                if (arr.count>=3) {
                    [contentArr addObject:[NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]]];
                }
                
            }
            NSString*  topictitle = [NSString stringWithFormat:@"%@",dic[@"topictitle"]];
            if (topictitle.length>0) {
                [contentArr addObject:topictitle];
            }
            
            NSString*  message = [NSString stringWithFormat:@"%@",dic[@"message"]];
            if (message.length>0) {
                [contentArr addObject:message];
            }

            
        }
            break;
            
            
            
        default:
            break;
    }
        if (yearStr.length>=4){
            yearStr = [yearStr substringToIndex:4];
            _yearLabel.text = yearStr;

        }else{
            _yearLabel.text = @" ";

        }

//    if (yearStr.length>=4){
//        yearStr = [yearStr substringToIndex:4];
//        
//        if (![yearStr isEqualToString:StrYear]) {
//            _yearLabel.hidden = NO;
//            _yearLabel.text = yearStr;
//            
//            NSLog(@"不同");
//            NSLog(@"yearStr=%@  _yearLabel.text=%@",yearStr,_yearLabel.text);
//            if (self.yearBlock) {
//                self.yearBlock(yearStr);
//            }
//        }else{
//            _yearLabel.hidden = YES;
//            NSLog(@"相同");
//        }
//        
//    }else{
//        _yearLabel.hidden = YES;
//    }
    _zanLabel.text = [NSString stringWithFormat:@"%@",dic[@"likenum"]];
    _numsLabel.text = [NSString stringWithFormat:@"%@",dic[@"commentnum"]];
    
    
    
    NSString* contentStr = [contentArr componentsJoinedByString:@" | "];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    if (![dic[@"video"] isEqualToString:@""]){//视频图标
        NSTextAttachment *text = [[NSTextAttachment alloc] init];
        text.image = [UIImage imageNamed:@"icon_video"];
        text.bounds = CGRectMake(0,-3, _titleLabel.font.pointSize, _titleLabel.font.pointSize);
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204),NSFontAttributeName:_titleLabel.font}]];
    }
    _titleLabel.attributedText  = attributedString;
    
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-80, 1000);
    CGSize expectSize = [_titleLabel sizeThatFits:maximumLabelSize];
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(expectSize.height);
    }];
    
    cellHight+=expectSize.height;
  
    
    for (int i=0; i<4; i++) {
        UIImageView* img = [_baseImage viewWithTag:100+i];
        img.hidden = YES;
    }
    NSString* photosStr = dic[@"photos"];
    NSArray* photoArr = [[NSArray alloc]init];
    if (photosStr.length>0&&![photosStr isEqualToString:@""]) {
        photoArr = [photosStr componentsSeparatedByString:@","];
    }
    
    [_baseImage mas_updateConstraints:^(MASConstraintMaker *make) {

        if (photoArr.count>0){
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.height.mas_equalTo(T_WIDTH(60));
            if (photoArr.count<5) {
                for (int i=0; i<photoArr.count; i++) {
                    UIImageView* img = [_baseImage viewWithTag:100+i];
                    img.hidden = NO;
                    [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoArr[i]] tempTmage:@"icon_Default_Product"];
                }
            }else{
                for (int i=0; i<4; i++) {
                    UIImageView* img = [_baseImage viewWithTag:100+i];
                    img.hidden = NO;;
                    [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoArr[i]] tempTmage:@"icon_Default_Product"];
                }
            }
        }else{
            make.top.equalTo(_titleLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }
    }];
    
    
    if (photoArr.count>0){
        cellHight+=(8+T_WIDTH(60));
    }
    
    NSString* isLike = [NSString stringWithFormat:@"%@",dic[@"isLiked"]];
    if ([isLike isEqualToString:@"0"]) {
        btnZan.selected = NO;
    }else{
        btnZan.selected = YES;
    }
    [self layoutSubviews];
    [self setNeedsLayout];
    return cellHight;
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
        NSArray* arrayYuanlai = [_topicModel.photos componentsSeparatedByString:@","];
        
        NSMutableArray *imageList = [[NSMutableArray alloc] init];
        for (int i = 0; i < arrayYuanlai.count; i ++) {
            UIImageView *imageView = [_baseImage viewWithTag:i+100];
            [imageList addObject:imageView.image];
        }
        
        PublishDongtaiVC *vc = [[PublishDongtaiVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isEdit = YES;
        vc.topicid = self.topicModel.id;
        vc.selectedType = self.topicModel.arttype;
        if (model.topictype.integerValue==8) {
            vc.age = self.topicModel.starttime;
        }else
        {
            vc.age = self.topicModel.age;
        }
        vc.longstr = self.topicModel.longstr;
        vc.width = self.topicModel.width;
        vc.height = self.topicModel.height;
        vc.format = self.topicModel.caizhi;
        vc.source = self.topicModel.sourceUserName;
        vc.message = self.topicModel.message;
        vc.city = self.topicModel.city;
        vc.name = self.topicModel.topictitle;
        vc.planner = self.topicModel.planner;
        vc.address = self.topicModel.address;
        vc.award = self.topicModel.award;
        vc.people = self.topicModel.peopleUserName;
        vc.topictype = self.topicModel.topictype;
        if ([self.topicModel.video stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
            vc.videoArray = [self.topicModel.video componentsSeparatedByString:@","];
        }
        vc.selectedImageList = imageList;
        vc.arrayRecorderSave = [ArtUIHelper stringToJSON:self.topicModel.audio].mutableCopy;
        vc.photos = [self.topicModel.photos componentsSeparatedByString:@","].mutableCopy;
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
        [(HViewController*)self.containingViewController showErrorHUDWithTitle:@"举报内容不能为空" SubTitle:nil Complete:nil];
        return;
    }
    if (![(HViewController*)self.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"正在举报" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                            @"tid" : _topicModel.id,
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
                            @"topicid" : _topicModel.id };
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
    if (![(HViewController*)self.baseViews.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"正在收藏" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                            @"topicid" : _topicModel.id };
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
