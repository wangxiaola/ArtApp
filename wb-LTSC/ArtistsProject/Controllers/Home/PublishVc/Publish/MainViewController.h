//
//  MainViewController.h
//  AudioRecorder
//
//  Created by jeliu on 4/22/16.
//  Copyright © 2016 hz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : BaseController

@property (nonatomic, copy) void(^btnRecorderCilck)(NSURL *,double cTime);

@end
