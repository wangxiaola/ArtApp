//
//  MSBCollectPhotoCell.m
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBCollectPhotoCell.h"
#import "GeneralConfigure.h"
#import "UIView+WebCache.h"
@interface MSBCollectPhotoCell ()

@end

@implementation MSBCollectPhotoCell


- (void)setPhoto:(NSString *)photo{
    [self.photoImageView sd_setShowActivityIndicatorView:YES];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photo] placeholderImage:[UIImage imageNamed:@"article_cell"]];
}


- (UIImageView *)photoImageView{
    if (_photoImageView==nil) {
        _photoImageView = [[UIImageView alloc] init];
        [_photoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_photoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_photoImageView setClipsToBounds:YES];
        [self.contentView addSubview:_photoImageView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_photoImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_photoImageView)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_photoImageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_photoImageView)]];
    }
    return _photoImageView;
}


@end
