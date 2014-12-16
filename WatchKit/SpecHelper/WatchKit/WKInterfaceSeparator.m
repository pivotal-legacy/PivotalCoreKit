#import "WKInterfaceSeparator.h"
#import "UIColor+PCK_StringToColor.h"

@interface WKInterfaceSeparator ()

@property (nonatomic) UIColor *color;

@end

@implementation WKInterfaceSeparator

- (void)setColor:(id)color
{
    _color = [color isKindOfClass:[UIColor class]] ? color : [UIColor colorWithNameOrHexValue:color];
}

@end
