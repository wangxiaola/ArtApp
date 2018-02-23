//
//  YTXTopicDetailPhotoViewCell.m
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "YTXTopicDetailPhotoViewCell.h"
#import "CangyouQuanDetailModel.h"

@interface YTXTopicDetailPhotoViewCell ()

@property (nonatomic, strong) UIImageView *photoImageView;

@property (nonatomic, strong) UIControl *controlView;

@end

@implementation YTXTopicDetailPhotoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self controlView];
    }
    return self;
}

- (void)setPhoto:(photoscbkModel *)photo
{
    _photo = photo;
    // 清除缓存
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
    [self.photoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@!def720", photo.photo]] placeholder:[UIImage imageNamed:@"icon_Default_Product"]];
    self.photoImageView.frame = CGRectMake(0, 7, self.contentView.frame.size.width, self.contentView.frame.size.width / [photo.cbk floatValue]);
}

- (UIImageView *)photoImageView
{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.backgroundColor = ColorHex(@"f6f6f6");
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.userInteractionEnabled = YES;
        _photoImageView.clipsToBounds = YES;
        [self.contentView addSubview:_photoImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [_photoImageView addGestureRecognizer:tap];
    }
    return _photoImageView;
}

- (UIControl *)controlView
{
    if (!_controlView) {
        _controlView = [[UIControl alloc] init];
        _controlView.backgroundColor = [UIColor clearColor];
        [self.photoImageView addSubview:_controlView];
        
        [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.photoImageView);
        }];
    }
    return _controlView;
}


- (void)imageTap:(UITapGestureRecognizer *)tap
{
    if (_imageTapBlock)_imageTapBlock(_photo,tap.view);
}

@end

