//
//  TopViewController.m
//  新闻
//
//  Created by gyh on 15/9/28.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "TopViewController.h"
#import "UIImageView+WebCache.h"
#import "TopData.h"
#import "BBNetworkTool.h"
#import "MJExtension.h"
#import "MSBArticleDetailBottom.h"
#import "MSBArticleCommentController.h"
#import "GeneralConfigure.h"
#import "IQKeyboardManager.h"
#import "MSBShareContentView.h"
#import "MSBArticleCommentModel.h"
#import "MSBCommentView.h"
#import "ArticleImageModel.h"
#import "Ann30ImageModel.h"
#import "AtlasImageView.h"

#define BOTTOM_VIEW_HEIGHT 140
#define MAX_TITILE_HEIGHT 50
@interface TopViewController ()<UIScrollViewDelegate>
{
    NSString * _currentImageUrl;
}
@property (nonatomic , strong) UIScrollView *scroll;
@property (nonatomic,strong) UIView * navBarView;
@property (nonatomic,strong) UIView * contentView;
@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic , strong) UILabel *countLabel;
@property (nonatomic,strong) UILabel * bottomCountLabel;
@property (nonatomic , strong) UITextView *textview;

@property (nonatomic , strong) AtlasImageView *imageV;

@property(nonatomic,copy) NSMutableArray *imageViews;
@property (nonatomic,copy) NSMutableArray * imgScolls;
@property(nonatomic,copy) NSMutableArray *t_imageViews;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,getter=isShow) BOOL show;
@end

@implementation TopViewController

- (NSMutableArray *)imageViews {

    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (NSMutableArray *)imgScolls {

    if (!_imgScolls) {
        _imgScolls = [NSMutableArray array];
    }
    return _imgScolls;
}

- (NSMutableArray *)t_imageViews {

    if (!_t_imageViews) {
        _t_imageViews = [NSMutableArray array];
    }
    return _t_imageViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPage = 0;
    self.show = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];

    [self initUI];

    [self setImageView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)initUI
{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scroll.backgroundColor = [UIColor blackColor];
    scroll.delegate = self;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.pagingEnabled = YES;
    [self.view addSubview:scroll];
    self.scroll = scroll;

    UIView * navBarView = [UIView new];
    navBarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, APP_NAVIGATIONBAR_H);
    navBarView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    [self.view addSubview:navBarView];
    self.navBarView = navBarView;

    UIView * contentView = [UIView new];
    contentView.frame = CGRectMake(0, SCREEN_HEIGHT - BOTTOM_VIEW_HEIGHT, SCREEN_WIDTH, BOTTOM_VIEW_HEIGHT);
    contentView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    [self.view addSubview:contentView];
    self.contentView = contentView;

    //返回按钮
    UIButton *backbtn = [[UIButton alloc]init];
    backbtn.frame = CGRectMake(5, isiPhoneX?44:20, 44, 44);
    [backbtn setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [backbtn.imageView setContentMode:UIViewContentModeCenter];
    [backbtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:backbtn];

    //logo
    UIImageView * logoView = [UIImageView new];
    logoView.image = [UIImage imageNamed:@"meishubao_logo"];
    logoView.frame = CGRectMake(0, 0, 110, 25);
    logoView.center = CGPointMake(navBarView.centerX, isiPhoneX?(44 + 22):(20 + 22));
    [navBarView addSubview:logoView];

    //更多选项按钮
    UIButton *downbtn = [[UIButton alloc]init];
    downbtn.frame = CGRectMake(SCREEN_WIDTH - 5 - 40, backbtn.frame.origin.y, 44, 44);
    [downbtn setImage:[UIImage imageNamed:@"detailpage_item_more"] forState:UIControlStateNormal];
    [downbtn addTarget:self action:@selector(presentActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:downbtn];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(5, 5, SCREEN_WIDTH - 60, MAX_TITILE_HEIGHT);
    titleLabel.dk_textColorPicker = DKColorPickerWithRGB(0xffffff, 0x989898);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //数量
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, titleLabel.frame.origin.y, 50, 15)];
    countLabel.dk_textColorPicker = DKColorPickerWithRGB(0xffffff, 0x989898);
//    countLabel.text = @"00/00";
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    
    //内容
    UITextView *textview = [[UITextView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame), self.contentView.width - 10, self.contentView.height - CGRectGetMaxY(titleLabel.frame) - 5)];
    textview.editable = NO;
    textview.font = [UIFont systemFontOfSize:14];
    textview.textAlignment = NSTextAlignmentLeft;
    textview.dk_textColorPicker = DKColorPickerWithRGB(0xffffff, 0x989898);
    textview.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:textview];
    self.textview = textview;

    //底部数量视图
    UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, SCREEN_HEIGHT, 50, 20)];
    bottomLabel.dk_textColorPicker = DKColorPickerWithRGB(0xffffff, 0x989898);
    bottomLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bottomLabel];
    self.bottomCountLabel = bottomLabel;
}

-(void)setLabel
{
    //数量
    if (self.imgSmeta.count > 1) {
        NSString *countNum = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.imgSmeta.count];
        self.countLabel.text = countNum;
        self.bottomCountLabel.text = countNum;
    }
    //内容
    [self setContentWithIndex:0];
    
}

/** 添加内容 */
- (void)setContentWithIndex:(NSInteger)index
{
    ArticleImageModel * model = self.imgSmeta[index];
    NSString *content = model.desc;
    NSString *contentTitle = model.name;
    //标题
    if ([contentTitle isEqualToString:@""] || contentTitle == nil) {
        
        self.textview.text = content;
        self.titleLabel.hidden = YES;
        self.textview.frame = CGRectMake(5, 0, self.contentView.width - 60, self.contentView.height - 15);
    }else {
    
        self.titleLabel.hidden = NO;
        CGFloat titleHeight = [NSString sizeWithText:contentTitle font:self.titleLabel.font maxSize:CGSizeMake(SCREEN_WIDTH - 60, CGFLOAT_MAX)].height;
        if (titleHeight > MAX_TITILE_HEIGHT) {
            titleHeight = MAX_TITILE_HEIGHT;
        }
        self.titleLabel.frame = CGRectMake(5, 5, SCREEN_WIDTH - 60, titleHeight);
        self.textview.frame = CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame), self.contentView.width - 10, self.contentView.height - CGRectGetMaxY(self.titleLabel.frame) - 5);
        self.titleLabel.text = contentTitle;
        self.textview.text = content;
    }
}


-(void)setImageView
{
    NSUInteger count = self.imgSmeta.count;
    
    for (int i = 0; i < count; i++) {
        
        CGFloat imageH = self.scroll.frame.size.height;
        CGFloat imageW = self.scroll.frame.size.width;
        CGFloat imageY = 0;
        CGFloat imageX = i * imageW;

        UIScrollView * imgScrll = [[UIScrollView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        imgScrll.showsHorizontalScrollIndicator = NO;
        imgScrll.showsVerticalScrollIndicator = NO;
        imgScrll.backgroundColor = [UIColor blackColor];
        imgScrll.delegate = self;
        imgScrll.minimumZoomScale = 1.0f;
        imgScrll.maximumZoomScale = 2.0f;
        imgScrll.tag = i;
        imgScrll.contentSize = CGSizeMake(imageW, imageH);

        AtlasImageView *imaV = [[AtlasImageView alloc] initWithFrame:imgScrll.bounds];
         // 图片的显示格式为合适大小
        imaV.contentMode= UIViewContentModeCenter;
        imaV.contentMode= UIViewContentModeScaleAspectFit;
        //[imaV setClipsToBounds:YES];
        imaV.userInteractionEnabled = YES;
        imaV.center = CGPointMake(imageW / 2, imageH / 2);
        [imgScrll addSubview:imaV];

        [self.scroll addSubview:imgScrll];
        [self.imageViews addObject:imaV];
        [self.imgScolls addObject:imgScrll];

        UIImageView * imgView = [[UIImageView alloc] initWithFrame:imaV.frame];
        [self.t_imageViews addObject:imgView];

        imaV.userInteractionEnabled = YES;
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showMoreItem:)];
        [imaV addGestureRecognizer:longPress];

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBarAndContentView)];
        [imaV addGestureRecognizer:tap];
    }

    self.currentPage = self.index?:0;
    self.scroll.contentOffset = CGPointMake(self.currentPage * SCREEN_WIDTH, 0);
    self.scroll.contentSize = CGSizeMake(self.scroll.frame.size.width * count, 0);

    [self setImgWithIndex:self.currentPage];
}

- (void)hideBarAndContentView {

    if (self.isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect barFrame = self.navBarView.frame;
            barFrame.origin.y = -APP_NAVIGATIONBAR_H;
            self.navBarView.frame = barFrame;
            self.navBarView.alpha = 0;

            CGRect contentViewFrame = self.contentView.frame;
            contentViewFrame.origin.y = SCREEN_HEIGHT;
            self.contentView.frame = contentViewFrame;
            self.contentView.alpha = 0;

        } completion:^(BOOL finished) {
            self.show = NO;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect labelFrame = self.bottomCountLabel.frame;
                labelFrame.origin.y = SCREEN_HEIGHT - (isiPhoneX?34+20:20);
                self.bottomCountLabel.frame = labelFrame;
                self.bottomCountLabel.alpha = 1;
            }];
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect barFrame = self.navBarView.frame;
            barFrame.origin.y = 0;
            self.navBarView.frame = barFrame;
            self.navBarView.alpha = 1;

            CGRect contentViewFrame = self.contentView.frame;
            contentViewFrame.origin.y = SCREEN_HEIGHT - BOTTOM_VIEW_HEIGHT;
            self.contentView.frame = contentViewFrame;
            self.contentView.alpha = 1;

            CGRect labelFrame = self.bottomCountLabel.frame;
            labelFrame.origin.y = SCREEN_HEIGHT;
            self.bottomCountLabel.frame = labelFrame;
            self.bottomCountLabel.alpha = 0;
        } completion:^(BOOL finished) {
            self.show = YES;
        }];
    }
}

- (void)collectImage
{
    BOOL isLogin =  [MSBJumpLoginVC jumpLoginVC:self];
    if (isLogin) {return;}
    __weak __block typeof(self) weakSelf = self;
    [[LLRequestBaseServer shareInstance] requestArticleDetailArticleCollectionPostId:nil isCollect:YES video_id:nil pic_url:_currentImageUrl type:3 success:^(LLResponse *response, id data) {
        [weakSelf showSuccess:@"图片收藏成功"];
    } failure:^(LLResponse *response) {
        if (response.code == 10016) {
            [weakSelf hudTip:@"图片已收藏"];
        }else {
        
            [weakSelf showError:@"图片收藏失败"];
        }
    } error:^(NSError *error) {
        [weakSelf showError:@"图片收藏失败"];
    }];
}

- (void)showMoreItem:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        [self presentActionSheet];
    }
}

- (void)presentActionSheet
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.view.tintColor = RGBCOLOR(181, 27, 32);
    [alert addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //收藏
        [self collectImage];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存
        [self saveImageToAlbum];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)saveImageToAlbum
{
    UIImageWriteToSavedPhotosAlbum(self.imageV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        [self showSuccess:@"保存成功"];
    }else{
        [self showError:@"保存失败"];
    }
}

/** 滚动完毕时调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag >0 == NO) {

        NSInteger numOfPage = ABS(self.scroll.contentOffset.x/scrollView.frame.size.width);

        if (numOfPage != self.currentPage) {

            UIScrollView *scro = [self.imgScolls objectAtIndex:self.currentPage];
            scro.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);

            //这里 把这个scroll的缩放比例设为1，其实就是给它里面图片大小还原，scroll初始的默认是1，给放大了滑动过来了，但这个scroller缩放的程度还是3，这里设为1，就是还原了scroller，它里面的图片自然也就还原了
            scro.zoomScale = 1;
        }

        self.currentPage = numOfPage;
        // 添加图片
        [self setImgWithIndex:numOfPage];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{

    UIImageView *imgView  = [self.imageViews objectAtIndex:self.currentPage];


    if (imgView.frame.size.width > SCREEN_WIDTH  && imgView.frame.size.height > SCREEN_HEIGHT) {
        scrollView.contentSize = CGSizeMake(imgView.frame.size.width, imgView.frame.size.height);
    }
    else if (imgView.frame.size.width > SCREEN_WIDTH && imgView.frame.size.height <= SCREEN_HEIGHT){
        scrollView.contentSize = CGSizeMake(imgView.frame.size.width, SCREEN_HEIGHT);
    }
    else if (imgView.frame.size.width <= SCREEN_WIDTH && imgView.frame.size.height > SCREEN_HEIGHT){
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, imgView.frame.size.height);
    }
    else if (imgView.frame.size.width <= SCREEN_WIDTH && imgView.frame.size.height <= SCREEN_HEIGHT){
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        NSArray *arr1 = [scrollView subviews];
        UIScrollView *scro = [arr1 objectAtIndex:self.currentPage];
        scro.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }

    imgView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    UIImageView * imgView  = [self.imageViews objectAtIndex:self.currentPage];
    UIImageView * t_imageView = [self.t_imageViews objectAtIndex:self.currentPage];
    if (imgView.frame.size.width <= SCREEN_WIDTH && imgView.frame.size.height <= SCREEN_HEIGHT){
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        imgView.frame = t_imageView.frame;
    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(scrollView.tag == self.currentPage){

        //取出 当前缩放图 的 未缩放的frame
        UIImageView *imgView  = [self.imageViews objectAtIndex:self.currentPage];

        if (imgView.frame.size.width>330) {

        }

        return imgView;
    }
    return nil;
}

- (void)setImgWithIndex:(NSInteger)i
{
    AtlasImageView *photoImgView = nil;
    photoImgView = self.imageViews[i];
    
    ArticleImageModel * model = self.imgSmeta[i];
    NSURL *purl = [NSURL URLWithString:model.url];
    _currentImageUrl = purl.absoluteString;
    // 如果这个相框里还没有照片才添加
    if (photoImgView.image == nil) {
        [photoImgView setImageWithUrl:purl];
        self.imageV = photoImgView;
    }

    // 添加文字
    NSString *countNum = [NSString stringWithFormat:@"%ld/%lu",i+1,(unsigned long)self.imgSmeta.count];
    self.countLabel.text = countNum;
    self.bottomCountLabel.text = countNum;

    // 添加内容
    [self setContentWithIndex:i];
}

-(void)setImgSmeta:(NSArray *)imgSmeta
{
    if (!imgSmeta||imgSmeta.count == 0) {
        return;
    }
    _imgSmeta = imgSmeta;
}

- (void)setIndex:(NSInteger )index {

    _index = index;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
