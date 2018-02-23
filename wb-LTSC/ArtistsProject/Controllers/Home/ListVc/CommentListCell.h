//
//  CommentListCell.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/11.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "ArtTableViewCell.h"

@interface CommentListCell : ArtTableViewCell
@property(nonatomic,strong)NSMutableDictionary* listDic;
@property(nonatomic,strong)UserInfoUserModel* model;
@property(nonatomic,copy)void(^sendBtnClick)(NSDictionary*);//评论
-(void)setCommentListCell:(NSDictionary*)dic;
@end
