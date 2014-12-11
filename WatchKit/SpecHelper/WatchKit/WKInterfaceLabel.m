#import "WKInterfaceLabel.h"
#import "UIColor+PCK_StringToColor.h"


@implementation WKInterfaceLabel

-(void)setColor:(id)textColor {
    _textColor = [textColor isKindOfClass:[UIColor class]] ? textColor : [UIColor colorWithNameOrHexValue:textColor];
}

- (UIColor *)color
{
    return _textColor;
}

@end
