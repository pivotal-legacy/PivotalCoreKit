#import "WKInterfaceLabel.h"
#import "UIColor+PCK_StringToColor.h"


@implementation WKInterfaceLabel

-(void)setColor:(NSString *)textColor {
    _textColor = [UIColor colorWithNameOrHexValue:textColor];
}

- (UIColor *)color
{
    return _textColor;
}

@end
