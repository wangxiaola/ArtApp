//
//  YTXTopicAuthorViewCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "YTXTopicAuthorViewCell.h"
#import "UserInfoModel.h"

#define ICON_SIZE       CGSizeMake( 40, 40 )

#define MARGIN          10

#define USER_NAME_FONT  kFont(15)

#define USER_TAG_FONT   kFont(11)

@interface YTXTopicAuthorViewCell ()

@property (nonatomic, strong) UIImageView *authorImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userTagLabel;
@property (nonatomic, strong) UIButton *followButton;

@property (nonatomic, strong) UIButton *accountButton;

@end

@implementation YTXTopicAuthorViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _authorImageView = [[UIImageView alloc] init];
        _authorImageView.clipsToBounds = TRUE;
        _authorImageView.layer.cornerRadius = ICON_SIZE.width / 2;
        [self.contentView addSubview:_authorImageView];
        
        [_authorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(MARGIN);
            make.top.mas_equalTo(MARGIN);
            make.size.mas_equalTo(ICON_SIZE);
        }];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = ART_FONT(ARTFONT_OFI);
        [self.contentView addSubview:_userNameLabel];
        
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_authorImageView.mas_right).offset(MARGIN);
            make.bottom.mas_equalTo(_authorImageView.mas_centerY).offset(-MARGIN/3);
        }];
        
        _userTagLabel = [[UILabel alloc] init];
        _userTagLabel.font = ART_FONT(ARTFONT_OFI);
        _userTagLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_userTagLabel];
        
        [_userTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_authorImageView.mas_right).offset(MARGIN);
            make.top.mas_equalTo(_authorImageView.mas_centerY).offset(MARGIN/3);
        }];
        
        _followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_followButton setTitle:@"已关注" forState:UIControlStateSelected];
        [_followButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _followButton.layer.cornerRadius = 4.0;
        _followButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _followButton.layer.borderWidth = 0.5;
        _followButton.titleLabel.font = ART_FONT(ARTFONT_OFI);
        [_followButton addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_followButton];
        
        [_followButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-MARGIN);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        UIView *linkView = [[UIView alloc] init];
        linkView.backgroundColor = Art_LineColor;
        [self.contentView addSubview:linkView];
        
        [linkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.mas_equalTo(0);
            make.height.mas_equalTo(Art_Line_HEIGHT);
        }];
        
        _accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountButton addTarget:self action:@selector(accountAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_accountButton];
        
        [_accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.mas_equalTo(0);
            make.right.mas_equalTo(_followButton.mas_left).offset(-MARGIN * 2);
        }];
    }
    return self;
}

- (void)accountAction
{
    if (_accountTouch) _accountTouch(_model);
}

- (void)setModel:(UserInfoUserModel *)model
{
    _model = model;
    self.userNameLabel.text = model.username;
    [self.authorImageView setImageURL:[NSURL URLWithString:model.avatar]];
    self.userTagLabel.text = model.tag;
}

+ (CGFloat)defaultCellHeight
{
    return 60;
}

- (void)followAction
{
    [self addGuanzhu];
}
//添加关注
-(void)addGuanzhu{
    if (![(BaseController*)self.containingViewController isNavLogin]) {
        return;
    }
    if (!_followButton.selected){
        //NSLog(@"关注");
        NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID,
                                @"tuid" : self.model.uid };
        [ArtRequest PostRequestWithActionName:@"addaction" andPramater:dict succeeded:^(id responseObject){
            if ([[ArtUIHelper sharedInstance] alertSuccessWith:@"关注" obj:responseObject]) {
                _followButton.selected = YES;
                
            }else{
                NSString* msg = responseObject[@"msg"];
                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [(BaseController*)self.containingViewController logonAgain];
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
                _followButton.selected = NO;
                
            }else{
                NSString* msg = responseObject[@"msg"];
                if((msg.length>0)&&[msg rangeOfString:@"其它手机登录"].location!=NSNotFound){
                    [(BaseController*)self.containingViewController logonAgain];
                }
            }
            
            
        } failed:^(id responseObject) {
            
        }];
        
    }
    
}
@end
