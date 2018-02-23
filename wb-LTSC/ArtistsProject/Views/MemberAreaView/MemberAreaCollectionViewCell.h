//
//  MemberAreaCollectionViewCell.h
//  ArtistsProject
//
//  Created by 大锅 on 2017/6/10.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsCategoryModel.h"
typedef void(^CallBackBlock)(GoodsCategoryModel * categoryModel);

@interface MemberAreaCollectionViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *imageview; // 显示图片
@property (nonatomic, strong)UILabel *titleLabel; // 显示文字
@property (nonatomic, assign)BOOL isDisplayCategory;
@property (nonatomic, strong)NSArray<GoodsCategoryModel *> *goodsCategory;//显示分类的数据
@property (nonatomic, copy)CallBackBlock callBackBlock;

-(void)setImageView:(NSString *)imageUrl titileLabelText:(NSString *)titileLabelText isDisplayCategory:(BOOL)isDisplayCategory  goodsCategory:(NSArray *)goodsCategory clickCategoryCallBackBlock:(CallBackBlock)CallBackBlock;

@end
