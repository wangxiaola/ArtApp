//
//  HImageSelector.h
//  ArtistProject
//
//  Created by HELLO WORLD on 2017/4/13.
//  Copyright © 2017年 HELLO WORLD. All rights reserved.
//
#import "HImageSelector.h"

#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "TZVideoPlayerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "CTAssetsPickerController.h"
#import "ShowIMGModel.h"
#import "selectMainVC.h"
#import "DBCameraViewController.h"
#import "SDPhotoBrowser.h"

@interface HImageSelector () <UIActionSheetDelegate, UINavigationControllerDelegate, DBCameraViewControllerDelegate, SDPhotoBrowserDelegate, CTAssetsPickerControllerDelegate, TZImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate> {
    HButton* btnAdd;
}

@property (assign, nonatomic) NSInteger iNumber;
@property (nonatomic, strong) UIImagePickerController* imagePickerVc;
@end

@implementation HImageSelector
- (id)init
{
    if (self = [super init]) {
        self.listImages=[[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{

}

- (void)setMaxNumberOfImage:(int)maxNumberOfImage
{
    _maxNumberOfImage = maxNumberOfImage;
    
    self.iNumber = maxNumberOfImage;
    self.listImages = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)setListImages:(NSMutableArray<UIImage*>*)listImages
{
    _listImages = listImages;
    
    self.iNumber = self.maxNumberOfImage - listImages.count;
    
    for (UIView* view in self.subviews) {
        //        if ([view isKindOfClass:[UIImageView class]]){
        [view removeFromSuperview];
        //        }
    }
    CGFloat wid = KKWidth(123);
    UIImageView* tempCell = nil;
    for (int i = 0; i < listImages.count; i++) {
        UIImageView* cell = [UIImageView new];
        [self addSubview:cell];
        [cell mas_makeConstraints:^(MASConstraintMaker* make) {
            if (self.allowScroll) {
                NSLog(@"%d", i / 4);
                make.left.equalTo(self).offset((i % 4) * (wid + KKWidth(30)) + KKWidth(30));
                make.top.equalTo(self).offset(i / 4 * (wid + KKWidth(30)) + KKWidth(30));
                make.size.mas_equalTo(CGSizeMake(wid, wid));
            }
            else {
                if (tempCell) {
                    make.left.equalTo(tempCell.mas_right).offset(KKWidth(30));
                }
                else {
                    make.left.equalTo(self).offset(KKWidth(30));
                }
                make.top.equalTo(self).offset(KKWidth(30));
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }
            
        }];
        cell.tag = i;
        //        cell.layer.borderWidth=1;
        
        if ([listImages[i] isKindOfClass:[UIImage class]]) {
            [cell setImage:listImages[i]];
        }
        else {
            [cell sd_setImageWithURL:[NSURL URLWithString:(NSString*)listImages[i]]];
        }
        
        cell.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cell_Click:)];
        [cell addGestureRecognizer:tap];
        
        if (self.allowEdit) {
            
            HButton* btnDel = [HButton new];
            [self addSubview:btnDel];
            [btnDel mas_makeConstraints:^(MASConstraintMaker* make) {
                make.centerX.equalTo(cell.mas_right);
                make.centerY.equalTo(cell.mas_top);
                make.size.mas_equalTo(CGSizeMake(20, 20));
                
            }];
            btnDel.tag = i;
            [btnDel setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
            [btnDel addTarget:self action:@selector(btnDel_Click:) forControlEvents:UIControlEventTouchUpInside];
        }
        tempCell = cell;
        
        cell.contentMode = UIViewContentModeScaleAspectFill;
        cell.layer.masksToBounds = YES;
    }
    
    if (listImages.count == self.maxNumberOfImage)
        return;
    
    btnAdd = [HButton new];
    [self addSubview:btnAdd];
    [btnAdd mas_makeConstraints:^(MASConstraintMaker* make) {
        if (self.allowScroll) {
            make.left.equalTo(self).offset((listImages.count % 4) * (wid + KKWidth(30)) + KKWidth(30));
            if (listImages.count == 0) {
                make.top.equalTo(self).offset(listImages.count / 4 * (wid + KKWidth(30)) + listImages.count / 4 * KKWidth(30));
            } else {
                make.top.equalTo(self).offset(listImages.count / 4 * (wid + KKWidth(30)) + KKWidth(30));
            }
            make.size.mas_equalTo(CGSizeMake(wid, wid));
        }
        else {
            if (tempCell) {
                make.left.equalTo(tempCell.mas_right).offset(KKWidth(30));
            }
            else {
                make.left.equalTo(self).offset(KKWidth(30));
            }
            make.top.equalTo(self).offset(KKWidth(30));
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }
    }];
    [btnAdd setImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(btnAdd_Click) forControlEvents:UIControlEventTouchUpInside];
}
- (void)cell_Click:(UITapGestureRecognizer*)sender
{
    
    NSMutableArray<UIImage*>* arrImage = [[NSMutableArray alloc] initWithArray:self.listImages];
    [arrImage removeObjectAtIndex:sender.view.tag];
    self.listImages = arrImage;
    if (self.selectDelBtnCilck) {
        self.selectDelBtnCilck(sender.view.tag);
    }
}

- (void)btnDel_Click:(HButton*)button
{
    NSMutableArray<UIImage*>* arrImage = [[NSMutableArray alloc] initWithArray:self.listImages];
    [arrImage removeObjectAtIndex:button.tag];
    self.listImages = arrImage;
    if (self.selectDelBtnCilck) {
        self.selectDelBtnCilck(button.tag);
    }
}

- (void)btnAdd_Click
{
    if (_didShowAlertBlock) {
        _didShowAlertBlock();
    }
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"去相册选择", nil];
    [sheet showInView:self];
}
- (void)imagePickerController:(TZImagePickerController*)picker didFinishPickingPhotos:(NSArray*)photos sourceAssets:(NSArray*)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.listImages];
    
    for (UIImage* image in photos) {
        [arr addObject:image];
    }
    
    self.listImages = arr;
    if (self.selectAddBtnCilck) {
        self.selectAddBtnCilck(nil);
    }
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController* tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(self.maxNumberOfImage - self.listImages.count) delegate:self];
        
        [tzImagePickerVc showProgressHUD];
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error) {
            [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel* model) {
                [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel*>* models) {
                    [tzImagePickerVc hideProgressHUD];
                    TZAssetModel* assetModel = [models firstObject];
                    if (tzImagePickerVc.sortAscendingByModificationDate) {
                        assetModel = [models lastObject];
                    }
                    
                    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.listImages];
                    [arr addObject:image];
                    
                    self.listImages = arr;
                    
                    if (self.selectAddBtnCilck) {
                        self.selectAddBtnCilck(nil);
                    }
                    
                }];
            }];

        }];
        
//        [[TZImageManager manager] savePhotoWithImage:image completion:^{
//            
//        }];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    }
    else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}

#pragma mark - TZImagePickerController

- (void)pushImagePickerController
{
    TZImagePickerController* imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(self.maxNumberOfImage - self.listImages.count) delegate:self];
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    //    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //
    //    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    //    imagePickerVc.selectedAssets = _selectedAssets; // optional, 可选的
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    //    imagePickerVc.allowPickingImage = self.allowPickingImageSwitch.isOn;
    //    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhotoSwitch.isOn;
    //
    //    // 4. 照片排列按修改时间升序
    //    imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage*>* photos, NSArray* assets, BOOL isSelectOriginalPhoto) {
        
        NSLog(@"%@", photos);
        
    }];
    
    [self.baseVC presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS8Later) {
        // 无权限 做一个友好的提示
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的"
                              "设置-隐私-相机"
                              "中允许访问相机"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"设置", nil];
        [alert show];
    }
    else { // 调用相机
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if (iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self.baseVC presentViewController:_imagePickerVc animated:YES completion:nil];
        }
        else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}
- (UIImagePickerController*)imagePickerVc
{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.baseVC.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.baseVC.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[ [TZImagePickerController class] ]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[ [UIImagePickerController class] ]];
        }
        else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary* titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

@end
