//
//  IntroHeadCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"
@class CangyouQuanDetailModel;
@class PublishDongtaiVC;


@interface IntroHeadCell : ArtTableViewCell

-(void)setArtTableViewHeadCellDicValue:(NSDictionary *)dic andTitle:(NSString*)title subTitle:(NSString*)subtitle;//近况
-(void)setArtTableViewHeadCellDicValue:(NSDictionary *)dic;//文字
@end
