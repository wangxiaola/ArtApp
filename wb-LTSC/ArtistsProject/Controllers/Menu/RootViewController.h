//
//  RootViewController.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/3/29.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ScrollViewController.h"


@interface RootViewController : ScrollViewController
@property(nonatomic,copy)NSString* navTitle;
-(void)leftBarItem_Click;
@end
