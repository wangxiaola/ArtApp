//
//  ArtCitySelectVc.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/19.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RootViewController.h"

@interface ArtCitySelectVc : RootViewController
@property(nonatomic,copy)void(^selectBlock)(NSDictionary*,NSString*);
@end
