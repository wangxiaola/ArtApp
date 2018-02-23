//
//  MyHomePageDockerVC.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/13.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RootViewController.h"

@interface MyHomePageDockerVC : RootViewController
-(void)hideStateView;
-(void)showStateView;

// 首标题
@property (nonatomic, strong) NSString *artName;

@end
