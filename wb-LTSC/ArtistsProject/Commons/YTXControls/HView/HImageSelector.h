//
//  HImageSelector.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/13.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//

#import "HView.h"
#import "DBCameraCropperViewController.h"

@interface HImageSelector : HView
///图片列表
@property (nonatomic, strong) NSMutableArray<UIImage*>* listImages;

///最多可选择的图片数（最好不要超过4张）
@property (nonatomic, readwrite) int maxNumberOfImage;
///是否允许编辑
@property (nonatomic, readwrite) BOOL allowEdit;
@property (nonatomic, readwrite) BOOL allowScroll;
///裁剪比例
@property (nonatomic, readwrite)DBCameraImageScale cropScale;

@property (nonatomic, strong) UIViewController* baseVC;

@property (nonatomic, copy) void (^selectAddBtnCilck)(UIImage*);
@property (nonatomic, copy) void (^selectDelBtnCilck)(NSInteger);
@property (nonatomic, copy) void (^didShowAlertBlock)();
@end

