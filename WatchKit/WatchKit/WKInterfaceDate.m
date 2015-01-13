#import "WKInterfaceDate.h"
#import "UIColor+PCK_StringToColor.h"

@interface WKInterfaceObject ()

- (void)setTextColor:(UIColor *)color NS_REQUIRES_SUPER;

- (void)setTimeZone:(NSTimeZone *)timeZone NS_REQUIRES_SUPER;
- (void)setCalendar:(NSCalendar *)calendar NS_REQUIRES_SUPER;

@end

@interface WKInterfaceDate ()

@property (nonatomic) UIColor *textColor;
@property (nonatomic, copy) NSString *format;

@end

@implementation WKInterfaceDate

- (void)setTextColor:(NSString *)color
{
    [self setColor:color];
    [super setTextColor:_textColor];
}

- (void)setColor:(id)textColor {
    _textColor = [textColor isKindOfClass:[UIColor class]] ? textColor : [UIColor colorWithNameOrHexValue:textColor];
}

- (UIColor *)color {
    return _textColor;
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
    [super setTimeZone:timeZone];
}

- (void)setCalendar:(NSCalendar *)calendar
{
    [super setCalendar:calendar];
}

@end
