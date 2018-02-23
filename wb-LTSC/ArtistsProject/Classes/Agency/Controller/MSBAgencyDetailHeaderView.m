//
//  MSBAgencyDetailHeaderView.m
//  meishubao
//
//  Created by T on 16/12/26.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBAgencyDetailHeaderView.h"
#import "GeneralConfigure.h"

#define kBtnW ((SCREEN_WIDTH - 60)/4)

/**MSBAgencyDetailHeaderView*/
@interface MSBAgencyDetailHeaderView ()<SDCycleScrollViewDelegate, UITextFieldDelegate>
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) SDCycleScrollView *sdCycleScrollView;
@property(nonatomic,strong) UILabel *messageLab;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIView *searchBar;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *tipLab;

//@property(nonatomic,strong) MSBSearchView *searchBar;

/*
@property(nonatomic,strong) UIButton *showBtn;
@property(nonatomic,strong) UIButton *adviceBtn;
@property(nonatomic,strong) UIButton *startTimeBtn;
@property(nonatomic,strong) UIButton *endTimeBtn;
//*/

@end

@implementation MSBAgencyDetailHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        
        /*
        [self.showBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [self.adviceBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [self.endTimeBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [self.startTimeBtn addTarget:self action:@selector(showBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //*/
         
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self.searchBar addGestureRecognizer:tapGes];

    }
    return self;
}

- (void)dealloc{
    if (self.searchBlock) {
        self.searchBlock = nil;
    }
    if (self.btnClickBlock) {
        self.btnClickBlock = nil;
    }
}


- (void)setImages:(NSArray *)images message:(NSString *)message{
    /**
    self.sdCycleScrollView.imageURLStringsGroup = images;
    self.messageLab.attributedText = [self createTitleAttribute:message];
     //*/
    
    
    //**
   self.sdCycleScrollView.imageURLStringsGroup = @[@"http://img1.360buyimg.com/da/jfs/t4117/299/779221198/62627/2e97117e/585c8e21N3ebe875d.jpg.webp"];
   self.messageLab.attributedText = [self createTitleAttribute:@"既要温暖过冬，又要蓝天白云，这是北方人民群众普遍关心的突出问题。这一举措体现了党中央以人民为中心的发展思想，想群众之所想、急群众之所急、解群众之所困。”国家能源局电力司司长黄学农说。既要温暖过冬，又要蓝天白云，这是北方人民群众普遍关心的突出问题。这一举措体现了党中央以人民为中心的发展思想，想群众之所想、急群众之所急、解群众之所困。”国家能源局电力司司长黄学农说。"];
      //*/
    
    self.iconImageView.dk_imagePicker = DKImagePickerWithNames(@"category_search",@"category_search_dark",@"category_search_dark");
    [self.tipLab setText:@"搜索关键字"];
    
}

- (void)tapClick{
    NSLog(@"tapClick");
    if (self.searchBlock) {
        self.searchBlock();
    }
}

- (void)showBtnClick:(UIButton *)btn{
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    switch (btn.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        default:
            break;
    }
}

- (UIView *)topView{
    if (_topView == nil) {
        _topView = [UIView new];
        [_topView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _topView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xE2E2E2, 0x222222, 0xfafafa);
        [self addSubview:_topView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_topView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_topView)]];
        [self addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_topView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:260.f]
                                           ]];

    }
    return _topView;
}

- (SDCycleScrollView *)sdCycleScrollView{
    if (_sdCycleScrollView == nil) {
        _sdCycleScrollView = [[SDCycleScrollView alloc] init];
        [_sdCycleScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _sdCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdCycleScrollView.autoScrollTimeInterval = 3.0f;
        _sdCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
          _sdCycleScrollView.delegate = self;
        _sdCycleScrollView.placeholderImage = [UIImage imageNamed:@"sd_scroll_bg"];
        [self.topView addSubview:_sdCycleScrollView];
        [self.topView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sdCycleScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_sdCycleScrollView)]];
        [self.topView addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_sdCycleScrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTop multiplier:1 constant:0.f],
                               [NSLayoutConstraint constraintWithItem:_sdCycleScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:150.f]
                               ]];
    }
    return _sdCycleScrollView;
}

- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [UILabel new];
        [_messageLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        _messageLab.dk_textColorPicker = DKColorPickerWithRGB(0x030303, 0x989898);
        [_messageLab setFont:[UIFont systemFontOfSize:14]];
        [_messageLab setNumberOfLines:5.f];
        [_messageLab setBackgroundColor:[UIColor clearColor]];
        [self.topView addSubview:_messageLab];
        [self.topView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
                                           [NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.sdCycleScrollView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15.f]
                                           ]];

    }
    return _messageLab;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [UIView new];
        [_bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
         _bottomView.dk_backgroundColorPicker = DKColorPickerWithRGB(0xE2E2E2, 0x222222, 0xfafafa);
        [self addSubview:_bottomView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomView)]];
        
#pragma mark - warning   90
        [self addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                               [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:45.f]
                               ]];
        
    }
    return _bottomView;
}

- (UIView *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UIView alloc] init];
        [_searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.bottomView addSubview:_searchBar];
        _searchBar.layer.dk_borderColorPicker = DKColorPickerWithRGB(0xbfbfbf, 0x282828);
        _searchBar.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _searchBar.layer.borderWidth = 0.5;
        _searchBar.layer.cornerRadius = 3.f;
        _searchBar.clipsToBounds = YES;
        
        [self.bottomView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
                                           [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:(SCREEN_WIDTH - 30)],
                                          [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_searchBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30.f]
                                          ]];
    }
    return _searchBar;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_iconImageView setContentMode:UIViewContentModeCenter];
        [_iconImageView setUserInteractionEnabled:YES];
        [self.searchBar addSubview:_iconImageView];
        [self.searchBar addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                               [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeLeading multiplier:1 constant:5.f],
                               [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:25.f],
                               [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:25.f]
                               ]];
        
    }
    return _iconImageView;
}

- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [UILabel new];
        [_tipLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        _tipLab.dk_textColorPicker = DKColorPickerWithRGB(0x989898, 0x989898);
        [_tipLab setFont:[UIFont systemFontOfSize:14]];
        [_tipLab setBackgroundColor:[UIColor clearColor]];
        [_tipLab setUserInteractionEnabled:YES];
        [_tipLab setText:@"搜索关键字"];
        [self.searchBar addSubview:_tipLab];
        [self.searchBar addConstraints:@[
                               [NSLayoutConstraint constraintWithItem:_tipLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:5.f],
                               [NSLayoutConstraint constraintWithItem:_tipLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                               ]];
        
    }
    return _tipLab;
}


/*
- (UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
         [_showBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x989898, 0x989898) forState:UIControlStateNormal];
        _showBtn.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x000000);
        [_showBtn setTitle:@"展览" forState:UIControlStateNormal];
        [_showBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_showBtn setTag:1];
        [_showBtn.layer setCornerRadius:3.f];
        [_showBtn setClipsToBounds:YES];
        
//        CGFloat imageWidth = 11;
//        CGFloat imageHeight = 7;
//        CGFloat labelWidth = [_showBtn.titleLabel.text sizeWithFont:_showBtn.titleLabel.font].width;
//        CGFloat labelHeight = [_showBtn.titleLabel.text sizeWithFont:_showBtn.titleLabel.font].height;
////
//        CGFloat spacing = 2;
//        _showBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
//        _showBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
        
//        _showBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
//        _showBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
        
        [_showBtn setImage:[UIImage imageNamed:@"detail_down_btn"] forState:UIControlStateNormal];
        
         [_showBtn setImagePosition:LXMImagePositionRight spacing:2];
        [self.bottomView addSubview:_showBtn];
        [self.bottomView addConstraints:@[
                                         [NSLayoutConstraint constraintWithItem:_showBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
                                         [NSLayoutConstraint constraintWithItem:_showBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_showBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:kBtnW-10],
                                          [NSLayoutConstraint constraintWithItem:_showBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30]
                                         ]];
    }
    return _showBtn;
}

- (UIButton *)adviceBtn{
    if (!_adviceBtn) {
        _adviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_adviceBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_adviceBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x989898, 0x989898) forState:UIControlStateNormal];
        _adviceBtn.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x000000);
        [_adviceBtn setTitle:@"咨询" forState:UIControlStateNormal];
        [_adviceBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_showBtn setTag:2];
        [_adviceBtn.layer setCornerRadius:3.f];
        [_adviceBtn setClipsToBounds:YES];
        
        [_adviceBtn setImage:[UIImage imageNamed:@"detail_down_btn"] forState:UIControlStateNormal];
        
        [_adviceBtn setImagePosition:LXMImagePositionRight spacing:2];
        [self.bottomView addSubview:_adviceBtn];
        [self.bottomView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_adviceBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.showBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_adviceBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_adviceBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:kBtnW-10],
                                          [NSLayoutConstraint constraintWithItem:_adviceBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30]
                                          ]];
    }
    return _adviceBtn;
}

- (UIButton *)startTimeBtn{
    if (!_startTimeBtn) {
        _startTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startTimeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_startTimeBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x989898, 0x989898) forState:UIControlStateNormal];
        _startTimeBtn.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x000000);
        [_startTimeBtn setTitle:@"开始时间" forState:UIControlStateNormal];
        [_startTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_startTimeBtn setTag:3];
        [_startTimeBtn.layer setCornerRadius:3.f];
        [_startTimeBtn setClipsToBounds:YES];
        
        [_startTimeBtn setImage:[UIImage imageNamed:@"detail_down_btn"] forState:UIControlStateNormal];
        
        [_startTimeBtn setImagePosition:LXMImagePositionLeft spacing:2];
        [self.bottomView addSubview:_startTimeBtn];
        [self.bottomView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_startTimeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.adviceBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_startTimeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_startTimeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:kBtnW+10],
                                          [NSLayoutConstraint constraintWithItem:_startTimeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30]
                                          ]];
    }
    return _startTimeBtn;
}

- (UIButton *)endTimeBtn{
    if (!_endTimeBtn) {
        _endTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endTimeBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_endTimeBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x989898, 0x989898) forState:UIControlStateNormal];
        _endTimeBtn.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x000000);
        [_endTimeBtn setTitle:@"结束时间" forState:UIControlStateNormal];
        [_endTimeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_endTimeBtn setTag:4];
        [_endTimeBtn.layer setCornerRadius:3.f];
        [_endTimeBtn setClipsToBounds:YES];
        
        [_endTimeBtn setImage:[UIImage imageNamed:@"detail_down_btn"] forState:UIControlStateNormal];
        
        [_endTimeBtn setImagePosition:LXMImagePositionLeft spacing:2];
        [self.bottomView addSubview:_endTimeBtn];
        [self.bottomView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_endTimeBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.startTimeBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_endTimeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                          [NSLayoutConstraint constraintWithItem:_endTimeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:kBtnW+10],
                                          [NSLayoutConstraint constraintWithItem:_endTimeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30]
                                          ]];
    }
    return _endTimeBtn;
}
//*/

- (NSAttributedString *)createTitleAttribute:(NSString *)title{
    
    if ([NSString isNull:title]) {
        return nil;
    } else {
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
        [attributeString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, attributeString.length)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 2.f;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        [attributeString addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributeString.length)];
        
        return attributeString;
    }
}


@end
