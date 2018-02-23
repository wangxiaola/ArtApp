//
//  selectMainVC.h
//  selectPIC
//
//  Created by colorful-ios on 15/11/23.
//  Copyright © 2015年 7Color. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReturnArrayBlock)(NSArray *array);

@interface selectMainVC : HViewController
@property (nonatomic,copy)ReturnArrayBlock returnArrayBlock;

@property (nonatomic,strong)NSArray *selecIMG;

+ (selectMainVC *)shareSelectMainVC;

///最多可选择的图片数（最好不要超过4张）
@property(nonatomic,readwrite) int maxNumberOfImage;
@end
