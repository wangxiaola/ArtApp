//
//  DBCameraCropperViewController
//  DBCamera
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBCameraCropperViewController;

@protocol DBCameraCropperDelegate <NSObject>

- (void)imageCropper:(DBCameraCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(DBCameraCropperViewController *)cropperViewController;

@end

@interface DBCameraCropperViewController : UIViewController

typedef enum{
    DBCameraImageScale_1x1,
    DBCameraImageScale_4x3
}DBCameraImageScale;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<DBCameraCropperDelegate> delegate;

- (id)initWithImage:(UIImage *)originalImage withCropScale:(DBCameraImageScale)cropScale limitScaleRatio:(NSInteger)limitRatio;

@end
