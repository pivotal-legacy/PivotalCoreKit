#import "NSObject+MethodDecoration.h"
#import "NSObject+MethodRedirection.h"
#import "objc/runtime.h"

@implementation NSObject (MethodDecoration)

+ (void)decorateMethod:(NSString *)methodName with:(NSString *)decoration {
    [self redirectSelector:NSSelectorFromString(methodName)
                        to:NSSelectorFromString([NSString stringWithFormat:@"%@With%@", methodName, [decoration capitalizedString]])
             andRenameItTo:NSSelectorFromString([NSString stringWithFormat:@"%@Without%@", methodName, [decoration capitalizedString]])];
}

@end
