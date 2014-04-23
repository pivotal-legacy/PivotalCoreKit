#import "UIActivityViewController+Spec.h"
#import <objc/objc-runtime.h>

static char kActivityItemsKey;
static char kApplicationActivitesKey;

@interface UIActivityViewController (SpecPrivate)
- (instancetype)original_initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities NS_RETURNS_RETAINED;
@end

@implementation UIActivityViewController (Spec)

#pragma mark - TODO Refactor to use code in Foundation project
+ (void)redirectSelector:(SEL)originalSelector to:(SEL)newSelector andRenameItTo:(SEL)renamedSelector {
    [self redirectSelector:originalSelector
                      forClass:[self class]
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

+ (void)load {
    [self redirectSelector:@selector(initWithActivityItems:applicationActivities:)
                        to:@selector(_initWithActivityItems:applicationActivities:)
             andRenameItTo:@selector(original_initWithActivityItems:applicationActivities:)];
}

- (instancetype)_initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
    if ((self = [super init])) {
        objc_setAssociatedObject(self, &kActivityItemsKey, activityItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, &kApplicationActivitesKey, applicationActivities, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return self;
}

- (NSArray *)activityItems {
    return objc_getAssociatedObject(self, &kActivityItemsKey);
}

- (NSArray *)applicationActivities {
    return objc_getAssociatedObject(self, &kApplicationActivitesKey);
}

@end
