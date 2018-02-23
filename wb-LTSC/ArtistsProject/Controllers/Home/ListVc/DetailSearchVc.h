//
//  DetailSearchVc.h
//  ArtistsProject
//
//  Created by HELLO WORLD on 2017/5/5.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "RootViewController.h"

@interface DetailSearchVc : RootViewController
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,copy)NSString *searchWord;
@property(nonatomic,copy)NSString* typeStr;//1-关联作品 2-关联记录
@property(nonatomic,copy)NSString* topictypeStr;//动态类型
@property(nonatomic,copy)NSString* topicId;//要更新的动态id
@property (nonatomic, copy)void(^guanLianSuccess)();//关联成功的会掉
@property(nonatomic,copy)NSString* idSArr;
@end
