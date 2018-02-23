//
//  MSBCollectVideoController.h
//  meishubao
//
//  Created by T on 16/11/25.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^CollectVideoDeleteBlock)(UIButton *btn);

@interface MSBCollectVideoController : BaseViewController
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) CollectVideoDeleteBlock deleteBlock;
@end
