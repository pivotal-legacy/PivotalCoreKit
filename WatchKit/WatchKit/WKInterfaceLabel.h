#import "WKInterfaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKInterfaceLabel : WKInterfaceObject

- (void)setText:(nullable NSString *)text;
- (void)setTextColor:(nullable UIColor *)textColor;

- (void)setAttributedText:(nullable NSAttributedString *)attributedText;

@end

NS_ASSUME_NONNULL_END
