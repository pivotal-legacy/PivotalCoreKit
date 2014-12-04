#import "UIActivityViewController+Spec.h"
#import "PCKMethodRedirector.h"
#import <objc/runtime.h>

static char kActivityItemsKey;
static char kApplicationActivitesKey;

@interface UIActivityViewController (SpecPrivate)
- (instancetype)original_initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities NS_RETURNS_RETAINED;
- (instancetype)_initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities __attribute__((objc_method_family(init)));
@end

@interface UIActivityViewControllerLoader : NSObject
@end

@implementation UIActivityViewControllerLoader
+ (void)load {
    [PCKMethodRedirector redirectSelector:@selector(initWithActivityItems:applicationActivities:)
                                 forClass:[UIActivityViewController class]
                                       to:@selector(_initWithActivityItems:applicationActivities:)
                            andRenameItTo:@selector(original_initWithActivityItems:applicationActivities:)];
}
@end

@implementation UIActivityViewController (Spec)

- (instancetype)_initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
    if (self = [super init]) {
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
