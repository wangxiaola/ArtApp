//
//  YTXSearchUserCell.m
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "YTXSearchUserCell.h"

@implementation YTXSearchUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
    _attentionBtn.layer.borderWidth = 1;
    _attentionBtn.layer.cornerRadius = KKWidth(5);
    [_attentionBtn addTarget:self action:@selector(Attention_Click:) forControlEvents:UIControlEventTouchUpInside];
    _attentionBtn.layer.borderColor = ColorHex(@"9b9b9b").CGColor;
    [_attentionBtn setTitleColor:ColorHex(@"858585") forState:UIControlStateNormal];
    _attentionBtn.titleLabel.font = kFont(12);
}
- (void)Attention_Click:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        //1.设置请求参数
        HPageViewController* superView = (HPageViewController*)self.containingViewController;
        if (![Global sharedInstance].userID) {
            return;
        }
        NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                                @"tuid" : _model.uid };
        
        //2.开始请求
        HHttpRequest* request = [[HHttpRequest alloc] init];
        [request httpPostRequestWithActionName:@"addaction" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
             _attentionBtn.hidden = YES;
            [superView.hudLoading hideAnimated:YES];
            ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
            [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        }
                     andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                         
                         
                         
                         NSLog(@"关注成功");
                         
                         
                         
                         
                     }
                      andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                          [superView.hudLoading hideAnimated:YES];
                      }];

    }else{
        //1.设置请求参数
        NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                                @"tuid" : _model.uid };
        HPageViewController* superView = (HPageViewController*)self.containingViewController;
        //    //2.开始请求
        HHttpRequest* request = [[HHttpRequest alloc] init];
        [request httpPostRequestWithActionName:@"delaction" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
            [superView.hudLoading hideAnimated:YES];
            ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
            [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
        }
                     andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                         [superView.hudLoading hideAnimated:YES];
                          NSLog(@"取消关注成功");
                     }
                      andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                          [superView.hudLoading hideAnimated:YES];
                      }];
        
    }
    
}

- (void)setModel:(YTXSearchUserModel*)model
{
    _model = model;
    [_avactorView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    _nameLabel.text = model.username;
    _tagLabel.text = @"";
    if (model.tips.length > 0) {
        _tagLabel.text = [NSString stringWithFormat:@"%@", model.tips];
    }
    if ([model.auth isEqualToString:@"0"]) {
        _attentionBtn.hidden = NO;
    }
    else{
        _attentionBtn.hidden = YES;

    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)attentionClick:(UIButton *)sender {
    
    
}

@end
