#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Spec)

- (nullable UIView *)subviewWithAccessibilityIdentifier:(NSString *)accessibilityIdentifier;
- (nullable UIView *)firstSubviewOfClass:(Class)aClass;
- (BOOL)isTrulyVisible;

@end

NS_ASSUME_NONNULL_END
