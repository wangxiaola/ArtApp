//
//  tb_InspectionItem.h
//  ShaManager
//
//  Created by HeLiulin on 15/8/2.
//  Copyright (c) 2015年 上海翔汇⺴络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface tb_GroupsDAL : NSObject

- (void) del:(NSString *)strWhere;
- (NSMutableArray*) getListModel:(NSString*)strWhere;
@end
