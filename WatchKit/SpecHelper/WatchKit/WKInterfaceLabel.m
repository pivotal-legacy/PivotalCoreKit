#import "WKInterfaceLabel.h"
#import "UIColor+PCK_StringToColor.h"


@interface WKInterfaceLabel ()

@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSAttributedString *attributedText;
@property (nonatomic) UIColor *textColor;

@end


@implementation WKInterfaceLabel

-(void)setColor:(id)textColor {
    _textColor = [textColor isKindOfClass:[UIColor class]] ? textColor : [UIColor colorWithNameOrHexValue:textColor];
}

- (UIColor *)color
{
    return _textColor;
}

@end
