//
//  PrivateListCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/11.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "CommentListCell.h"
#import "MyHomePageDockerVC.h"

@interface CommentListCell ()
{
    NSString* kindStr;//回复/删除
}
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* subTitleLabel;
@property(nonatomic,strong)UIButton* addBtn;
@end

@implementation CommentListCell
-(void)addContentViews{
    self.contentView.backgroundColor = BACK_VIEW_COLOR;
    _iconView = [[UIImageView alloc]init];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    _iconView.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconView];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [_iconView addGestureRecognizer:tap];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = ART_FONT(ARTFONT_OFI);
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView.mas_centerY).offset(-20);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 20));
    }];
    
    
    _subTitleLabel = [[UILabel alloc]init];
    _subTitleLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, 20));
    }];
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.titleLabel.font = ART_FONT(ARTFONT_OZ);
    [_addBtn setTitleColor:kColor4 forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addGuanzhu) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));

    }];
    _listDic = [[NSMutableDictionary alloc]init];
}
-(void)tapClick{
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = _model.username;
    vc.artId = _model.uid;
    [self.contentView.containingViewController.navigationController pushViewController:vc animated:YES];
}
-(void)setCommentListCell:(NSDictionary*)dic{
    [_listDic removeAllObjects];
    [_listDic addEntriesFromDictionary:dic];
    _model = [UserInfoUserModel mj_objectWithKeyValues:dic[@"user"]];
   
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",_model.avatar] tempTmage:@"temp_Default_headProtrait"];
    
    NSString* nameStr = _model.username;
    NSString* timeStr =   [self compareCurrentTime:[NSString stringWithFormat:@"%@",dic[@"dateline"]]];;
    
    NSString* resultStr = [NSString stringWithFormat:@"%@ %@",nameStr,timeStr];
    
    NSMutableAttributedString* attri = [[NSMutableAttributedString alloc]initWithString:resultStr];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,nameStr.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OT] range:NSMakeRange(0,nameStr.length)];
    
    [attri addAttribute:NSForegroundColorAttributeName value:RGB(150,150,150) range:NSMakeRange(nameStr.length,timeStr.length+1)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OZ] range:NSMakeRange(nameStr.length,timeStr.length+1)];
    
    
    _nameLabel.attributedText = attri;
    _subTitleLabel.text = dic[@"message"];
    NSString* commitId = [NSString stringWithFormat:@"%@",_model.uid];
    NSString* cid = [NSString stringWithFormat:@"%@",dic[@"uid"]];
    if (!(cid.length>0)||!(commitId.length>0)) {
        _addBtn.hidden = YES;
        kindStr = @"";
    }else if ([commitId isEqualToString:cid]){
        _addBtn.hidden = NO;
        kindStr = @"删除";
        [_addBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        _addBtn.hidden = NO;
        kindStr = @"回复";
        [_addBtn setTitle:@"回复" forState:UIControlStateNormal];
    }
}
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    [_listDic removeAllObjects];
    [_listDic addEntriesFromDictionary:dic];
    _model = [UserInfoUserModel mj_objectWithKeyValues:dic[@"author"]];
    
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",_model.avatar] tempTmage:@"temp_Default_headProtrait"];
    
    NSString* nameStr = _model.username;
    NSString* timeStr = [NSString stringWithFormat:@"%@",dic[@"datelineFormat"]];
    NSString* resultStr = [NSString stringWithFormat:@"%@ %@",nameStr,timeStr];
    
    NSMutableAttributedString* attri = [[NSMutableAttributedString alloc]initWithString:resultStr];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,nameStr.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OT] range:NSMakeRange(0,nameStr.length)];
    
    [attri addAttribute:NSForegroundColorAttributeName value:RGB(150,150,150) range:NSMakeRange(nameStr.length,timeStr.length+1)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ARTFONT_OZ] range:NSMakeRange(nameStr.length,timeStr.length+1)];
    
    
    _nameLabel.attributedText = attri;
    _subTitleLabel.text = dic[@"message"];

    NSString* commitId = [NSString stringWithFormat:@"%@",_model.uid];
    NSString* cid = [Global sharedInstance].userID;
    
    if (!(cid.length>0)||!(commitId.length>0)) {
        _addBtn.hidden = YES;
        kindStr = @"";
    }else if ([commitId isEqualToString:cid]){
        _addBtn.hidden = NO;
        kindStr = @"删除";
        [_addBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        _addBtn.hidden = NO;
        kindStr = @"回复";
        [_addBtn setTitle:@"回复" forState:UIControlStateNormal];
    }
}
//回复/删除
-(void)addGuanzhu{
    if (![(BaseController*)self.contentView.containingViewController isNavLogin]) {
        return;
    }
    if (kindStr.length>0) {
        
    NSDictionary* dic = [self.listDic copy];
    if ([kindStr isEqualToString:@"回复"]) {
    if (self.sendBtnClick){
        self.sendBtnClick(dic);
     }
    }else{
        BaseController* superveiw = (BaseController*)self.contentView.containingViewController;
           //删除
        NSString* cidStr  = _listDic[@"cid"];
        
        NSDictionary* dict = @{
                                @"cid" : cidStr?cidStr:@"",
                                };
        
        [superveiw showLoadingHUDWithTitle:@"正在删除评论" SubTitle:nil];
        //__weak typeof(self)wself = self;
        [ArtRequest PostRequestWithActionName:@"deltopiccomment" andPramater:dict succeeded:^(id responseObject){
            [superveiw.hudLoading hideAnimated:YES];
           // [wself loadData];
            if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"删除评论" obj:responseObject]) {
                //评论成功
                ScrollViewController* superView = (ScrollViewController*)self.contentView.containingViewController;
                
                if ([superView respondsToSelector:@selector(refreshData)]){
                    [superView refreshData];
                }
            }else{
                NSString* msg = responseObject[@"msg"];
                
                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [superveiw logonAgain];
                }
            }
            
        } failed:^(id responseObject) {
            [superveiw.hudLoading hideAnimated:YES];
        }];

    }
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
@end
