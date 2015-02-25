#import "CLLocationManager+Spec.h"
#import "PCKMethodRedirector.h"
#import "objc/runtime.h"

static char kAuthorizationKey;

@interface CLLocationManager ()
+ (CLAuthorizationStatus)original_authorizationStatus;
@end

@implementation CLLocationManager (Spec)

+ (void)load {
    [PCKMethodRedirector redirectClassSelector:@selector(authorizationStatus)
                                      forClass:self
                                            to:@selector(stubbed_authorizationStatus)
                                 andRenameItTo:@selector(original_authorizationStatus)];
}

+ (CLAuthorizationStatus)stubbed_authorizationStatus {
    return [objc_getAssociatedObject(self, &kAuthorizationKey) intValue];
}

+ (void)setAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {
    objc_setAssociatedObject(self, &kAuthorizationKey, @(authorizationStatus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
