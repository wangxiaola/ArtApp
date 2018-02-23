//
//  MSBPersonCenterPhotoVC.h
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PersonPhotoDeleteBlock)(UIButton *btn);
@interface MSBPersonCenterPhotoVC : BaseViewController
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) PersonPhotoDeleteBlock deleteBlock;
@end
