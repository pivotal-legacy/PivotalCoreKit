#import "PCKMethodRedirector.h"
#import <objc/runtime.h>

@implementation PCKMethodRedirector

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    if ([klass instancesRespondToSelector:renamedSelector]) {
        return;
    }

    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
    class_addMethod(klass, renamedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));

    Method newMethod = class_getInstanceMethod(klass, newSelector);
    class_replaceMethod(klass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
}

@end
