//
//  MBScrolViewController.m
//  MobileBusiness
//
//  Created by 中嘉信诺 on 15/10/28.
//  Copyright © 2015年 中嘉信诺. All rights reserved.
//

#import "MBScrolViewController.h"
#import "AppDelegate.h"
#import "ArtTabBarController.h"
#import "ArtRequest.h"
#import "HomeListDetailVc.h"


#define DURATION 1.0f

@interface MBScrolViewController ()<UIScrollViewDelegate>
{
    NSTimer* _timer;
    NSInteger _inter;
}
@property(nonatomic,strong)UIScrollView* baseScrolView;
@property(nonatomic,strong)NSMutableArray* imgArr;
@end

@implementation MBScrolViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _imgArr = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden = YES;
    _baseScrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _baseScrolView.pagingEnabled = YES;
    _baseScrolView.bounces = NO;
    _baseScrolView.delegate = self;
    _baseScrolView.userInteractionEnabled = YES;
    [self.view addSubview:_baseScrolView];
    
    UIButton *btnTitle=[[UIButton alloc]init];
    btnTitle.frame = CGRectMake(SCREEN_WIDTH/2-T_WIDTH(40), SCREEN_HEIGHT-T_WIDTH(80), T_WIDTH(80), T_WIDTH(30));
    btnTitle.layer.cornerRadius = 5;
    btnTitle.backgroundColor = [UIColor whiteColor];
    [btnTitle setTitle:@"进 入" forState:UIControlStateNormal];
    [btnTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnTitle.titleLabel.font=ART_FONT(ARTFONT_OE);
    [btnTitle addTarget:self action:@selector(ScrolTapClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnTitle];
    
    _timer  = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(runing) userInfo:nil repeats:YES];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer forMode:NSRunLoopCommonModes];
    [self loadData];
}
-(void)loadData{
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(_baseScrolView)weakView = _baseScrolView;
    [ArtRequest GetRequestWithActionName:@"indexslide" andPramater:@{@"uid":[[Global sharedInstance] getBundleID]} succeeded:^(id responseObject) {
        kPrintLog(responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]){
            [_imgArr removeAllObjects];
            [_imgArr addObjectsFromArray:responseObject];
            
            NSMutableArray* tempArr = [[NSMutableArray alloc]init];
            for (NSDictionary* dic in _imgArr) {
                [tempArr addObject:dic[@"photo"]];
            }
//            cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) imageURLStringsGroup:tempArr];
//            [cycleScrollView setAutoScrollTimeInterval:3];
//            cycleScrollView.delegate = weakSelf;
//            [weakView addSubview:cycleScrollView];
            

            NSArray * imgArr = [responseObject mutableCopy];
            for (int i=0; i<imgArr.count; i++) {
                UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                [img sd_setImageWithURL:[NSURL URLWithString:imgArr[i][@"photo"]] placeholderImage:[UIImage imageNamed:@""]];
                [weakView addSubview:img];
            }
            _inter = -1;
            [self startTimer];
             weakView.contentSize = CGSizeMake(SCREEN_WIDTH*imgArr.count, 0);
        }
       

    } failed:^(id responseObject) {
        //[weakSelf showErrorHUDWithTitle:@"您的网络不给力" SubTitle:nil Complete:nil];
        __weak typeof(weakSelf)strongSelf = weakSelf;
        [PHNoResponse showHUDAddedTo:KEY_WINDOW :^(id responseObject) {
            [strongSelf loadData];
        }];
    }];
}
-(void)ScrolTapClick
{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    app.tab  = [[ArtTabBarController alloc] init];
    [UIView transitionWithView:app.window duration:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //self.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.view.alpha=0.5;
        
    }completion:^(BOOL finished){
         
         [UIView transitionWithView:app.window duration:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^
          {
              
          } completion:^(BOOL finished){
              app.window.rootViewController=app.tab;
              
          }];
     }];
}

#pragma CATransition动画实现
- (void) transitionWithType:(NSString *) type WithSubtype:(NSString *) subtype ForView : (UIView *) view
{
    [view.layer removeAnimationForKey:@"animation"];
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = DURATION;
    
    //设置运动type
    animation.type = type;
    if (subtype != nil) {
        
        //设置子类
        animation.subtype = subtype;//
    }
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    [view.layer addAnimation:animation forKey:@"animation"];
}

-(void)stopTimer{
    [_timer setFireDate:[NSDate distantFuture]];
}
//开启
-(void)startTimer{
    [_timer setFireDate:[NSDate distantPast]];
}
- (void) animationWithView : (UIView *)view WithAnimationTransition : (UIViewAnimationTransition)transition
{
    [UIView animateWithDuration:DURATION animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:view cache:YES];
    }];
}
-(void)runing{
    _inter++;
     [self transitionWithType:kCATransitionFade WithSubtype:kCATransitionFromBottom ForView:_baseScrolView];
    [_baseScrolView setContentOffset:CGPointMake(_inter*SCREEN_WIDTH, 0) animated:NO];
    if (_inter>(_imgArr.count-1)){
        _baseScrolView.contentOffset = CGPointMake(0,0);
        _inter=0;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _inter = scrollView.contentOffset.y/SCREEN_WIDTH;
    //[self startTimer];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //[self stopTimer];
}
@end
