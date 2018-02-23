//
//  MSBPersonCenterFollowCell.m
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPersonCenterFollowCell.h"
#import "GeneralConfigure.h"

@interface MSBPersonCenterFollowCell ()
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *titleLab;
@property(nonatomic,strong) UIView *lineView;


@property(nonatomic,strong) UILabel *messageLab;
@property (nonatomic, strong) UILabel *articleLab;

@property(nonatomic,strong) UIButton *commentBtn;
@property(nonatomic,strong) UIButton *praiseBtn;
@end

@implementation MSBPersonCenterFollowCell

- (instancetype)init{
    if (self == [super init]) {
        [self.contentView setBackgroundColor:RGBCOLOR(240, 240, 240)];
        
        [self.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)praiseBtnClick:(UIButton *)btn{
    
}

- (void)commentBtnClick:(UIButton *)btn{
    
}

- (void)setModel:(NSDictionary *)item{
    MSBUser *user = [MSBAccount getUser];
    
    if (user.avarImage) {
        [self.iconImageView setImage:user.avarImage];
    }else{
        [self.iconImageView setImage:[UIImage imageNamed:@"people_collection_cell"]];
    }
    
    if (user.nickname) {
        [self.titleLab setText:user.nickname];
    }else{
        [self.titleLab setText:@"行走的画家"];
    }
    
    [self.messageLab setText:item[@"message"]];
    
    [self.articleLab setText:item[@"article"]];
    
    [self.praiseBtn setTitle:@"10" forState:UIControlStateNormal];
    [self.commentBtn setTitle:@"10" forState:UIControlStateNormal];
    
    [self.lineView setBackgroundColor:RGBALCOLOR(200, 199, 204, 1)];
}

+ (CGFloat)rowHeight:(NSDictionary *)item
           cellWidth:(CGFloat)cellWidth{
    CGFloat h1;
    CGFloat h2;
    NSAttributedString *attributeMessage = [self createAttribute:item[@"message"]];
    h1 = attributeMessage == nil ? 0 : ([attributeMessage boundingRectWithSize:(CGSize){cellWidth - 30, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height);
    
    NSAttributedString *attributeArticle = [self createAttribute:item[@"article"]];
    h2 = attributeArticle == nil ? 0 : ([attributeArticle boundingRectWithSize:(CGSize){cellWidth - 30, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height);
    
    return h1 + h2 + 70.f;
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

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [_iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_iconImageView setImage:[UIImage imageNamed:@"people_collection_cell"]];
        [_iconImageView.layer setCornerRadius:14];
        [_iconImageView.layer setBorderColor:RGBALCOLOR(181, 27, 32, 1.0f).CGColor];
        [_iconImageView.layer setBorderWidth:0.5f];
        [_iconImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_iconImageView setClipsToBounds:YES];
        [self.contentView addSubview:_iconImageView];
        [self.contentView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:15.f],
                                          [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:28.f],
                                          [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:28.f],
                                          [NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10.f]
                                          ]];
    }
    return _iconImageView;
    
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        [_titleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLab setFont:[UIFont systemFontOfSize:14.f]];
        [_titleLab setTextColor:RGBCOLOR(0, 46, 103)];
        [_titleLab setNumberOfLines:0];
        [self.contentView addSubview:_titleLab];
        UIView *image = self.iconImageView;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-7-[_titleLab]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(image,_titleLab)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f]];
    }
    return _titleLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [_lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_lineView setBackgroundColor:RGBALCOLOR(200, 199, 204, 1)];
        [self.contentView addSubview:_lineView];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLab attribute:NSLayoutAttributeBottom multiplier:1 constant:6.f],
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.titleLab attribute:NSLayoutAttributeLeading multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15.f],
                                           [NSLayoutConstraint constraintWithItem:_lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:0.5f]
                                           ]];
    }
    return _lineView;
}

- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc] init];
        [_messageLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_messageLab setFont:[UIFont systemFontOfSize:12.f]];
        [_messageLab setTextColor:RGBCOLOR(0, 0, 0)];
        [_messageLab setNumberOfLines:0];
        [self.contentView addSubview:_messageLab];
        
        UIView *image = self.iconImageView;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-12-[_messageLab]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(image,_messageLab)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_messageLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lineView attribute:NSLayoutAttributeBottom multiplier:1 constant:10.f]];
    }
    return _messageLab;
}

- (UILabel *)articleLab{
    if (!_articleLab) {
        _articleLab = [[UILabel alloc] init];
        [_articleLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_articleLab setFont:[UIFont systemFontOfSize:12.f]];
        [_articleLab setTextColor:RGBCOLOR(0, 0, 0)];
        [_articleLab setNumberOfLines:0];
        [_articleLab setBackgroundColor:RGBCOLOR(216, 216, 216)];
        [self.contentView addSubview:_articleLab];
        UIView *image = self.iconImageView;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[image]-7-[_articleLab]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(image,_articleLab)]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_articleLab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.messageLab attribute:NSLayoutAttributeBottom multiplier:1 constant:5.f]];
    }
    return _articleLab;
}

- (UIButton *)praiseBtn{
    if (!_praiseBtn) {
        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_praiseBtn setTitle:@"10" forState:UIControlStateNormal];
        [_praiseBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_praiseBtn setTitleColor:RGBALCOLOR(170 , 170, 170,1) forState:UIControlStateNormal];
        [_praiseBtn.imageView setContentMode:UIViewContentModeCenter];
        [_praiseBtn setImage:[UIImage imageNamed:@"info_icon_praise"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"info_icon_praise_selected"] forState:UIControlStateSelected];
        [self.contentView addSubview:_praiseBtn];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.articleLab attribute:NSLayoutAttributeBottom multiplier:1 constant:5.f],
                                           [NSLayoutConstraint constraintWithItem:_praiseBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-15.f]
                                           ]];
    }
    return _praiseBtn;
}

- (UIButton *)commentBtn{
    if (!_commentBtn) {
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_commentBtn setTitle:@"10" forState:UIControlStateNormal];
        [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
        [_commentBtn setTitleColor:RGBALCOLOR(170 , 170, 170,1) forState:UIControlStateNormal];
        [_commentBtn.imageView setContentMode:UIViewContentModeCenter];
        [_commentBtn setImage:[UIImage imageNamed:@"immerse_comment"] forState:UIControlStateNormal];
        [self.contentView addSubview:_commentBtn];
        [self.contentView addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_commentBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.praiseBtn attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_commentBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.praiseBtn attribute:NSLayoutAttributeLeading multiplier:1 constant:-15.f]
                                           ]];
    }
    return _commentBtn;
}

@end
