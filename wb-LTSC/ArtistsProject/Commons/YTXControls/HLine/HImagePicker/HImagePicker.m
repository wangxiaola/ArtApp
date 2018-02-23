//
//  HImageUploader.m
//  HUIKitLib_Demo
//
//  Created by HeLiulin on 15/11/25.
//  Copyright © 2015年 上海翔汇网络科技有限公司. All rights reserved.
//

#import "HImagePicker.h"
#import "UIViewController+KNSemiModal.h"
#import "HViewController.h"

@interface HImagePicker ()<UIActionSheetDelegate,UINavigationControllerDelegate,DBCameraViewControllerDelegate>

@end

@implementation HImagePicker
//@synthesize imageView;
- (id) init
{
    if (self=[super init]){
        [self customInit];
    }
    return self;
}
- (id) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self customInit];
    }
    return self;
}
- (void) customInit
{
    self.allowCrop=YES;
    self.cropScale=DBCameraImageScale_1x1;
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageView_Tap)];
    [self addGestureRecognizer:tap];
}
- (void) imageView_Tap
{
    [((HViewController*)self.containingViewController) hideKeyBoard];
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照",nil];
    [actionSheet showInView:self];
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIViewController * parent = [self containingViewController];
    if (buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    switch (buttonIndex) {
        case 0: { //从相册选择
            DBCameraLibraryViewController* vc = [[DBCameraLibraryViewController alloc] init];
            [vc setDelegate:self]; //DBCameraLibraryViewController must have a DBCameraViewControllerDelegate object
            [vc setAllowEditing:self.allowCrop]; //Optional
            [vc setCropScale:self.cropScale];
            [vc setFullScreenMode];
            DBNavigationController* nav = [[DBNavigationController alloc] initWithRootViewController:vc];
            [parent presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 1: { //拍照
            DBCameraViewController* cameraController = [DBCameraViewController initWithDelegate:self];
            [cameraController setAllowEditing:self.allowCrop];
            [cameraController setCropScale:self.cropScale];

            DBCameraContainerViewController* container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
            [container setCameraViewController:cameraController];
            [container setFullScreenMode];
            
            DBNavigationController* nav = [[DBNavigationController alloc] initWithRootViewController:container];
            [parent presentViewController:nav animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark - DBCameraViewControllerDelegate

- (void) dismissCamera:(id)cameraViewController{
    [self.containingViewController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}
- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    [cameraViewController dismissViewControllerAnimated:YES completion:^{
        UIImage *dealedImage=image;
        if (self.cropWidth){
            dealedImage=[self imageCompressForWidth:image targetWidth:self.cropWidth];
        }
        [self setImage:dealedImage];
        self.hadSelectedImage=YES;
        if (self.didSelectedImageBlcok){
            self.didSelectedImageBlcok(dealedImage);
        }
    }];
}

#pragma mark - 图片压缩
/**
 *  图片压缩
 *
 *  @param sourceImage 原图片
 *  @param defineWidth 宽度
 *
 *  @return 处理后的图片
 */
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
