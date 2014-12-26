#import "WKInterfaceObject.h"

@interface PCKMessageCapturer ()

- (void)setHidden:(BOOL)hidden NS_REQUIRES_SUPER;
- (void)setAlpha:(CGFloat)alpha NS_REQUIRES_SUPER;

- (void)setWidth:(CGFloat)width NS_REQUIRES_SUPER;
- (void)setHeight:(CGFloat)height NS_REQUIRES_SUPER;

@end

@implementation WKInterfaceObject

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
}

- (void)setAlpha:(CGFloat)alpha
{
    [super setAlpha:alpha];
}

- (void)setWidth:(CGFloat)width
{
    [super setWidth:width];
}

- (void)setHeight:(CGFloat)height
{
    [super setHeight:height];
}

@end
