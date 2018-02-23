//
//  CirclesHeadCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/16.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "CirclesHeadCell.h"
#import "NSMutableAttributedString+YTXCangyouquanCell.h"

#import "CangyouQuanDetailModel.h"

@interface CirclesHeadCell ()
{
    CangyouQuanDetailModel* model;
}
@property(nonatomic,strong)UIImageView* iconView;
@property(nonatomic,strong)UILabel* nameLabel;
@property(nonatomic,strong)UILabel* subLabel;
@property(nonatomic,strong)UILabel* kindLabel;
@end

@implementation CirclesHeadCell

-(void)addContentViews{
    
    _iconView = [[UIImageView alloc]init];
    _iconView.layer.cornerRadius = T_WIDTH(15);
    _iconView.layer.masksToBounds = YES;
    _iconView.userInteractionEnabled = YES;
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(30), T_WIDTH(30)));
    }];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHead)];
    [_iconView addGestureRecognizer:tap];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.textColor = kColor6;
    _nameLabel.font = ART_FONT(ARTFONT_OTH);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).offset(10);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(200), T_WIDTH(14)));
    }];
    
    
    _subLabel = [[UILabel alloc]init];
    _subLabel.textColor = kColor3;
    _subLabel.font = ART_FONT(ARTFONT_OZ);
    _subLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_subLabel];
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).offset(10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(200), T_WIDTH(11)));
    }];
    
    _kindLabel = [[UILabel alloc]init];
    _kindLabel.textColor = kColor6;
    _kindLabel.numberOfLines = 0;
    _kindLabel.font = ART_FONT(ARTFONT_OF);
    _kindLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_kindLabel];
    [_kindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.equalTo(_iconView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(280), T_WIDTH(15)));
    }];
}

-(CGFloat)setCirclesHeadCellDicValue:(NSDictionary *)dic{
    CGFloat height = T_WIDTH(30)+15;
    model = [CangyouQuanDetailModel mj_objectWithKeyValues:dic];
    
    [_iconView sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@",model.user.avatar] tempTmage:@"temp_Default_headProtrait"];
    _nameLabel.text = model.user.username;
    _subLabel.text = model.user.tag;
    
    
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    
    switch (model.topictype.integerValue) {
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
            
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
            }
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
            if (model.arttype.length > 0) {
                [resultArr addObject:model.arttype];
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
            
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
            }
            
            if (model.age.length > 0) {
                [resultArr addObject:model.age];
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
            if (model.topictitle.length > 0) {
                [resultArr addObject:model.topictitle];
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

    if (model.video.length>0){//视频图标
        NSTextAttachment *text = [[NSTextAttachment alloc] init];
        text.image = [UIImage imageNamed:@"icon_video"];
        text.bounds = CGRectMake(0,-3, _kindLabel.font.pointSize, _kindLabel.font.pointSize);
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204),NSFontAttributeName:_kindLabel.font}]];
    }
    
    _kindLabel.attributedText = attributedString;
    CGSize tempSize = [_kindLabel sizeThatFits:CGSizeMake(T_WIDTH(280), T_WIDTH(15))];
    [_kindLabel mas_updateConstraints:^(MASConstraintMaker *make){
        if (tempSize.height<100) {
            make.size.mas_equalTo(CGSizeMake(T_WIDTH(280), tempSize.height));
        }else{
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(280), 100));
        }
        
    }];
    if (tempSize.height<100) {
        height+=tempSize.height+15;
    }else{
       height+=100+15;
    }
    
    return height;
}
-(void)tapHead{
    
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = model.user.username;
    vc.artId = model.user.uid;
    if (self.baseViews) {
        [self.baseViews.containingViewController.navigationController pushViewController:vc animated:YES];
    }else{
       [self.contentView.containingViewController.navigationController pushViewController:vc animated:YES];    }
    
}
@end
