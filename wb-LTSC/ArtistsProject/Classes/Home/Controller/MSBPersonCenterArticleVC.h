//
//  MSBPersonCenterArticleVC.h
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PersonCenterDeleteBlock)(UIButton *btn);

@interface MSBPersonCenterArticleVC : BaseViewController
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) PersonCenterDeleteBlock deleteBlock;

@end
