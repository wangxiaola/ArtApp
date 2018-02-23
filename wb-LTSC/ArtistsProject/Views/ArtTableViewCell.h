//
//  ArtTableViewCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtTableViewCell : UITableViewCell
@property(nonatomic,weak)UIView* baseViews;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
-(void)addContentViews;
-(void)setArtTableViewCellDicValue:(NSDictionary *)dic;
-(void)setArtTableViewCellArrValue:(NSArray *)arr;
@end
