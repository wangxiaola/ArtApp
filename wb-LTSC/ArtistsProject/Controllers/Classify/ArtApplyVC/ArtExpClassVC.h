//
//  ArtExpClassVC.h
//  ArtistsProject
//
//  Created by 黄兵 on 2017/6/28.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "HViewController.h"

@interface ArtExpClassVC : HViewController

@property (nonatomic, copy) void(^saveBtnCilck)(NSString *backValue, NSString *backId);
@end
