#import "NSObject+MethodDecoration.h"
#import "objc/runtime.h"

@implementation NSObject (MethodDecoration)

+ (void)decorateMethod:(NSString *)methodName with:(NSString *)decoration {
    SEL baseSelector = NSSelectorFromString(methodName);
    Method baseMethod = class_getInstanceMethod([self class], baseSelector);
    IMP baseImplementation = method_getImplementation(baseMethod);
    const char *baseTypeEncoding = method_getTypeEncoding(baseMethod);

    NSString *undecoratedMethodName = [NSString stringWithFormat:@"%@Without%@", methodName, [decoration capitalizedString]];
    SEL undecoratedSelector = NSSelectorFromString(undecoratedMethodName);
    class_addMethod([self class], undecoratedSelector, baseImplementation, baseTypeEncoding);

    NSString *decoratedMethodName = [NSString stringWithFormat:@"%@With%@", methodName, [decoration capitalizedString]];
    SEL decoratedSelector = NSSelectorFromString(decoratedMethodName);
    Method decoratedMethod = class_getInstanceMethod([self class], decoratedSelector);
    IMP decoratedImplementation = method_getImplementation(decoratedMethod);
    const char *decoratedTypeEncoding = method_getTypeEncoding(decoratedMethod);

    class_replaceMethod([self class], baseSelector, decoratedImplementation, decoratedTypeEncoding);
}

@end
