//
//  YTXTopicDetailPhotoViewCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class photoscbkModel;

@interface YTXTopicDetailPhotoViewCell : UITableViewCell

@property (nonatomic, strong) photoscbkModel *photo;

@property (nonatomic, copy) void (^imageTapBlock)(photoscbkModel *photo, UIImageView *tapImageView);

@end
