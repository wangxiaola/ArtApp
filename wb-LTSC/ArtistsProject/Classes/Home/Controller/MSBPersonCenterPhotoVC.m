//
//  MSBPersonCenterPhotoVC.m
//  meishubao
//
//  Created by T on 16/12/1.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBPersonCenterPhotoVC.h"
#import "GeneralConfigure.h"

#import "MSBCollectPhotoCell.h"

@interface MSBCollectionViewHeader : UICollectionReusableView{
    
}
@property(nonatomic,strong) UILabel *timeLab;

@end

@implementation MSBCollectionViewHeader

- (void)setTime:(NSString *)time{
    self.timeLab.text = time;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        [_timeLab setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeLab setFont:[UIFont systemFontOfSize:12.f]];
        _timeLab.dk_textColorPicker = DKColorPickerWithRGB(0x1d1d26, 0x989898);
        [self addSubview:_timeLab];
        [self addConstraints:@[
                                           [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0.f],
                                           [NSLayoutConstraint constraintWithItem:_timeLab attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:10.f]
                                           ]];
    }
    return _timeLab;
}

@end

@interface MSBPersonCenterPhotoVC ()<UICollectionViewDelegate,UICollectionViewDataSource, UIGestureRecognizerDelegate>{
    NSMutableArray<MSBInfoStorePhotoItem*>* _modelList;
    NSString *_offset;
     NSString *_total;
}
@property(nonatomic,strong) UICollectionView *colletionView;
@property (nonatomic, weak) UILabel  *photoLab;
@property (nonatomic, strong) UIButton  *deleteButton;
@property(nonatomic, strong) NSIndexPath *deleteIndexPath;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) CGRect originalFrame;

@end

@implementation MSBPersonCenterPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.colletionView reloadData];
    
    [self refreshData];
    
    self.deleteBlock = ^(UIButton *btn){
        NDLog(@"MSBPersonCenterPhotoVC deleteBlock");
    };
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _modelList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MSBInfoStorePhotoItem *item = _modelList[section];
    return item.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSBInfoStorePhotoItem *item = _modelList[indexPath.section];
    NSString *pic = item.pics[indexPath.row];
    MSBCollectPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MSBCollectPhotoCell identifier] forIndexPath:indexPath];
    [cell setPhoto:pic];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MSBInfoStorePhotoItem *item = _modelList[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        MSBCollectionViewHeader *view =  [collectionView dequeueReusableSupplementaryViewOfKind:kind   withReuseIdentifier:[MSBCollectionViewHeader identifier]   forIndexPath:indexPath];
        [view setTime:[NSString stringWithFormat:@"%@",item.time]];
        return view;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MSBInfoStorePhotoItem *item = _modelList[indexPath.section];
    NSString *pic = item.pics[indexPath.row];
    
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIGestureRecognizer *coverGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap:)];
    [cover addGestureRecognizer:coverGes];
    [keyWindow addSubview:cover];
    cover.frame = keyWindow.bounds;
    
    if (self.deleteButton) {
        
        [self.deleteButton removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
   [imageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"article_cell"]];
     [cover addSubview:imageView];
    self.imageView = imageView;
    MSBCollectPhotoCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    imageView.frame = [cell.photoImageView.superview convertRect:cell.photoImageView.frame toView:keyWindow];
    self.originalFrame = imageView.frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGFloat imageW = keyWindow.width;
        CGFloat imageH = (imageW * cell.photoImageView.height) / cell.photoImageView.width;
        CGFloat imageY = (keyWindow.height - imageH) * 0.5;
        imageView.frame = CGRectMake(0, imageY, imageW, imageH);
    }];
}

- (void)coverTap:(UITapGestureRecognizer *)tap{
    UIView *cover = (UIView *)tap.view;
    [UIView animateWithDuration:0.5 animations:^{
        cover.alpha = 0.0;
        self.imageView.frame = self.originalFrame;
    } completion:^(BOOL finished) {
        [cover removeFromSuperview];
        self.imageView = nil;
    }];
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (SCREEN_WIDTH - 42) / 3;
    return CGSizeMake(w, w);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.bounds.size.width, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)deleteAction:(UIButton *)sender{

    MSBInfoStorePhotoItem *item = _modelList[self.deleteIndexPath.section];
    __weak __block typeof(self) weakSelf = self;
    [weakSelf hudLoding];
    [[LLRequestServer shareInstance] requestDeletedCollectionWithType:3 post_id:nil video_id:nil pic_url:item.pics[self.deleteIndexPath.row] success:^(LLResponse *response, id data) {

        if (data && [data isKindOfClass:[NSDictionary class]]) {
            weakSelf.photoLab.text =[NSString stringWithFormat:@"图片（%@）", [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"total"]]]];
            [item.pics removeObjectAtIndex:weakSelf.deleteIndexPath.row];
            if (item.pics.count == 0) {
                
                [_modelList removeObject:item];
            }
            [weakSelf.deleteButton removeFromSuperview];
            
            [weakSelf.colletionView reloadData];
            [weakSelf showSuccess:@"删除成功"];
        }else {
            [weakSelf hiddenHudLoding];
        }
    } failure:^(LLResponse *response) {
        [weakSelf showError:@"删除失败"];
    } error:^(NSError *error) {

        [weakSelf showError:@"网络错误"];
    }];
}

- (void)activiteDeletionMode:(UILongPressGestureRecognizer *)gr{

    NSIndexPath *indexPath = [self.colletionView indexPathForItemAtPoint:[gr locationInView:self.colletionView]];
    UICollectionViewCell *cell = [self.colletionView cellForItemAtIndexPath:indexPath];
    self.deleteButton.hidden = NO;
    [cell addSubview:self.deleteButton];
    self.deleteIndexPath = indexPath;
    [self.deleteButton bringSubviewToFront:self.colletionView];
}

- (void)refreshData{
    __weak __block typeof(self) weakSelf = self;
    [self hudLoding];
    if ([NSString isNull:self.uid]) {
       [[LLRequestServer shareInstance] requestUserMyStoreItemsWithCollectType:@"3" offset:nil pagesize:10 success:^(LLResponse *response, id data) {
           [weakSelf hiddenHudLoding];
           if (data && [data isKindOfClass:[NSDictionary class]]) {
               _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
               weakSelf.photoLab.text =[NSString stringWithFormat:@"图片（%@）", [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"total"]]]];
               NSArray *itemArr = data[@"items"];
               _modelList = [[NSMutableArray alloc] init];
               for (int i = 0; i < itemArr.count; i++) {
                   
                   MSBInfoStorePhotoItem *item = [[MSBInfoStorePhotoItem alloc] init];
                   item.time = itemArr[i][@"time"];
                   item.pics = [[NSMutableArray alloc] initWithArray:itemArr[i][@"pics"]];
                   [_modelList addObject:item];
               }
               [weakSelf.colletionView reloadData];
           }
       } failure:^(LLResponse *response) {
           [weakSelf hiddenHudLoding];
           [weakSelf.colletionView reloadData];
       } error:^(NSError *error) {
           [weakSelf hiddenHudLoding];
           [weakSelf.colletionView reloadData];
       }];
    }else{
        [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"3"
              uid:self.uid offset:nil pagesize:10 success:^(LLResponse *response, id data) {
                  [weakSelf hiddenHudLoding];
                  if (data && [data isKindOfClass:[NSDictionary class]]) {
                      _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                   weakSelf.photoLab.text =[NSString stringWithFormat:@"图片（%@）", [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"total"]]]];
                      NSArray *itemArr = data[@"items"];
                      _modelList = [[NSMutableArray alloc] init];
                      for (int i = 0; i < itemArr.count; i++) {
                          
                          MSBInfoStorePhotoItem *item = [[MSBInfoStorePhotoItem alloc] init];
                          item.time = itemArr[i][@"time"];
                          item.pics = [[NSMutableArray alloc] initWithArray:itemArr[i][@"pics"]];
                          [_modelList addObject:item];
                      }
                      [weakSelf.colletionView reloadData];
                  }
                  
              } failure:^(LLResponse *response) {
                  [weakSelf hiddenHudLoding];
                  [weakSelf.colletionView reloadData];
              } error:^(NSError *error) {
                  [weakSelf hiddenHudLoding];
                  [weakSelf.colletionView reloadData];
              }];
    }
}

- (void)appendData{
    __weak __block typeof(self) weakSelf = self;
    if ([NSString isNull:self.uid]) {
       [[LLRequestServer shareInstance] requestUserMyStoreItemsWithCollectType:@"3" offset:_offset pagesize:10 success:^(LLResponse *response, id data) {
           [weakSelf.colletionView.footer endRefreshing];
           if (data && [data isKindOfClass:[NSDictionary class]]) {
               _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
               NSArray *arr = [MSBInfoStorePhotoItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
               if (_modelList) {
                   [_modelList addObjectsFromArray:arr];
               } else {
                   _modelList = [NSMutableArray arrayWithArray:arr];
               }
               [weakSelf.colletionView reloadData];
           }

       } failure:^(LLResponse *response) {
           if (response.code == 10006) {
               [weakSelf.colletionView.footer noticeNoMoreData];
           } else {
               [weakSelf.colletionView.footer endRefreshing];
           }
       } error:^(NSError *error) {
            [weakSelf.colletionView.footer endRefreshing];
       }];
    }else{
        [[LLRequestServer shareInstance] requestUserStoreItemsWithCollectType:@"3"
                  uid:self.uid offset:_offset pagesize:10 success:^(LLResponse *response, id data) {
                      [weakSelf.colletionView.footer endRefreshing];
                      if (data && [data isKindOfClass:[NSDictionary class]]) {
                          _offset = [NSString notNilString:[NSString stringWithFormat:@"%@", data[@"offset"]]];
                          NSArray *arr = [MSBInfoStorePhotoItem mj_objectArrayWithKeyValuesArray:data[@"items"]];
                          if (_modelList) {
                              [_modelList addObjectsFromArray:arr];
                          } else {
                              _modelList = [NSMutableArray arrayWithArray:arr];
                          }
                          [weakSelf.colletionView reloadData];
                      }
                      
                  }failure:^(LLResponse *response) {
                      if (response.code == 10006) {
                          [weakSelf.colletionView.footer noticeNoMoreData];
                      } else {
                          [weakSelf.colletionView.footer endRefreshing];
                      }
                      
                  }error:^(NSError *error) {
                      [weakSelf.colletionView.footer endRefreshing];
                  }];
    }
    
}


- (UICollectionView *)colletionView{
    if (_colletionView == nil) {
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _colletionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_colletionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _colletionView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        [_colletionView registerClass:[MSBCollectPhotoCell class] forCellWithReuseIdentifier:[MSBCollectPhotoCell identifier]];
        [_colletionView registerClass:[MSBCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[MSBCollectionViewHeader identifier]];

        [_colletionView setDelegate:self];
        [_colletionView setDataSource:self];
        [self.view addSubview:_colletionView];
        
        _colletionView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, -40, SCREEN_WIDTH, 40);
        headerView.backgroundColor = [UIColor clearColor];
        [_colletionView addSubview:headerView];
        
        UILabel *lab = [UILabel new];
        lab.textColor = RGBCOLOR(181, 27, 32);
        lab.font = [UIFont boldSystemFontOfSize:14];
        lab.text = @"图片（0）";
        self.photoLab = lab;
        [lab setFrame:CGRectMake(10, 0, SCREEN_WIDTH, 40)];
        [headerView addSubview:lab];
        
//        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//        header.automaticallyChangeAlpha = YES;
//        header.lastUpdatedTimeLabel.hidden = YES;
//        _colletionView.header = header; // info_collection_delete
        _colletionView.footer = [MJDIYBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(appendData)];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activiteDeletionMode:)];
        longPress.delegate = self;
        [_colletionView addGestureRecognizer:longPress];
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake((SCREEN_WIDTH - 36) / 3 - 36, 0, 36, 36);
        
        UIImage *image = [[UIImage imageNamed:@"cancel_dark"] imageWithTintColor:RGBCOLOR(181, 27, 32)];
        [deleteButton setImage:image forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton = deleteButton;

        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_colletionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_colletionView)]];
      [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_colletionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_colletionView)]];
    }
    
    return _colletionView;

}

@end
