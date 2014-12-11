#import "WKInterfaceSeparator.h"
#import "UIColor+PCK_StringToColor.h"


@implementation WKInterfaceSeparator

- (void)setColor:(NSString *)color
{
    _color = [UIColor colorWithNameOrHexValue:color];
}

@end
