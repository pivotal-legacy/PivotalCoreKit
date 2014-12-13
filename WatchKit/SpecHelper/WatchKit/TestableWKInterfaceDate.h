#import <Foundation/Foundation.h>

@protocol TestableWKInterfaceDate <NSObject>

- (void)setTextColor:(UIColor *)color;
- (void)setFormat:(NSString *)format;

@optional

- (UIColor *)textColor;
- (NSString *)format;

@end
