//
//  HImageUploader.h
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/25.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBNavigationController.h"
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "DBCameraLibraryViewController.h"

@interface HImagePicker : UIImageView
///是否允许裁剪
@property(nonatomic,readwrite) BOOL allowCrop;
///裁剪比例
@property(nonatomic,readwrite) DBCameraImageScale cropScale;
///裁剪宽度
@property(nonatomic,readwrite) CGFloat cropWidth;
@property(nonatomic,copy) void(^didSelectedImageBlcok)(UIImage *image);
@property(nonatomic,readwrite) BOOL hadSelectedImage;
@end
