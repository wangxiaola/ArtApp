//
//  PrivateListCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/11.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "GuanzhuCell.h"

@interface GuanzhuCell ()
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* subTitleLabel;
@property(nonatomic,strong)UIButton* addBtn;
@end

@implementation GuanzhuCell
-(void)addContentViews{
    _iconView = [[UIImageView alloc]init];
    _iconView.layer.cornerRadius = 20;
    _iconView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconView];
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
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    _subTitleLabel = [[UILabel alloc]init];
    _subTitleLabel.font = ART_FONT(ARTFONT_OT);
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.iconView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setImage:[UIImage imageNamed:@"detailAdd"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addGuanzhu) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        
    }];
    _listDic = [[NSMutableDictionary alloc]init];
}
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic{
    [_listDic removeAllObjects];
    [_listDic addEntriesFromDictionary:dic];
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",dic[@"avatar"]] tempTmage:@"temp_Default_headProtrait"];
    _nameLabel.text = dic[@"username"];
    _subTitleLabel.text = dic[@"tag"];
    NSString* relStr= [NSString stringWithFormat:@"%@",dic[@"rel"]];
    if ([relStr isEqualToString:@"2"]||[relStr isEqualToString:@"1"]) {
        _addBtn.selected = YES;
        _addBtn.hidden = YES;
    }else{
        _addBtn.selected = NO;
    }
}

//添加关注
-(void)addGuanzhu{
    if (![(HViewController*)self.contentView.containingViewController isNavLogin]) {
        return;
    }
    if (!_addBtn.selected){
        //NSLog(@"关注");
        NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                                @"tuid" : self.listDic[@"uid"] };
        [ArtRequest PostRequestWithActionName:@"addaction" andPramater:dict succeeded:^(id responseObject){
            if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"关注" obj:responseObject]) {
                _addBtn.selected = YES;
                _addBtn.hidden = YES;
            }else{
                NSString* msg = responseObject[@"msg"];

                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [(HViewController*)self.contentView.containingViewController logonAgain];
                }
        
            }
            
        } failed:^(id responseObject) {
            
        }];
        
    }else{
        //NSLog(@"取消关注");
        NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                                @"tuid" : self.listDic[@"uid"]
                                };
        
        [ArtRequest PostRequestWithActionName:@"delaction" andPramater:dict succeeded:^(id responseObject){
            if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"取消关注" obj:responseObject]) {
                _addBtn.selected = NO;
            }else{
                NSString* msg = responseObject[@"msg"];

                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [(HViewController*)self.contentView.containingViewController logonAgain];
                }
            }
            
        } failed:^(id responseObject) {
            
        }];
        
    }
    
}

@end
