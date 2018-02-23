//
//  SearchViewController.h
//  ShesheDa
//
//  Created by lixianjun on 2016/12/25.
//  Copyright © 2016年 北京艺天下文化科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : HViewController

@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,copy)NSString *searchWord;
@property (nonatomic,copy)NSString *searchType;


@end
