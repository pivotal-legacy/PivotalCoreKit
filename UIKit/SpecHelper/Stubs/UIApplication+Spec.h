#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Spec)

+ (nullable NSURL *)lastOpenedURL;
+ (void)reset;

@end

NS_ASSUME_NONNULL_END
