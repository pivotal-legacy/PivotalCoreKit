#import <Foundation/Foundation.h>

@interface NSObject (MethodDecoration)

+ (void)decorateMethod:(NSString *)methodName with:(NSString *)decoration;

@end
