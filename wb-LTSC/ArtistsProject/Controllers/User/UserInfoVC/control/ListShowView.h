//
//  ListShowView.h
//  ShesheDa
//
//  Created by chen on 16/7/8.
//  Copyright © 2016年 上海翔汇网络有限公司. All rights reserved.
//

#import "HView.h"

@interface ListShowView : HView

@property(nonatomic,copy)NSMutableArray *arrayList;

-(void)addAudio:(NSDictionary *)dic;

@end
