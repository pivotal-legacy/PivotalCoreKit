#import "WKInterfaceObject.h"

@interface PCKMessageCapturer ()

- (void)setHidden:(BOOL)hidden NS_REQUIRES_SUPER;
- (void)setAlpha:(CGFloat)alpha NS_REQUIRES_SUPER;

- (void)setWidth:(CGFloat)width NS_REQUIRES_SUPER;
- (void)setHeight:(CGFloat)height NS_REQUIRES_SUPER;

@end

@interface WKInterfaceObject ()
@property (nonatomic, getter=isHidden) BOOL hidden;
@property (nonatomic) CGFloat alpha;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@end

@implementation WKInterfaceObject

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    _hidden = hidden;
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
    _alpha = alpha;
}

- (void)setWidth:(CGFloat)width
{
    [super setWidth:width];
    _width = width;
}

- (void)setHeight:(CGFloat)height
{
    [super setHeight:height];
    _height = height;
}

@end
