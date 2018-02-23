//
//  PlayerViewController.h
//  TestYKMediaPlayer
//
//  Created by weixinghua on 13-6-25.
//  Copyright (c) 2013年 Youku Inc. All rights reserved.
//

@interface PlayerViewController : HViewController

@property (nonatomic, assign) BOOL islocal;
@property (nonatomic, retain) id videoItem;

@property(strong,nonatomic)NSString *videoID;

@end
