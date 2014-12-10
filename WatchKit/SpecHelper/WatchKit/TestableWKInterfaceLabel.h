#import <Foundation/Foundation.h>

@protocol TestableWKInterfaceLabel <NSObject>

- (void)setText:(NSString *)text;
- (void)setTextColor:(UIColor *)textColor;
- (void)setAttributedText:(NSAttributedString *)attributedText;

@optional

- (NSString *)text;
- (UIColor *)textColor;
- (NSAttributedString *)attributedText;

@end
