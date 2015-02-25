#import "NSObject+MethodDecoration.h"
#import "PCKMethodRedirector.h"
#import "objc/runtime.h"

@implementation NSObject (MethodDecoration)

+ (void)decorateMethod:(NSString *)methodName with:(NSString *)decoration {
    [PCKMethodRedirector redirectSelector:NSSelectorFromString(methodName)
                                 forClass:self
                                       to:NSSelectorFromString([NSString stringWithFormat:@"%@With%@", methodName, [decoration capitalizedString]])
                            andRenameItTo:NSSelectorFromString([NSString stringWithFormat:@"%@Without%@", methodName, [decoration capitalizedString]])];
}

@end
