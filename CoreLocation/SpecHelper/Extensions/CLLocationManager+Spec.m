#import "CLLocationManager+Spec.h"
#import "objc/runtime.h"

static char kAuthorizationKey;

@interface CLLocationManager ()
+ (CLAuthorizationStatus)original_authorizationStatus;
@end

@implementation CLLocationManager (Spec)

+ (void)load {
    [self redirectClassSelector:@selector(authorizationStatus)
                             to:@selector(stubbed_authorizationStatus)
                  andRenameItTo:@selector(original_authorizationStatus)];
}

+ (CLAuthorizationStatus)stubbed_authorizationStatus {
    return [objc_getAssociatedObject(self, &kAuthorizationKey) intValue];
}

+ (void)setAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {
    objc_setAssociatedObject(self, &kAuthorizationKey, @(authorizationStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - TODO Refactor to use code in Foundation project
+ (void)redirectClassSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    [self redirectSelector:originalSelector
                  forClass:objc_getMetaClass(class_getName([self class]))
                        to:newSelector
             andRenameItTo:renamedSelector];
}

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
