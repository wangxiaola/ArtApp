//
//  DetailSearchCell.m
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/5/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//
#import "DetailSearchCell.h"

@implementation DetailSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //自定义线条
    UIImageView *line1=[[UIImageView alloc]init];
    line1.backgroundColor=Art_LineColor;
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-0.5);
    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    _avactorView.userInteractionEnabled = YES;
    [_avactorView addGestureRecognizer:tap];
    [_avactorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(30), T_WIDTH(30)));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avactorView.mas_right).offset(5);
        make.top.mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(100), T_WIDTH(16)));
    }];
    
    [_sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(0);
        make.top.mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(T_WIDTH(100), T_WIDTH(16)));
    }];

    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.left.equalTo(_avactorView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-T_WIDTH(30)-10-50, 0));
    }];
    
    CGFloat imgWidth = (SCREEN_WIDTH-T_WIDTH(30)-10-50-15)/4;
    
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        make.left.equalTo(_avactorView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
    }];
    
    [_imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        make.left.equalTo(_imageView1.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
    }];
    [_imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        make.left.equalTo(_imageView2.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
    }];
    [_imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        make.left.equalTo(_imageView3.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
    }];
}
- (CGFloat)getHeight
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return _imageView1.bottom +15;
}

-(void)setModel:(CangyouQuanDetailModel *)model{
    _model = model;
    
    [self addDetailSearchCell];
}
-(void)addDetailSearchCell{
    //[super layoutSubviews];
   
    [_avactorView sd_setImageWithURL:[NSURL URLWithString:_model.user.avatar] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    _nameLabel.text = _model.user.username;
    if (_model.topictypeName.length > 0){
        _sourceLabel.text = [NSString stringWithFormat:@"%@",_model.topictypeName];
    }
    //_timeLabel.text = [self changeTime:model.dateline];
    
    
    NSMutableArray* resultArr = [[NSMutableArray alloc]init];
    
    switch (_model.topictype.integerValue) {
        case 1:
        {
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
            if (_model.catetypeName.length > 0) {
                [resultArr addObject:_model.catetypeName];
            }
            if (_model.statusName.length > 0) {
                [resultArr addObject:_model.statusName];
            }
            
        }
            break;
        case 3:
        {
            if (_model.message.length > 0) {
                [resultArr addObject:_model.message];
            }
            
        }
            break;
        case 4:
            
        {
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
            
            if (_model.gtypename.length > 0) {
                [resultArr addObject:_model.gtypename];
            }
            
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
        }
            break;
        case 6:
        {
            
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
            
            NSString* widthStr = [NSString stringWithFormat:@"%@",_model.width];
            NSString* heightStr = [NSString stringWithFormat:@"%@",_model.height];
            NSString* longStr = [NSString stringWithFormat:@"%@",_model.longstr];
            NSString* sizeStr = [ArtUIHelper returnWidth:widthStr Height:heightStr Long:longStr];
            
            if (sizeStr.length>0) {
                [resultArr addObject:sizeStr];
            }
            

            if (_model.arttype.length > 0) {
                [resultArr addObject:_model.arttype];
            }
            
            
            
        }
            break;
        case 7:
        {
            
            if (_model.message.length > 0) {
                [resultArr addObject:_model.message];
            }
            
            if (_model.arttype.length > 0) {
                [resultArr addObject:_model.arttype];
            }
            
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
            
        }
            break;
        case 8:
        {
            
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
            
            if (_model.city.length > 0) {
                [resultArr addObject:_model.city];
            }
            if (_model.address.length > 0) {
                [resultArr addObject:_model.address];
            }
            
            if (_model.starttime.length > 0) {
                [resultArr addObject:_model.starttime];
            }
            
            
        }
            break;
        case 9:
        {
            if (_model.peopleUserName.length>0) {
                [resultArr addObject:_model.peopleUserName];
            }
            
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
            
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
            
        }
            break;
        case 13:
        {
            if (_model.message.length > 0) {
                [resultArr addObject:_model.message];
            }
            [resultArr addObject:@"艺术年表"];
            
            
            if (_model.age.length>0) {
                [resultArr addObject:_model.age];
            }
        }
            break;
        case 14:
        {
            [resultArr addObject:@"荣誉奖项"];
            
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
            if (_model.award.length > 0) {
                [resultArr addObject:_model.award];
            }
            if (_model.message.length > 0) {
                [resultArr addObject:[NSString stringWithFormat:@"：%@",_model.message]];
            }
            
            
        }
            break;
            
        case 15:
        {
            [resultArr addObject:@"收藏拍卖"];
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
            
            if (_model.sourceUserName.length>0) {
                [resultArr addObject:_model.sourceUserName];
            }
            
            if (_model.message.length > 0) {
                [resultArr addObject:_model.message];
            }
            
            
            
        }
            break;
        case 16:
        {
            [resultArr addObject:@"公益捐赠"];
            
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
            
            if (_model.sourceUserName.length>0) {
                [resultArr addObject:_model.sourceUserName];
            }
           
            
        }
            break;
            
        case 17:
        {
            
            if (_model.sourceUserName.length>0) {
                [resultArr addObject:_model.sourceUserName];
            }
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
        }
            break;
            
        case 18:
        {
            
            [resultArr addObject:@"出版著作"];
            if (_model.age.length > 0) {
                [resultArr addObject:_model.age];
            }
            if (_model.topictitle.length > 0) {
                [resultArr addObject:_model.topictitle];
            }
            if (_model.message.length > 0) {
                [resultArr addObject:_model.message];
            }
        }
            break;
            
            
        default:
            break;
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[resultArr componentsJoinedByString:@" | "]];
    
    if (_model.video.length>0){//视频图标
        NSTextAttachment *text = [[NSTextAttachment alloc] init];
        text.image = [UIImage imageNamed:@"icon_video"];
        text.bounds = CGRectMake(0,-3, _contentLabel.font.pointSize, _contentLabel.font.pointSize);
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:text]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 视频" attributes:@{NSForegroundColorAttributeName:RGB(51, 153, 204),NSFontAttributeName:_contentLabel.font}]];
    }
    
    _contentLabel.attributedText = attributedString;
    CGSize tempSize = [_contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-T_WIDTH(30)-10-50, T_WIDTH(16))];
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-T_WIDTH(30)-10-50, tempSize.height));
    }];
    _imageView1.hidden = YES;
    _imageView2.hidden = YES;
    _imageView3.hidden = YES;
    _imageView4.hidden = YES;
    //图片
    if (_model.photoscbk.count > 0){
        CGFloat imgWidth = (SCREEN_WIDTH-T_WIDTH(30)-10-50-15)/4;
        [_imageView1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
            make.top.equalTo(_contentLabel.mas_bottom).offset(5);
        }];
        
        if (_model.photoscbk.count == 1) {
            
            YTXPhotoscbkModel *photoModel = [_model.photoscbk objectAtIndex:0];
            [_imageView1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel.photo] tempTmage:@"icon_Default_Product"];
            _imageView1.hidden = NO;
            
        }else if (_model.photoscbk.count == 2) {
            
            YTXPhotoscbkModel *photoModel1 = [_model.photoscbk objectAtIndex:0];
            
            YTXPhotoscbkModel *photoModel2 = [_model.photoscbk objectAtIndex:1];
            [_imageView1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel1.photo] tempTmage:@"icon_Default_Product"];
             _imageView1.hidden = NO;
            [_imageView2 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel2.photo] tempTmage:@"icon_Default_Product"];
             _imageView2.hidden = NO;
            
        }
        else if (_model.photoscbk.count == 3) {
            
            YTXPhotoscbkModel *photoModel1 = [_model.photoscbk objectAtIndex:0];
            YTXPhotoscbkModel *photoModel2 = [_model.photoscbk objectAtIndex:1];
            YTXPhotoscbkModel *photoModel3 = [_model.photoscbk objectAtIndex:2];
            
            [_imageView1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel1.photo] tempTmage:@"icon_Default_Product"];
             _imageView1.hidden = NO;
            [_imageView2 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel2.photo] tempTmage:@"icon_Default_Product"];
             _imageView2.hidden = NO;
            [_imageView3 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel3.photo] tempTmage:@"icon_Default_Product"];
             _imageView3.hidden = NO;
            
            
        }else if (_model.photoscbk.count >= 4) {
            
            YTXPhotoscbkModel *photoModel1 = [_model.photoscbk objectAtIndex:0];
            YTXPhotoscbkModel *photoModel2 = [_model.photoscbk objectAtIndex:1];
            YTXPhotoscbkModel *photoModel3 = [_model.photoscbk objectAtIndex:2];
            YTXPhotoscbkModel *photoModel4 = [_model.photoscbk objectAtIndex:3];
            
            [_imageView1 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel1.photo] tempTmage:@"icon_Default_Product"];
             _imageView1.hidden = NO;
            [_imageView2 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel2.photo] tempTmage:@"icon_Default_Product"];
             _imageView2.hidden = NO;
            [_imageView3 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel3.photo] tempTmage:@"icon_Default_Product"];
             _imageView3.hidden = NO;
            [_imageView4 sd_setImageWithUrlStr:[NSString stringWithFormat:@"%@!450a",photoModel4.photo] tempTmage:@"icon_Default_Product"];
             _imageView4.hidden = NO;
            
        }
        
    }else{
        CGFloat imgWidth = (SCREEN_WIDTH-T_WIDTH(30)-10-50-15)/4;
        [_imageView1 mas_updateConstraints:^(MASConstraintMaker *make){
            make.size.mas_equalTo(CGSizeMake(imgWidth, 0));
            make.top.equalTo(_contentLabel.mas_bottom).offset(0);
        }];
    }    
}
-(void)tapClick:(UITapGestureRecognizer*)tap{
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = _model.user.username;
    vc.artId = _model.user.uid;
    [self.contentView.containingViewController.navigationController pushViewController:vc animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
