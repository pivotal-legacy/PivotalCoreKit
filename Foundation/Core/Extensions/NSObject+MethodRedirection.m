#import "NSObject+MethodRedirection.h"
#import "objc/runtime.h"

@implementation NSObject (MethodRedirection)

+ (void)redirectSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    [NSObject redirectSelector:originalSelector
                      forClass:[self class]
                            to:newSelector
                 andRenameItTo:renamedSelector];

}

+ (void)redirectClassSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    [NSObject redirectSelector:originalSelector
                      forClass:objc_getMetaClass(class_getName([self class]))
                            to:newSelector
                 andRenameItTo:renamedSelector];
}

+ (void)redirectSelector:(SEL)originalSelector forClass:(Class)klass to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    if ([klass instancesRespondToSelector:renamedSelector]) {
        [NSException raise:@"SelectorAlreadyExists" format:@"Attempted to rename %@ to %@, but %@ already exists.", NSStringFromSelector(originalSelector), NSStringFromSelector(renamedSelector), NSStringFromSelector(renamedSelector)];
        return;
    }

    Method originalMethod = class_getInstanceMethod(klass, originalSelector);
    class_addMethod(klass, renamedSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));

    Method newMethod = class_getInstanceMethod(klass, newSelector);
    class_replaceMethod(klass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
}

@end
