//
//  AnyWorksHeadCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "AnyWorksHeadCell.h"
#import "DetailSearchVc.h"
#import "HomeListDetailVc.h"

@interface AnyWorksHeadCell ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@end

@implementation AnyWorksHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *line1=[[UIImageView alloc]init];
    line1.backgroundColor=kLineColor;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(Art_Line_HEIGHT);
        make.top.equalTo(self.contentView.mas_top).offset(0);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setWorkHead:(NSString *)kindStr num:(NSString *)num uid:(NSString *)uid{
    _titleLabel.text = kindStr;
    NSString* loginId = [Global sharedInstance].userID;
//    if ([loginId isEqualToString:uid]){//是用户自己的作品
        if(num.integerValue>0){
            _numberLabel.text = num;
            [_editBtn setTitle:@"添加" forState:UIControlStateNormal];
            _editBtn.hidden = NO;
        }else{
            _numberLabel.text = @"";
            [_editBtn setTitle:@"添加" forState:UIControlStateNormal];
            _editBtn.hidden = NO;
        }
//    }else{
//        if(num.integerValue>0){
//            _numberLabel.text = num;
//            _editBtn.hidden = YES;
//        }else{
//            _numberLabel.text = @"";
//            _editBtn.hidden = YES;
//        }
//    }
}
-(void)setModel:(CangyouQuanDetailModel *)model{
    _model = model;
}
- (IBAction)editBtnClick:(UIButton *)sender {
    NSString* btnTitle = sender.titleLabel.text;
    NSString* titbleTit = _titleLabel.text;
    if ([titbleTit isEqualToString:@"商品"]) {
        if ([btnTitle isEqualToString:@"添加"]) {
            __weak typeof(self)weakSelf = self;
            DetailSearchVc * search =[DetailSearchVc new];
            if (_model.work_ids.length>0) {
                search.idSArr = _model.work_ids;
            }
            search.guanLianSuccess = ^(){
                [weakSelf reloadSuperViewData];
            };
            search.isOpenHeaderRefresh = YES;
            search.isOpenFooterRefresh = YES;
            search.topictypeStr = @"4";
            search.typeStr = @"1";
            search.topicId = _model.id;
            search.hidesBottomBarWhenPushed = YES;
            search.navigationController.navigationBarHidden = YES;
            [self.containingViewController.navigationController pushViewController:search animated:YES];
        }else if([btnTitle isEqualToString:@"编辑"]){
            __weak typeof(self)weakSelf = self;
            DetailSearchVc * search =[DetailSearchVc new];
            if (_model.work_ids.length>0) {
                search.idSArr = _model.work_ids;
            }
            
            search.guanLianSuccess = ^(){
                [weakSelf reloadSuperViewData];
            };
            search.isOpenHeaderRefresh = YES;
            search.isOpenFooterRefresh = YES;
            search.topictypeStr = @"4";
            search.typeStr = @"1";
            search.topicId = _model.id;
            search.hidesBottomBarWhenPushed = YES;
            search.navigationController.navigationBarHidden = YES;
            [self.containingViewController.navigationController pushViewController:search animated:YES];
        }
    }else if ([titbleTit isEqualToString:@"记录"]){
        if ([btnTitle isEqualToString:@"添加"]){
            __weak typeof(self)weakSelf = self;
            DetailSearchVc * search =[DetailSearchVc new];
            if (_model.relation_ids.length>0) {
                search.idSArr = _model.relation_ids;
            }
            search.guanLianSuccess = ^(){
                [weakSelf reloadSuperViewData];
            };
            search.isOpenHeaderRefresh = YES;
            search.isOpenFooterRefresh = YES;
            search.typeStr = @"2";
            search.topicId = _model.id;
            search.hidesBottomBarWhenPushed = YES;
            search.navigationController.navigationBarHidden = YES;
            [self.containingViewController.navigationController pushViewController:search animated:YES];
        }else if ([btnTitle isEqualToString:@"编辑"]){
            __weak typeof(self)weakSelf = self;
            DetailSearchVc * search =[DetailSearchVc new];
            if (_model.relation_ids.length>0) {
                search.idSArr = _model.relation_ids;
            }

            search.guanLianSuccess = ^(){
                [weakSelf reloadSuperViewData];
            };
            search.isOpenHeaderRefresh = YES;
            search.isOpenFooterRefresh = YES;
            search.typeStr = @"2";
            search.topicId = _model.id;
            search.hidesBottomBarWhenPushed = YES;
            search.navigationController.navigationBarHidden = YES;
            [self.containingViewController.navigationController pushViewController:search animated:YES];
        }
    }
}

-(void)reloadSuperViewData{
    HomeListDetailVc* superView = (HomeListDetailVc*)self.containingViewController;
    if ([superView respondsToSelector:@selector(refreshData)]) {
        [superView refreshData];
    }
}
@end
