//
//  OfflineListViewController.h
//  meishubao
//
//  Created by LWR on 2017/3/1.
//  Copyright © 2017年 benbun. All rights reserved.
//

#import "BaseViewController.h"
@class MSBSettingController;

@interface OfflineListViewController : BaseViewController

@property (nonatomic, strong) NSArray *termArr;
@property (nonatomic, strong) MSBSettingController *settingVC;

@end
