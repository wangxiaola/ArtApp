//
//  AnyWorksHeadCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeListDetailVc;

@interface AnyWorksHeadCell : UITableViewCell
@property(nonatomic,strong)CangyouQuanDetailModel* model;
-(void)setWorkHead:(NSString*)kindStr num:(NSString*)num uid:(NSString*)uid;
@end
