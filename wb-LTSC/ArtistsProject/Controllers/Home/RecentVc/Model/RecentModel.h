//
//  RecentModel.h
//  ArtistsProject
//
//  Created by 黄兵 on 2018/2/5.
//  Copyright © 2018年 HELLO WORLD. All rights reserved.
//

#import "BaseClassModel.h"

@interface RecentModel : BaseClassModel

@end

@interface RecentCategoryListModel : BaseClassModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *term_id;

@end
@interface RecentCategoryModel : BaseClassModel

@property (nonatomic, strong)NSArray  *data;

@end
