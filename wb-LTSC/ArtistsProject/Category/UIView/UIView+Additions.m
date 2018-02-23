//
//  UIView+Additions.m
//  dzmmac
//
//  Created by dzmmac on 13-11-28.
//
//

#import "UIView+Additions.h"

@implementation UIView (ZYJView)

-(UIView *)getBlackViewWithSelect:(SEL)_select target:(id)_target{
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor clearColor];
    btn.titleLabel.text=@"";
    btn.frame=blackView.frame;
    if (_select) {
        [btn addTarget:_target action:_select forControlEvents:UIControlEventTouchUpInside];
    }
    [blackView addSubview:btn];
    blackView.alpha=0;
    blackView.backgroundColor=[UIColor blackColor];
    blackView.tag=9999;
    return blackView;
}

-(void)showBlackViewWithAlpha:(CGFloat)_float belowSubview:(UIView *)_view hiddenSelect:(SEL)_select target:(id)_target{
    if (![self viewWithTag:9999]) {
        UIView *viewBlack = [self getBlackViewWithSelect:_select target:_target];
        if (_view) {
            [self insertSubview:viewBlack belowSubview:_view];
        }else{
            [self addSubview:viewBlack];
        }
        [UIView beginAnimations:@"showBlack" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [self viewWithTag:9999].alpha=_float;
        [UIView commitAnimations];
    }
}

-(void)showBlackViewWithAlpha:(CGFloat)_float aboveSubview:(UIView *)_view hiddenSelect:(SEL)_select target:(id)_target{
    if (![self viewWithTag:9999]) {
        UIView *viewBlack = [self getBlackViewWithSelect:_select target:_target];
        if (_view) {
            [self insertSubview:viewBlack aboveSubview:_view];
        }else{
            [self addSubview:viewBlack];
        }
        [UIView beginAnimations:@"showBlack" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [self viewWithTag:9999].alpha=_float;
        [UIView commitAnimations];
    }
}

-(void)hiddenBlackView
{
    if ([self viewWithTag:9999])
    {
        [UIView beginAnimations:@"hiddenBlack" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [self viewWithTag:9999].alpha=0;
        [UIView commitAnimations];
        [[self viewWithTag:9999] performSelector:@selector(removeFromSuperview) withObject:[self viewWithTag:9999] afterDelay:0.2];
    }
}

-(UIButton *)getButtonWithTag:(NSInteger)_index{
    if ([[self viewWithTag:_index] isKindOfClass:[UIButton class]]) {
        return (UIButton *)[self viewWithTag:_index];
    }
    return nil;
}

-(UIImageView *)getUIImageViewWithTag:(NSInteger)_index{
    if ([[self viewWithTag:_index] isKindOfClass:[UIImageView class]]) {
        return (UIImageView *)[self viewWithTag:_index];
    }
    return nil;
}

-(UILabel *)getUILabelWithTag:(NSInteger)_index{
    if ([[self viewWithTag:_index] isKindOfClass:[UILabel class]]) {
        return (UILabel *)[self viewWithTag:_index];
    }
    return nil;
}

-(UITextField *)getUITextFieldWithTag:(NSInteger)_index{
    if ([[self viewWithTag:_index] isKindOfClass:[UITextField class]]) {
        return (UITextField *)[self viewWithTag:_index];
    }
    return nil;
}

-(void)beginRespirationLamp{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:self.alpha>0?1:0];
    animation.toValue=[NSNumber numberWithFloat:self.alpha>0?0:1];
    animation.autoreverses=YES;
    animation.repeatCount=FLT_MAX;
    animation.removedOnCompletion=NO;
    animation.duration=2;
    animation.fillMode=kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"RespirationLamp"];
}

-(void)endRespirationLamp{
    [self.layer removeAnimationForKey:@"RespirationLamp"];
}

-(void)setRadius:(float)_radius{
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:_radius]; //设置矩圆角半径
}

-(void)setBorder:(float)_border{
    [self.layer setBorderWidth:_border];
}

-(void)setBorderColor:(CGColorRef)_color{
    [self.layer setBorderColor:_color];
}

-(void)radianWithTransform:(NSInteger)_x withAnimation:(BOOL)_animation{
    if (_animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
    }
    self.transform = CGAffineTransformMakeRotation(M_PI*_x/180.0);
    if (_animation) {
        [UIView commitAnimations];
    }
}


-(UIView *)getScreenWidthLineDefaultColorByY:(CGFloat)y{
    UIView *Lineview = [[UIView alloc ] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 0.45)];
    Lineview.backgroundColor = ST_SEPERATE_LINE_COLOR;
    return Lineview;
}
+(UIView *)getScreenWidthLineDefaultColorByY:(CGFloat)y{
    UIView *Lineview = [[UIView alloc ] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, 0.45)];
    Lineview.backgroundColor = ST_SEPERATE_LINE_COLOR;
    return Lineview;
}
- (CGPoint)position {
    return self.frame.origin;
}

- (void)setPosition:(CGPoint)position {
    CGRect rect = self.frame;
    rect.origin = position;
    [self setFrame:rect];
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect rect = self.frame;
    rect.origin.x = x;
    [self setFrame:rect];
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect rect = self.frame;
    rect.origin.y = y;
    [self setFrame:rect];
}


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}





- (BOOL)visible {
    return !self.hidden;
}

- (void)setVisible:(BOOL)visible {
    self.hidden=!visible;
}


-(void)removeAllSubViews{
    
    for (UIView *subview in self.subviews){
        [subview removeFromSuperview];
    }
    
}


- (CGSize)size {
    return [self frame].size;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    [self setFrame:rect];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = self.frame;
    rect.size.width = width;
    [self setFrame:rect];
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = self.frame;
    rect.size.height = height;
    [self setFrame:rect];
}

#pragma mark - 设置部分圆角
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

@end
