#import <UIKit/UIKit.h>

@interface UIView (Spec)

- (UIView *)subviewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
- (UIView *)firstSubviewOfClass:(Class)aClass;

@end
