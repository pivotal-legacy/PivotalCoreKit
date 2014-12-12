#import "WKInterfaceDate.h"
#import "UIColor+PCK_StringToColor.h"

@implementation WKInterfaceDate

- (void)setColor:(id)textColor {
    _textColor = [textColor isKindOfClass:[UIColor class]] ? textColor : [UIColor colorWithNameOrHexValue:textColor];
}

- (UIColor *)color {
    return _textColor;
}

@end
