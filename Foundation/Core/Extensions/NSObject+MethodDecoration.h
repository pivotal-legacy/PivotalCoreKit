#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MethodDecoration)

+ (void)decorateMethod:(NSString *)methodName with:(NSString *)decoration;

@end

NS_ASSUME_NONNULL_END
