//
//  IntroListCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/2.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface IntroListCell : ArtTableViewCell
@property (nonatomic, copy)void(^yearBlock)(NSString*);
-(CGFloat)setIntroListCellDicValue:(NSDictionary *)dic yearStr:(NSString*)StrYear;
@end
