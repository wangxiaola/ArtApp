//
//  GFPageSlider.h
//  GFPageSlider
//
//  Created by Mercy on 15/6/30.
//  Copyright (c) 2015年 Mercy. All rights reserved.
//
//  使用步骤：
//          1、初始化各个页面的视图控制器
//          2、将各个页面的视图控制器添加为当前控制器的子控制器
//          3、初始化PageSlider,传入页面数量、各个页面的ViewController对象以及Titles
//          4、将PageSlider添加为当前控制器视图的子视图
//          5、设置PageSlider属性(不设置则使用默认值)
//          6、若要添加更多页面，则先初始化要添加的试图控制器，然后将其添加为当前控制器的自控制器，再调用
//             addPagesWithPageCount:viewControllers:menuButtonTitles 方法进行添加
//

#import <UIKit/UIKit.h>

@interface HPageSlider : UIView
/// 菜单栏的高度
@property (nonatomic) CGFloat menuHeight;
/// 屏幕可见Menu数量
@property (nonatomic) int menuNumberPerPage;
/// 菜单栏标题颜色
@property (nonatomic) UIColor *menuTitleColor;
@property (nonatomic) UIColor *menuSelectedTitleColor;
/// 标题栏背景色
@property (nonatomic) UIColor *menuBackColor;
@property (nonatomic,copy) void(^didPageChangedBlock)(NSInteger);
@property(nonatomic,strong) NSMutableArray *viewControllers;
@property (nonatomic) NSInteger currentPage; //!< 当前页
/**
 *  PageSlider初始化函数
 *
 *  @param frame           想要设定的PageSlider控件的frame
 *  @param pageCount       滑动页的数目pageCount
 *  @param viewControllers 各个页面的ViewController
 *  @param titles          MenuButton的名称(titles参数可为nil，表示使用默认值)
 */
- (instancetype)initWithFrame:(CGRect)frame
                 numberOfPage:(int)pageCount
             menuButtonTitles:(NSArray *)titles;

@end
