//
//  ListRecordCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/9.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface ListRecordCell : ArtTableViewCell
@property(nonatomic,strong)void(^detailBtnCilck)();
@property(nonatomic,strong)NSMutableDictionary* listDic;
@property(nonatomic,strong)NSMutableDictionary* recordkDic;
-(CGFloat)heightWithModel:(NSDictionary *)dic;
@end
