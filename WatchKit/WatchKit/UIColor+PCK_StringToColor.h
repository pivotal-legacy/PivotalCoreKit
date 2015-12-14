#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (PCK_StringToColor)

+ (UIColor *)colorWithNameOrHexValue:(NSString *)nameOrHexValue;

@end

NS_ASSUME_NONNULL_END
