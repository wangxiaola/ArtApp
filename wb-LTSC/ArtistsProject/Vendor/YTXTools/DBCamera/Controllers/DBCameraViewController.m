//
//  DBCameraViewController.m
//  DBCamera
//
//  Created by iBo on 31/01/14.
//  Copyright (c) 2014 PSSD - Daniele Bogo. All rights reserved.
//

#import "DBCameraViewController.h"
#import "DBCameraManager.h"
#import "DBCameraView.h"
#import "DBCameraGridView.h"
#import "DBCameraDelegate.h"
#import "DBCameraLibraryViewController.h"
#import "DBLibraryManager.h"
#import "DBMotionManager.h"

#import "UIImage+Crop.h"
#import "DBCameraMacros.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


#ifndef DBCameraLocalizedStrings
#define DBCameraLocalizedStrings(key) \
[[NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"DBCamera" ofType:@"bundle"]] localizedStringForKey:(key) value:@"" table:@"DBCamera"]
#endif

@interface DBCameraViewController () <DBCameraManagerDelegate, DBCameraViewDelegate, DBCameraCropperDelegate> {
    BOOL _processingPhoto;
    UIDeviceOrientation _deviceOrientation;
    BOOL wasStatusBarHidden;
    BOOL wasWantsFullScreenLayout;
}

@property (nonatomic, strong) id customCamera;
@end

@implementation DBCameraViewController
@synthesize cameraGridView = _cameraGridView;
@synthesize forceQuadCrop = _forceQuadCrop;
@synthesize tintColor = _tintColor;
@synthesize selectedTintColor = _selectedTintColor;
@synthesize cameraSegueConfigureBlock = _cameraSegueConfigureBlock;
@synthesize cameraManager = _cameraManager;

#pragma mark - Life cycle

+ (instancetype) initWithDelegate:(id<DBCameraViewControllerDelegate>)delegate
{
    return [[self alloc] initWithDelegate:delegate cameraView:nil];
}

+ (instancetype) init
{
    return [[self alloc] initWithDelegate:nil cameraView:nil];
}

- (instancetype) initWithDelegate:(id<DBCameraViewControllerDelegate>)delegate cameraView:(id)camera
{
    self = [super init];

    if ( self ) {
        _processingPhoto = NO;
        _deviceOrientation = UIDeviceOrientationPortrait;
        if ( delegate )
            _delegate = delegate;

        if ( camera )
            [self setCustomCamera:camera];

        [self setAllowEditing:YES];

        [self setTintColor:[UIColor whiteColor]];
        [self setSelectedTintColor:[UIColor cyanColor]];
    }

    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor blackColor]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];

    NSError *error;
    if ( [self.cameraManager setupSessionWithPreset:AVCaptureSessionPresetPhoto error:&error] ) {
        if ( self.customCamera ) {
            if ( [self.customCamera respondsToSelector:@selector(previewLayer)] ) {
                [(AVCaptureVideoPreviewLayer *)[self.customCamera valueForKey:@"previewLayer"] setSession:self.cameraManager.captureSession];

                if ( [self.customCamera respondsToSelector:@selector(delegate)] )
                    [self.customCamera setValue:self forKey:@"delegate"];
            }

            [self.view addSubview:self.customCamera];
        } else
            [self.view addSubview:self.cameraView];
    }

    id camera =_customCamera ?: _cameraView;
    [camera insertSubview:self.cameraGridView atIndex:1];
    
    if ( [camera respondsToSelector:@selector(cameraButton)] ) {
        [(DBCameraView *)camera cameraButton].enabled = [self.cameraManager hasMultipleCameras];
        [self.cameraManager hasMultipleCameras];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.cameraManager performSelector:@selector(startRunning) withObject:nil afterDelay:0.0];
    
    __weak typeof(self) weakSelf = self;
    [[DBMotionManager sharedManager] setMotionRotationHandler:^(UIDeviceOrientation orientation){
        [weakSelf rotationChanged:orientation];
    }];
    [[DBMotionManager sharedManager] startMotionHandler];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ( !self.customCamera )
        [self checkForLibraryImage];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cameraManager performSelector:@selector(stopRunning) withObject:nil afterDelay:0.0];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _cameraManager = nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void) checkForLibraryImage
{
    if ( !self.cameraView.photoLibraryButton.isHidden && [self.parentViewController.class isSubclassOfClass:NSClassFromString(@"DBCameraContainerViewController")] ) {
        if ( [ALAssetsLibrary authorizationStatus] !=  ALAuthorizationStatusDenied ) {
            __weak DBCameraView *weakCamera = self.cameraView;
            [[DBLibraryManager sharedInstance] loadLastItemWithBlock:^(BOOL success, UIImage *image) {
                [weakCamera.photoLibraryButton setBackgroundImage:image forState:UIControlStateNormal];
            }];
        }
    } else
        [self.cameraView.photoLibraryButton setHidden:YES];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) dismissCamera
{
    if ( _delegate && [_delegate respondsToSelector:@selector(dismissCamera:)] )
        [_delegate dismissCamera:self];
}

- (DBCameraView *) cameraView
{
    if ( !_cameraView ) {
        _cameraView = [DBCameraView initWithCaptureSession:self.cameraManager.captureSession];
        [_cameraView setTintColor:self.tintColor];
        [_cameraView setSelectedTintColor:self.selectedTintColor];
        [_cameraView defaultInterface];
        [_cameraView setDelegate:self];
    }

    return _cameraView;
}

- (DBCameraManager *) cameraManager
{
    if ( !_cameraManager ) {
        _cameraManager = [[DBCameraManager alloc] init];
        [_cameraManager setDelegate:self];
    }

    return _cameraManager;
}

- (DBCameraGridView *) cameraGridView
{
    if ( !_cameraGridView ) {
        DBCameraView *camera =_customCamera ?: _cameraView;
        _cameraGridView = [[DBCameraGridView alloc] initWithFrame:camera.previewLayer.frame];
        [_cameraGridView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_cameraGridView setNumberOfColumns:2];
        [_cameraGridView setNumberOfRows:2];
        [_cameraGridView setAlpha:0];
    }

    return _cameraGridView;
}

- (void) setCameraGridView:(DBCameraGridView *)cameraGridView
{
    _cameraGridView = cameraGridView;
    __block DBCameraGridView *blockGridView = cameraGridView;
    __weak DBCameraView *camera =_customCamera ?: _cameraView;
    [camera.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [obj isKindOfClass:[DBCameraGridView class]] ) {
            [obj removeFromSuperview];
            [camera insertSubview:blockGridView atIndex:1];
            blockGridView = nil;
            *stop = YES;
        }
    }];
}

- (void) rotationChanged:(UIDeviceOrientation) orientation
{
    if ( orientation != UIDeviceOrientationUnknown ||
         orientation != UIDeviceOrientationFaceUp ||
         orientation != UIDeviceOrientationFaceDown ) {
        _deviceOrientation = orientation;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    DBCameraView *camera = _customCamera ?: _cameraView;
    camera.frame = CGRectMake(0, 0, size.width, size.height);
    camera.previewLayer.frame = CGRectMake(0, 0, size.width, size.height);
}

+ (AVCaptureVideoOrientation)interfaceOrientationToVideoOrientation:(UIInterfaceOrientation)orientation {
    AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        default:
            break;
    }
    return videoOrientation;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    AVCaptureVideoOrientation videoOrientation = [[self class] interfaceOrientationToVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    DBCameraView *camera = _customCamera ?: _cameraView;
    if (camera.previewLayer.connection.supportsVideoOrientation
        && camera.previewLayer.connection.videoOrientation != videoOrientation) {
        camera.previewLayer.connection.videoOrientation = videoOrientation;
    }
}

#pragma mark - CameraManagerDelagate

- (void) closeCamera
{
    [self dismissCamera];
}

- (void) switchCamera
{
    if ( [self.cameraManager hasMultipleCameras] )
        [self.cameraManager cameraToggle];
}

- (void) cameraView:(UIView *)camera showGridView:(BOOL)show {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.cameraGridView.alpha = (show ? 1.0 : 0.0);
    } completion:NULL];
}

- (void) triggerFlashForMode:(AVCaptureFlashMode)flashMode
{
    if ( [self.cameraManager hasFlash] )
        [self.cameraManager setFlashMode:flashMode];
}

- (void) captureImageDidFinish:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    _processingPhoto = NO;

    NSMutableDictionary *finalMetadata = [NSMutableDictionary dictionaryWithDictionary:metadata];
    finalMetadata[@"DBCameraSource"] = @"Camera";

    if ( !self.allowEditing ) {
        if ( [_delegate respondsToSelector:@selector(camera:didFinishWithImage:withMetadata:)] )
            [_delegate camera:self didFinishWithImage:image withMetadata:finalMetadata];
    } else {
        CGFloat newW = 256.0;
        CGFloat newH = 340.0;

        if ( image.size.width > image.size.height ) {
            newW = 340.0;
            newH = ( newW * image.size.height ) / image.size.width;
        }
        DBCameraCropperViewController *cropVC=[[DBCameraCropperViewController alloc] initWithImage:[self fixOrientation:image] withCropScale:self.cropScale limitScaleRatio:2];
        cropVC.delegate=self;
        [self.navigationController pushViewController:cropVC animated:YES];
    }
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (void) captureImageFailedWithError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    });
}

- (void) captureSessionDidStartRunning
{
    id camera = self.customCamera ?: _cameraView;
    CGRect bounds = [(UIView *)camera bounds];
    CGPoint screenCenter = (CGPoint){ CGRectGetMidX(bounds), CGRectGetMidY(bounds) };
    if ([camera respondsToSelector:@selector(drawFocusBoxAtPointOfInterest:andRemove:)] )
        [camera drawFocusBoxAtPointOfInterest:screenCenter andRemove:NO];
    if ( [camera respondsToSelector:@selector(drawExposeBoxAtPointOfInterest:andRemove:)] )
        [camera drawExposeBoxAtPointOfInterest:screenCenter andRemove:NO];
}

- (void)openLibrary
{
    if ( [ALAssetsLibrary authorizationStatus] !=  ALAuthorizationStatusDenied ) {
        [UIView animateWithDuration:.3 animations:^{
            [self.view setAlpha:0];
            [self.view setTransform:CGAffineTransformMakeScale(.8, .8)];
        } completion:^(BOOL finished) {
            DBCameraLibraryViewController *library = [[DBCameraLibraryViewController alloc] initWithDelegate:self.containerDelegate];
            [library setTintColor:self.tintColor];
            [library setSelectedTintColor:self.selectedTintColor];
            [library setForceQuadCrop:_forceQuadCrop];
            [library setDelegate:self.delegate];
            [library setAllowEditing:self.allowEditing];
            [library setCameraSegueConfigureBlock:self.cameraSegueConfigureBlock];
            [library setLibraryMaxImageSize:self.libraryMaxImageSize];
            [self.containerDelegate switchFromController:self toController:library];
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:DBCameraLocalizedStrings(@"general.error.title") message:DBCameraLocalizedStrings(@"pickerimage.nopolicy") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        });
    }
}
- (void)imageCropper:(DBCameraCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    if ( [self.delegate respondsToSelector:@selector(camera:didFinishWithImage:withMetadata:)] )
        [self.delegate camera:self didFinishWithImage:editedImage withMetadata:nil];
}
- (void)imageCropperDidCancel:(DBCameraCropperViewController *)cropperViewController;
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CameraViewDelegate

- (void) cameraViewStartRecording
{
    if ( _processingPhoto )
        return;

    _processingPhoto = YES;

    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

        if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
            [[[UIAlertView alloc] initWithTitle:DBCameraLocalizedStrings(@"general.error.title")
                                        message:DBCameraLocalizedStrings(@"cameraimage.nopolicy")
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil] show];

            return;
        }
        else if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:nil];

            return;
        }
    }

    [self.cameraManager captureImageForDeviceOrientation:_deviceOrientation];
}

- (void) cameraView:(UIView *)camera focusAtPoint:(CGPoint)point
{
    if ( self.cameraManager.videoInput.device.isFocusPointOfInterestSupported ) {
        [self.cameraManager focusAtPoint:[self.cameraManager convertToPointOfInterestFrom:[[(DBCameraView *)camera previewLayer] frame]
                                                                              coordinates:point
                                                                                    layer:[(DBCameraView *)camera previewLayer]]];
    }
}

- (BOOL) cameraViewHasFocus
{
    return self.cameraManager.hasFocus;
}

- (void) cameraView:(UIView *)camera exposeAtPoint:(CGPoint)point
{
    if ( self.cameraManager.videoInput.device.isExposurePointOfInterestSupported ) {
        [self.cameraManager exposureAtPoint:[self.cameraManager convertToPointOfInterestFrom:[[(DBCameraView *)camera previewLayer] frame]
                                                                                 coordinates:point
                                                                                       layer:[(DBCameraView *)camera previewLayer]]];
    }
}

- (CGFloat) cameraMaxScale
{
    return [self.cameraManager cameraMaxScale];
}

- (void) cameraCaptureScale:(CGFloat)scaleNum
{
    [self.cameraManager setCameraMaxScale:scaleNum];
}

#pragma mark - UIApplicationDidEnterBackgroundNotification

- (void) applicationDidEnterBackground:(NSNotification *)notification
{
    id modalViewController = self.presentingViewController;
    if ( modalViewController )
        [self dismissCamera];
}

@end
