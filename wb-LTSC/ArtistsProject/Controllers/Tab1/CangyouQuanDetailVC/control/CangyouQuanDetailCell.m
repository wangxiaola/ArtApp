//
//  CangyouQuanDetailCell.m
//  ShesheDa
//
//  Created by MengTuoChina on 16/7/23.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "CangyouQuanDetailCell.h"
#import "HomeListDetailVc.h"
#import "MyHomePageDockerVC.h"
#import "PlayerViewController.h"
#import "ViewAudioShow.h"
#import "NSMutableAttributedString+YTXCangyouquanCell.h"
#import "PublishDongtaiVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@implementation CangyouQuanDetailCell{
    UIImageView* imgTitle;
    UILabel *lblName, *lblSpace, *lblSubmit, *lblTime;
    UIButton* btnguanzhu;
    HLabel *lblState, *lblState3; //状态1
    HView* viewState2;
    HView* viewImage;
    HView *viewBottom;
    HLabel* lblChakanNumber;
    HButton *btnZan, *btnComment, *btnMore;
    HLabel *lblZan,*lblComment;
    HView *viewIsLike, *viewComment;
    NSMutableArray* arrayVideoID;
    NSMutableArray* arrayVideoImage;
    HButton* btnUrl;
    CGFloat cellImageHeight;
}

//@synthesize img
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isYiSuJiaJinKuang = reuseIdentifier;
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = [UIColor whiteColor];
    cellImageHeight = 1;
    arrayVideoID = [[NSMutableArray alloc] init];
    arrayVideoImage = [[NSMutableArray alloc] init];
    if ([self.isYiSuJiaJinKuang isEqualToString:@"isYiSuJiaJinKuang"]) {
        imgTitle = [[UIImageView alloc] init];
        imgTitle.layer.masksToBounds = YES;
        imgTitle.layer.cornerRadius = 17;
        [self addSubview:imgTitle];
        [imgTitle mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.width.height.mas_equalTo(KKWidth(68));
        }];
        
        //名字
        lblName = [[UILabel alloc] init];
        lblName.textColor = ColorHex(@"2e2e2e");
        lblName.font = kFont(15);
        [self addSubview:lblName];
        [lblName mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(imgTitle.mas_centerY);
            make.left.equalTo(imgTitle.mas_right).offset(10);
        }];
        
        lblSpace = [[UILabel alloc] init];
        lblSpace.text = @"|";
        lblSpace.textColor = ColorHex(@"858585");
        lblSpace.font = kFont(10);
        [self addSubview:lblSpace];
        [lblSpace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lblName);
            make.left.equalTo(lblName.mas_right).offset(5);
        }];
        
        lblSubmit = [[UILabel alloc] init];
        lblSubmit.textColor = ColorHex(@"858585");
        lblSubmit.font = kFont(10);
        [self addSubview:lblSubmit];
        [lblSubmit mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(lblName.mas_centerY);
            make.left.equalTo(lblSpace.mas_right).offset(5);
        }];
        
        //时间
        lblTime = [[UILabel alloc] init];
        lblTime.textColor = ColorHex(@"858585");
        lblTime.font = kFont(10);
        [self addSubview:lblTime];
        [lblTime mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(imgTitle.mas_centerY).offset(5);
            make.left.equalTo(imgTitle.mas_right).offset(10);
        }];
        
        //是否关注阿牛
        btnguanzhu = [[UIButton alloc] init];
        [btnguanzhu setTitle:@"关注" forState:UIControlStateNormal];
        [btnguanzhu setTitle:@"已关注" forState:UIControlStateSelected];
        btnguanzhu.layer.borderWidth = 1;btnguanzhu.layer.cornerRadius = KKWidth(5);
        [btnguanzhu addTarget:self action:@selector(btnguanzhu_Click) forControlEvents:UIControlEventTouchUpInside];
        btnguanzhu.layer.borderColor = ColorHex(@"9b9b9b").CGColor;
        [btnguanzhu setTitleColor:ColorHex(@"858585") forState:UIControlStateNormal];
        btnguanzhu.titleLabel.font = kFont(12);
        [self addSubview:btnguanzhu];
        [btnguanzhu mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(imgTitle);
            make.right.equalTo(self).offset(-10);
            make.width.mas_equalTo(KKWidth(95));
            make.height.mas_equalTo(KKWidth(45));
        }];
        
        HButton* btnGuanzhu = [[HButton alloc] init];
        btnGuanzhu.backgroundColor = kClearColor;
        [btnGuanzhu addTarget:self action:@selector(btnGuanzhuzzhu_Click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnGuanzhu];
        [btnGuanzhu mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.top.equalTo(imgTitle);
            make.right.equalTo(btnguanzhu.mas_left);
            make.height.mas_equalTo(45);
        }];
        
        lblState = [[HLabel alloc] init];
        lblState.textColor = ColorHex(@"2e2e2e");
        lblState.font = kFont(15);
        lblState.numberOfLines = 3;
        [self addSubview:lblState];
        [lblState mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(imgTitle.mas_bottom).offset(20);
            make.left.equalTo(self).offset(10);
            make.right.equalTo(self).offset(-10);
        }];
        
        lblState3 = [[HLabel alloc] init];
        lblState3.textColor = ColorHex(@"2e2e2e");
        lblState3.font = kFont(15);
        lblState3.numberOfLines = 3;
        [self addSubview:lblState3];
        [lblState3 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(lblState.mas_bottom).offset(5);
            make.left.equalTo(imgTitle);
            make.right.equalTo(self).offset(-10);
        }];
        
        viewState2 = [[HView alloc] init];
        viewState2.backgroundColor = kClearColor;
        [self addSubview:viewState2];
        [viewState2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lblState3.mas_bottom).offset(2);
            make.height.mas_equalTo(1);
        }];
        
        viewImage = [[HView alloc] init];
        viewImage.backgroundColor = kClearColor;
        [self addSubview:viewImage];
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self);
            make.top.equalTo(viewState2.mas_bottom).offset(2);
            make.right.equalTo(self);
        }];
        viewImage.hidden = YES;
        
        //底部状态栏
        viewBottom = [[HView alloc] init];
        viewBottom.backgroundColor = kClearColor;
        [self addSubview:viewBottom];
        [viewBottom mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(viewImage.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        lblChakanNumber = [[HLabel alloc] init];
        lblChakanNumber.textColor = kSubTitleColor;
        lblChakanNumber.textAlignment = NSTextAlignmentCenter;
        lblChakanNumber.font = kFont(12);
        [viewBottom addSubview:lblChakanNumber];
        [lblChakanNumber mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(viewBottom);
            make.left.mas_equalTo(10);
        }];
        
        btnMore = [[HButton alloc] init];
        [btnMore setImage:[UIImage imageNamed:@"icon_cangyouquan_more"] forState:UIControlStateNormal];
        [btnMore addTarget:self action:@selector(btnMore_Click) forControlEvents:UIControlEventTouchUpInside];
        [viewBottom addSubview:btnMore];
        [btnMore mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(viewBottom).offset(-10);
            make.top.bottom.equalTo(viewBottom);
        }];
        
        lblComment = [[HLabel alloc] init];
        lblComment.text = @"0";
        lblComment.font = kFont(15);
        lblComment.textColor = kSubTitleColor;
        [viewBottom addSubview:lblComment];
        [lblComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnMore.mas_left).offset(-20);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        //评论
        btnComment = [[HButton alloc] init];
        [btnComment setImage:[UIImage imageNamed:@"icon_cangyou_comment"] forState:UIControlStateNormal];
        [btnComment addTarget:self action:@selector(btnCommit_Click) forControlEvents:UIControlEventTouchUpInside];
        [viewBottom addSubview:btnComment];
        [btnComment mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(lblComment.mas_left).offset(-10);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        lblZan = [[HLabel alloc] init];
        lblZan.text = @"0";
        lblZan.font = kFont(15);
        lblZan.textColor = kSubTitleColor;
        [viewBottom addSubview:lblZan];
        [lblZan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(btnComment.mas_left).offset(-20);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        //赞按钮
        btnZan = [[HButton alloc] init];
        [btnZan addTarget:self action:@selector(btnZan_CLick) forControlEvents:UIControlEventTouchUpInside];
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_zan"] forState:UIControlStateNormal];
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_Azan"] forState:UIControlStateSelected];
        [viewBottom addSubview:btnZan];
        [btnZan mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(lblZan.mas_left).offset(-5);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        //添加点击喜欢的人的数组
        viewIsLike = [[HView alloc] init];
        viewIsLike.backgroundColor = ColorHex(@"D1E9E9" alpha : 0.5);
        [self addSubview:viewIsLike];
        [viewIsLike mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(viewBottom.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        viewIsLike.hidden = YES;
        
        viewComment = [[HView alloc] init];
        viewComment.backgroundColor = ColorHex(@"D1E9E9" alpha : 0.5);
        [self addSubview:viewComment];
        [viewComment mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(viewIsLike.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        viewComment.hidden = YES;
        
    }else{
        
        viewImage = [[HView alloc] init];
        viewImage.backgroundColor = kClearColor;
        [self addSubview:viewImage];
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(imgTitle.mas_bottom).offset(0);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
        viewImage.hidden = YES;
        lblState3 = [[HLabel alloc] init];
        lblState3.textColor = ColorHex(@"2e2e2e");
        lblState3.font = kFont(15);
        lblState3.numberOfLines = 3;
        [self addSubview:lblState3];
        [lblState3 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(viewImage.mas_bottom).offset(5);
            make.left.equalTo(imgTitle);
            make.right.equalTo(self).offset(-15);
        }];
        
        viewState2 = [[HView alloc] init];
        viewState2.backgroundColor = kClearColor;
        [self addSubview:viewState2];
        [viewState2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lblState3.mas_bottom).offset(2);
            make.height.mas_equalTo(1);
        }];
        
        lblState = [[HLabel alloc] init];
        lblState.backgroundColor = kClearColor;
        lblState.textColor = ColorHex(@"2e2e2e");
        lblState.font = kFont(15);
        lblState.numberOfLines = 3;
        [self addSubview:lblState];
        [lblState mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(viewState2.mas_bottom).offset(2);
            make.right.equalTo(self).offset(-10);
        }];
        //底部状态栏
        viewBottom = [[HView alloc] init];
        viewBottom.backgroundColor = kClearColor;
        [self addSubview:viewBottom];
        [viewBottom mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lblState.mas_bottom).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        lblChakanNumber = [[HLabel alloc] init];
        lblChakanNumber.textColor = kSubTitleColor;
        lblChakanNumber.textAlignment = NSTextAlignmentCenter;
        lblChakanNumber.font = kFont(12);
        [viewBottom addSubview:lblChakanNumber];
        [lblChakanNumber mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(viewBottom);
            make.left.mas_equalTo(10);
        }];
        
        btnMore = [[HButton alloc] init];
        [btnMore setImage:[UIImage imageNamed:@"icon_cangyouquan_more"] forState:UIControlStateNormal];
        [btnMore addTarget:self action:@selector(btnMore_Click) forControlEvents:UIControlEventTouchUpInside];
        [viewBottom addSubview:btnMore];
        [btnMore mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(viewBottom).offset(-10);
            make.top.bottom.equalTo(viewBottom);
        }];
        
        lblComment = [[HLabel alloc] init];
        lblComment.text = @"0";
        lblComment.font = kFont(15);
        lblComment.textColor = kSubTitleColor;
        [viewBottom addSubview:lblComment];
        [lblComment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnMore.mas_left).offset(-20);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        //评论
        btnComment = [[HButton alloc] init];
        [btnComment setImage:[UIImage imageNamed:@"icon_cangyou_comment"] forState:UIControlStateNormal];
        [btnComment addTarget:self action:@selector(btnCommit_Click) forControlEvents:UIControlEventTouchUpInside];
        [viewBottom addSubview:btnComment];
        [btnComment mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(lblComment.mas_left).offset(-10);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        lblZan = [[HLabel alloc] init];
        lblZan.text = @"0";
        lblZan.font = kFont(15);
        lblZan.textColor = kSubTitleColor;
        [viewBottom addSubview:lblZan];
        [lblZan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(btnComment.mas_left).offset(-20);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        //赞按钮
        btnZan = [[HButton alloc] init];
        [btnZan addTarget:self action:@selector(btnZan_CLick) forControlEvents:UIControlEventTouchUpInside];
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_zan"] forState:UIControlStateNormal];
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_Azan"] forState:UIControlStateSelected];
        [viewBottom addSubview:btnZan];
        [btnZan mas_makeConstraints:^(MASConstraintMaker* make) {
            make.right.equalTo(lblZan.mas_left).offset(-5);
            make.centerY.mas_equalTo(btnMore.centerY);
        }];
        
        //添加点击喜欢的人的数组
        viewIsLike = [[HView alloc] init];
        viewIsLike.backgroundColor = ColorHex(@"D1E9E9" alpha : 0.5);
        [self addSubview:viewIsLike];
        [viewIsLike mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(viewBottom.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        viewIsLike.hidden = YES;
        
        viewComment = [[HView alloc] init];
        viewComment.backgroundColor = ColorHex(@"D1E9E9" alpha : 0.5);
        [self addSubview:viewComment];
        [viewComment mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.right.equalTo(self);
            make.top.equalTo(viewIsLike.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        viewComment.hidden = YES;
    }
    
    
}

- (void)btnGuanzhuzzhu_Click
{
    MyHomePageDockerVC* vc = [[MyHomePageDockerVC alloc] init];
    vc.navTitle = _model.user.username;
    vc.artId = _model.user.uid;
    [self.containingViewController.navigationController pushViewController:vc animated:YES];
}
- (void)setModel:(CangyouQuanDetailModel*)model
{
    _model = model;
    [imgTitle sd_setImageWithURL:[NSURL URLWithString:model.user.avatar] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
    lblName.text = model.user.username;
    if (model.user.tag.length > 0) {
        lblSubmit.text = [NSString stringWithFormat:@"%@", model.user.tag];
    }
    lblTime.text = [self changeTime:model.dateline];
    
    //是否关注
    if ([model.isfollow isEqualToString:@"1"]) {
        btnguanzhu.selected = YES;
        btnguanzhu.hidden = YES;
    }
    
    for (UIView* view in viewState2.subviews) {
        [view removeFromSuperview];
    }
    viewState2.hidden = YES;
    [viewState2 mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo(1);
    }];
    
    //状态(geng)
    NSLog(@"1111999000=====%d",model.topictype.intValue);
    switch (model.topictype.intValue) {
        case 1: {
            NSMutableArray *stateArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stateArray addObject:model.topictitle];
            }
            if (model.catetypeName.length > 0) {
                [stateArray addObject:model.catetypeName];
            }
            if (model.statusName.length > 0) {
                [stateArray addObject:model.statusName];
            }
            
            if (stateArray.count > 0){
                lblState.text = [stateArray componentsJoinedByString:@" | "];
            }
            if (![model.status isEqualToString:@"4"]) {
                NSMutableArray *resultArray = [[NSMutableArray alloc] init];
                [resultArray addObject:@"鉴定结论："];
                if (model.statusName.length > 0) {
                    [resultArray addObject:model.statusName];
                }
                if (model.ageText.length > 0) {
                    [resultArray addObject:model.ageText];
                }
                if (model.priceText.length > 0) {
                    [resultArray addObject:model.ageText];
                }
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[resultArray componentsJoinedByString:@" | "]];
                if (![model.video isEqualToString:@""]) {
                    [attributedString appendLine];
                    [attributedString appendIconVideo];
                }
                lblState3.attributedText = attributedString;
            }
        } break;
        case 2:
        case 3:
        {
            viewState2.hidden = NO;
            //添加控件
            NSArray* arrayAudio = [ArtUIHelper stringToJSON:model.audio];
            for (int i = 0; i < arrayAudio.count; i++) {
                NSMutableDictionary* dic = arrayAudio[i];
                ViewAudioShow* viewAudioShowDetail = [[ViewAudioShow alloc] init];
                viewAudioShowDetail.dic = dic;
                viewAudioShowDetail.strName = model.user.username;
                [viewState2 addSubview:viewAudioShowDetail];
                [viewAudioShowDetail mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.left.equalTo(viewState2).offset(KKWidth(20));
                    make.width.mas_equalTo(kScreenW / 2);
                    make.top.equalTo(viewState2).offset(KKWidth(10) + (i * KKWidth(55)));
                    make.height.mas_equalTo(KKWidth(55));
                }];
            }
            
            [viewState2 mas_updateConstraints:^(MASConstraintMaker* make) {
                make.height.mas_equalTo((arrayAudio.count * KKWidth(10)) + (arrayAudio.count * KKWidth(55)));
            }];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:model.message];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            
            lblState.attributedText = attributedString;
        } break;
        case 4:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.gtypename.length > 0) {
                [stringArray addObject:model.gtypename];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            if (![model.video isEqualToString:@""]) {
                [attribuedString appendLine];
                [attribuedString appendIconVideo];
            }
            lblState.attributedText = attribuedString;
            break;
        }
        case 6:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
//            if (model.age.length > 0) {
//                [stringArray addObject:model.age];
//            }
            if (model.zuopinGuigeText.length > 0) {
                [stringArray addObject:model.zuopinGuigeText];
            }
            if (model.caizhi.length > 0) {
                [stringArray addObject:model.caizhi];
            }
            if (model.arttype.length > 0) {
                [stringArray addObject:model.arttype];
            }
            
            NSString *string = [stringArray componentsJoinedByString:@" | "];
           NSMutableAttributedString *attribuedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            if (![model.video isEqualToString:@""]) {
                [attribuedString appendLine];
                [attribuedString appendIconVideo];
            }
            
            lblState.attributedText = attribuedString;
            break;
        }
        case 7:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            if (model.arttype.length > 0) {
                [stringArray addObject:model.arttype];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
   
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            NSLog(@"%@",model.age);
            lblState.attributedText = attributedString;
            break;
        }
        case 8:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.starttime.length > 0) {
                [stringArray addObject:model.starttime];
            }
            if (model.city.length > 0) {
                [stringArray addObject:model.city];
            }
            if (model.address.length > 0) {
                [stringArray addObject:model.address];
            }
            
            NSString *string =[stringArray componentsJoinedByString:@" | "];
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
             NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            lblState.attributedText = attributedString;
            break;
        }
        case 9:
        {
            NSString *people = @"";
            if ([model.people isKindOfClass:[NSString class]]) {
                people = model.people;
            } else if ([model.people isKindOfClass:[NSDictionary class]]) {
                people = model.people[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (people.length > 0) {
                [stringArray addObject:people];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            lblState.attributedText = attributedString;
            break;
        }
        case 13:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            [stringArray addObject:@"艺术年表"];
            
            
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@|%@",model.age,string]];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
//            NSLog(@"111123455===%@",model.age);
            lblState.attributedText = attributedString;
            break;
        }
        case 14:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.award.length > 0) {
                [stringArray addObject:model.award];
            }
            if (model.message.length > 0) {
                [stringArray addObject:[NSString stringWithFormat:@"获奖作品：%@",model.message]];
            }
            [stringArray addObject:@"荣誉奖项"];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[stringArray componentsJoinedByString:@" | "]];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            
            lblState.attributedText = attributedString;
            break;
        }
        case 15:
        {
            NSString *source = @"";
            if ([model.source isKindOfClass:[NSString class]]) {
                source = model.source;
            } else if ([model.source isKindOfClass:[NSDictionary class]]) {
                source = model.source[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (source.length > 0) {
                [stringArray addObject:source];
            }
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            [stringArray addObject:@"收藏拍卖"];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[stringArray componentsJoinedByString:@" | "]];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            
            lblState.attributedText = attributedString;
            break;
        }
        case 16:
        {
            NSString *source = @"";
            if ([model.source isKindOfClass:[NSString class]]) {
                source = model.source;
            } else if ([model.source isKindOfClass:[NSDictionary class]]) {
                source = model.source[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (source.length > 0) {
                [stringArray addObject:source];
            }
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            [stringArray addObject:@"公益捐赠"];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[stringArray componentsJoinedByString:@" | "]];
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            
            lblState.attributedText = attributedString;
            break;
        }
        case 17:
        {
            NSString *source = @"";
            if ([model.source isKindOfClass:[NSString class]]) {
                source = model.source;
            } else if ([model.source isKindOfClass:[NSDictionary class]]) {
                source = model.source[@"username"];;
            }
            
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            if (source.length > 0) {
                [stringArray addObject:source];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            NSString *string = [stringArray componentsJoinedByString:@" | "];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
            lblState.attributedText = attributedString;
            break;
        }
        case 18:
        {
            NSMutableArray *stringArray = [[NSMutableArray alloc] init];
            [stringArray addObject:@"出版著作"];
            if (model.age.length > 0) {
                [stringArray addObject:model.age];
            }
            if (model.topictitle.length > 0) {
                [stringArray addObject:model.topictitle];
            }
            if (model.message.length > 0) {
                [stringArray addObject:model.message];
            }
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[stringArray componentsJoinedByString:@" | "]];
            
            if (![model.video isEqualToString:@""]) {
                [attributedString appendLine];
                [attributedString appendIconVideo];
            }
            
            lblState.attributedText = attributedString;
            break;
        }
    }
    
    //图片
    viewImage.hidden = YES;
    
    for (UIView* view in viewImage.subviews) {
        [view removeFromSuperview];
    }
    NSArray* arrayYuanlai = [model.photos componentsSeparatedByString:@","];
    NSMutableArray* arrayPhoto = [[NSMutableArray alloc] init];
    
    for (NSString* arrayPhotoUrl in arrayYuanlai) {
        if (arrayPhotoUrl.length > 3) {
            [arrayPhoto addObject:arrayPhotoUrl];
        }
    }
    
    if (arrayPhoto.count > 0) {
        viewImage.hidden = NO;
        [self upDataImage:arrayPhoto];
    }
    
    //查看数
    lblChakanNumber.text = [NSString stringWithFormat:@"查看%@", model.clicknum];
    
    //喜欢数 评论数
    lblZan.text = model.likenum;
    lblComment.text = model.commentnum;
    if ([model.isLiked isEqualToString:@"1"]) {
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_Azan"] forState:UIControlStateNormal];
    }
    else {
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_zan"] forState:UIControlStateNormal];
    }
    
    NSString* strVideo = model.video;
    if (strVideo.length > 2) {
        NSMutableArray* arrayVideo = [[strVideo componentsSeparatedByString:@","] mutableCopy];
        for (NSString* strPic in arrayVideo) {
            if (strPic.length < 2) {
                [arrayVideo removeObject:strPic];
            }
        }
        [arrayVideoID removeAllObjects];
        [arrayVideoImage removeAllObjects];
        [self getVideoID:arrayVideo withNumber:0];
    }
}

- (NSString*)getVideoIDWithVideoUrl:(NSString*)strVideo
{
    NSString* sub = @"";
    NSUInteger i = 0;
    NSUInteger iMoren = 4;
    NSRange start = [strVideo rangeOfString:@"vid="];
    i = start.location + iMoren;
    if (start.length == 0) {
        start = [strVideo rangeOfString:@"id_"];
        iMoren = 3;
        i = start.location + iMoren;
    }
    if (start.length == 0) {
        return @"";
    }
    for (; i < strVideo.length; i++) {
        NSString* strCoin = [strVideo substringWithRange:NSMakeRange(i, 1)];
        int asciiCode = [strCoin characterAtIndex:0]; //65
        if (!((47 < asciiCode && asciiCode < 58) || (64 < asciiCode && asciiCode < 91) || (96 < asciiCode && asciiCode < 123) || asciiCode == 61)) {
            break;
        }
    }
    sub = [strVideo substringWithRange:NSMakeRange(start.location + iMoren, i - start.location - iMoren)];
    return sub;
}

- (NSString*)getVideoIDWithVideoUrl1:(NSString*)strVideo
{
    NSString* sub = @"";
    NSUInteger i = 0;
    NSUInteger iMoren = 4;
    NSRange start = [strVideo rangeOfString:@"vid="];
    i = start.location + iMoren;
    if (start.length == 0) {
        start = [strVideo rangeOfString:@"id_"];
        iMoren = 3;
        i = start.location + iMoren;
    }
    if (start.length == 0) {
        return @"";
    }
    for (; i < strVideo.length; i++) {
        NSString* strCoin = [strVideo substringWithRange:NSMakeRange(i, 1)];
        int asciiCode = [strCoin characterAtIndex:0]; //65
        if (!((47 < asciiCode && asciiCode < 58) || (64 < asciiCode && asciiCode < 91) || (96 < asciiCode && asciiCode < 123) || asciiCode == 61)) {
            break;
        }
    }
    sub = [strVideo substringWithRange:NSMakeRange(start.location + iMoren, i - start.location - iMoren)];
    return sub;
}

- (void)getVideoID:(NSMutableArray*)arrayVideo withNumber:(NSInteger)iVideo
{
    
    NSString* strVideoUrl = arrayVideo[iVideo];
    NSString* strVideoID = [self getVideoIDWithVideoUrl1:strVideoUrl];
    NSInteger iVideonumner = iVideo + 1;
    if (strVideoID.length < 1) {
        
        //        [self getVideoID:arrayVideo withNumber:iVideonumner];
        return;
    }
    
    NSDictionary* dict = @{ @"client_id" : youKuclientId,
                            @"video_id" : strVideoID };
    //1.管理器
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    //2 设定类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    manager.requestSerializer.timeoutInterval = 20.0f; //超时时间
    
    NSString* url = @"https://openapi.youku.com/v2/videos/show.json";
    //4 请求
    [manager GET:url
      parameters:dict
         success:^(NSURLSessionTask* operation, id responseObject) {
             NSString* strVideoUrl = [responseObject objectForKey:@"bigThumbnail"];
             [arrayVideoImage addObject:strVideoUrl];
             [arrayVideoID addObject:strVideoID];
             NSInteger iVideonumner1 = iVideonumner;
             if (iVideonumner1 < arrayVideo.count) {
                 [self getVideoID:arrayVideo withNumber:iVideonumner1];
             }
             
         }
         failure:^(NSURLSessionTask* operation, NSError* error){
         }];
}

- (void)updataLikePersion:(NSArray*)arrayLisk
{
    viewIsLike.hidden = NO;
    [viewIsLike mas_updateConstraints:^(MASConstraintMaker* make) {
        make.height.mas_equalTo((kScreenW - 110) / 10 + 20);
    }];
    
    UIImageView* imgLikeTitleLast = nil;
    for (UserInfoUserModel* model in arrayLisk) {
        UIImageView* imgLikeTitle = [[UIImageView alloc] init];
        [imgLikeTitle sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"temp_Default_headProtrait"]];
        imgLikeTitle.layer.masksToBounds = YES;
        imgLikeTitle.layer.cornerRadius = (kScreenW - 110) / 20;
        [viewIsLike addSubview:imgLikeTitle];
        [imgLikeTitle mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerY.equalTo(viewIsLike);
            make.width.height.mas_equalTo((kScreenW - 110) / 10);
            if (!imgLikeTitleLast) {
                make.left.equalTo(viewIsLike).offset(10);
            }
            else {
                make.left.equalTo(imgLikeTitleLast.mas_right).offset(10);
            }
        }];
        imgLikeTitleLast = imgLikeTitle;
    }
}

- (void)upDataImage:(NSArray*)arrayImage
{
    if (arrayImage.count < 1) {
        return;
    }
    
    UIViewContentMode contentModel = UIViewContentModeScaleAspectFill;
    
    if (arrayImage.count == 1) {
        UIImageView* img1 = [[UIImageView alloc] init];
        
        [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        img1.contentMode = contentModel;
        img1.clipsToBounds = YES;
        img1.tag = [arrayImage indexOfObject:arrayImage[0]]+100;
        img1.layer.masksToBounds = YES;
        [viewImage addSubview:img1];
        [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.centerX.equalTo(viewImage);
            make.top.equalTo(viewImage);
            make.width.height.mas_equalTo(kScreenW);
        }];
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(img1);
        }];
    }
    
    if (arrayImage.count == 2) {
        UIImageView* img1 = [[UIImageView alloc] init];
        [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1b2", arrayImage[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        img1.contentMode = contentModel;
        img1.clipsToBounds = YES;
        img1.tag = [arrayImage indexOfObject:arrayImage[0]]+100;
        [viewImage addSubview:img1];
        [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewImage);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight) / 3 * 2);
        }];
        
        UIImageView* img2 = [[UIImageView alloc] init];
        img2.contentMode = contentModel;
        img2.clipsToBounds = YES;
        img2.tag = [arrayImage indexOfObject:arrayImage[1]]+100;
        [img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[1]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img2];
        [img2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.right.equalTo(viewImage);
            make.height.mas_equalTo((kScreenW - cellImageHeight) / 3 * 2);
        }];
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(img2);
        }];
    }
    
    if (arrayImage.count == 3) {
        UIImageView* img1 = [[UIImageView alloc] init];
        img1.contentMode = contentModel;
        img1.tag = [arrayImage indexOfObject:arrayImage[0]]+100;
        img1.clipsToBounds = YES;
        [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1b2", arrayImage[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img1];
        [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewImage);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight) / 3 * 2 + cellImageHeight);
        }];
        
        UIImageView* img2 = [[UIImageView alloc] init];
        img2.contentMode = contentModel;
        img2.tag = [arrayImage indexOfObject:arrayImage[1]]+100;
        img2.clipsToBounds = YES;
        [img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1", arrayImage[1]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img2];
        [img2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.right.equalTo(viewImage);
            make.height.mas_equalTo((kScreenW - cellImageHeight) / 3);
        }];
        
        UIImageView* img3 = [[UIImageView alloc] init];
        img3.contentMode = contentModel;
        img3.tag = [arrayImage indexOfObject:arrayImage[2]]+100;
        img3.clipsToBounds = YES;
        [img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1", arrayImage[2]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img3];
        [img3 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.bottom.equalTo(img1);
            make.right.equalTo(viewImage);
            make.top.equalTo(img2.mas_bottom).offset(cellImageHeight); //((kScreenW-30)/3);
        }];
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(img3);
        }];
    }
    
    if (arrayImage.count == 4) {
        UIImageView* img1 = [[UIImageView alloc] init];
        img1.contentMode = contentModel;
        img1.tag = [arrayImage indexOfObject:arrayImage[0]]+100;
        img1.clipsToBounds = YES;
        [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1b2", arrayImage[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img1];
        [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewImage);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3 * 2 + cellImageHeight);
        }];
        
        UIImageView* img2 = [[UIImageView alloc] init];
        img2.contentMode = contentModel;
        img2.clipsToBounds = YES;
        img2.tag = [arrayImage indexOfObject:arrayImage[1]]+100;
        [img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[1]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img2];
        [img2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img3 = [[UIImageView alloc] init];
        img3.contentMode = contentModel;
        img3.clipsToBounds = YES;
        img3.tag = [arrayImage indexOfObject:arrayImage[2]]+100;
        [img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[2]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img3];
        [img3 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img2.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img4 = [[UIImageView alloc] init];
        img4.contentMode = contentModel;
        img4.clipsToBounds = YES;
        img4.tag = [arrayImage indexOfObject:arrayImage[3]]+100;
        [img4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1", arrayImage[3]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img4];
        [img4 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.bottom.equalTo(img1);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3 * 2 + cellImageHeight);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(img4);
        }];
    }
    
    if (arrayImage.count == 5) {
        UIImageView* img1 = [[UIImageView alloc] init];
        img1.contentMode = contentModel;
        img1.clipsToBounds = YES;
        img1.tag = [arrayImage indexOfObject:arrayImage[0]]+100;
        [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img1];
        [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewImage);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img11 = [[UIImageView alloc] init];
        img11.contentMode = contentModel;
        img11.clipsToBounds = YES;
        img11.tag = [arrayImage indexOfObject:arrayImage[4]]+100;
        [img11 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[4]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img11];
        [img11 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewImage);
            make.top.equalTo(img1.mas_bottom).offset(cellImageHeight);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img2 = [[UIImageView alloc] init];
        img2.contentMode = contentModel;
        img2.clipsToBounds = YES;
        img2.tag = [arrayImage indexOfObject:arrayImage[1]]+100;
        [img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[1]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img2];
        [img2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        
        UIImageView* img3 = [[UIImageView alloc] init];
        img3.contentMode = contentModel;
        img3.clipsToBounds = YES;
        img3.tag = [arrayImage indexOfObject:arrayImage[2]]+100;
        [img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[2]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img3];
        [img3 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img2.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img4 = [[UIImageView alloc] init];
        img4.clipsToBounds = YES;
        img4.tag = [arrayImage indexOfObject:arrayImage[3]]+100;
        img4.contentMode = contentModel;
        [img4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1", arrayImage[3]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img4];
        [img4 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.bottom.equalTo(img11);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3 * 2 + cellImageHeight);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(img4);
        }];
    }
    
    if (arrayImage.count == 6 || arrayImage.count == 9) {
        UIImageView* imgLast = nil;
        for (int i = 0; i < arrayImage.count; i++) {
            UIImageView* img1 = [[UIImageView alloc] init];
            img1.contentMode = contentModel;
            img1.clipsToBounds = YES;
            img1.tag = [arrayImage indexOfObject:arrayImage[i]]+100;
            [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[i]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
            [viewImage addSubview:img1];
            [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(viewImage).offset(i % 3 * ((kScreenW - cellImageHeight * 2) / 3 + cellImageHeight));
                make.top.equalTo(viewImage).offset(i / 3 * ((kScreenW - cellImageHeight * 2) / 3 + cellImageHeight));
                make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
                make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            }];
            imgLast = img1;
        }
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(imgLast);
        }];
    }
    
    if (arrayImage.count == 7) {
        UIImageView* img11 = [[UIImageView alloc] init];
        img11.contentMode = contentModel;
        img11.clipsToBounds = YES;
        img11.tag = [arrayImage indexOfObject:arrayImage[0]]+100;
        [img11 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[0]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img11];
        [img11 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewImage);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img12 = [[UIImageView alloc] init];
        img12.contentMode = contentModel;
        img12.clipsToBounds = YES;
        img12.tag = [arrayImage indexOfObject:arrayImage[1]]+100;
        [img12 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[1]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img12];
        [img12 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img11.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img13 = [[UIImageView alloc] init];
        img13.contentMode = contentModel;
        img13.clipsToBounds = YES;
        img13.tag = [arrayImage indexOfObject:arrayImage[2]]+100;
        [img13 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[2]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img13];
        [img13 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img12.mas_right).offset(cellImageHeight);
            make.top.equalTo(viewImage);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img1 = [[UIImageView alloc] init];
        img1.contentMode = contentModel;
        img1.clipsToBounds = YES;
        img1.tag = [arrayImage indexOfObject:arrayImage[3]]+100;
        [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!1b2", arrayImage[3]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img1];
        [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(viewImage);
            make.top.equalTo(img11.mas_bottom).offset(cellImageHeight);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3 * 2 + cellImageHeight);
        }];
        
        UIImageView* img2 = [[UIImageView alloc] init];
        img2.contentMode = contentModel;
        img2.clipsToBounds = YES;
        img2.tag = [arrayImage indexOfObject:arrayImage[4]]+100;
        [img2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[4]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img2];
        [img2 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.top.equalTo(img1);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img3 = [[UIImageView alloc] init];
        img3.contentMode = contentModel;
        img3.clipsToBounds = YES;
        img3.tag = [arrayImage indexOfObject:arrayImage[5]]+100;
        [img3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1", arrayImage[5]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img3];
        [img3 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img2.mas_right).offset(cellImageHeight);
            make.top.equalTo(img1);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        UIImageView* img4 = [[UIImageView alloc] init];
        img4.contentMode = contentModel;
        img4.clipsToBounds = YES;
        img4.tag = [arrayImage indexOfObject:arrayImage[6]]+100;
        [img4 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[6]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:img4];
        [img4 mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(img1.mas_right).offset(cellImageHeight);
            make.bottom.equalTo(img1);
            make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3 * 2 + cellImageHeight);
            make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
        }];
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(img4);
        }];
    }
    
    if (arrayImage.count == 8) {
        UIImageView* imgLast = nil;
        for (int i = 0; i < arrayImage.count - 1; i++) {
            UIImageView* img1 = [[UIImageView alloc] init];
            img1.clipsToBounds = YES;
            img1.tag = [arrayImage indexOfObject:arrayImage[i]]+100;
            img1.contentMode = contentModel;
            [img1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!450a", arrayImage[i]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
            [viewImage addSubview:img1];
            [img1 mas_makeConstraints:^(MASConstraintMaker* make) {
                if (i %3 == 0) {
                    make.left.mas_equalTo(0);
                } else {
                    make.left.mas_equalTo(imgLast.mas_right).offset(cellImageHeight);
                }
                make.top.equalTo(viewImage).offset(i / 3 * ((kScreenW - cellImageHeight * 2) / 3) + (cellImageHeight * (i / 3)));
                make.width.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
                make.height.mas_equalTo((kScreenW - cellImageHeight * 2) / 3);
            }];
            imgLast = img1;
        }
        
        UIImageView* imgLastOne = [[UIImageView alloc] init];
        imgLastOne.contentMode = contentModel;
        imgLastOne.clipsToBounds = YES;
        imgLastOne.tag = [arrayImage indexOfObject:arrayImage[7]]+100;
        [imgLastOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!2b1", arrayImage[7]]] placeholderImage:[UIImage imageNamed:@"icon_Default_Product"]];
        [viewImage addSubview:imgLastOne];
        [imgLastOne mas_makeConstraints:^(MASConstraintMaker* make) {
            make.left.equalTo(imgLast.mas_right).offset(cellImageHeight);
            make.right.equalTo(viewImage.mas_right);
            make.top.equalTo(imgLast);
            make.height.mas_equalTo(imgLast);
        }];
        
        [viewImage mas_makeConstraints:^(MASConstraintMaker* make) {
            make.bottom.equalTo(imgLastOne);
        }];
    }
}

- (NSString*)changeTime:(NSString*)time
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.intValue];
    return [formatter stringFromDate:confromTimesp];
}


//赞点击事件
- (void)btnZan_CLick
{
    if (![(HViewController*)self.containingViewController isNavLogin]) {
        return;
    }
    
    if ([_model.isLiked isEqualToString:@"1"]) {
        //取消点赞
        _model.isLiked = @"0";
        lblZan.text = [NSString stringWithFormat:@"%d",lblZan.text.intValue - 1];
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_zan"] forState:UIControlStateNormal];
        [self cancelZan];
    }else {
        //点赞
        _model.isLiked = @"1";
        lblZan.text = [NSString stringWithFormat:@"%d", lblZan.text.intValue + 1];
        [btnZan setImage:[UIImage imageNamed:@"icon_appraisal_Azan"] forState:UIControlStateNormal];
        [self Zan];
    }
}

//取消点赞
- (void)cancelZan
{
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID?:@"0",
                            @"topicid" : _model.id };
    //    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"delliketopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hide:YES];
                  }];
}

//赞
- (void)Zan
{
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    NSDictionary* dict = @{ @"cuid" : [Global sharedInstance].userID?:@"0",
                            @"topicid" : _model.id };
    //    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"liketopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hide:YES];
        ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hide:YES];
                  }];
}

//关注按钮点击事件
- (void)btnguanzhu_Click
{
    //是否关注
    if ([_model.isfollow isEqualToString:@"1"]) {
        //取消关注
        _model.isfollow = @"0";
        btnguanzhu.selected = NO;
        [self quxiaoguanzhu];
    }
    else {
        //关注
        _model.isfollow = @"1";
        btnguanzhu.selected = YES;
        btnguanzhu.hidden = YES;
        [self addGuanzhu];
    }
}

//取消关注
- (void)quxiaoguanzhu
{
    if (![(HViewController*)self.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"tuid" : _model.postuid };
    
    //    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"delaction" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hideAnimated:YES];
        ResultModel* result = [ResultModel mj_objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     if ([superView respondsToSelector:@selector(reloadData)]) {
                         [superView reloadData];
                     }
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hideAnimated:YES];
                  }];
}

//添加关注
- (void)addGuanzhu
{
    if (![(HViewController*)self.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"tuid" : _model.postuid };
    
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"addaction" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hide:YES];
        ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     
                 }andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hide:YES];
                  }];
}

- (void)jubao
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"请输入举报内容" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    [dialog show];
}

- (void)shoucang
{
    if (![(HViewController*)self.containingViewController isNavLogin]) {
        return;
    }
    
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"正在收藏" SubTitle:nil];
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"topicid" : _model.id };
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"collecttopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hide:YES];
        ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [superView.hudLoading hide:YES];
                     [superView showOkHUDWithTitle:@"收藏成功" SubTitle:nil Complete:nil];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hide:YES];
                  }];
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
    NSDictionary* dict = @{ @"uid" : [Global sharedInstance].userID?:@"0",
                            @"tid" : _model.id,
                            @"reason" : nameField.text ?: @"" };
    //2.开始请求
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"denounce" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hide:YES];
        ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [superView.hudLoading hide:YES];
                     [superView showOkHUDWithTitle:@"举报成功" SubTitle:nil Complete:nil];
                 }
                  andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hide:YES];
                  }];
}
//删除动态
- (void)deleteDongtai
{
    //1.设置请求参数
    HPageViewController* superView = (HPageViewController*)self.containingViewController;
    [superView showLoadingHUDWithTitle:@"删除中" SubTitle:nil];
    NSString* userId=@"";
    if ([Global sharedInstance].userID.length>0) {
        userId = [Global sharedInstance].userID;
    }
    NSDictionary* dict = @{ @"uid" : userId?:@"0",
                            @"topicid" : _model.id };
    //2.开始请求
    
    HHttpRequest* request = [[HHttpRequest alloc] init];
    [request httpPostRequestWithActionName:@"deltopic" andPramater:dict andDidDataErrorBlock:^(NSURLSessionTask* operation, id responseObject) {
        [superView.hudLoading hide:YES];
        ResultModel* result = [ResultModel objectWithKeyValues:responseObject];
        [superView showErrorHUDWithTitle:result.msg SubTitle:nil Complete:nil];
    }
                 andDidRequestSuccessBlock:^(NSURLSessionTask* operation, id responseObject) {
                     [superView.hudLoading hide:YES];
                     if ([superView respondsToSelector:@selector(reloadData)]){
                         [superView reloadData];
                     }else{
                         [self.delate deleteBtnClick];
                     }
                }andDidRequestFailedBlock:^(NSURLSessionTask* operation, NSError* error) {
                      [superView.hudLoading hide:YES];
                  }];
}
//更多按钮点击事件（耿园园12345678）
- (void)btnMore_Click
{
//    OSMessage* msg = [[OSMessage alloc] init];
//    NSInteger toptc = [_topictype integerValue];
//    switch (toptc) {
//        case 1:
//        {
//            NSString* strCangpinResult = @"";
//            
//            switch (self.topicModel.status.intValue) {
//                case 1: {
//                    strCangpinResult = @"真";
//                } break;
//                case 2: {
//                    strCangpinResult = @"假";
//                } break;
//                case 3: {
//                    strCangpinResult = @"无法鉴定";
//                } break;
//                case 4: {
//                    strCangpinResult = @"未鉴定";
//                } break;
//                default:
//                    break;
//            }
//            
//            msg.title = [NSString stringWithFormat:@"「%@」%@ %@  【盛典鉴宝】", self.topicModel.topictitle, self.topicModel.message, strCangpinResult];
//            msg.desc = [NSString stringWithFormat:@"「%@」%@ %@  【盛典鉴宝】", self.topicModel.topictitle, self.topicModel.message, strCangpinResult];
//        }
//            break;
//        case 2:
//        {
//            msg.title = [NSString stringWithFormat:@"%@ ",self.topicModel.message];
//            msg.desc = [NSString stringWithFormat:@"%@ ",self.topicModel.message];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 4:
//        {
//            msg.title = [NSString stringWithFormat:@"%@ | %@ ",self.topicModel.gtype,self.topicModel.topictitle];
//            msg.desc = [NSString stringWithFormat:@"%@ | %@ ",self.topicModel.gtype,self.topicModel.topictitle];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 6:
//        {
//            NSString*string =self.topicModel.alt;
//            string = [string substringFromIndex:7];
//            msg.title = [NSString stringWithFormat:@"「%@作品」 %@ | %@ | %@ X %@ X %@ cm ",_model.user.username,
//                         self.topicModel.topictitle,self.topicModel.age,self.topicModel.width,self.topicModel.height,self.topicModel.longstr];
//            msg.desc = [NSString stringWithFormat:@"「%@作品」 %@ | %@ | %@ X %@ X %@ cm ",_model.user.username,
//                        self.topicModel.topictitle,self.topicModel.age,self.topicModel.width,self.topicModel.height,self.topicModel.longstr];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 7:
//        {
//            msg.title = [NSString stringWithFormat:@"「%@近况」%@ ",_model.user.username,
//                         self.topicModel.message];
//            msg.desc = [NSString stringWithFormat:@"「%@近况」%@ ",_model.user.username,
//                        self.topicModel.message];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 8:
//        {
//          
//            msg.title = [NSString stringWithFormat:@"%@ | %@ | %@ | %@ ",
//                         self.topicModel.topictitle,self.topicModel.starttime,self.topicModel.city,self.topicModel.address];
//            msg.desc = [NSString stringWithFormat:@"%@ | %@ | %@ | %@ ",
//                        self.topicModel.topictitle,self.topicModel.starttime,self.topicModel.city,self.topicModel.address];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 9:
//        {
//
//            msg.title = [NSString stringWithFormat:@"%@ | 作者: %@ ",
//                         self.topicModel.topictitle,self.topicModel.peopleUserName];
//            msg.desc = [NSString stringWithFormat:@"%@ | 作者: %@ ",
//                        self.topicModel.topictitle,self.topicModel.peopleUserName];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//            
//        case 12:
//        {
//            msg.title = [NSString stringWithFormat:@"%@ ",
//                         self.topicModel.message];
//            msg.desc = [NSString stringWithFormat:@"%@ ",
//                        self.topicModel.message];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 13:
//        {
//            msg.title = [NSString stringWithFormat:@"「%@艺术年表」%@ ",_model.user.username,
//                         self.topicModel.message];
//            msg.desc = [NSString stringWithFormat:@"「%@艺术年表」%@ ",_model.user.username,
//                        self.topicModel.message];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 14:
//        {
//            
//           
//            msg.title = [NSString stringWithFormat:@"「%@获奖」%@ | %@ | %@ | 获奖作品：%@ ",_model.user.username,
//                         self.topicModel.age,self.topicModel.topictitle,self.topicModel.award,self.topicModel.message];
//            msg.desc = [NSString stringWithFormat:@"「%@获奖」%@ | %@ | %@ | 获奖作品：%@",_model.user.username,
//                        self.topicModel.age,self.topicModel.topictitle,self.topicModel.award,self.topicModel.message];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 15:
//        {
//            
//            
//            msg.title = [NSString stringWithFormat:@"时间：%@ | 机构：%@ | 作品：%@ ",
//                         self.topicModel.age,self.topicModel.source,self.topicModel.message];
//            msg.desc = [NSString stringWithFormat:@"时间：%@ | 机构：%@ | 作品：%@",
//                        self.topicModel.age,self.topicModel.source,self.topicModel.message];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 17:
//        {
//    
//            msg.title = [NSString stringWithFormat:@"%@ | %@ ",
//                         self.topicModel.source,self.topicModel.topictitle];
//            msg.desc = [NSString stringWithFormat:@"%@ | %@ ",
//                        self.topicModel.source,self.topicModel.topictitle];
//            if (self.topicModel.photoscbk.count > 0) {
//                photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//                msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//            }
//        }
//            break;
//        case 18:
//        {
//            
//            msg.title = [NSString stringWithFormat:@"「%@出版著作」 | %@ | %@ | %@ ",_model.user.username,
//                         self.topicModel.age,self.topicModel.topictitle,self.topicModel.message];
//            msg.desc = [NSString stringWithFormat:@"「%@出版著作」 | %@ | %@ | %@ ",_model.user.username,
//                        self.topicModel.age,self.topicModel.topictitle,self.topicModel.message];
//        }
//            break;
//            
//    }
//     [Global sharedInstance].publishId=self.topicModel.user.uid;
//     HShareVC *shareVc = [[HShareVC alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
//    shareVc.msg = msg;
//    if (self.topicModel.photoscbk.count > 0) {
//        photoscbkModel *photoscbkModel = [self.topicModel.photoscbk objectOrNilAtIndex:0];
//        msg.image = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoscbkModel.photo]];
//        shareVc.shareimage= [UIImage imageWithData:msg.image];
//    }else
//    {
//        shareVc.shareimage=[UIImage imageNamed:@"icon_share12"];
//    }
//    shareVc.sharetitle=msg.title;
//    shareVc.sharedes=msg.desc;
//    shareVc.shareurl=self.topicModel.alt;
//    shareVc.msg = msg;
//   
//    shareVc.deleteEdit = YES;
//    shareVc.userID = self.topicModel.user.uid;
//    [shareVc setSelectJubaoCilck:^{
//        //举报功能
//        NSLog(@"举报");
//        [self jubao];
//    }];
//    [shareVc setSelectShoucangCilck:^{
//        //收藏功能
//        NSLog(@"收藏");
//        [self shoucang];
//    }];
//    [shareVc setSelectShanchuCilck:^{
//        //删除功能
//        NSLog(@"删除");
//        [self deleteDongtai];
//    }];
//    
//    [shareVc setSelectDingzhiCilck:^{
//        [self.manager zhidingBtnClick];
//    }];
//    [shareVc setSelectEditClick:^{
//        NSLog(@"编辑");
//        NSMutableArray *imageList = [[NSMutableArray alloc] init];
//        for (int i = 0; i < [viewImage subviews].count; i ++) {
//            UIImageView *imageView = [viewImage viewWithTag:i+100];
//            [imageList addObject:imageView.image];
//        }
//        PublishDongtaiVC *vc = [[PublishDongtaiVC alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.isEdit = YES;
//        vc.topicid = self.model.id;
//        vc.selectedType = self.model.arttype;
//        if (toptc==8) {
//            vc.age = self.model.starttime;
//        }else
//        {
//          vc.age = self.model.age;
//        }
//        vc.longstr = self.model.longstr;
//        vc.width = self.model.width;
//        vc.height = self.model.height;
//        vc.format = self.model.caizhi;
//        id resobject = self.model.source;
//        if([resobject isKindOfClass:[NSDictionary class]]){
//           vc.source = self.model.source[@"username"];
//            
//        }else{
//            vc.source = self.model.source;
//        };
//        vc.message = self.model.message;
//        vc.city = self.model.city;
//        vc.name = self.model.topictitle;
//        vc.planner = self.model.planner;
//        vc.address = self.model.address;
//        vc.award = self.model.award;
//        
//        id resobject1 = self.model.people;
//        if([resobject1 isKindOfClass:[NSDictionary class]]){
//            vc.people = self.model.people[@"username"];
//            
//        }else{
//            vc.people = self.model.people;
//        };
//        vc.topictype = self.model.topictype;
//        if ([self.model.video stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
//            vc.videoArray = [self.model.video componentsSeparatedByString:@","];
//        }
//        vc.selectedImageList = imageList;
//        vc.arrayRecorderSave = [self stringToJSON:self.model.audio].mutableCopy;
//        vc.photos = [self.model.photos componentsSeparatedByString:@","].mutableCopy;
//        NSLog(@"222222----%@",vc.photos);
//        [self.containingViewController.navigationController pushViewController:vc animated:YES];
//    }];
//    
//    [shareVc showShareView];
}

- (void)setState:(NSString*)state
{
    if ([state isEqualToString:@"1"]) {
        btnguanzhu.backgroundColor = kWhiteColor;
        btnguanzhu.layer.masksToBounds = YES;
        btnguanzhu.layer.cornerRadius = 5;
    }
}

- (void)btnCommit_Click
{
    HomeListDetailVc* detailVC = [[HomeListDetailVc alloc]init];
    detailVC.topicid = _model.id;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.containingViewController.navigationController pushViewController:detailVC animated:YES];
}

- (void)tapVideo_Click:(UITapGestureRecognizer*)tapVideo
{
//     播放视频
    PlayerViewController* vc = [[PlayerViewController alloc] init];
    vc.videoID = arrayVideoID[tapVideo.view.tag];
    [self.containingViewController.navigationController pushViewController:vc animated:YES];
}
@end
