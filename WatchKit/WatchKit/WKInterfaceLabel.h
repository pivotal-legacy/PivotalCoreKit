#import "WKInterfaceObject.h"


@interface WKInterfaceLabel : WKInterfaceObject

- (void)setText:(NSString *)text;
- (void)setTextColor:(UIColor *)textColor;

- (void)setAttributedText:(NSAttributedString *)attributedText;

@end
