//
//  UIView+Additions.h
//  dzmmac
//
//  Created by dzmmac on 13-11-28.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


@interface UIView (ZYJView)

- (void)showBlackViewWithAlpha:(CGFloat)_float belowSubview:(UIView *)_view hiddenSelect:(SEL)_select target:(id)_tag;
-(void)showBlackViewWithAlpha:(CGFloat)_float aboveSubview:(UIView *)_view hiddenSelect:(SEL)_select target:(id)_target;
- (void)hiddenBlackView;
- (UIButton *)getButtonWithTag:(NSInteger)_index;
- (UIImageView *)getUIImageViewWithTag:(NSInteger)_index;
- (UILabel *)getUILabelWithTag:(NSInteger)_index;
- (UITextField *)getUITextFieldWithTag:(NSInteger)_index;
- (void)beginRespirationLamp;
- (void)endRespirationLamp;
-(void)setRadius:(float)_radius;
-(void)setBorder:(float)_border;
-(void)setBorderColor:(CGColorRef)_color;
-(void)radianWithTransform:(NSInteger)_x withAnimation:(BOOL)_animation;

-(UIView *)getScreenWidthLineDefaultColorByY:(CGFloat)y;
+(UIView *)getScreenWidthLineDefaultColorByY:(CGFloat)y;

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;


@property CGPoint position;
@property CGFloat x;
@property CGFloat y;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;


// makes hiding more logical
@property BOOL	visible;


// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;


@end
