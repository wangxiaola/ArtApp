//
//  MSBWebLoading.m
//  meishubao
//
//  Created by T on 16/12/15.
//  Copyright © 2016年 benbun. All rights reserved.
//

#import "MSBWebLoading.h"
#import "GeneralConfigure.h"

static const CGFloat kImageWidth = 250;
static const CGFloat kImageHeight = 56;

@interface MSBWebLoading ()
@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation MSBWebLoading

+ (instancetype)defaultLoading{
    static MSBWebLoading *loadingView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadingView = [[MSBWebLoading alloc] init];
    });
    return loadingView;
}

- (instancetype)init{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) , CGRectGetHeight([UIScreen mainScreen].bounds));
    }
    return self;
}

- (void)startLoading:(UIView *)view{
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [view addSubview:self];
    
    if (self.imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc ]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - kImageWidth) * 0.5, (view.height - kImageHeight) *0.5, kImageWidth, kImageHeight)];
        [self addSubview:imageView];
        imageView.contentMode = UIViewContentModeCenter;
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 1; i<=13; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%02zd", @"load_effect_center", i]];
            [array addObject:image];
        }
        imageView.animationImages = array;
        imageView.animationRepeatCount = 0;
        imageView.animationDuration = 2.0;
        [imageView startAnimating];
        self.imageView = imageView;
    }
}
- (void)endLoading{
    if (self.imageView) {
        [self.imageView stopAnimating];
        [self.imageView removeFromSuperview];
        self.imageView = nil;
    }
    
    if (self) {
        [self removeFromSuperview];
    }
}
@end
