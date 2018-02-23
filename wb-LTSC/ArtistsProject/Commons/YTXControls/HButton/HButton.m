//自定义button

#import "HButton.h"

@implementation HButton

- (id) init
{
    if (self=[super init]){
        [self initialize];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

- (void) initialize
{
    self.borderWidth=HViewBorderWidthMake(0, 0, 0, 0);
    self.borderColor=[UIColor blackColor];
    self.backgroundColor=[UIColor clearColor];
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    HBorderDraw *draw=[HBorderDraw new];
    [draw drawBorder:rect andViewBorderWidth:self.borderWidth andViewBorderColor:self.borderColor];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageTextAlignment == HButtonImageTextAlignmentVertical) {
        // Center image
        CGPoint center = self.imageView.center;
        center.x = self.frame.size.width / 2;
        center.y = self.frame.size.height / 2 - [self titleLabel].frame.size.height / 2;
        self.imageView.center = center;

        //Center text
        CGRect newFrame = [self titleLabel].frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 5;
        newFrame.size.width = self.frame.size.width;

        self.titleLabel.frame = newFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}
@end
