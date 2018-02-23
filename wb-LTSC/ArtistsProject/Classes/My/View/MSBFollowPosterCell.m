//
//  MSBFollowPosterCell.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBFollowPosterCell.h"
#import "GeneralConfigure.h"

@interface MSBFollowPosterCell ()
@property(nonatomic,strong) UILabel *messageLab;
@property (nonatomic, strong) UILabel *timeLab;

@property(nonatomic,strong) UIButton *praiseBtn;

@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UILabel *articleLab;
@property(nonatomic,strong) UIImageView *iconImageView;

@property(nonatomic,strong) UIView *lineView;

@end

@implementation MSBFollowPosterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.lineView.dk_backgroundColorPicker = CellLineColor;
        self.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x222222, 0xfafafa);
        
        [self.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self.bottomView addGestureRecognizer:tap];

    }
    return self;
}

- (void)dealloc{
    if (self.messageLab) {
        self.messageLab.attributedText = nil;
    }
    
    if (self.timeLab) {
        self.timeLab.text = nil;
    }
    
    if (self.articleLab) {
        self.articleLab.text = nil;
    }
    
    if (self.praiseBlock) {
        self.praiseBlock = nil;
    }
}

- (void)praiseBtnClick:(UIButton *)btn{
    if (self.praiseBlock) {
        self.praiseBlock(btn);
    }
}

- (void)tapClick{
    if (self.articleBlock) {
        self.articleBlock();
    }
}

- (void)setModel:(MSBUserFollowPoster *)item{
    self.timeLab.text = item.comment_time;
    self.messageLab.text = item.comment_content;
    self.articleLab.text = item.post_title;
    self.praiseBtn.selected = item.praise;
    if (item.praise) {
        [self.praiseBtn setTitle:@"1" forState:UIControlStateSelected];
    }else{
        [self.praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    }
}

+ (CGFloat)rowHeight:(MSBUserFollowPoster *)item
           cellWidth:(CGFloat)cellWidth{
    CGFloat h;
    
    NSAttributedString *attribute = [self createAttribute:item.comment_content];
    h = attribute == nil ? 0 : ([attribute boundingRectWithSize:(CGSize){cellWidth - 30, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height);
    return h + 100.f;
}

#pragma mark - Private Methods
+ (NSAttributedString *)createAttribute:(NSString *)content{
    if ([NSString isNull:content]) {
        return nil;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2.f;
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:content];
    
    [attributeStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(102.f, 102.f, 102.f)} range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attributeStr.length)];
    return attributeStr;
}

#pragma mark - setter/getter
- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] init];
        [_messageLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_messageLab setFont:[UIFont systemFontOfSize:15.f]];
        _messageLab.dk_textColorPicker = DKColorPickerWithRGB(0x1d1d26, 0x989898);
        [_messageLab setNumberOfLines:0];
        [self.contentView addSubview:_messageLab];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_messageLab]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_messageLab)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.timeLab attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f]];
    }
    return _messageLab;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeLab setFont:[UIFont systemFontOfSize:12.f]];
//        [_timeLab setTextColor:RGBALCOLOR(29 , 29, 38,0.6)];
         _timeLab.dk_textColorPicker = DKColorPickerWithRGB(0x1d1d26, 0x989898);
        [self.contentView addSubview:_timeLab];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f]
                                           ]];
    }
    return _timeLab;
}

- (UIButton *)praiseBtn{
    if (!_praiseBtn) {
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_praiseBtn setTitle:@"0" forState:UIControlStateNormal];
        [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_praiseBtn dk_setTitleColorPicker:DKColorPickerWithRGB(0x1d1d26, 0x989898) forState:UIControlStateNormal];
        [_praiseBtn.imageView setContentMode:UIViewContentModeCenter];
        [_praiseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [_praiseBtn setImage:[UIImage imageNamed:@"info_icon_praise"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"info_icon_praise_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:_praiseBtn];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.timeLab attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15.f]
                                           ]];
    }
    return _praiseBtn;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        [_bottomView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_bottomView setClipsToBounds:YES];
        [_bottomView.layer setCornerRadius:13.5f];
        _bottomView.layer.dk_borderColorPicker = DKColorPickerWithRGB(0xbbbbbd, 0x282828);
        [_bottomView.layer setBorderWidth:0.5f];
         _bottomView.dk_backgroundColorPicker =  DKColorPickerWithKey(BG);
        [self.contentView addSubview:_bottomView];
         [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_bottomView]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomView)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageLab attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_bottomView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:27.f]
                                           ]];
    }
    return _bottomView;
}

- (UILabel *)articleLab{
    if (!_articleLab) {
        _articleLab = [[UILabel alloc] init];
        [_articleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_articleLab setFont:[UIFont systemFontOfSize:12.f]];
        [_articleLab setNumberOfLines:1];
//        [_articleLab setTextColor:RGBALCOLOR(29 , 29, 38,0.6)];
        _articleLab.dk_textColorPicker = DKColorPickerWithRGB(0x1d1d26, 0x989898);
        [self.bottomView addSubview:_articleLab];
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_articleLab]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_articleLab)]];
        [self.bottomView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_articleLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeLeading multiplier:1 constant:6.f],
                                          [NSLayoutConstraint constraintWithItem:_articleLab attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-6.f]
                                          ]];
    }
    return _articleLab;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_iconImageView setContentMode:UIViewContentModeCenter];
        [_iconImageView setImage:[UIImage imageNamed:@"icon_info_arrow"]];
        [self.bottomView addSubview:_iconImageView];
        [self.bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_iconImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_iconImageView)]];
        [self.bottomView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-6.f],
                                           [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:8.f]
                                           ]];
    }
    return _iconImageView;

}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [_lineView setBackgroundColor:RGBALCOLOR(210, 210, 210, 0.75)];
        [self.contentView addSubview:_lineView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lineView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_lineView)]];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f],
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0.5f]
                                           ]];
    }
    return _lineView;
}
@end
