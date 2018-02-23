//
//  ShowIMGVC.h
//  selectPIC
//
//  Created by colorful-ios on 15/11/24.
//  Copyright © 2015年 7Color. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Photos/Photos.h>


@interface ShowIMGVC : HViewController

@property (nonatomic,strong)PHFetchResult *assetsFetchResult;
@property (nonatomic,strong)NSArray *selectedModel;

///最多可选择的图片数（最好不要超过4张）
@property(nonatomic,readwrite) int maxNumberOfImage;

@end
