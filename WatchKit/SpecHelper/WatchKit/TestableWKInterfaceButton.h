#import <UIKit/UIKit.h>

@protocol TestableWKInterfaceButton <NSObject>

- (void)setTitle:(NSString *)title;
- (void)setColor:(UIColor *)color;
- (void)setEnabled:(BOOL)enabled;

@optional

- (NSString *)title;
- (UIColor *)color;
- (BOOL)enabled;

@end
