#import "UIApplication+Spec.h"

@implementation UIApplication (Spec)

static NSMutableArray *URLs__ = nil;

+ (void)afterEach {
    [self reset];
}

+ (void)reset {
    [URLs__ removeAllObjects];
}

+ (NSURL *)lastOpenedURL {
    return [URLs__ lastObject];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)openURL:(NSURL *)url {
    if (!URLs__) {
        URLs__ = [[NSMutableArray alloc] init];
    }
    [URLs__ addObject:url];
}

#pragma clang diagnostic pop

@end
