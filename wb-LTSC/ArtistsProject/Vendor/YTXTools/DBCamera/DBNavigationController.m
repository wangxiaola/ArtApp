//
//  DemoNavigationController.m
//  DBCamera
//
//  Created by Sebastian Ludwig on 10.05.15.
//  Copyright (c) 2015 PSSD - Daniele Bogo. All rights reserved.
//

#import "DBNavigationController.h"

@implementation DBNavigationController

- (void)viewDidLoad
{
    self.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController.presentedViewController) {
        return self.topViewController.presentedViewController.supportedInterfaceOrientations;
    }
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}

@end
