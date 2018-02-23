//自定义button

#import <UIKit/UIKit.h>
#import "HBorderDraw.h"
@interface HButton : UIButton
typedef enum{
    HButtonImageTextAlignmentHorizon,
    HButtonImageTextAlignmentVertical
} HButtonImageTextAlignment;

@property(nonatomic,strong) id extInfo;
@property(nonatomic) HViewBorderWidth borderWidth;
@property(nonatomic,strong) UIColor *borderColor;
@property(nonatomic,readwrite) HButtonImageTextAlignment imageTextAlignment;
@end
