#import "UIApplication+Spec.h"
#import "PCKMethodRedirector.h"
#import <objc/runtime.h>

@implementation UIApplication (Spec)

static NSMutableArray *URLs = nil;

+ (void)load {
    URLs = [NSMutableArray array];
    id cedarHooksProtocol = NSProtocolFromString(@"CDRHooks");
    if (cedarHooksProtocol) {
        class_addProtocol(self, cedarHooksProtocol);
    }
    [PCKMethodRedirector redirectPCKReplaceSelectorsForClass:self];
}

+ (void)afterEach {
    [self reset];
}

+ (void)reset {
    [URLs removeAllObjects];
}

+ (NSURL *)lastOpenedURL {
    return [URLs lastObject];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)pck_replace_openURL:(NSURL *)url {
    [URLs addObject:url];
}
#pragma clang diagnostic pop

@end
