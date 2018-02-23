//
//  YTXHomeSearchVC.h
//  ShesheDa
//
//  Created by lixianjun on 2017/1/7.
//  Copyright © 2017年 北京艺天下文化科技有限公司. All rights reserved.
//

#import "HViewController.h"

@interface YTXHomeSearchVC : HViewController
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,copy)NSString *searchWord;

@end
