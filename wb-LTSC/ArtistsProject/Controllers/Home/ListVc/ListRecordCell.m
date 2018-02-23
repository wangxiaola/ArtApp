//
//  ListRecordCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/9.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ListRecordCell.h"
#import "sendBtn.h"

@interface ListRecordCell ()
{
    CangyouQuanDetailModel* model;
    
}
@property(nonatomic,strong)sendBtn* chkDefault;

@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIImageView* baseImage;
@end

@implementation ListRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _recordkDic = [[NSMutableDictionary alloc]init];

        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = ART_FONT(ARTFONT_OF);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-60);
            make.height.mas_equalTo(20);
        }];
        
        _chkDefault = [[sendBtn alloc] init];
        _chkDefault.titleFrame = CGRectMake(0, 0, 0, 0);
        _chkDefault.imgFrame = CGRectMake(0, 10, 10, 10);
        [_chkDefault setImage:[UIImage imageNamed:@"icon_UserIndexVC_rightArrow"] forState:UIControlStateNormal];
        [_chkDefault addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_chkDefault];
        [_chkDefault mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
       
        
    
        _baseImage = [[UIImageView alloc]init];
        _baseImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_baseImage];
        [_baseImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.right.equalTo(self.contentView.mas_right).offset(-60);
            make.height.mas_equalTo(T_WIDTH(0));
        }];
        
        for (int i=0; i<4; i++) {
            UIImageView* img = [[UIImageView alloc]init];
            img.tag = 100+i;
            [_baseImage addSubview:img];
            
            img.backgroundColor = [UIColor orangeColor];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.and.bottom.equalTo(_baseImage);
                make.width.mas_equalTo((SCREEN_WIDTH-90)/4);
                make.left.equalTo(_baseImage).offset(i*((SCREEN_WIDTH-90)/4+5));
            }];
        }
        
    }
    return self;
}


-(CGFloat)heightWithModel:(NSDictionary *)dic{
    [_recordkDic removeAllObjects];
    [_recordkDic addEntriesFromDictionary:dic];
    
    CGFloat height = 0;
    model = [CangyouQuanDetailModel mj_objectWithKeyValues:dic];
    
    
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
        text.bounds = CGRectMake(0,-3, _titleLabel.font.pointSize, _titleLabel.font.pointSize);
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204),NSFontAttributeName:_titleLabel.font}]];
    }
    
    _titleLabel.attributedText  = attributedString;
    
    //直接用label调用返回自适应的size 布限制高宽
    
    CGSize expectSize = [_titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-75,20)];
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make){
        if (_titleLabel.text.length>0) {
            make.top.equalTo(self.contentView.mas_top).offset(5);
        }else{
          make.top.equalTo(self.contentView.mas_top).offset(0);
        }
        
        if (expectSize.height>40) {
            make.height.mas_equalTo(40);
        }else{
            make.height.mas_equalTo(expectSize.height);
        }
        
    }];
    
    
    if (expectSize.height>40) {
        height = height+40+5;
    }else{
        if (_titleLabel.text.length>0) {
            height = height+5+expectSize.height;
        }
    }
    
    for (int i=0; i<4; i++) {
        UIImageView* img = [_baseImage viewWithTag:100+i];
        img.hidden = YES;
    }
    id arr = dic[@"photoscbk"];
    NSMutableArray* photoArr = [[NSMutableArray alloc]init];
    if ([arr isKindOfClass:[NSArray class]]){
        [photoArr addObjectsFromArray:arr];
    }
    
    if (photoArr.count>0){
        height = height+10+(SCREEN_WIDTH-90)/4;
    }
    
    [_baseImage mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (photoArr.count>0){
            make.top.equalTo(_titleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo((SCREEN_WIDTH-90)/4);
            if (photoArr.count<5) {
                for (int i=0; i<photoArr.count; i++) {
                    UIImageView* img = [_baseImage viewWithTag:100+i];
                    img.contentMode = UIViewContentModeScaleAspectFill;
                    img.clipsToBounds = YES;
                    img.layer.masksToBounds = YES;
                    img.hidden = NO;
                    [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoArr[i][@"photo"]] tempTmage:@"icon_Default_Product"];
                }
                
            }else{
                for (int i=0; i<4; i++) {
                    UIImageView* img = [_baseImage viewWithTag:100+i];
                    img.contentMode = UIViewContentModeScaleAspectFill;
                    img.clipsToBounds = YES;
                    img.layer.masksToBounds = YES;
                    img.hidden = NO;;
                    [img sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoArr[i][@"photo"]] tempTmage:@"icon_Default_Product"];
                }
            }
        }else{
            make.top.equalTo(_titleLabel.mas_bottom).offset(0);
            make.height.mas_equalTo(0);
        }
        
    }];
    
    return height+15;
}

-(void)detailClick{
    if (self.detailBtnCilck) {
        self.detailBtnCilck(self.recordkDic);
    }
}
@end
