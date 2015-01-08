#import "WKInterfaceLabel.h"
#import "UIColor+PCK_StringToColor.h"


@interface WKInterfaceObject ()

- (void)setText:(NSString *)text NS_REQUIRES_SUPER;
- (void)setTextColor:(UIColor *)textColor NS_REQUIRES_SUPER;

- (void)setAttributedText:(NSAttributedString *)attributedText NS_REQUIRES_SUPER;

@end


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

- (void)setText:(NSString *)text
{
    if ([text isKindOfClass:[NSDictionary class]]) {
        NSDictionary *textDictionary = (id)text;
        NSString *fallBackString = textDictionary[@"fallbackString"];
        if (fallBackString) {
            text = fallBackString;
        }
    }
    _text = text;
    [super setText:text];
}

- (void)setTextColor:(UIColor *)textColor
{
    [self setColor:textColor];
    [super setTextColor:textColor];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    [super setAttributedText:attributedText];
}

@end
