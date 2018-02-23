//
//  HomeListDetailVc.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/6.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RootViewController.h"

@class CangyouQuanDetailModel;
@interface HomeListDetailVc : RootViewController
@property(nonatomic,copy)NSString* topictype;
@property(nonatomic,copy)NSString* topicid;
@property(nonatomic,assign)BOOL isScrollToBottom;//是否滚到底部
@end
